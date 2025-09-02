import 'dart:async';
import 'package:flutter/material.dart';
import '../models/spin_soal_model.dart';
import '../services/question_service.dart';
import '../utils/dialog_utils.dart';
import '../../jawab_soal.dart';

class SpinSoalController {
  final SpinSoalModel model;
  late List<int> _availableQuestions;
  bool _isSpinning = false;
  int? _selectedQuestion;
  Map<String, dynamic>? _currentSoal;
  StreamController<int>? _fortuneWheelController;

  SpinSoalController(this.model) {
    print('DEBUG SpinSoalController constructor:');
    print('- model.mode: ${model.mode}');
    print(
      '- model.onQuestionAnswered available: ${model.onQuestionAnswered != null}',
    );
    print(
      '- model.onQuestionAnsweredWithNumber available: ${model.onQuestionAnsweredWithNumber != null}',
    );

    _availableQuestions = List.from(model.availableQuestions);
    _fortuneWheelController = StreamController<int>();
  }

  // Getters
  List<int> get availableQuestions => _availableQuestions;
  bool get isSpinning => _isSpinning;
  int? get selectedQuestion => _selectedQuestion;
  Map<String, dynamic>? get currentSoal => _currentSoal;
  Stream<int>? get fortuneStream => _fortuneWheelController?.stream;

  void dispose() {
    _fortuneWheelController?.close();
  }

  Future<void> initializeForSingleQuestion(VoidCallback setState) async {
    print('DEBUG CONTROLLER: initializeForSingleQuestion called');
    print('DEBUG CONTROLLER: Available questions: $_availableQuestions');

    if (_availableQuestions.length == 1) {
      final questionNumber = _availableQuestions[0];
      print('DEBUG CONTROLLER: Setting selected question to: $questionNumber');
      _selectedQuestion = questionNumber;
      setState();

      print('DEBUG CONTROLLER: Loading soal...');
      await _loadSoal(questionNumber);
      print('DEBUG CONTROLLER: Soal loaded: $_currentSoal');
      setState();
    }
  }

  Future<void> _loadSoal(int nomorSoal) async {
    print('DEBUG CONTROLLER: _loadSoal called with nomorSoal: $nomorSoal');
    final soal = await QuestionService.loadSoal(nomorSoal);
    if (soal != null) {
      _currentSoal = soal;
      print(
          'DEBUG CONTROLLER: Soal loaded successfully: ${soal['pertanyaan']}');
    } else {
      print('DEBUG CONTROLLER: ERROR - Failed to load soal $nomorSoal');
    }
  }

  void spinWheel(VoidCallback setState, BuildContext context) {
    if (_availableQuestions.isEmpty) {
      DialogUtils.showNoQuestionsDialog(context, model.onAllQuestionsComplete);
      return;
    }

    _isSpinning = true;
    _selectedQuestion = null;
    _currentSoal = null;
    setState();

    final index = QuestionService.getRandomIndex(_availableQuestions);
    final selectedQuestion = _availableQuestions[index];

    _fortuneWheelController?.add(index);

    Future.delayed(const Duration(seconds: 4), () {
      _selectedQuestion = selectedQuestion;
      setState();
      _loadSoal(selectedQuestion).then((_) => setState());
    });
  }

  void onAnimationEnd(VoidCallback setState, BuildContext context) {
    _isSpinning = false;
    setState();

    // Tidak langsung navigasi ke answerQuestion
    // Biarkan widget yang memanggil method ini yang mengatur popup dan navigasi
  }

