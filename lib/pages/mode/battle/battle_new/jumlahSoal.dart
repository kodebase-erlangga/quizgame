import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizgame/pages/mode.dart';
import 'package:quizgame/pages/mode/single/panduan_single.dart';
import 'package:quizgame/pages/kuis/spinner/spin_nama.dart';
import 'package:quizgame/pages/kuis/hasil/hasil_battle.dart';
import '../team_transition.dart';

class JumlahSoal extends StatefulWidget {
  final int teamCount;
  final int studentCount;
  final List<List<String>> teamMembers;
  final List<String> teamNames;

  const JumlahSoal({
    super.key,
    required this.teamCount,
    required this.studentCount,
    required this.teamMembers,
    required this.teamNames,
  });

  @override
  State<JumlahSoal> createState() => JumlahSoalState();
}

class JumlahSoalState extends State<JumlahSoal> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? selectedQuestionOption;
  List<String> questionOptions = [
    '30 Soal (Standar)',
    'Jumlah Soal sesuai jumlah peserta'
  ];

  // Battle state management
  Map<String, int> teamScores = {};
  Map<String, List<String>> teamMembersMap = {};
  List<Map<String, dynamic>> battleResults = [];
  DateTime? battleStartTime;

  @override
  void initState() {
    super.initState();
    _initializeBattleData();
  }

  void _initializeBattleData() {
    // Initialize team scores and members map
    for (int i = 0; i < widget.teamCount; i++) {
      String teamName = widget.teamNames[i];
      teamScores[teamName] = 0;
      teamMembersMap[teamName] = List.from(widget.teamMembers[i]);
    }
  }

  void _startBattleMode() {
    if (selectedQuestionOption == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih mode jumlah soal terlebih dahulu'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Determine question mode and start the battle
    bool isQuestionPerStudent =
        selectedQuestionOption == 'Jumlah Soal sesuai jumlah peserta';

    // Initialize battle start time
    battleStartTime = DateTime.now();

    // Start from first team
    _startTeamBattle(
      teamIndex: 0,
      isQuestionPerStudent: isQuestionPerStudent,
    );
  }

  void _startTeamBattle(
      {required int teamIndex, required bool isQuestionPerStudent}) {
    print(
        'DEBUG: _startTeamBattle called - teamIndex: $teamIndex, totalTeams: ${widget.teamCount}');

    if (teamIndex >= widget.teamCount) {
      // All teams completed, navigate to results
      print('DEBUG: All teams completed, navigating to results');
      _navigateToResults();
      return;
    }

    List<String> currentTeamMembers = List.from(widget.teamMembers[teamIndex]);
    String currentTeamName = widget.teamNames[teamIndex];

    print(
        'DEBUG: Starting battle for team: $currentTeamName (index: $teamIndex)');

    // Calculate number of questions for this team
    // (This will be used in the SpinNama component to determine question management)
    int questionsForThisTeam;
    if (isQuestionPerStudent) {
      questionsForThisTeam = currentTeamMembers.length;
    } else {
      questionsForThisTeam = 30; // Standard 30 questions
    }

    // Log for debugging
    print(
        'Team: $currentTeamName, Questions: $questionsForThisTeam, Mode: ${isQuestionPerStudent ? "Per Student" : "Standard"}');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SpinNama(
          mode: 'battle',
          availableNames: currentTeamMembers,
          currentTeam: currentTeamName,
          removeAfterSpin:
              isQuestionPerStudent, // Remove names only in question per student mode
          maxQuestions:
              questionsForThisTeam, // Pass the calculated question count
          onQuestionAnswered: (teamName, questionNumber, isCorrect) {
            // Update team score
            if (isCorrect) {
              setState(() {
                teamScores[teamName] = (teamScores[teamName] ?? 0) + 10;
              });
            }

            // Record battle result
            battleResults.add({
              'teamName': teamName,
              'questionNumber': questionNumber,
              'isCorrect': isCorrect,
              'timestamp': DateTime.now(),
            });

            print(
                'Team: $teamName, Question: $questionNumber, Correct: $isCorrect, Score: ${teamScores[teamName]}');
          },
          onAllNamesComplete: () {
            // When current team completes all questions, show transition to next team
            print(
                'DEBUG: Team $currentTeamName completed all questions, showing transition');

            // Pop the SpinNama screen first
            Navigator.pop(context);

            // Show team transition if there are more teams
            if (teamIndex + 1 < widget.teamCount) {
              String nextTeamName = widget.teamNames[teamIndex + 1];

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TeamTransition(
                    currentTeamName: currentTeamName,
                    nextTeamName: nextTeamName,
                    currentTeamIndex: teamIndex,
                    totalTeams: widget.teamCount,
                    teamScores: Map.from(teamScores),
                    onContinue: () {
                      // Pop transition screen and start next team
                      Navigator.pop(context);
                      _startTeamBattle(
                        teamIndex: teamIndex + 1,
                        isQuestionPerStudent: isQuestionPerStudent,
                      );
                    },
                  ),
                ),
              );
            } else {
              // No more teams, go to results
              _navigateToResults();
            }
          },
        ),
      ),
    ).then((_) {
      // This ensures we handle any unexpected returns from SpinNama
      print('DEBUG: SpinNama returned unexpectedly');
    });
  }

  void _navigateToResults() {
    // Calculate total battle time
    Duration totalTime = DateTime.now().difference(battleStartTime!);

    // Find winner team (team with highest score)
    String winnerTeam = '';
    int highestScore = -1;
    teamScores.forEach((teamName, score) {
      if (score > highestScore) {
        highestScore = score;
        winnerTeam = teamName;
      }
    });

    // Navigate to battle results page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HasilModeBattle(
          teamScores: teamScores,
          teamMembers: teamMembersMap,
          battleResults: battleResults,
          totalTime: totalTime,
          winnerTeam: winnerTeam,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xffFEFFE8),
          image: DecorationImage(
            image: AssetImage('assets/images/bg_line.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                SafeArea(child: _buildAppBar(context)),
                Expanded(child: Center(child: _buildTeamForm())),
                SizedBox(height: 80),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Image.asset(
                'assets/images/groupBattle.png',
                width: 400,
                fit: BoxFit.fitWidth,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset(
                'assets/images/groupBattle.png',
                width: 400,
                fit: BoxFit.fitWidth,
              ),
            ),
          ],
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ModePermainan(),
                  ),
                );
              },
            ),
          ),
          const Spacer(),
          IconButton(
            icon: Image.asset(
              'assets/icons/icon_info.png',
              height: 54.0,
              width: 54.0,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PanduanSingle()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget DropdownJumlahSoal() {
    return Container(
      width: 247,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(38),
        border: Border.all(color: const Color(0xFF444444), width: 1),
      ),
      child: Center(
        child: DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          hint: const Text(
            'Pilih Jumlah Soal',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontFamily: 'Satoshi',
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500),
          ),
          value: selectedQuestionOption,
          isExpanded: true,
          menuMaxHeight: 200,
          dropdownColor: Colors.white,
          elevation: 8,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w500,
          ),
          items: questionOptions
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        e,
                        style: const TextStyle(
                          color: Color(0xFF444444),
                          fontSize: 16,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedQuestionOption = value;
              print('Selected: $value');
            });
          },
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: Color(0xFF444444),
          ),
        ),
      ),
    );
  }

  Widget Tombol() {
    return Row(
      children: [
        Container(
          width: 135,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xff459D93),
            borderRadius: BorderRadius.circular(38),
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Kembali',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Container(
          width: 135,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xff459D93),
            borderRadius: BorderRadius.circular(38),
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: TextButton(
            onPressed: () {
              _startBattleMode();
            },
            child: const Text(
              'Mulai',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTeamForm() {
    return Container(
      height: 410,
      width: 490,
      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 38),
      decoration: BoxDecoration(
        color: const Color(0xffFFAA0D),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.black, width: 2),
        // boxShadow: [
        //   BoxShadow(
        //     color: const Color(0xff459D93).withOpacity(0.4),
        //     blurRadius: 8,
        //     offset: const Offset(0, 4),
        //     spreadRadius: 1,
        //   ),
        // ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/GroupBattleMode.png',
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 18.26),
                const Text(
                  'Silahkan pilih jumlah soal yang akan ditampilkan',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontFamily: 'Satoshi',
                    fontStyle: FontStyle.normal,
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        DropdownJumlahSoal(),
                        const SizedBox(height: 28),
                        Tombol(),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
