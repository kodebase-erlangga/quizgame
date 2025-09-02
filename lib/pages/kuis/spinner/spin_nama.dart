import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart' as fortune;
import 'spin_soal_refactored.dart';
import 'widgets/name_popup.dart';

class SpinNama extends StatefulWidget {
  final String mode;
  final List<String> availableNames;
  final String? currentTeam;
  final bool removeAfterSpin;
  final Function(String)? onNameSelected;
  final Function()? onAllNamesComplete;
  final Function(String, int, bool)?
      onQuestionAnswered; // teamName, questionNumber, isCorrect
  final int? maxQuestions; // Add this parameter for custom question count

  const SpinNama({
    super.key,
    required this.mode,
    required this.availableNames,
    this.currentTeam,
    this.removeAfterSpin = true,
    this.onNameSelected,
    this.onAllNamesComplete,
    this.onQuestionAnswered,
    this.maxQuestions, // Add this parameter
  });

  @override
  State<SpinNama> createState() => _SpinNamaState();
}

class _SpinNamaState extends State<SpinNama> with TickerProviderStateMixin {
  List<String> _availableNames = [];
  String? _selectedName;
  bool _isSpinning = false;
  int? _selectedIndex;
  List<int> _globalAvailableQuestions = [];
  StreamController<int>? _fortuneWheelController;
  bool _allowAutoSelect = false; // Flag to control auto-select timing

  @override
  void initState() {
    super.initState();
    _availableNames = List.from(widget.availableNames);
    _fortuneWheelController = StreamController<int>();

    _globalAvailableQuestions = _generateQuestionsForMode();

    print('DEBUG: SpinNama initState');
    print('DEBUG: Mode: ${widget.mode}');
    print('DEBUG: Available names: $_availableNames');
    print('DEBUG: Available questions: $_globalAvailableQuestions');
    print('DEBUG: removeAfterSpin: ${widget.removeAfterSpin}');

    // Remove auto-select from initState to prevent unwanted popups during transitions
    // Auto-select will be handled by _checkForAutoSelect() method when appropriate

    // For battle mode, completely disable auto-select to prevent team transition conflicts
    if (widget.mode == 'battle') {
      print(
          'DEBUG: Battle mode - auto-select disabled to prevent transition conflicts');
      _allowAutoSelect = false;
      return;
    }

    // Enable auto-select after a delay for non-battle modes
    int delayMs = 1500;
    Future.delayed(Duration(milliseconds: delayMs), () {
      if (mounted && widget.mode != 'battle') {
        setState(() {
          _allowAutoSelect = true;
        });
        _checkForAutoSelect();
      }
    });
  }

  @override
  void dispose() {
    _fortuneWheelController?.close();
    super.dispose();
  }

  void _spinWheel() {
    if (_availableNames.isEmpty) {
      _showNoNamesDialog();
      return;
    }

    setState(() {
      _isSpinning = true;
      _selectedName = null;
      _selectedIndex = null;
    });

    final random = Random();
    final index = random.nextInt(_availableNames.length);
    _selectedIndex = index; // Simpan index yang dipilih

    _fortuneWheelController?.add(index);
  }

  void _showNoNamesDialog() {
    print('DEBUG: _showNoNamesDialog called - triggering team completion');
    if (widget.onAllNamesComplete != null) {
      // This will trigger team switch in JumlahSoal
      widget.onAllNamesComplete!();
    } else {
      // Fallback: just pop the current screen
      Navigator.pop(context);
    }
  }

  void _showAllQuestionsCompletedDialog() {
    print('DEBUG: _showAllQuestionsCompletedDialog called');
    if (widget.onAllNamesComplete != null) {
      // This indicates all teams have completed
      widget.onAllNamesComplete!();
    } else {
      // Fallback: just pop the current screen
      Navigator.pop(context);
    }
  }

  void _checkTeamCompletion() {
    print('DEBUG: _checkTeamCompletion called');
    print('DEBUG: Names remaining: ${_availableNames.length}');
    print('DEBUG: Questions remaining: ${_globalAvailableQuestions.length}');
    print('DEBUG: removeAfterSpin: ${widget.removeAfterSpin}');

    bool isTeamCompleted = false;

    if (widget.removeAfterSpin) {
      // Question per student mode: team completed when no names left OR no questions left
      isTeamCompleted =
          _availableNames.isEmpty || _globalAvailableQuestions.isEmpty;
      print('DEBUG: Per student mode - Team completed: $isTeamCompleted');
    } else {
      // Standard mode: team completed when no questions left
      isTeamCompleted = _globalAvailableQuestions.isEmpty;
      print('DEBUG: Standard mode - Team completed: $isTeamCompleted');
    }

    if (isTeamCompleted) {
      print('DEBUG: Team completion detected - calling onAllNamesComplete');
      _showNoNamesDialog();
    } else if (_availableNames.isNotEmpty &&
        _globalAvailableQuestions.isNotEmpty) {
      // Team can continue - check if we should auto-select
      _checkForAutoSelect();
    }
  }

