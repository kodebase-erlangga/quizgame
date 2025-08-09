import 'package:flutter/material.dart';
import 'package:quizgame/pages/kuis/hasil.dart';
import 'package:quizgame/pages/kuis/soal.dart';
import 'package:quizgame/pages/mode.dart';

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
        '/hasil': (context) => const Hasil(),
        '/soal_kolaborasi': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
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
}
