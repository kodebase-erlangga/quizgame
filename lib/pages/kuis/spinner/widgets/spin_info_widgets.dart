import 'package:flutter/material.dart';

class SpinInfoWidgets {
  static Widget buildPlayerInfo({
    required String mode,
    String? currentPlayer,
    String? currentTeam,
  }) {
    return Row(
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
              currentPlayer ?? "",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                fontFamily: 'Poppins',
              ),
            ),
        ),
      ],
    );
    // return Container(
    //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    //   decoration: BoxDecoration(
    //     color: Colors.white,
    //     borderRadius: BorderRadius.circular(25),
    //   ),
    //   child: Row(
    //     children: [
    //       Image.asset('assets/icons/icon_nama.png', width: 42, height: 42),
    //       const SizedBox(width: 12),
    //       Expanded(
            // child: Text(
            //   currentPlayer ?? "",
            //   style: const TextStyle(
            //     fontSize: 16,
            //     fontWeight: FontWeight.w600,
            //     color: Colors.black87,
            //     fontFamily: 'Poppins',
            //   ),
            // ),
    //       ),
    //     ],
    //   ),
    // );
  }

  static Widget buildQuestionsRemaining(int questionsCount) {
    return Row(
      children: [
        Image.asset('assets/icons/icon_kelas.png', width: 45, height: 45),
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
            'Sisa soal : $questionsCount',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ],
    );
  }

  static Widget buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(color: Colors.white),
          SizedBox(height: 20),
          Text(
            'Sedang memilih soal...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildSelectedQuestionDisplay({
    required int selectedQuestion,
    required Map<String, dynamic> currentSoal,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF8055FE).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.help_outline,
                    color: Color(0xFF8055FE),
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Soal Nomor $selectedQuestion',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8055FE),
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              child: Text(
                currentSoal['soal'] ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildInstructions() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.touch_app, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Tap pada wheel untuk memutar dan memilih soal!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
