import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:quizgame/pages/mode.dart';
import 'package:quizgame/pages/mode/single/panduan_single.dart';
import 'package:quizgame/pages/mode/battle/battle_new/jumlahSoal.dart';

class PembagianTim extends StatefulWidget {
  final int teamCount;
  final int studentCount;

  const PembagianTim({
    super.key,
    required this.teamCount,
    required this.studentCount,
  });

  @override
  State<PembagianTim> createState() => PembagianTimState();
}

class PembagianTimState extends State<PembagianTim> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Timer? _inputTimer;
  bool _hasShownPopup = false;
  static const int maxParticipants = 100;
  bool _isValidParticipantCount = true;

  String? selectedQuestionOption;
  List<String> questionOptions = [
    '30 Soal (Standar)',
    'Jumlah Soal sesuai jumlah peserta'
  ];

  late List<List<String>> teamMembers;
  late List<String> teamNames;

  @override
  void initState() {
    super.initState();
    // Validate student count doesn't exceed maximum
    _isValidParticipantCount = widget.studentCount <= maxParticipants;

    if (!_isValidParticipantCount) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showMaxParticipantsError();
      });
      return;
    }
    _generateTeamMembers();
    _generateTeamNames();
  }

  void _showMaxParticipantsError() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                Icons.warning,
                color: Colors.red,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Batas Maksimal Terlampaui',
                style: TextStyle(
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          content: Container(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jumlah peserta yang Anda masukkan: ${widget.studentCount} orang',
                  style: const TextStyle(
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Batas maksimal: $maxParticipants orang',
                  style: const TextStyle(
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xff459D93),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Silakan kurangi jumlah peserta agar tidak melebihi batas maksimal yang diizinkan.',
                  style: TextStyle(
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Container(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ModePermainan(),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xff459D93),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Kembali & Ubah Jumlah Peserta',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _generateTeamMembers() {
    int studentsPerTeam = (widget.studentCount / widget.teamCount).floor();
    int remainingStudents = widget.studentCount % widget.teamCount;

    teamMembers = [];
    int studentNumber = 1;

    for (int i = 0; i < widget.teamCount; i++) {
      List<String> members = [];
      int membersInThisTeam = studentsPerTeam + (i < remainingStudents ? 1 : 0);

      for (int j = 0; j < membersInThisTeam; j++) {
        members.add('Siswa $studentNumber');
        studentNumber++;
      }
      teamMembers.add(members);
    }
  }

  void _generateTeamNames() {
    teamNames = [];
    for (int i = 0; i < widget.teamCount; i++) {
      teamNames.add('Tim ${i + 1}');
    }
  }

  @override
  void dispose() {
    _inputTimer?.cancel();
    super.dispose();
  }

  void _startInputTimer() {
    _inputTimer?.cancel();
    _hasShownPopup = false; // Reset popup state when new input is detected
    _inputTimer = Timer(const Duration(seconds: 1), () {
      if (!_hasShownPopup && mounted) {
        _showInputConfirmationPopup();
        _hasShownPopup = true;
      }
    });
  }

  void _showInputConfirmationPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Konfirmasi Input',
            style: TextStyle(
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          content: const Text(
            'Anda telah menginput nama anggota tim. Pastikan semua nama sudah sesuai sebelum melanjutkan.',
            style: TextStyle(
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Color(0xff459D93),
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(child: _buildTeamForm()),
                  ),
                ),
                const SizedBox(height: 80),
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
        const Spacer(),
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
              // Pass team data to JumlahSoal page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JumlahSoal(
                    teamCount: widget.teamCount,
                    studentCount: widget.studentCount,
                    teamMembers: teamMembers,
                    teamNames: teamNames,
                  ),
                ),
              );
            },
            child: const Text(
              'Selanjutnya',
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

  Widget editTim() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1,
        ),
        itemCount: widget.teamCount,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/icons/icon_game.png',
                      height: 30,
                      width: 30,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        initialValue: teamNames[index],
                        maxLength: 15,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          counterText: '',
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontFamily: 'Satoshi',
                          fontStyle: FontStyle.normal,
                        ),
                        onChanged: (value) {
                          setState(() {
                            teamNames[index] = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (int memberIndex = 0;
                            memberIndex < teamMembers[index].length;
                            memberIndex++)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Row(
                              children: [
                                const Text(
                                  '• ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontFamily: 'Satoshi',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    initialValue: teamMembers[index]
                                        [memberIndex],
                                    maxLength: 15,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      counterText: '',
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontFamily: 'Satoshi',
                                      fontWeight: FontWeight.w400,
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        teamMembers[index][memberIndex] = value;
                                      });
                                      _startInputTimer();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTeamForm() {
    // Add validation check before rendering
    if (!_isValidParticipantCount) {
      return Container(
        width: 822,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 36),
        decoration: BoxDecoration(
          color: const Color(0xffFFAA0D),
          borderRadius: BorderRadius.circular(41),
          border: Border.all(color: Colors.black, width: 2.5),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 80,
                color: Colors.red,
              ),
              const SizedBox(height: 20),
              Text(
                'Jumlah peserta melebihi batas maksimal',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                  fontFamily: 'Satoshi',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                '${widget.studentCount} > $maxParticipants orang',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontFamily: 'Satoshi',
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      width: 822,
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 36),
      decoration: BoxDecoration(
        color: const Color(0xffFFAA0D),
        borderRadius: BorderRadius.circular(41),
        border: Border.all(color: Colors.black, width: 2.5),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'assets/images/GroupBattleMode.png',
                fit: BoxFit.cover,
                width: 278.559,
              ),
            ),
            const SizedBox(height: 18.26),
            Text(
              'Berikut Pembagian acak siswa tiap tim (Maksimal $maxParticipants peserta), Nomor siswa bisa disesuaikan dengan nomor absensi',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontFamily: 'Satoshi',
                fontStyle: FontStyle.normal,
              ),
            ),
            const SizedBox(height: 28),
            Expanded(
              child: SingleChildScrollView(
                child: editTim(),
              ),
            ),
            const SizedBox(height: 28),
            Tombol(),
          ],
        ),
      ),
    );
  }
}
