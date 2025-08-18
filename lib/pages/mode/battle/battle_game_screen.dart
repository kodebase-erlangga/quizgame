import 'package:flutter/material.dart';
import 'package:quizgame/pages/kuis/spinner/spin_soal_refactored.dart';
import '../../kuis/spinner/spin_nama.dart';
import 'battle_game_manager.dart';

class BattleGameScreen extends StatefulWidget {
  final BattleGameManager gameManager;

  const BattleGameScreen({super.key, required this.gameManager});

  @override
  State<BattleGameScreen> createState() => _BattleGameScreenState();
}

class _BattleGameScreenState extends State<BattleGameScreen> {
  late BattleGameManager gameManager;
  String _gameStatus = "Mempersiapkan permainan...";

  @override
  void initState() {
    super.initState();
    gameManager = widget.gameManager;
    // Use WidgetsBinding to safely start the game loop after the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _startGameLoop();
      }
    });
  }

  /// This function implements the game loop for battle mode
  Future<void> _startGameLoop() async {
    while (mounted && !gameManager.isGameComplete) {
      // Check if current team is complete
      if (gameManager.isCurrentTeamComplete) {
        // Move to next team
        gameManager.moveToNextTeam();

        // If no more teams, exit loop
        if (gameManager.isGameComplete) {
          break;
        }

        setState(() {
          _gameStatus = "Giliran ${gameManager.currentTeamName}...";
        });

        // Small delay before starting next team
        await Future.delayed(const Duration(milliseconds: 500));
        continue;
      }

      // Current team still has members to play
      setState(() {
        _gameStatus =
            "Giliran ${gameManager.currentTeamName} - Memilih anggota...";
      });

      // ACTION: Show SpinNama for current team
      final selectedMember = await Navigator.push<String>(
        context,
        MaterialPageRoute(
          builder: (context) => SpinNama(
            mode: 'battle',
            currentTeam: gameManager.currentTeamName,
            availableNames: List.from(gameManager.currentTeamMembers),
            removeAfterSpin: gameManager.removeNamesAfterSpin,
          ),
        ),
      );

      // If user backs out of SpinNama, end the game
      if (selectedMember == null || !mounted) break;

      // Set current member and handle name usage
      gameManager.onNameUsed(selectedMember);

      setState(() {
        _gameStatus =
            "${gameManager.currentTeamName} - $selectedMember akan menjawab soal...";
      });

      // ACTION: Show SpinSoal for selected member
      final answeredQuestion = await Navigator.push<int>(
        context,
        MaterialPageRoute(
          builder: (context) => SpinSoal(
            mode: 'battle',
            currentTeam: gameManager.currentTeamName,
            currentPlayer: selectedMember,
            availableQuestions: List.from(gameManager.currentTeamQuestions),
            onQuestionAnswered: (isCorrect) {
              // Record the answer
              gameManager.onQuestionAnswered(isCorrect, selectedMember);
            },
          ),
        ),
      );

      // If user backs out of SpinSoal/JawabSoal, end the game
      if (answeredQuestion == null || !mounted) break;

      // Remove the answered question
      gameManager.onQuestionUsed(answeredQuestion);

      // Update UI
      setState(() {});
    }

    // Game complete - show results
    if (mounted) {
      setState(() {
        _gameStatus = "Battle Selesai!";
      });
      _showResults();
    }
  }

  void _showResults() {
    Navigator.pushReplacementNamed(
      context,
      '/hasil',
      arguments: gameManager.getResultsData(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Battle Mode - ${gameManager.currentTeamName}'),
        backgroundColor: Colors.red[100],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Kembali',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Team Progress Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Tim ${gameManager.currentTeamName}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatCard(
                          'Soal Dijawab',
                          '${gameManager.teamCurrentQuestionCount[gameManager.currentTeamName] ?? 0}/${gameManager.questionsPerTeam}',
                          Colors.blue,
                        ),
                        _buildStatCard(
                          'Skor',
                          '${gameManager.teamScores[gameManager.currentTeamName] ?? 0}',
                          Colors.green,
                        ),
                        _buildStatCard(
                          'Anggota Tersisa',
                          '${gameManager.currentTeamMembers.length}',
                          Colors.orange,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Team Members with Answer Status
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Anggota Tim:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          (gameManager.teamMembers[gameManager
                                      .currentTeamName] ??
                                  [])
                              .map((member) {
                                final answerStatus = gameManager
                                    .getMemberAnswerStatus(
                                      gameManager.currentTeamName,
                                      member,
                                    );
                                final isAvailable = gameManager
                                    .currentTeamMembers
                                    .contains(member);

                                Color backgroundColor;
                                Color textColor;
                                IconData? icon;

                                if (answerStatus == null) {
                                  // Belum menjawab
                                  backgroundColor = isAvailable
                                      ? Colors.blue[100]!
                                      : Colors.grey[300]!;
                                  textColor = isAvailable
                                      ? Colors.blue[800]!
                                      : Colors.grey[600]!;
                                  icon = isAvailable
                                      ? Icons.person
                                      : Icons.person_outline;
                                } else if (answerStatus == true) {
                                  // Jawaban benar
                                  backgroundColor = Colors.green[100]!;
                                  textColor = Colors.green[800]!;
                                  icon = Icons.check_circle;
                                } else {
                                  // Jawaban salah
                                  backgroundColor = Colors.red[100]!;
                                  textColor = Colors.red[800]!;
                                  icon = Icons.cancel;
                                }

                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: backgroundColor,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: textColor,
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(icon, size: 16, color: textColor),
                                      const SizedBox(width: 4),
                                      Text(
                                        member,
                                        style: TextStyle(
                                          color: textColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              })
                              .toList(),
                    ),
                    const SizedBox(height: 8),
                    // Legend
                    Row(
                      children: [
                        _buildLegendItem(
                          Icons.person,
                          Colors.blue,
                          'Belum Menjawab',
                        ),
                        const SizedBox(width: 16),
                        _buildLegendItem(
                          Icons.check_circle,
                          Colors.green,
                          'Benar',
                        ),
                        const SizedBox(width: 16),
                        _buildLegendItem(Icons.cancel, Colors.red, 'Salah'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Status Display
            SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    _gameStatus,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),

            const Spacer(),

            // Overall Progress
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Progress Battle',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: gameManager.teamNames.map((teamName) {
                        final isCurrentTeam =
                            teamName == gameManager.currentTeamName;
                        final isComplete =
                            (gameManager.teamCurrentQuestionCount[teamName] ??
                                0) >=
                            gameManager.questionsPerTeam;

                        return Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isCurrentTeam
                                    ? Colors.red[100]
                                    : (isComplete
                                          ? Colors.green[100]
                                          : Colors.grey[200]),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isCurrentTeam
                                      ? Colors.red
                                      : (isComplete
                                            ? Colors.green
                                            : Colors.grey),
                                  width: 2,
                                ),
                              ),
                              child: Text(
                                teamName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isCurrentTeam
                                      ? Colors.red
                                      : (isComplete
                                            ? Colors.green
                                            : Colors.grey),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${gameManager.teamCurrentQuestionCount[teamName] ?? 0}/${gameManager.questionsPerTeam}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(IconData icon, MaterialColor color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color[800]),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12, color: color[800])),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
