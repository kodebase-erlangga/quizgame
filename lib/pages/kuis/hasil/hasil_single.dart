import 'package:flutter/material.dart';
import 'package:quizgame/pages/mode.dart';
import 'package:quizgame/utils/quiz_calculator.dart';

class HasilSingle extends StatefulWidget {
  final int correctAnswers;
  final int totalQuestions;
  final String playerName;
  final List<Map<String, dynamic>> questionResults;
  final Duration totalTime;

  const HasilSingle({
    super.key,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.playerName,
    required this.questionResults,
    required this.totalTime,
  });

  @override
  State<HasilSingle> createState() => _HasilSingleState();
}

class _HasilSingleState extends State<HasilSingle> {
  late QuizResult _quizResult;

  @override
  void initState() {
    super.initState();
    // Recalculate results using QuizCalculator for consistency
    _quizResult = QuizCalculator.calculateResults(
      correctAnswers: widget.correctAnswers,
      totalQuestions: widget.totalQuestions,
      questionResults: widget.questionResults,
    );
  }

  String get scorePercentage {
    return '${_quizResult.percentage.round()}%';
  }

  String get performanceLevel {
    return _quizResult.performanceLevel;
  }

  Color get performanceColor {
    if (_quizResult.percentage >= 80) return Colors.green;
    if (_quizResult.percentage >= 60) return Colors.blue;
    if (_quizResult.percentage >= 40) return Colors.orange;
    return Colors.red;
  }

  String get formattedTime {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(widget.totalTime.inMinutes.remainder(60));
    final seconds = twoDigits(widget.totalTime.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
        return false;
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
            child: Column(
              children: [
                _buildAppBar(context),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(250, 20, 250, 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 46),
                        _buildNameContainer(),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(child: _buildCorrectAnswersContainer()),
                            const SizedBox(width: 20),
                            Expanded(child: _buildWrongAnswersContainer()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
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
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ModePermainan(),
                  ),
                  (route) => false,
                );
              },
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Hasil',
                style: TextStyle(
                  color: Color(0xFF444444),
                  fontFamily: 'Straw Milky',
                  fontSize: 32,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          Image.asset(
            'assets/images/Quizverse.png',
            width: 153,
            height: 47,
          ),
        ],
      ),
    );
  }

  Widget _buildNameContainer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFF444444), width: 2),
        color: const Color(0xFF459D93),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.playerName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Straw Milky',
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorrectAnswersContainer() {
    return Container(
      height: 185,
      width: 510,
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 21),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF444444), width: 2),
        color: const Color(0xFF459D93),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Jawaban yang benar',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Straw Milky',
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '${_quizResult.correctAnswers}',
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Straw Milky',
              fontSize: 64,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWrongAnswersContainer() {
    return Container(
      height: 185,
      width: 510,
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 21),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF444444), width: 2),
        color: const Color(0xFFEA4C37),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Jawaban yang salah',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Straw Milky',
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '${_quizResult.wrongAnswers}',
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Straw Milky',
              fontSize: 64,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
