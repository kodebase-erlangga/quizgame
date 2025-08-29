import 'package:flutter/material.dart';
import 'package:quizgame/pages/mode.dart';

class HasilCollaboration extends StatefulWidget {
  final int correctAnswers;
  final int totalQuestions;
  final String teamName;
  final List<String> participants;
  final List<Map<String, dynamic>> questionResults;
  final Duration totalTime;

  const HasilCollaboration({
    super.key,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.teamName,
    required this.participants,
    required this.questionResults,
    required this.totalTime,
  });

  @override
  State<HasilCollaboration> createState() => _HasilCollaborationState();
}

class _HasilCollaborationState extends State<HasilCollaboration> {
  String get scorePercentage {
    if (widget.totalQuestions == 0) return '0%';
    return '${((widget.correctAnswers / widget.totalQuestions) * 100).round()}%';
  }

  String get teamPerformance {
    final percentage = (widget.correctAnswers / widget.totalQuestions) * 100;
    if (percentage >= 80) return 'Outstanding Teamwork!';
    if (percentage >= 60) return 'Great Collaboration!';
    if (percentage >= 40) return 'Good Team Effort!';
    return 'Keep Working Together!';
  }

  Color get performanceColor {
    final percentage = (widget.correctAnswers / widget.totalQuestions) * 100;
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return Colors.blue;
    if (percentage >= 40) return Colors.orange;
    return Colors.red;
  }

  String get formattedTime {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(widget.totalTime.inMinutes.remainder(60));
    final seconds = twoDigits(widget.totalTime.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF3689EF), Color(0xFF2D5A87)],
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
                _buildTeamScoreCard(),
                const SizedBox(height: 20),
                _buildParticipantsCard(),
                const SizedBox(height: 20),
                _buildDetailsCard(),
                const Spacer(),
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
          Icons.groups,
          size: 80,
          color: performanceColor,
        ),
        const SizedBox(height: 10),
        Text(
          'Team Challenge Complete!',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Straw Milky',
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 5),
        Text(
          teamPerformance,
          style: TextStyle(
            fontSize: 18,
            color: performanceColor,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTeamScoreCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.group, color: Color(0xFF3689EF), size: 24),
              const SizedBox(width: 8),
              Text(
                widget.teamName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D5A87),
                  fontFamily: 'Straw Milky',
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildScoreItem('Team Score', scorePercentage, performanceColor),
              Container(width: 1, height: 50, color: Colors.grey.shade300),
              _buildScoreItem(
                  'Correct', '${widget.correctAnswers}', Colors.green),
              Container(width: 1, height: 50, color: Colors.grey.shade300),
              _buildScoreItem('Total', '${widget.totalQuestions}', Colors.blue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }

  Widget _buildParticipantsCard() {
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
            'Team Members',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D5A87),
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 15),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.participants.map((participant) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF3689EF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF3689EF), width: 1),
                ),
                child: Text(
                  participant,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF2D5A87),
                    fontWeight: FontWeight.w500,
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

  Widget _buildDetailsCard() {
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
            'Game Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D5A87),
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 15),
          _buildDetailRow('Mode', 'Collaboration'),
          _buildDetailRow('Team Size', '${widget.participants.length} members'),
          _buildDetailRow('Time Taken', formattedTime),
          _buildDetailRow('Wrong Answers',
              '${widget.totalQuestions - widget.correctAnswers}'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontFamily: 'Poppins',
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D5A87),
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
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
              foregroundColor: const Color(0xFF3689EF),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Color(0xFF3689EF), width: 2),
              ),
            ),
            child: const Text(
              'Main Lagi',
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
              foregroundColor: const Color(0xFF3689EF),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Ke Menu Utama',
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
