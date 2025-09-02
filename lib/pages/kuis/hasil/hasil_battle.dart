import 'package:flutter/material.dart';
import 'package:quizgame/pages/mode.dart';

class HasilModeBattle extends StatefulWidget {
  final Map<String, int> teamScores;
  final Map<String, List<String>> teamMembers;
  final List<Map<String, dynamic>> battleResults;
  final Duration totalTime;
  final String winnerTeam;

  const HasilModeBattle({
    super.key,
    required this.teamScores,
    required this.teamMembers,
    required this.battleResults,
    required this.totalTime,
    required this.winnerTeam,
  });

  @override
  State<HasilModeBattle> createState() => _HasilModeBattleState();
}

class _HasilModeBattleState extends State<HasilModeBattle> {
  late List<MapEntry<String, List<String>>> groupedTeams;

  @override
  void initState() {
    super.initState();
    // Group teams by score
    Map<int, List<String>> scoreGroups = {};

    widget.teamScores.forEach((teamName, score) {
      if (scoreGroups.containsKey(score)) {
        scoreGroups[score]!.add(teamName);
      } else {
        scoreGroups[score] = [teamName];
      }
    });

    // Sort scores in descending order and create grouped teams list
    List<int> sortedScores = scoreGroups.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    groupedTeams = sortedScores
        .map((score) => MapEntry(score.toString(), scoreGroups[score]!))
        .toList();
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
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                children: [
                  _buildAppBar(context),
                  const SizedBox(height: 20),
                  // _buildBattleSummary(),
                  // const SizedBox(height: 20),
                  peringkat(),
                  const SizedBox(height: 30),
                  daftarPeringkat(),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget peringkat() {
    return Container(
      width: 1040,
      height: 403,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
      decoration: BoxDecoration(
        color: const Color(0xFFFFAA0D),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Position 2
          if (groupedTeams.length >= 2)
            _buildRankingItem(
              rank: 2,
              imagePath: 'assets/icons/juara2.png',
              teamNames: groupedTeams[1].value,
              score: groupedTeams[1].key,
              height: 200,
            ),
          // Position 1 (Winner)
          if (groupedTeams.isNotEmpty)
            _buildRankingItem(
              rank: 1,
              imagePath: 'assets/icons/juara1.png',
              teamNames: groupedTeams[0].value,
              score: groupedTeams[0].key,
              height: 250,
            ),
          // Position 3
          if (groupedTeams.length >= 3)
            _buildRankingItem(
              rank: 3,
              imagePath: 'assets/icons/juara3.png',
              teamNames: groupedTeams[2].value,
              score: groupedTeams[2].key,
              height: 150,
            ),
        ],
      ),
    );
  }

  Widget _buildRankingItem({
    required int rank,
    required String imagePath,
    required List<String> teamNames,
    required String score,
    required double height,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Crown/Trophy Image
        Container(
          width: 80,
          height: 80,
          child: Image.asset(
            imagePath,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 10),
        // Podium
        Container(
          width: 180,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: const Offset(2, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Rank Number
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: rank == 1
                      ? Colors.yellow
                      : rank == 2
                          ? Colors.grey[400]
                          : Colors.brown[300],
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Center(
                  child: Text(
                    '$rank',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Team Names (multiple teams if tied)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: teamNames
                        .map(
                          (teamName) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text(
                              teamName,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              // Score
              Text(
                score,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
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

  Widget daftarPeringkat() {
    // Only show if there are more than 3 ranking groups
    if (groupedTeams.length <= 3) {
      return const SizedBox.shrink();
    }

    List<Widget> rankItems = [];
    int currentRank = 4;

    for (int i = 3; i < groupedTeams.length; i++) {
      for (String teamName in groupedTeams[i].value) {
        rankItems.add(_buildTeamRankItem(
          rank: currentRank,
          teamName: teamName,
          points: int.parse(groupedTeams[i].key),
          isEvenRow: (rankItems.length) % 2 == 0,
          isLast: i == groupedTeams.length - 1 &&
              teamName == groupedTeams[i].value.last,
        ));
      }
      // Update rank for next group
      currentRank += groupedTeams[i].value.length;
    }

    return Container(
      width: 1040,
      decoration: BoxDecoration(
        color: const Color(0xFF5BBAA7),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFF4A9B89), width: 2),
      ),
      child: Column(children: rankItems),
    );
  }

  Widget _buildTeamRankItem({
    required int rank,
    required String teamName,
    required int points,
    required bool isEvenRow,
    required bool isLast,
  }) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: isEvenRow
            ? const Color(0xFF5BBAA7) // Lighter teal for even rows
            : const Color(0xFF4A9B89), // Darker teal for odd rows
        borderRadius: isLast
            ? const BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              )
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$rank. $teamName',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Satoshi',
              ),
            ),
            Text(
              '$points Point',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Satoshi',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBattleSummary() {
    String formattedTime =
        "${widget.totalTime.inMinutes}:${(widget.totalTime.inSeconds % 60).toString().padLeft(2, '0')}";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF5BBAA7),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Column(
        children: [
          const Text(
            'Hasil Battle Mode',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Satoshi',
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Pemenang: ${widget.winnerTeam}',
            style: const TextStyle(
              color: Colors.yellow,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: 'Satoshi',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Total Waktu: $formattedTime',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Satoshi',
            ),
          ),
          Text(
            'Jumlah Tim: ${widget.teamScores.length}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Satoshi',
            ),
          ),
        ],
      ),
    );
  }
}
