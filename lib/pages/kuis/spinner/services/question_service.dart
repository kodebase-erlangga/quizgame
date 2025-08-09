import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';

class QuestionService {
  static Future<Map<String, dynamic>?> loadSoal(int nomorSoal) async {
    try {
      final String data = await rootBundle.loadString(
        'assets/soal/soal_umum.json',
      );
      final List<dynamic> listSoal = json.decode(data);

      if (nomorSoal > 0 && nomorSoal <= listSoal.length) {
        return listSoal[nomorSoal - 1];
      }
      return null;
    } catch (e) {
      print('Error loading soal: $e');
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
