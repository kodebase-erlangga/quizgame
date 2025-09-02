import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';

class QuestionService {
  static Future<Map<String, dynamic>?> loadSoal(int nomorSoal) async {
    print('DEBUG QUESTIONSERVICE: loadSoal called with nomorSoal: $nomorSoal');
    try {
      final String data = await rootBundle.loadString(
        'assets/soal/soal_umum.json',
      );
      final List<dynamic> listSoal = json.decode(data);
      print('DEBUG QUESTIONSERVICE: Total soal available: ${listSoal.length}');

      if (nomorSoal > 0 && nomorSoal <= listSoal.length) {
        final soal = listSoal[nomorSoal - 1];
        print(
            'DEBUG QUESTIONSERVICE: Soal loaded successfully: ${soal['pertanyaan']}');
        return soal;
      }
      print(
          'DEBUG QUESTIONSERVICE: Invalid nomorSoal: $nomorSoal (valid range: 1-${listSoal.length})');
      return null;
    } catch (e) {
      print('DEBUG QUESTIONSERVICE: Error loading soal: $e');
      return null;
    }
  }

  static int selectRandomQuestion(List<int> availableQuestions) {
    if (availableQuestions.isEmpty) {
      throw Exception('No questions available');
    }

    final random = Random();
    final index = random.nextInt(availableQuestions.length);
    return availableQuestions[index];
  }

  static int getRandomIndex(List<int> availableQuestions) {
    if (availableQuestions.isEmpty) {
      throw Exception('No questions available');
    }

    final random = Random();
    return random.nextInt(availableQuestions.length);
  }
}
