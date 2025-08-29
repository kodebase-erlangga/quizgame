import 'package:flutter/material.dart';
import 'package:quizgame/pages/mode.dart';

class HasilBattle extends StatefulWidget {
  final Map<String, int> teamScores;
  final Map<String, List<String>> teamMembers;
  final List<Map<String, dynamic>> battleResults;
  final Duration totalTime;
  final String winnerTeam;

  const HasilBattle({
    super.key,
    required this.teamScores,
    required this.teamMembers,
    required this.battleResults,
    required this.totalTime,
    required this.winnerTeam,
  });

  @override
  State<HasilBattle> createState() => _HasilBattleState();
}

class _HasilBattleState extends State<HasilBattle> {
  String get formattedTime {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(widget.totalTime.inMinutes.remainder(60));
    final seconds = twoDigits(widget.totalTime.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  List<MapEntry<String, int>> get sortedTeams {
    var entries = widget.teamScores.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries;
  }

  Color getTeamColor(int index) {
    const colors = [
      Color(0xFFFFD700), // Gold for winner
      Color(0xFFC0C0C0), // Silver for second
      Color(0xFFCD7F32), // Bronze for third
      Color(0xFF4A9B8E), // Default for others
    ];
    return colors[index < colors.length ? index : colors.length - 1];
  }

  IconData getPositionIcon(int index) {
    switch (index) {
      case 0:
        return Icons.emoji_events;
      case 1:
        return Icons.workspace_premium;
      case 2:
        return Icons.military_tech;
      default:
        return Icons.group;
    }
  }

  String getPositionText(int index) {
    switch (index) {
      case 0:
        return '1st Place - Champion!';
      case 1:
        return '2nd Place - Great Job!';
      case 2:
        return '3rd Place - Well Done!';
      default:
        return '${index + 1}th Place';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFF6B35), Color(0xFFD63031)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildHeader(),
                const SizedBox(height: 30),
                _buildWinnerCard(),
                const SizedBox(height: 20),
                Expanded(child: _buildLeaderboard()),
                const SizedBox(height: 20),
                _buildBattleStats(),
                const SizedBox(height: 20),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Icon(
          Icons.emoji_events,
          size: 80,
          color: Color(0xFFFFD700),
        ),
        const SizedBox(height: 10),
        Text(
          'Battle Complete!',
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Straw Milky',
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'The ultimate quiz showdown has ended!',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white70,
            fontFamily: 'Poppins',
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildWinnerCard() {
    final winnerScore = widget.teamScores[widget.winnerTeam] ?? 0;
    final winnerMembers = widget.teamMembers[widget.winnerTeam] ?? [];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFFFFD700), width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.emoji_events,
            size: 60,
            color: Color(0xFFFFD700),
          ),
          const SizedBox(height: 15),
          Text(
            '🏆 CHAMPION 🏆',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFD700),
              fontFamily: 'Straw Milky',
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.winnerTeam,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFFD63031),
              fontFamily: 'Straw Milky',
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Score: $winnerScore points',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D5A52),
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 15),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: winnerMembers.map((member) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFFFFD700).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Color(0xFFFFD700), width: 1),
                ),
                child: Text(
                  member,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFFD63031),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFFD63031),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.leaderboard, color: Colors.white, size: 24),
                const SizedBox(width: 10),
                const Text(
                  'Final Leaderboard',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: sortedTeams.length,
              itemBuilder: (context, index) {
                final team = sortedTeams[index];
                final members = widget.teamMembers[team.key] ?? [];
                return _buildTeamRankCard(team.key, team.value, members, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamRankCard(
      String teamName, int score, List<String> members, int position) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: getTeamColor(position).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: getTeamColor(position), width: 2),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: getTeamColor(position),
            child: Icon(
              getPositionIcon(position),
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  teamName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D5A52),
                    fontFamily: 'Straw Milky',
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  getPositionText(position),
                  style: TextStyle(
                    fontSize: 14,
                    color: getTeamColor(position),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: members.map((member) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        member,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                '$score',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: getTeamColor(position),
                  fontFamily: 'Poppins',
                ),
              ),
              const Text(
                'points',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBattleStats() {
    final totalQuestions = widget.battleResults.length;
    final totalTeams = widget.teamScores.length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Battle Statistics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFD63031),
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem('Mode', 'Battle Royale'),
              _buildStatItem('Teams', '$totalTeams'),
              _buildStatItem('Questions', '$totalQuestions'),
              _buildStatItem('Duration', formattedTime),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFFD63031),
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const ModePermainan()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFFD63031),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Color(0xFFD63031), width: 2),
              ),
            ),
            child: const Text(
              'Battle Again',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFEFFE8),
              foregroundColor: const Color(0xFFD63031),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Main Menu',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
