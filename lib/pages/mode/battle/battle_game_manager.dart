class BattleGameManager {
  final List<String> teamNames;
  final Map<String, List<String>> teamMembers;
  final int questionsPerTeam;
  final bool removeNamesAfterSpin;

  // Game state
  int currentTeamIndex = 0;
  Map<String, int> teamScores = {};
  Map<String, int> teamCorrect = {};
  Map<String, int> teamWrong = {};
  Map<String, List<String>> teamAvailableMembers = {};
  Map<String, List<int>> teamAvailableQuestions = {};
  Map<String, int> teamCurrentQuestionCount = {};

  // Track member answer status: teamName -> memberName -> isCorrect
  Map<String, Map<String, bool?>> memberAnswerStatus = {};

  // Track which members have answered for each team (similar to collaboration mode)
  Map<String, Set<String>> teamMembersWhoAnswered = {};

  // Current member answering
  String? currentMember;

  BattleGameManager({
    required this.teamNames,
    required this.teamMembers,
    required this.questionsPerTeam,
    required this.removeNamesAfterSpin,
  }) {
    _initializeGame();
  }

  void _initializeGame() {
    for (String teamName in teamNames) {
      teamScores[teamName] = 0;
      teamCorrect[teamName] = 0;
      teamWrong[teamName] = 0;
      teamAvailableMembers[teamName] = List.from(teamMembers[teamName] ?? []);
      teamAvailableQuestions[teamName] = List.generate(
        questionsPerTeam,
        (index) => index + 1,
      );
      teamCurrentQuestionCount[teamName] = 0;

      // Initialize member answer status
      memberAnswerStatus[teamName] = {};
      teamMembersWhoAnswered[teamName] = <String>{};
      for (String member in teamMembers[teamName] ?? []) {
        memberAnswerStatus[teamName]![member] = null;
      }
    }
  }

  String get currentTeamName => teamNames[currentTeamIndex];

  List<String> get currentTeamMembers {
    if (removeNamesAfterSpin) {
      // For "based_on_students" mode: use teamAvailableMembers (names are removed after spin)
      return teamAvailableMembers[currentTeamName] ?? [];
    } else {
      // For standard 30 questions mode: always return all team members
      // This ensures names are never removed from the wheel
      return teamMembers[currentTeamName] ?? [];
    }
  }

  List<int> get currentTeamQuestions =>
      teamAvailableQuestions[currentTeamName] ?? [];

  bool get isGameComplete {
    if (removeNamesAfterSpin) {
      // For "based_on_students" mode: game is complete when all team members have answered once
      for (String teamName in teamNames) {
        final teamMembersList = teamMembers[teamName] ?? [];
        final membersAnswered = teamMembersWhoAnswered[teamName] ?? <String>{};
        if (membersAnswered.length < teamMembersList.length) {
          return false; // This team still has members who haven't answered
        }
      }
      return true; // All team members have answered
    } else {
      // For standard 30 questions mode: game is complete when all questions have been used
      for (String teamName in teamNames) {
        if ((teamCurrentQuestionCount[teamName] ?? 0) < questionsPerTeam) {
          return false; // This team still has questions remaining
        }
      }
      return true; // All teams have used all their questions
    }
  }

  bool get isCurrentTeamComplete {
    if (removeNamesAfterSpin) {
      // For "based_on_students" mode: team is complete when all members have answered
      final teamMembersList = teamMembers[currentTeamName] ?? [];
      final membersAnswered =
          teamMembersWhoAnswered[currentTeamName] ?? <String>{};
      return membersAnswered.length >= teamMembersList.length;
    } else {
      // For standard 30 questions mode: team is complete when all questions have been used
      return (teamCurrentQuestionCount[currentTeamName] ?? 0) >=
          questionsPerTeam;
    }
  }

  void onQuestionAnswered(bool isCorrect, String memberName) {
    final currentTeam = currentTeamName;
    teamCurrentQuestionCount[currentTeam] =
        (teamCurrentQuestionCount[currentTeam] ?? 0) + 1;

    // Record member answer status
    memberAnswerStatus[currentTeam]![memberName] = isCorrect;

    // Track that this member has answered
    teamMembersWhoAnswered[currentTeam]!.add(memberName);

    if (isCorrect) {
      teamScores[currentTeam] = (teamScores[currentTeam] ?? 0) + 10;
      teamCorrect[currentTeam] = (teamCorrect[currentTeam] ?? 0) + 1;
    } else {
      teamWrong[currentTeam] = (teamWrong[currentTeam] ?? 0) + 1;
    }
  }

  void onNameUsed(String memberName) {
    // Set current member
    currentMember = memberName;

    if (removeNamesAfterSpin) {
      teamAvailableMembers[currentTeamName]?.remove(memberName);
    }
  }

  void onQuestionUsed(int questionNumber) {
    teamAvailableQuestions[currentTeamName]?.remove(questionNumber);
  }

  // Get answer status for a specific member in a team
  bool? getMemberAnswerStatus(String teamName, String memberName) {
    return memberAnswerStatus[teamName]?[memberName];
  }

  // Get all member statuses for current team
  Map<String, bool?> getCurrentTeamMemberStatuses() {
    return memberAnswerStatus[currentTeamName] ?? {};
  }

  // Check if current team has more available members and questions
  bool get hasMoreTurnsForCurrentTeam {
    // Check if current team still has members who haven't answered
    final teamMembersList = teamMembers[currentTeamName] ?? [];
    final membersAnswered =
        teamMembersWhoAnswered[currentTeamName] ?? <String>{};

    if (removeNamesAfterSpin) {
      // If removing names after spin, check available members
      return teamAvailableMembers[currentTeamName]?.isNotEmpty ?? false;
    } else {
      // If not removing names, check if all members have answered
      return membersAnswered.length < teamMembersList.length;
    }
  }

  void moveToNextTeam() {
    // Reset available members for next team if needed
    if (currentTeamIndex + 1 < teamNames.length) {
      currentTeamIndex++;
      // Reset available members for the new current team if they were depleted
      if (removeNamesAfterSpin) {
        final nextTeamName = currentTeamName;
        final membersAnswered =
            teamMembersWhoAnswered[nextTeamName] ?? <String>{};
        final allMembers = teamMembers[nextTeamName] ?? [];

        // Only reset if all members have answered but we want to continue
        if (membersAnswered.length >= allMembers.length) {
          teamAvailableMembers[nextTeamName] = List.from(allMembers);
        }
      }
    } else {
      currentTeamIndex++; // This will make isGameComplete return true
    }
  }

  Map<String, dynamic> getResultsData() {
    return {
      'isBattleMode': true,
      'teamNames': teamNames,
      'teamScores': teamScores,
      'teamCorrect': teamCorrect,
      'teamWrong': teamWrong,
      'teamMembers': teamMembers,
      'memberAnswerStatus': memberAnswerStatus, // Add individual member results
      'total': questionsPerTeam,
    };
  }
}