  void answerQuestion(BuildContext context, {VoidCallback? onStateUpdate}) {
    print('DEBUG CONTROLLER: answerQuestion called');
    print('DEBUG CONTROLLER: _selectedQuestion = $_selectedQuestion');
    print('DEBUG CONTROLLER: _currentSoal = $_currentSoal');

    if (_selectedQuestion != null && _currentSoal != null) {
      print('DEBUG CONTROLLER: Navigating to JawabSoal');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => JawabSoal(
            nomorSoal: _selectedQuestion!,
            onAnswered: (bool benar) {
              print('DEBUG CONTROLLER: onAnswered triggered with benar=$benar');
              print('DEBUG CONTROLLER: mode=${model.mode}');
              print(
                'DEBUG CONTROLLER: onQuestionAnswered available: ${model.onQuestionAnswered != null}',
              );
              print(
                'DEBUG CONTROLLER: onQuestionAnsweredWithNumber available: ${model.onQuestionAnsweredWithNumber != null}',
              );

              if (model.mode == 'single' &&
                  model.onQuestionAnsweredWithNumber != null) {
                print(
                    'DEBUG CONTROLLER: Calling onQuestionAnsweredWithNumber for single mode');
                model.onQuestionAnsweredWithNumber!(_selectedQuestion!, benar);
              } else if (model.mode == 'battle' &&
                  model.onQuestionAnsweredWithNumber != null) {
                print(
                    'DEBUG CONTROLLER: Calling onQuestionAnsweredWithNumber for battle mode');
                model.onQuestionAnsweredWithNumber!(_selectedQuestion!, benar);
              } else if (model.mode == 'collaboration' &&
                  model.onQuestionAnsweredWithNumber != null) {
                print(
                    'DEBUG CONTROLLER: Calling onQuestionAnsweredWithNumber for collaboration mode');
                model.onQuestionAnsweredWithNumber!(_selectedQuestion!, benar);
              } else if (model.onQuestionAnswered != null) {
                print('DEBUG CONTROLLER: Calling onQuestionAnswered');
                model.onQuestionAnswered!(benar);
              } else {
                print('DEBUG CONTROLLER: WARNING - No callback available!');
              }
            },
          ),
        ),
      ).then((_) {
        // ignore: use_build_context_synchronously
        _handleAfterAnswering(context, onStateUpdate: onStateUpdate);
      });
    } else {
      print(
          'DEBUG CONTROLLER: Cannot navigate - selectedQuestion: $_selectedQuestion, currentSoal: $_currentSoal');
      if (_selectedQuestion != null && _currentSoal == null) {
        print('DEBUG CONTROLLER: Soal belum dimuat, mencoba memuat ulang...');
        _loadSoal(_selectedQuestion!).then((_) {
          if (onStateUpdate != null) {
            onStateUpdate();
          }
          // Retry after loading
          if (_currentSoal != null) {
            answerQuestion(context, onStateUpdate: onStateUpdate);
          } else {
            print('DEBUG CONTROLLER: ERROR - Failed to load soal');
          }
        });
      }
    }
  }

  void _handleAfterAnswering(
    BuildContext context, {
    VoidCallback? onStateUpdate,
  }) {
    if (model.mode == 'single') {
      // Mode single: hapus soal, nama tetap
      _availableQuestions.remove(_selectedQuestion);
      _selectedQuestion = null;
      _currentSoal = null;

      // Immediate UI update
      if (onStateUpdate != null) {
        onStateUpdate();
      }

      if (_availableQuestions.isEmpty) {
        DialogUtils.showNoQuestionsDialog(
          context,
          model.onAllQuestionsComplete,
        );
      }
    } else if (model.mode == 'collaboration') {
      // Mode collaboration: soal dan nama akan dihapus di SpinNama
      // Hanya kembalikan nomor soal yang dijawab
      final answeredQuestion = _selectedQuestion;
      _selectedQuestion = null;
      _currentSoal = null;

      // Update UI
      if (onStateUpdate != null) {
        onStateUpdate();
      }

      // Kembali ke SpinNama dengan informasi soal yang sudah dijawab
      Navigator.pop(context, answeredQuestion);
    } else if (model.mode == 'battle') {
      // Mode battle: Don't remove questions here, let SpinNama manage the questions
      // Just return the answered question number back to SpinNama
      final answeredQuestion = _selectedQuestion;
      _selectedQuestion = null;
      _currentSoal = null;

      // Update UI
      if (onStateUpdate != null) {
        onStateUpdate();
      }

      print(
          'DEBUG CONTROLLER: Battle mode - returning answered question: $answeredQuestion');
      Navigator.pop(context, answeredQuestion);
    } else {
      Navigator.pop(context, _selectedQuestion);
    }
  }
}
