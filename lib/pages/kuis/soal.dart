import 'package:flutter/material.dart';
import 'jawab_soal.dart';

class SoalStatus extends InheritedWidget {
  final Set<int> dijawab;
  final Map<int, bool> statusJawaban;
  final Function(int) tandaiDijawab;
  const SoalStatus({
    super.key,
    required this.dijawab,
    required this.statusJawaban,
    required this.tandaiDijawab,
    required super.child,
  });

  static SoalStatus? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SoalStatus>();

  @override
  bool updateShouldNotify(SoalStatus oldWidget) =>
      dijawab != oldWidget.dijawab || statusJawaban != oldWidget.statusJawaban;
}

class Soal extends StatefulWidget {
  final String nama;
  final List<String>? daftarSiswa; // Parameter untuk mode kolaborasi
  final String? modeSoal; // Parameter untuk mode soal kolaborasi
  final bool isBattleMode; // Parameter untuk mode battle
  final List<String>? teamNames; // Nama tim untuk battle mode
  final Map<int, List<String>>? teamMembers; // Anggota tim untuk battle mode
  final String? questionMode; // Mode pertanyaan untuk battle
  final List<String>? manualStudents; // Siswa manual untuk battle mode
  final int? classSize; // Ukuran kelas untuk battle mode
  final int? studentsPerTeam; // Jumlah siswa per tim untuk battle mode

  const Soal({
    super.key,
    required this.nama,
    this.daftarSiswa,
    this.modeSoal,
    this.isBattleMode = false,
    this.teamNames,
    this.teamMembers,
    this.questionMode,
    this.manualStudents,
    this.classSize,
    this.studentsPerTeam,
  });

  @override
  State<Soal> createState() => _SoalState();
}

Widget soal(
  BuildContext context,
  Set<int> dijawab,
  Map<int, bool> statusJawaban,
  void Function(int, bool) onAnswered,
  int totalSoal, // Parameter baru untuk total soal
) {
  final isLandscape =
      MediaQuery.of(context).orientation == Orientation.landscape;
  final crossAxisCount = isLandscape ? 10 : 5;
  return GridView.count(
    crossAxisCount: crossAxisCount,
    children: List.generate(totalSoal, (index) {
      final nomor = index + 1;
      final sudahDijawab = dijawab.contains(nomor);
      final isBenar = statusJawaban[nomor];

      Color backgroundColor;
      Color textColor = Colors.black;

      if (sudahDijawab) {
        if (isBenar == true) {
          backgroundColor = Colors.green;
          textColor = Colors.white;
        } else if (isBenar == false) {
          backgroundColor = Colors.red;
          textColor = Colors.white;
        } else {
          backgroundColor = Colors.grey;
          textColor = Colors.white;
        }
      } else {
        backgroundColor = Colors.blue[100]!;
      }

      return GestureDetector(
        onTap: sudahDijawab
            ? null
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => JawabSoal(
                      nomorSoal: nomor,
                      onAnswered: (bool benar) {
                        onAnswered(nomor, benar);
                      },
                    ),
                  ),
                );
              },
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: sudahDijawab
                  ? (isBenar == true ? Colors.green : Colors.red)
                  : Colors.blue,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              '$nomor',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ),
      );
    }),
  );
}

class _SoalState extends State<Soal> {
  final Set<int> _dijawab = {};
  final Map<int, bool> _statusJawaban = {};
  int _benar = 0;
  int _salah = 0;
  int _point = 0;
  late int _totalSoal;

