import 'package:flutter/material.dart';
import 'package:quizgame/pages/mode.dart';

class Hasil extends StatelessWidget {
  const Hasil({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String nama = args['nama'] ?? '';
    final int point = args['point'] ?? 0;
    final int benar = args['benar'] ?? 0;
    final int salah = args['salah'] ?? 0;
    final int total = args['total'] ?? 30;
    final List<String>? daftarSiswa = args['daftarSiswa'] as List<String>?;
    final Map<String, bool>? hasilPerSiswa =
        args['hasilPerSiswa'] as Map<String, bool>?;
    final String? modeSoal = args['modeSoal'] as String?;

    // Battle mode parameters
    final bool isBattleMode = args['isBattleMode'] ?? false;
    final List<String>? teamNames = args['teamNames'] as List<String>?;
    final Map<String, int>? teamScores =
        args['teamScores'] as Map<String, int>?;
    final Map<String, int>? teamCorrect =
        args['teamCorrect'] as Map<String, int>?;
    final Map<String, int>? teamWrong = args['teamWrong'] as Map<String, int>?;
    final Map<String, List<String>>? teamMembers =
        args['teamMembers'] as Map<String, List<String>>?;
    final Map<String, Map<String, bool?>>? memberAnswerStatus =
        args['memberAnswerStatus'] as Map<String, Map<String, bool?>>?;

    // Tentukan apakah ini mode kolaborasi
    final bool isModeKolaborasi =
        args['isModeKolaborasi'] == true || daftarSiswa != null;

    // Pisahkan siswa berdasarkan hasil jawaban
    List<String> siswaBenar = [];
    List<String> siswaSalah = [];

    // Debug print untuk melihat data yang diterima di hasil
    if (isModeKolaborasi) {
      print('DEBUG Hasil.dart:');
      print('- nama: $nama');
      print('- daftarSiswa: $daftarSiswa');
      print('- hasilPerSiswa: $hasilPerSiswa');
      print('- modeSoal: $modeSoal');
      print('- isModeKolaborasi: $isModeKolaborasi');
      print('- benar: $benar, salah: $salah, total: $total');
    }

    if (hasilPerSiswa != null && hasilPerSiswa.isNotEmpty) {
      print('DEBUG: Processing hasilPerSiswa...');
      hasilPerSiswa.forEach((nama, hasil) {
        print('DEBUG: Student $nama -> ${hasil ? 'BENAR' : 'SALAH'}');
        if (hasil) {
          siswaBenar.add(nama);
        } else {
          siswaSalah.add(nama);
        }
      });

      // Add students who haven't answered yet to "salah" list if in sesuai_siswa mode
      if (modeSoal == 'sesuai_siswa' && daftarSiswa != null) {
        print('DEBUG: Checking for students who haven\'t answered...');
        for (String siswa in daftarSiswa) {
          if (!hasilPerSiswa.containsKey(siswa)) {
            print('DEBUG: Student $siswa hasn\'t answered yet');
            siswaSalah.add('$siswa (belum menjawab)');
          }
        }
      }
    } else if (isModeKolaborasi && daftarSiswa != null) {
      print('DEBUG: hasilPerSiswa is null/empty, marking all as not answered');
      // If hasilPerSiswa is null but we have student list, show all as "not answered yet"
      siswaSalah.addAll(daftarSiswa.map((nama) => '$nama (belum menjawab)'));
    }

    // Debug print hasil kategorisasi
    if (isModeKolaborasi) {
      print('DEBUG Kategorisasi:');
      print('- siswaBenar: $siswaBenar');
      print('- siswaSalah: $siswaSalah');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isBattleMode
              ? 'Hasil Battle'
              : isModeKolaborasi
              ? 'Hasil Kolaborasi'
              : 'Hasil Quiz',
        ),
        backgroundColor: isBattleMode ? Colors.red[100] : null,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isBattleMode) ...[
                _buildBattleResults(
                  teamNames,
                  teamScores,
                  teamCorrect,
                  teamWrong,
                  teamMembers,
                  memberAnswerStatus,
                  total,
                ),
              ] else if (isModeKolaborasi && modeSoal == 'sesuai_siswa') ...[
                // Mode Kolaborasi dengan Soal Sesuai Siswa
                Text(
                  'Grup: $nama',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Jumlah Peserta: ${daftarSiswa?.length ?? 0} siswa',
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
                Text(
                  'Mode: Soal Sesuai Siswa',
                  style: const TextStyle(fontSize: 14, color: Colors.blue),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Point: $point',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Total Soal: $total',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Benar: $benar',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Salah: $salah',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Tampilkan pengelompokan siswa
                Expanded(
                  child: Row(
                    children: [
                      // Kolom siswa yang benar
                      Expanded(
                        child: Card(
                          color: Colors.green[50],
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Jawab Benar (${siswaBenar.length})',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Expanded(
                                  child: siswaBenar.isEmpty
                                      ? const Center(
                                          child: Text(
                                            'Tidak ada siswa\nyang menjawab benar',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        )
                                      : ListView.builder(
                                          itemCount: siswaBenar.length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 2,
                                                  ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.green[100],
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                '${index + 1}. ${siswaBenar[index]}',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Kolom siswa yang salah
                      Expanded(
                        child: Card(
                          color: Colors.red[50],
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Jawab Salah (${siswaSalah.length})',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Expanded(
                                  child: siswaSalah.isEmpty
                                      ? const Center(
                                          child: Text(
                                            'Tidak ada siswa\nyang menjawab salah',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        )
                                      : ListView.builder(
                                          itemCount: siswaSalah.length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 2,
                                                  ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.red[100],
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                '${index + 1}. ${siswaSalah[index]}',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else if (isModeKolaborasi && modeSoal == 'tetap_30') ...[
                // Mode Kolaborasi dengan 30 Soal Standar (tampilan seperti single mode)
                Text(
                  'Grup: $nama',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Jumlah Peserta: ${daftarSiswa?.length ?? 0} siswa',
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
                Text(
                  'Mode: 30 Soal (Standar)',
                  style: const TextStyle(fontSize: 14, color: Colors.blue),
                ),
                const SizedBox(height: 16),
                Text('Point: $point', style: const TextStyle(fontSize: 22)),
                const SizedBox(height: 16),
                Text(
                  'Benar: $benar',
                  style: const TextStyle(fontSize: 20, color: Colors.green),
                ),
                Text(
                  'Salah: $salah',
                  style: const TextStyle(fontSize: 20, color: Colors.red),
                ),
                const SizedBox(height: 8),
                Text(
                  'Total Soal: $total',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                // Tampilkan persentase untuk mode standar
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Persentase Kelulusan: ${((benar / total) * 100).toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        ((benar / total) * 100) >= 70
                            ? 'LULUS ✅'
                            : 'TIDAK LULUS ❌',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ((benar / total) * 100) >= 70
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Standar Kelulusan: ≥70%',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // Mode Single
                Text('Nama: $nama', style: const TextStyle(fontSize: 22)),
                const SizedBox(height: 16),
                Text('Point: $point', style: const TextStyle(fontSize: 22)),
                const SizedBox(height: 16),
                Text(
                  'Benar: $benar',
                  style: const TextStyle(fontSize: 20, color: Colors.green),
                ),
                Text(
                  'Salah: $salah',
                  style: const TextStyle(fontSize: 20, color: Colors.red),
                ),
                const SizedBox(height: 8),
                Text(
                  'Total Soal: $total',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ModePermainan(),
                  ),
                  (route) => false,
                ),
                child: const Text('Kembali ke Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBattleResults(
    List<String>? teamNames,
    Map<String, int>? teamScores,
    Map<String, int>? teamCorrect,
    Map<String, int>? teamWrong,
    Map<String, List<String>>? teamMembers,
    Map<String, Map<String, bool?>>? memberAnswerStatus,
    int total,
  ) {
    if (teamNames == null || teamScores == null) {
      return const Text('Data battle tidak ditemukan');
    }

    // Find winning team
    String winningTeam = teamNames.first;
    int highestScore = teamScores[winningTeam] ?? 0;
    for (String team in teamNames) {
      if ((teamScores[team] ?? 0) > highestScore) {
        highestScore = teamScores[team] ?? 0;
        winningTeam = team;
      }
    }

    return Expanded(
      child: Column(
        children: [
          // Winning team section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.amber[300]!, Colors.amber[100]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.amber.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                const Icon(Icons.emoji_events, size: 48, color: Colors.orange),
                const SizedBox(height: 8),
                const Text(
                  'WINNING TEAM',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  winningTeam,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                Text(
                  '$highestScore Points',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Team scores section
          Expanded(
            child: ListView.builder(
              itemCount: teamNames.length,
              itemBuilder: (context, index) {
                String teamName = teamNames[index];
                int score = teamScores[teamName] ?? 0;
                int correct = teamCorrect?[teamName] ?? 0;
                int wrong = teamWrong?[teamName] ?? 0;
                double percentage = total > 0 ? (correct / total) * 100 : 0;
                bool isWinner = teamName == winningTeam;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: isWinner ? 8 : 4,
                  color: isWinner ? Colors.amber[50] : null,
                  child: ExpansionTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isWinner ? Colors.amber[100] : Colors.blue[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isWinner
                                ? Colors.amber[800]
                                : Colors.blue[800],
                          ),
                        ),
                      ),
                    ),
                    title: Row(
                      children: [
                        if (isWinner)
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                        if (isWinner) const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            teamName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isWinner ? Colors.amber[800] : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Score: $score points'),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              child: LinearProgressIndicator(
                                value: percentage / 100,
                                backgroundColor: Colors.grey[300],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  percentage >= 70 ? Colors.green : Colors.red,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text('${percentage.toStringAsFixed(1)}%'),
                          ],
                        ),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildStatChip(
                                  'Correct',
                                  correct,
                                  Colors.green,
                                ),
                                _buildStatChip('Wrong', wrong, Colors.red),
                                _buildStatChip(
                                  'Total',
                                  correct + wrong,
                                  Colors.blue,
                                ),
                              ],
                            ),
                            if (teamMembers != null &&
                                teamMembers[teamName] != null) ...[
                              const SizedBox(height: 16),
                              const Text(
                                'Team Members:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 4,
                                runSpacing: 4,
                                children: teamMembers[teamName]!.map((member) {
                                  // Get member's answer status
                                  final memberResult =
                                      memberAnswerStatus?[teamName]?[member];
                                  Color chipColor;
                                  IconData? chipIcon;

                                  if (memberResult == null) {
                                    chipColor = Colors.grey;
                                    chipIcon = Icons.help_outline;
                                  } else if (memberResult == true) {
                                    chipColor = Colors.green;
                                    chipIcon = Icons.check_circle;
                                  } else {
                                    chipColor = Colors.red;
                                    chipIcon = Icons.cancel;
                                  }

                                  return Chip(
                                    avatar: Icon(
                                      chipIcon,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    label: Text(
                                      member,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                    backgroundColor: chipColor,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 8),
                              // Legend for member status
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.help_outline,
                                        size: 14,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Belum Menjawab',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        size: 14,
                                        color: Colors.green[600],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Benar',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.green[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.cancel,
                                        size: 14,
                                        color: Colors.red[600],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Salah',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.red[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, int value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Text(
            '$value',
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}
