class CollaborationGameManager {
  final List<String> studentNames;
  final int totalQuestions;
  final bool removeNamesAfterSpin;
  final String groupName;

  List<String> availableNames;
  List<int> availableQuestions;
  Set<String> studentsWhoAnswered = {};
  Map<String, bool> studentResults = {}; 

  int currentScore = 0;
  int correctAnswers = 0;
  int wrongAnswers = 0;
  String? currentStudent; // Track current student answering

  CollaborationGameManager({
    required this.studentNames,
    required this.totalQuestions,
    required this.removeNamesAfterSpin,
    required this.groupName,
  }) : availableNames = List.from(studentNames),
       availableQuestions = List.generate(totalQuestions, (index) => index + 1);

  bool get hasMoreNames => availableNames.isNotEmpty;
  bool get hasMoreQuestions => availableQuestions.isNotEmpty;
  bool get isGameComplete => availableQuestions.isEmpty;
  bool get allStudentsAnswered =>
      studentsWhoAnswered.length >= studentNames.length;

  String? getNextName() {
    if (availableNames.isEmpty) return null;
    return availableNames.first;
  }

  void removeSelectedName(String name) {
    if (removeNamesAfterSpin) {
      availableNames.remove(name);
      // Don't add to studentsWhoAnswered here - it's handled in recordAnswer
    }
    // For tetap_30 mode, don't remove names since students can answer multiple times
  }

  void setCurrentStudent(String name) {
    currentStudent = name;
  }

  void removeSelectedQuestion(int question) {
    availableQuestions.remove(question);
  }

  void recordAnswer(bool isCorrect) {
    if (isCorrect) {
      correctAnswers++;
      currentScore += 10; // 10 points per correct answer
    } else {
      wrongAnswers++;
    }

    // Record individual student result if current student is set
    if (currentStudent != null) {
      studentResults[currentStudent!] = isCorrect;

      // Add to studentsWhoAnswered when recording answer in sesuai_siswa mode
      if (removeNamesAfterSpin) {
        studentsWhoAnswered.add(currentStudent!);
      }

      print(
        'DEBUG recordAnswer: ${currentStudent!} -> ${isCorrect ? 'BENAR' : 'SALAH'}',
      );
      print('DEBUG studentResults: $studentResults');
      print('DEBUG studentsWhoAnswered: $studentsWhoAnswered');
    }
  }

  Map<String, dynamic> getGameResults() {
    return {
      'score': currentScore,
      'correct': correctAnswers,
      'wrong': wrongAnswers,
      'total': totalQuestions,
      'percentage': totalQuestions > 0
          ? (correctAnswers / totalQuestions * 100).round()
          : 0,
    };
  }

  // Reset names if all are used but questions remain
  void resetNamesIfNeeded() {
    if (availableNames.isEmpty &&
        availableQuestions.isNotEmpty &&
        removeNamesAfterSpin) {
      availableNames = List.from(studentNames);
    }
  }
}