  // Battle mode variables
  final Map<String, int> _teamScores = {};
  final Map<String, int> _teamCorrect = {};
  final Map<String, int> _teamWrong = {};
  int _currentTeamIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeSoal();
    if (widget.isBattleMode) {
      _initializeBattleMode();
    }
  }

  void _initializeSoal() {
    if (widget.isBattleMode) {
      // Battle mode: total soal berdasarkan question mode
      if (widget.questionMode == 'standard_30') {
        _totalSoal = 30;
      } else {
        // Based on students per team, not total students
        int studentsPerTeam = widget.studentsPerTeam ?? 0;
        _totalSoal =
            studentsPerTeam > 0 ? studentsPerTeam : 10; // minimum 10 questions
      }
    } else if (widget.daftarSiswa != null) {
      // Mode kolaborasi: cek pengaturan mode soal
      if (widget.modeSoal == 'tetap_30') {
        _totalSoal = 30;
      } else {
        // Default: soal sesuai jumlah siswa
        _totalSoal = widget.daftarSiswa!.length;
      }
    } else {
      // Mode single: 5 soal
      _totalSoal = 5;
    }
  }

  void _initializeBattleMode() {
    if (widget.teamNames != null) {
      for (String teamName in widget.teamNames!) {
        _teamScores[teamName] = 0;
        _teamCorrect[teamName] = 0;
        _teamWrong[teamName] = 0;
      }
    }
  }

  void _tandaiDijawab(int nomor, bool benar) {
    setState(() {
      _dijawab.add(nomor);
      _statusJawaban[nomor] = benar;
      if (benar) {
        _benar++;
        _point += 10;
      } else {
        _salah++;
      }

      // Update battle mode scores
      if (widget.isBattleMode && widget.teamNames != null) {
        String currentTeam =
            widget.teamNames![_currentTeamIndex % widget.teamNames!.length];
        if (benar) {
          _teamScores[currentTeam] = (_teamScores[currentTeam] ?? 0) + 10;
          _teamCorrect[currentTeam] = (_teamCorrect[currentTeam] ?? 0) + 1;
        } else {
          _teamWrong[currentTeam] = (_teamWrong[currentTeam] ?? 0) + 1;
        }
        _currentTeamIndex++;
      }
    });

    if (_dijawab.length == _totalSoal) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (widget.isBattleMode) {
          _navigateToBattleResults();
        } else {
          _navigateToNormalResults();
        }
      });
    }
  }

  void _navigateToBattleResults() {
    Navigator.pushReplacementNamed(
      context,
      '/hasil',
      arguments: {
        'nama': widget.nama,
        'point': _point,
        'benar': _benar,
        'salah': _salah,
        'total': _totalSoal,
        'isBattleMode': true,
        'teamNames': widget.teamNames,
        'teamScores': _teamScores,
        'teamCorrect': _teamCorrect,
        'teamWrong': _teamWrong,
        'teamMembers': widget.teamMembers,
        'manualStudents': widget.manualStudents,
        'classSize': widget.classSize,
        'studentsPerTeam': widget.studentsPerTeam,
      },
    );
  }

  void _navigateToNormalResults() {
    // Buat data hasil per siswa untuk mode kolaborasi
    Map<String, bool>? hasilPerSiswa;
    if (widget.daftarSiswa != null) {
      hasilPerSiswa = {};

      if (widget.modeSoal == 'tetap_30') {
        // Mode tetap 30: hitung persentase benar untuk setiap siswa
        final persentaseBenar = (_benar / _totalSoal) * 100;
        for (String namaSiswa in widget.daftarSiswa!) {
          // Siswa dianggap "benar" jika persentase >= 70%
          hasilPerSiswa[namaSiswa] = persentaseBenar >= 70;
        }
      } else {
        // Mode sesuai siswa: setiap siswa mewakili satu soal
        for (int i = 0; i < widget.daftarSiswa!.length; i++) {
          final nomorSoal = i + 1;
          final namaSiswa = widget.daftarSiswa![i];
          final hasil = _statusJawaban[nomorSoal] ?? false;
          hasilPerSiswa[namaSiswa] = hasil;
        }
      }
    }

    Navigator.pushReplacementNamed(
      context,
      '/hasil',
      arguments: {
        'nama': widget.nama,
        'point': _point,
        'benar': _benar,
        'salah': _salah,
        'total': _totalSoal,
        'daftarSiswa': widget.daftarSiswa,
        'hasilPerSiswa': hasilPerSiswa,
        'modeSoal': widget.modeSoal,
      },
    );
  }

  PreferredSizeWidget appBar(BuildContext context) {
    String title;

    if (widget.isBattleMode) {
      String currentTeam =
          widget.teamNames != null && widget.teamNames!.isNotEmpty
              ? widget.teamNames![_currentTeamIndex % widget.teamNames!.length]
              : 'Tim';
      title = 'Mode Battle - Giliran: $currentTeam';
    } else if (widget.daftarSiswa != null) {
      title = widget.modeSoal == 'tetap_30'
          ? 'Kolaborasi (${widget.daftarSiswa!.length} Siswa - 30 Soal)'
          : 'Kolaborasi (${widget.daftarSiswa!.length} Siswa - ${widget.daftarSiswa!.length} Soal)';
    } else {
      title = 'Soal - ${widget.nama}';
    }

    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(title),
      backgroundColor: widget.isBattleMode ? Colors.red[100] : null,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            setState(() {
              _dijawab.clear();
              _statusJawaban.clear();
              _benar = 0;
              _salah = 0;
              _point = 0;
              _currentTeamIndex = 0;
              if (widget.isBattleMode) {
                _initializeBattleMode();
              }
            });
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SoalStatus(
      dijawab: _dijawab,
      statusJawaban: _statusJawaban,
      tandaiDijawab: (int nomor) {},
      child: Scaffold(
        appBar: appBar(context),
        body: Align(
          alignment: Alignment.center,
          child: soal(
            context,
            _dijawab,
            _statusJawaban,
            _tandaiDijawab,
            _totalSoal,
          ),
        ),
      ),
    );
  }
}
