class QuizResult {
  final int correctAnswers;
  final int wrongAnswers;
  final int totalQuestions;
  final double percentage;
  final String performanceLevel;

  QuizResult({
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.totalQuestions,
    required this.percentage,
    required this.performanceLevel,
  });
}

class QuizCalculator {
  static QuizResult calculateResults({
    int? correctAnswers,
    int? wrongAnswers,
    int? totalQuestions,
    List<Map<String, dynamic>>? questionResults,
    Map<String, dynamic>? gameData,
  }) {
    int finalCorrect = 0;
    int finalWrong = 0;
    int finalTotal = 0;

    if (questionResults != null && questionResults.isNotEmpty) {
      finalTotal = questionResults.length;
      for (var result in questionResults) {
        if (result['isCorrect'] == true || result['correct'] == true) {
          finalCorrect++;
        } else {
          finalWrong++;
        }
      }
    }
    // Priority 2: Use gameData if available
    else if (gameData != null) {
      finalCorrect = gameData['benar'] ?? gameData['correctAnswers'] ?? 0;
      finalTotal = gameData['total'] ?? gameData['totalQuestions'] ?? 0;
      finalWrong = finalTotal - finalCorrect;
    }
    // Priority 3: Use direct parameters
    else {
      finalCorrect = correctAnswers ?? 0;
      finalTotal = totalQuestions ?? 0;
      if (wrongAnswers != null) {
        finalWrong = wrongAnswers;
        // Recalculate total if needed
        if (finalTotal == 0) {
          finalTotal = finalCorrect + finalWrong;
        }
      } else {
        finalWrong = finalTotal - finalCorrect;
      }
    }

    // Ensure non-negative values
    finalCorrect = finalCorrect.abs();
    finalWrong = finalWrong.abs();
    finalTotal = finalTotal.abs();

    // Recalculate if totals don't match
    if (finalCorrect + finalWrong != finalTotal && finalTotal > 0) {
      finalWrong = finalTotal - finalCorrect;
    } else if (finalTotal == 0 && (finalCorrect > 0 || finalWrong > 0)) {
      finalTotal = finalCorrect + finalWrong;
    }

    // Calculate percentage
    double percentage = finalTotal > 0 ? (finalCorrect / finalTotal) * 100 : 0;

    // Determine performance level
    String performanceLevel = _getPerformanceLevel(percentage);

    return QuizResult(
      correctAnswers: finalCorrect,
      wrongAnswers: finalWrong,
      totalQuestions: finalTotal,
      percentage: percentage,
      performanceLevel: performanceLevel,
    );
  }

  static String _getPerformanceLevel(double percentage) {
    if (percentage >= 80) return 'Excellent!';
    if (percentage >= 60) return 'Good Job!';
    if (percentage >= 40) return 'Keep Trying!';
    return 'Need More Practice!';
  }

  static Map<String, dynamic> processGameResults(Map<String, dynamic> args) {
    final result = calculateResults(
      correctAnswers: args['benar'] ?? args['correctAnswers'],
      totalQuestions: args['total'] ?? args['totalQuestions'],
      questionResults: args['questionResults'],
      gameData: args,
    );

    return {
      ...args,
      'correctAnswers': result.correctAnswers,
      'wrongAnswers': result.wrongAnswers,
      'totalQuestions': result.totalQuestions,
      'benar': result.correctAnswers,
      'salah': result.wrongAnswers,
      'total': result.totalQuestions,
      'percentage': result.percentage,
      'performanceLevel': result.performanceLevel,
    };
  }
}
