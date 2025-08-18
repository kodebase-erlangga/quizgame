import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart' as fortune;

class SpinWheelWidget extends StatelessWidget {
  final List<int> availableQuestions;
  final bool isSpinning;
  final Stream<int>? fortuneStream;
  final VoidCallback? onTap;
  final VoidCallback? onAnimationEnd;

  const SpinWheelWidget({
    super.key,
    required this.availableQuestions,
    required this.isSpinning,
    this.fortuneStream,
    this.onTap,
    this.onAnimationEnd,
  });

  @override
  Widget build(BuildContext context) {
    // Daftar warna yang beragam untuk wheel
    final List<Color> wheelColors = [
      Color(0xFFFFAA0D),
      Color(0xFFEA4C37),
      Color(0xFF459D93),
    ];

    // If there's only one question, show it without the wheel
    if (availableQuestions.length == 1) {
      return _buildSingleQuestionDisplay(wheelColors[0]);
    }

    return _buildFortuneWheel(wheelColors);
  }

  Widget _buildSingleQuestionDisplay(Color color) {
    return Center(
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(color: Colors.white, width: 4),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Soal ${availableQuestions[0]}',
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
              ),
              const SizedBox(height: 10),
              const Text(
                "Langsung menjawab...",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFortuneWheel(List<Color> wheelColors) {
    final items = availableQuestions.map((question) {
      final colorIndex =
          availableQuestions.indexOf(question) % wheelColors.length;

      return fortune.FortuneItem(
        child: Center(
          // memastikan teks benar-benar di tengah sektor
          child: Text(
            'Soal $question',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              fontFamily: 'Poppins',
              shadows: [
                Shadow(
                  color: Colors.black38,
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
        style: fortune.FortuneItemStyle(
          color: wheelColors[colorIndex],
          borderWidth: 4,
          borderColor: Colors.white,
        ),
      );
    }).toList();

    return SizedBox(
      width: 250,
      height: 250,
      child: GestureDetector(
        onTap: isSpinning ? null : onTap,
        child: fortune.FortuneWheel(
          animateFirst: false,
          selected: fortuneStream!,
          items: items,
          duration: const Duration(seconds: 5),
          rotationCount: 20,
          physics: fortune.CircularPanPhysics(
            duration: const Duration(seconds: 2),
            curve: Curves.decelerate,
          ),
          onAnimationEnd: onAnimationEnd,
          styleStrategy: fortune.UniformStyleStrategy(
            borderWidth: 4,
            borderColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
