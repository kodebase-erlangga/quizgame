import 'package:flutter/material.dart';
import 'package:quizgame/pages/kuis/soal.dart';
import 'package:quizgame/pages/mode.dart';
import 'package:quizgame/utils/quiz_calculator.dart';
import 'pages/kuis/hasil/hasil_single.dart';
import 'pages/kuis/hasil/hasil_colaboration.dart';
import 'pages/kuis/hasil/hasil_battleXX.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ModePermainan(),
      routes: {
        '/hasil': (context) => _buildHasilPage(context),
        '/soal_kolaborasi': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return Soal(
            nama: 'Kolaborasi',
            daftarSiswa: args['siswa'] as List<String>,
            modeSoal: args['modeSoal'] as String?,
          );
        },
      },
    );
  }

  Widget _buildHasilPage(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    if (args == null) {
      // Default to single player if no arguments
      return const HasilSingle(
        correctAnswers: 0,
        totalQuestions: 0,
        playerName: 'Unknown',
        questionResults: [],
        totalTime: Duration(seconds: 0),
      );
    }

    // Process results using QuizCalculator
    final processedArgs = QuizCalculator.processGameResults(args);

    // Check if it's battle mode
    final bool isBattleMode = processedArgs['isBattleMode'] ?? false;
    // if (isBattleMode) {
    //   return HasilBattle(
    //     teamScores: processedArgs['teamScores'] ?? {},
    //     teamMembers: processedArgs['teamMembers'] ?? {},
    //     battleResults: processedArgs['battleResults'] ?? [],
    //     totalTime: processedArgs['totalTime'] ?? const Duration(seconds: 0),
    //     winnerTeam: processedArgs['winnerTeam'] ?? '',
    //   );
    // }

    // Check if it's collaboration mode
    final bool isModeKolaborasi = processedArgs['isModeKolaborasi'] == true ||
        processedArgs['daftarSiswa'] != null;
    if (isModeKolaborasi) {
      return HasilCollaboration(
        correctAnswers: processedArgs['correctAnswers'] ?? 0,
        totalQuestions: processedArgs['totalQuestions'] ?? 0,
        teamName: processedArgs['nama'] ?? 'Team',
        participants: processedArgs['daftarSiswa'] ?? [],
        questionResults: processedArgs['questionResults'] ?? [],
        totalTime: processedArgs['totalTime'] ?? const Duration(seconds: 0),
      );
    }

    // Default to single player mode
    return HasilSingle(
      correctAnswers: processedArgs['correctAnswers'] ?? 0,
      totalQuestions: processedArgs['totalQuestions'] ?? 0,
      playerName: processedArgs['nama'] ?? 'Player',
      questionResults: processedArgs['questionResults'] ?? [],
      totalTime: processedArgs['totalTime'] ?? const Duration(seconds: 0),
    );
  }
}
