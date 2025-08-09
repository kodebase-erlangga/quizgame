import 'package:flutter/material.dart';
import '../../kuis/spinner/spin_nama.dart';
import '../../kuis/spinner/spin_soal_refactored.dart';
import 'CollaborationGameManager.dart';

class CollaborationGameScreen extends StatefulWidget {
  final CollaborationGameManager gameManager;

  const CollaborationGameScreen({Key? key, required this.gameManager})
    : super(key: key);

  @override
  _CollaborationGameScreenState createState() =>
      _CollaborationGameScreenState();
}

class _CollaborationGameScreenState extends State<CollaborationGameScreen> {
  late CollaborationGameManager gameManager;
  String _gameStatus = "Mempersiapkan permainan...";

  @override
  void initState() {
    super.initState();
    gameManager = widget.gameManager;
    // Use WidgetsBinding to safely start the game loop after the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _startGameLoop();
      }
    });
  }

  /// This function implements the state machine logic for the collaboration mode.
  Future<void> _startGameLoop() async {
    print('DEBUG: Starting game loop');
    print(
      'DEBUG: Initial state - removeNamesAfterSpin: ${gameManager.removeNamesAfterSpin}',
    );
    print('DEBUG: Initial studentNames: ${gameManager.studentNames}');
    print('DEBUG: Initial availableNames: ${gameManager.availableNames}');

    // MANUAL TEST: Let's test CollaborationGameManager directly
    print('\n===== MANUAL TEST CollaborationGameManager =====');
    gameManager.setCurrentStudent('TestUser');
    print('After setCurrentStudent(TestUser): ${gameManager.currentStudent}');

    gameManager.recordAnswer(true);
    print('After recordAnswer(true):');
    print('  - studentResults: ${gameManager.studentResults}');
    print('  - studentsWhoAnswered: ${gameManager.studentsWhoAnswered}');
    print('  - currentScore: ${gameManager.currentScore}');

    // Reset for actual game
    gameManager.studentResults.clear();
    gameManager.studentsWhoAnswered.clear();
    gameManager.currentScore = 0;
    gameManager.correctAnswers = 0;
    gameManager.wrongAnswers = 0;
    gameManager.currentStudent = null;
    print('Reset manager for actual game');
    print('===== END MANUAL TEST =====\n');

    // The game loop continues based on the mode:
    // - "sesuai_siswa": until all students have answered (1 question each)
    // - "tetap_30": until all 30 questions are answered
    while (mounted && _shouldContinueGame()) {
      print('DEBUG: Starting new game loop iteration');

      // STATE: cek_selesai (start of loop) -> spin_nama
      gameManager.resetNamesIfNeeded();
      if (!gameManager.hasMoreNames) {
        print('DEBUG: No more names available, breaking loop');
        // This case happens if names run out but questions don't, and reset is off.
        break;
      }

      setState(() {
        _gameStatus = "Menunggu pemilihan nama...";
      });

      // ACTION: tampilkanSpinNama
      final selectedName = await Navigator.push<String>(
        context,
        MaterialPageRoute(
          builder: (context) => SpinNama(
            mode: 'collaboration',
            availableNames: List.from(gameManager.availableNames),
            removeAfterSpin: gameManager.removeNamesAfterSpin,
          ),
        ),
      );

      // If user backs out of SpinNama, end the game.
      if (selectedName == null || !mounted) {
        print('DEBUG: User backed out of SpinNama or component unmounted');
        break;
      }

      print('DEBUG: Selected name: $selectedName');

      // EVENT: NAMA_TERPILIH -> spin_soal
      setState(() {
        _gameStatus = "Siswa '$selectedName' akan memutar soal...";
      });

      // Set current student before showing spin soal
      gameManager.setCurrentStudent(selectedName);
      print('DEBUG: Set current student to: ${gameManager.currentStudent}');

      // ACTION: tampilkanSpinSoal
      print('DEBUG: About to show SpinSoal for $selectedName');
      print(
        'DEBUG: Current student before SpinSoal: ${gameManager.currentStudent}',
      );

      // Define callback function first for debugging
      void onQuestionAnsweredCallback(bool isCorrect) {
        print('DEBUG: ===== onQuestionAnswered CALLBACK TRIGGERED =====');
        print('DEBUG: Student: $selectedName');
        print('DEBUG: Answer: ${isCorrect ? 'CORRECT' : 'WRONG'}');
        print(
          'DEBUG: Current student in manager: ${gameManager.currentStudent}',
        );

        // Manual test - let's manually update the data to see if it works
        print('DEBUG: Before recordAnswer call');
        print('  - studentResults: ${gameManager.studentResults}');
        print('  - studentsWhoAnswered: ${gameManager.studentsWhoAnswered}');
        print('  - currentScore: ${gameManager.currentScore}');

        gameManager.recordAnswer(isCorrect);

        print('DEBUG: After recordAnswer call');
        print('  - studentResults: ${gameManager.studentResults}');
        print('  - studentsWhoAnswered: ${gameManager.studentsWhoAnswered}');
        print('  - currentScore: ${gameManager.currentScore}');
        print('DEBUG: ===== END onQuestionAnswered CALLBACK =====');
      }

      print('DEBUG: Callback function created successfully');

      final answeredQuestion = await Navigator.push<int>(
        context,
        MaterialPageRoute(
          builder: (context) {
            print('DEBUG: Creating SpinSoal widget...');
            return SpinSoal(
              mode: 'collaboration',
              currentPlayer: selectedName,
              availableQuestions: List.from(gameManager.availableQuestions),
              onQuestionAnswered: onQuestionAnsweredCallback,
            );
          },
        ),
      );

      print(
        'DEBUG: Returned from SpinSoal with answeredQuestion: $answeredQuestion',
      );

      // EVENT: JAWABAN_DIKIRIM -> POPUP_DITUTUP -> cek_selesai
      // If user backs out of SpinSoal/JawabSoal, end the game.
      if (answeredQuestion == null || !mounted) {
        print('DEBUG: User backed out of SpinSoal or component unmounted');
        break;
      }

      print('DEBUG: Question answered: $answeredQuestion');
      print('DEBUG: Current game state after question answered:');
      print('  - studentResults: ${gameManager.studentResults}');
      print('  - studentsWhoAnswered: ${gameManager.studentsWhoAnswered}');
      print('  - currentScore: ${gameManager.currentScore}');
      print('  - correctAnswers: ${gameManager.correctAnswers}');
      print('  - wrongAnswers: ${gameManager.wrongAnswers}');

      // Remove the selected question first
      gameManager.removeSelectedQuestion(answeredQuestion);

      // Then remove the name from available names (this will also update studentsWhoAnswered)
      gameManager.removeSelectedName(selectedName);

      print('DEBUG: After removing name $selectedName:');
      print('  - availableNames: ${gameManager.availableNames}');
      print('  - studentsWhoAnswered: ${gameManager.studentsWhoAnswered}');

      // Update the main screen UI with new scores before the next loop iteration.
      setState(() {});
    }

    // The loop has ended.
    // STATE: SELESAI -> hasil
    if (mounted) {
      setState(() {
        _gameStatus = "Permainan Selesai!";
      });
      _showResults();
    }
  }

  void _showResults() {
    final results = gameManager.getGameResults();

    // Debug print untuk melihat data yang dikirim
    print('DEBUG CollaborationGameScreen _showResults:');
    print('- groupName: ${gameManager.groupName}');
    print('- studentNames: ${gameManager.studentNames}');
    print('- studentResults: ${gameManager.studentResults}');
    print('- studentsWhoAnswered: ${gameManager.studentsWhoAnswered}');
    print('- removeNamesAfterSpin: ${gameManager.removeNamesAfterSpin}');
    print(
      '- modeSoal: ${gameManager.removeNamesAfterSpin ? 'sesuai_siswa' : 'tetap_30'}',
    );
    print('- results: $results');
    print('- currentScore: ${gameManager.currentScore}');
    print('- correctAnswers: ${gameManager.correctAnswers}');
    print('- wrongAnswers: ${gameManager.wrongAnswers}');

    // Final check before sending
    print('FINAL DATA TO SEND:');
    print('- point: ${results['score']}');
    print('- benar: ${results['correct']}');
    print('- salah: ${results['wrong']}');
    print('- total: ${results['total']}');
    print('- hasilPerSiswa: ${gameManager.studentResults}');
    print('- daftarSiswa: ${gameManager.studentNames}');

    Navigator.pushReplacementNamed(
      context,
      '/hasil',
      arguments: {
        'nama': gameManager.groupName,
        'point': results['score'],
        'benar': results['correct'],
        'salah': results['wrong'],
        'total': results['total'],
        'modeSoal': gameManager.removeNamesAfterSpin
            ? 'sesuai_siswa'
            : 'tetap_30',
        'daftarSiswa': gameManager.studentNames,
        'hasilPerSiswa': gameManager.studentResults,
        'isModeKolaborasi': true,
        'percentage': results['percentage'],
      },
    );
  }

  /// Determines if the game should continue based on the mode
  bool _shouldContinueGame() {
    //ihsan kocak
    if (gameManager.removeNamesAfterSpin) {
      // Mode "sesuai_siswa": continue until all students have answered
      return !gameManager.allStudentsAnswered && gameManager.hasMoreQuestions;
    } else {
      // Mode "tetap_30": continue until all questions are answered
      return gameManager.hasMoreQuestions;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mode Kolaborasi'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        // Prevent user from going back manually
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Score display
              Text(
                'Skor: ${gameManager.currentScore}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Benar: ${gameManager.correctAnswers} | Salah: ${gameManager.wrongAnswers}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16),
              Text(
                gameManager.removeNamesAfterSpin
                    ? 'Siswa yang sudah menjawab: ${gameManager.studentsWhoAnswered.length}/${gameManager.studentNames.length}'
                    : 'Soal tersisa: ${gameManager.availableQuestions.length}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 32),
              // Status display
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                _gameStatus,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