  void _checkForAutoSelect() {
    print('DEBUG: _checkForAutoSelect called');
    print('DEBUG: Available names: ${_availableNames.length}');
    print('DEBUG: Allow auto-select: $_allowAutoSelect');

    if (_allowAutoSelect &&
        _availableNames.length == 1 &&
        _selectedName == null) {
      print('DEBUG: Auto-selecting last remaining member');
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted && _availableNames.isNotEmpty && _allowAutoSelect) {
          setState(() {
            _selectedName = _availableNames[0];
          });
          _showSingleNamePopupAndContinue();
        }
      });
    } else if (_availableNames.length > 1) {
      print('DEBUG: Multiple members available, waiting for spin');
    } else if (!_allowAutoSelect) {
      print('DEBUG: Auto-select not allowed yet, waiting...');
    }
  }

  List<int> _generateQuestionsForMode() {
    List<int> questions;

    if (widget.mode == 'collaboration') {
      if (widget.removeAfterSpin) {
        final totalStudents = widget.availableNames.length;
        questions = List.generate(totalStudents, (i) => i + 1);
      } else {
        questions = List.generate(30, (i) => i + 1);
      }
    } else if (widget.mode == 'battle') {
      // For battle mode, questions are managed per team
      if (widget.removeAfterSpin) {
        // Question per student mode: each student gets 1 question
        final totalStudents = widget.availableNames.length;
        questions = List.generate(totalStudents, (i) => i + 1);
        print(
            'DEBUG: Battle mode - Question per student: $totalStudents questions');
      } else {
        // Standard mode: use maxQuestions if provided, otherwise default to 30
        int questionCount = widget.maxQuestions ?? 30;
        questions = List.generate(questionCount, (i) => i + 1);
        print('DEBUG: Battle mode - Standard: $questionCount questions');
      }
    } else {
      questions = List.generate(5, (i) => i + 1);
    }

    print('DEBUG: Generated questions: ${questions.length} total');
    return questions;
  }

  void _continueToNextStep() {
    print('DEBUG: _continueToNextStep - Starting');
    print('DEBUG: Selected name: $_selectedName');
    print('DEBUG: Questions available: ${_globalAvailableQuestions.length}');
    print('DEBUG: Names available: ${_availableNames.length}');

    if (_selectedName != null) {
      // Check if there are still questions available
      if (_globalAvailableQuestions.isEmpty) {
        print('DEBUG: No questions available, showing completion dialog');
        _showAllQuestionsCompletedDialog();
        return;
      }

      print('DEBUG: Proceeding to SpinSoal');
      if (widget.mode == 'collaboration' || widget.mode == 'battle') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SpinSoal(
              mode: widget.mode,
              currentPlayer: _selectedName,
              currentTeam: widget.currentTeam,
              availableQuestions: List.from(_globalAvailableQuestions),
              onQuestionAnsweredWithNumber: (questionNumber, isCorrect) {
                print(
                    'DEBUG: SpinNama received question answered - Number: $questionNumber, Correct: $isCorrect');

                // Immediately call the parent callback for battle mode scoring
                if (widget.mode == 'battle' &&
                    widget.onQuestionAnswered != null) {
                  print('DEBUG: Calling parent onQuestionAnswered callback');
                  widget.onQuestionAnswered!(
                      widget.currentTeam ?? '', questionNumber, isCorrect);
                }
              },
              onAllQuestionsComplete: () {
                if (mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ),
        ).then((answeredQuestionNumber) {
          if (mounted) {
            print(
                'DEBUG: Returned from SpinSoal with answered question: $answeredQuestionNumber');

            if (widget.mode == 'collaboration') {
              if (widget.removeAfterSpin) {
                setState(() {
                  _availableNames.remove(_selectedName);
                  if (answeredQuestionNumber != null) {
                    _globalAvailableQuestions.remove(answeredQuestionNumber);
                  }
                  _selectedName = null;
                  _selectedIndex = null;
                });
              } else {
                setState(() {
                  if (answeredQuestionNumber != null) {
                    _globalAvailableQuestions.remove(answeredQuestionNumber);
                  }
                  _selectedName = null;
                  _selectedIndex = null;
                });
              }
            } else if (widget.mode == 'battle') {
              setState(() {
                // Remove name only if removeAfterSpin is true (question per student mode)
                if (widget.removeAfterSpin) {
                  print('DEBUG: Battle mode - Removing name: $_selectedName');
                  _availableNames.remove(_selectedName);
                } else {
                  print('DEBUG: Battle mode - Keeping name: $_selectedName');
                }
                if (answeredQuestionNumber != null) {
                  print(
                      'DEBUG: Battle mode - Removing question: $answeredQuestionNumber');
                  _globalAvailableQuestions.remove(answeredQuestionNumber);
                }
                print('DEBUG: Remaining names: $_availableNames');
                print('DEBUG: Remaining questions: $_globalAvailableQuestions');
                _selectedName = null;
                _selectedIndex = null;

                // Reset auto-select flag to prevent immediate popup
                _allowAutoSelect = false;
              });

              // Check team completion after a short delay
              Future.delayed(const Duration(milliseconds: 500), () {
                if (mounted) {
                  setState(() {
                    _allowAutoSelect = true;
                  });
                  _checkTeamCompletion();
                }
              });
            } else {
              if (widget.removeAfterSpin) {
                setState(() {
                  _availableNames.remove(_selectedName);
                  if (answeredQuestionNumber != null) {
                    _globalAvailableQuestions.remove(answeredQuestionNumber);
                  }
                  _selectedName = null;
                  _selectedIndex = null;
                });
              } else {
                setState(() {
                  if (answeredQuestionNumber != null) {
                    _globalAvailableQuestions.remove(answeredQuestionNumber);
                  }
                  _selectedName = null;
                  _selectedIndex = null;
                });
              }
            }

            if (widget.mode == 'collaboration') {
              if (widget.removeAfterSpin) {
                if (_availableNames.isEmpty) {
                  _showNoNamesDialog();
                } else {
                  _checkForAutoSelect();
                }
              } else {
                if (_globalAvailableQuestions.isEmpty) {
                  _showAllQuestionsCompletedDialog();
                } else {
                  _checkForAutoSelect();
                }
              }
            } else if (widget.mode == 'battle') {
              // Use centralized team completion check
              _checkTeamCompletion();
            } else {
              if (_availableNames.isEmpty) {
                _showNoNamesDialog();
              } else if (_globalAvailableQuestions.isEmpty) {
                _showAllQuestionsCompletedDialog();
              } else if (_availableNames.length == 1) {
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (mounted) {
                    setState(() {
                      _selectedName = _availableNames[0];
                    });
                    _showSingleNamePopupAndContinue();
                  }
                });
              }
            }
          }
        });
      } else if (widget.onNameSelected != null) {
        widget.onNameSelected!(_selectedName!);
      }
    } else {}
  }

  void _showSingleNamePopupAndContinue() async {
    if (_selectedName != null) {
      print(
          'DEBUG: _showSingleNamePopupAndContinue - Starting with $_selectedName');
      print('DEBUG: Questions available: ${_globalAvailableQuestions.length}');

      // Show popup for single name
      await NamePopup.show(
        context,
        selectedName: _selectedName!,
        autoClose: true,
        autoCloseDuration: const Duration(seconds: 3),
      );

      print('DEBUG: Popup closed, continuing to next step');

      // Continue to next step after popup
      if (mounted) {
        _continueToNextStep();
      }
    }
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Image.asset(
                'assets/images/icon_back.png',
                height: 54.0,
                width: 54.0,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.arrow_back_ios, color: Colors.white);
                },
              ),
              onPressed: () async {
                final shouldExit = await _showExitConfirmationDialog();
                if (shouldExit == true && context.mounted) {
                  Navigator.pop(context);
                }
              },
              tooltip: 'Kembali',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeImage() {
    return Align(
      alignment: Alignment.center,
      child: Image.asset(
        'assets/images/spinGiliranSiswa.png',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildInstructionText() {
    return const Text(
      'Klik spin wheel dibawah ini untuk memilih nama',
      style: TextStyle(
        fontStyle: FontStyle.normal,
        fontFamily: 'Satoshi',
        fontSize: 15,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildPlayerInfo() {
    if (widget.currentTeam == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset(
                'assets/icons/icon_kelas.png',
                width: 12,
                height: 12,
                color: Colors.white,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.group, size: 12, color: Colors.white);
                },
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${widget.currentTeam}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNamesRemaining() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/icons/icon_nama.png', width: 45, height: 45),
        const SizedBox(width: 12),
        Container(
          width: 230,
          height: 45,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(38),
            border: Border.all(color: Colors.black87, width: 1),
          ),
          child: Text(
            'Sisa nama: ${_availableNames.length}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainContent() {
    if (_availableNames.isNotEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 250,
            height: 250,
            child: GestureDetector(
              onTap: _isSpinning ? null : _spinWheel,
              child: _buildSpinningWheel(),
            ),
          ),
        ],
      );
    }

    if (_isSpinning) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 16),
            Text(
              'Memilih nama...',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildSpinningWheel() {
    final List<Color> wheelColors = [
      Colors.purple.shade500,
      Colors.blue.shade500,
      Colors.teal.shade500,
      Colors.green.shade500,
      Colors.amber.shade500,
      Colors.orange.shade500,
      Colors.red.shade500,
      Colors.pink.shade500,
    ];

    if (_availableNames.length == 1) {
      final colorIndex = 0;

      // For battle mode, show a manual button instead of auto-triggering
      if (widget.mode == 'battle') {
        return Container(
          width: 250,
          height: 250,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: wheelColors[colorIndex],
            border: Border.all(color: Colors.white, width: 4),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _availableNames[0],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: 'Poppins',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedName = _availableNames[0];
                    });
                    _continueToNextStep();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: wheelColors[colorIndex],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Pilih',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      // Original single name display for non-battle modes
      return Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: wheelColors[colorIndex],
          border: Border.all(color: Colors.white, width: 4),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _availableNames[0],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  shadows: [
                    Shadow(
                      color: Colors.black38,
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                "Langsung ke soal...",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
      );
    }

    final items = _availableNames.map((name) {
      // Menggunakan warna yang berbeda untuk setiap nama
      final colorIndex = _availableNames.indexOf(name) % wheelColors.length;

      return fortune.FortuneItem(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: Text(
              name,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: _availableNames.length <= 6 ? 14 : 12,
                fontFamily: 'Poppins',
                shadows: const [
                  Shadow(
                    color: Colors.black38,
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        style: fortune.FortuneItemStyle(
          color: wheelColors[colorIndex],
          borderWidth: 2,
          borderColor: Colors.white,
        ),
      );
    }).toList();

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: fortune.FortuneWheel(
        animateFirst: false,
        selected: _fortuneWheelController!.stream,
        items: items,
        duration: const Duration(seconds: 4),
        physics: fortune.CircularPanPhysics(
          duration: const Duration(seconds: 2),
          curve: Curves.decelerate,
        ),
        onAnimationEnd: () => _handleSpinAnimationEnd(),
        styleStrategy: fortune.UniformStyleStrategy(
          borderWidth: 4,
          borderColor: Colors.white,
        ),
      ),
    );
  }

  void _handleSpinAnimationEnd() async {
    if (mounted && _selectedIndex != null) {
      // Pilih nama berdasarkan index yang sudah ditentukan
      final selectedName = _availableNames[_selectedIndex!];

      setState(() {
        _isSpinning = false;
        _selectedName = selectedName;
      });

      // Tampilkan popup nama terpilih
      await NamePopup.show(
        context,
        selectedName: selectedName,
        autoClose: true,
        autoCloseDuration: const Duration(seconds: 3),
      );

      // Lanjutkan ke spin soal setelah popup selesai
      if (mounted) {
        _continueToNextStep();
      }
    }
  }

  Future<bool?> _showExitConfirmationDialog() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Yakin ingin keluar?'),
        content: const Text(
          'Jika Anda keluar sekarang, semua progress akan terhapus.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // Stay on the page
            child: const Text('Tidak'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), // Allow exit
            child: const Text('Ya, keluar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) return;

        final shouldExit = await _showExitConfirmationDialog();
        if (shouldExit == true && context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            color: Color(0xffFEFFE8),
            image: DecorationImage(
              image: AssetImage('assets/images/bg_line.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    _buildAppBar(),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Center(
                        child: Container(
                          width: 853.96,
                          height: 460.53,
                          padding: const EdgeInsets.fromLTRB(100, 36, 100, 36),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(41),
                            color: const Color(0xFF3689EF),
                            border: Border.all(color: Colors.black, width: 3),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildModeImage(),
                                    const SizedBox(height: 20),
                                    _buildInstructionText(),
                                    const SizedBox(height: 20),
                                    _buildPlayerInfo(),
                                    const SizedBox(height: 16),
                                    _buildNamesRemaining(),
                                  ],
                                ),
                              ),
                              Container(
                                width: 2,
                                height: double.infinity,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                color: Colors.white.withOpacity(0.3),
                              ),
                              Expanded(flex: 1, child: _buildMainContent()),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Image.asset(
                    'assets/images/footer.png',
                    width: 400,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Image.asset(
                    'assets/images/footer.png',
                    width: 400,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
