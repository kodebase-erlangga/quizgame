import 'package:flutter/material.dart';
import 'package:quizgame/pages/mode.dart';
import 'models/spin_soal_model.dart';
import 'controllers/spin_soal_controller.dart';
import 'widgets/spin_wheel_widget.dart';
import 'widgets/spin_info_widgets.dart';
import 'widgets/question_popup.dart';
import 'utils/dialog_utils.dart';

class SpinSoal extends StatefulWidget {
  final String mode;
  final String? currentPlayer;
  final String? currentTeam;
  final List<int> availableQuestions;
  final Function(bool)? onQuestionAnswered;
  final Function(int, bool)? onQuestionAnsweredWithNumber;
  final Function()? onAllQuestionsComplete;

  SpinSoal({
    super.key,
    required this.mode,
    this.currentPlayer,
    this.currentTeam,
    required this.availableQuestions,
    this.onQuestionAnswered,
    this.onQuestionAnsweredWithNumber,
    this.onAllQuestionsComplete,
  }) {
    print('DEBUG SpinSoal constructor:');
    print('- mode: $mode');
    print('- currentPlayer: $currentPlayer');
    print('- onQuestionAnswered available: ${onQuestionAnswered != null}');
    print(
      '- onQuestionAnsweredWithNumber available: ${onQuestionAnsweredWithNumber != null}',
    );
  }

  @override
  State<SpinSoal> createState() => _SpinSoalState();
}

class _SpinSoalState extends State<SpinSoal> {
  late SpinSoalController _controller;

  @override
  void initState() {
    super.initState();

    final model = SpinSoalModel(
      mode: widget.mode,
      currentPlayer: widget.currentPlayer,
      currentTeam: widget.currentTeam,
      availableQuestions: widget.availableQuestions,
      onQuestionAnswered: widget.onQuestionAnswered,
      onQuestionAnsweredWithNumber: widget.onQuestionAnsweredWithNumber,
      onAllQuestionsComplete: widget.onAllQuestionsComplete,
    );

    _controller = SpinSoalController(model);

    // Auto-select when there's only one question available
    if (_controller.availableQuestions.length == 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _controller.initializeForSingleQuestion(() => setState(() {})).then((
            _,
          ) {
            _showSingleQuestionPopupAndContinue();
          });
        }
      });
    }
  }

  void _showSingleQuestionPopupAndContinue() async {
    if (_controller.selectedQuestion != null && mounted) {
      await QuestionPopup.show(
        context,
        questionNumber: _controller.selectedQuestion!,
        autoClose: true,
        autoCloseDuration: const Duration(seconds: 3),
      );

      // Navigate to question after popup closes
      if (mounted) {
        _controller.answerQuestion(
          context,
          onStateUpdate: () => setState(() {}),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) return;

        final shouldExit = await DialogUtils.showExitConfirmationDialog(
          context,
        );
        if (shouldExit == true && context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(color: Color(0xffFEFFE8)),
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
                            color: Color(0xFF459D93),
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
                                    Align(
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                        'assets/images/spinPertanyaan.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    textspin(),
                                    const SizedBox(height: 20),
                                    _buildPlayerInfo(),
                                    const SizedBox(height: 16),
                                    _buildQuestionsRemaining(),
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
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ModePermainan(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget textspin() {
    return Text(
      'Klik spin wheel dibawah ini untuk mendapatkan soal ',
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
    if (!_controller.model.hasPlayerInfo) {
      return const SizedBox.shrink();
    }

    return SpinInfoWidgets.buildPlayerInfo(
      mode: _controller.model.mode,
      currentPlayer: _controller.model.currentPlayer,
      currentTeam: _controller.model.currentTeam,
    );
  }

  Widget _buildQuestionsRemaining() {
    return SpinInfoWidgets.buildQuestionsRemaining(
      _controller.availableQuestions.length,
    );
  }

  Widget _buildMainContent() {
    if (_controller.availableQuestions.isNotEmpty) {
      return SpinWheelWidget(
        availableQuestions: _controller.availableQuestions,
        isSpinning: _controller.isSpinning,
        fortuneStream: _controller.fortuneStream,
        onTap: () => _controller.spinWheel(() => setState(() {}), context),
        onAnimationEnd: () => _handleSpinAnimationEnd(),
      );
    }

    if (_controller.isSpinning) {
      return SpinInfoWidgets.buildLoadingIndicator();
    }

    if (_controller.selectedQuestion != null &&
        _controller.currentSoal != null &&
        !_controller.isSpinning) {
      return SpinInfoWidgets.buildSelectedQuestionDisplay(
        selectedQuestion: _controller.selectedQuestion!,
        currentSoal: _controller.currentSoal!,
      );
    }

    return const SizedBox.shrink();
  }

  void _handleSpinAnimationEnd() async {
    _controller.onAnimationEnd(() => setState(() {}), context);

    if (_controller.selectedQuestion != null && mounted) {
      await QuestionPopup.show(
        context,
        questionNumber: _controller.selectedQuestion!,
        autoClose: true,
        autoCloseDuration: const Duration(seconds: 3),
      );

      // Navigate to question after popup closes
      if (mounted) {
        _controller.answerQuestion(
          context,
          onStateUpdate: () => setState(() {}),
        );
      }
    }
  }
}
