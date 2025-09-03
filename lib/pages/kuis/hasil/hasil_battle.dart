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
      height: 423,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
      decoration: BoxDecoration(
        color: const Color(0xFFFFAA0D),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (groupedTeams.length >= 2)
            _buildRankingItem(
              rank: 2,
              imagePath: 'assets/icons/juara2.png',
              imageStages: 'assets/images/stand_juara2.png',
              teamNames: groupedTeams[1].value,
              score: groupedTeams[1].key,
              height: 160,
            ),
          if (groupedTeams.length >= 2) const SizedBox(width: 90),
          if (groupedTeams.isNotEmpty)
            _buildRankingItem(
              rank: 1,
              imagePath: 'assets/icons/juara1.png',
              imageStages: 'assets/images/stand_juara1.png',
              teamNames: groupedTeams[0].value,
              score: groupedTeams[0].key,
              height: 200,
            ),
          if (groupedTeams.length >= 3) const SizedBox(width: 90),
          if (groupedTeams.length >= 3)
            _buildRankingItem(
              rank: 3,
              imagePath: 'assets/icons/juara3.png',
              imageStages: 'assets/images/stand_juara3.png',
              teamNames: groupedTeams[2].value,
              score: groupedTeams[2].key,
              height: 120,
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
    required String imageStages,
  }) {
    return SizedBox(
      width: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          imagePath == ''
              ? const SizedBox.shrink()
              : Image.asset(
                  imagePath,
                  width: 137,
                  height: 125,
                  fit: BoxFit.contain,
                ),
          const SizedBox(height: 8),
          // Team name and score
          Text(
            teamNames.join(', '),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Straw Milky',
            ),
          ),
          Text(
            '$score points',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: Colors.white,
              fontFamily: 'Satoshi',
            ),
          ),
          imageStages == ''
              ? const SizedBox.shrink()
              : Image.asset(
                  imageStages,
                  width: 120,
                  height: height,
                  fit: BoxFit.contain,
                ),
        ],
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
