import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:quizgame/pages/mode.dart';
import 'package:quizgame/pages/mode/collaboration/anggotaTim.dart';
import 'package:quizgame/pages/mode/single/panduan_single.dart';
import 'package:quizgame/pages/mode/battle/battle_new/pembagianTim.dart';

class JumlahTim extends StatefulWidget {
  const JumlahTim({super.key});

  @override
  State<JumlahTim> createState() => JumlahTimState();
}

class JumlahTimState extends State<JumlahTim> {
  final TextEditingController namaGrupController = TextEditingController();
  final TextEditingController jumlahPesertaController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int? selectedTeamCount;
  int? studentCount;
  List<int> availableTeams = [2, 3, 5, 10];
  bool isStudentFilledFirst = false;
  bool isTeamFilledFirst = false;
  static const int maxParticipants = 100;
  Timer? _inputTimer;
  bool _hasShownMaxParticipantsPopup = false;

  @override
  void dispose() {
    _inputTimer?.cancel();
    super.dispose();
  }

  void _startInputTimer() {
    _inputTimer?.cancel();
    _hasShownMaxParticipantsPopup =
        false; // Reset popup state when new input is detected
    _inputTimer = Timer(const Duration(seconds: 2), () {
      if (!_hasShownMaxParticipantsPopup &&
          mounted &&
          studentCount != null &&
          studentCount! > maxParticipants) {
        _showMaxParticipantsInputPopup();
        _hasShownMaxParticipantsPopup = true;
      }
    });
  }

  void _showMaxParticipantsInputPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Peringatan Input',
            style: TextStyle(
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.orange,
            ),
          ),
          content: Text(
            'Anda telah memasukkan ${studentCount!} peserta. Batas maksimal adalah $maxParticipants peserta. Silakan kurangi jumlah peserta sebelum melanjutkan.',
            style: const TextStyle(
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

  void _showMaxParticipantsPopup() {
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
                  'Jumlah peserta yang Anda masukkan: ${studentCount!} orang',
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
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xff459D93),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Ubah Jumlah Peserta',
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

  void _showTeamReducedDialog(int oldTeam, int newTeam) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Jumlah Tim Disesuaikan'),
          content: Text(
            'Jumlah Peserta tidak mencukupi untuk $oldTeam tim. '
            'Jumlah tim otomatis disesuaikan menjadi $newTeam tim.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  int _getMaxPossibleTeams(int students) {
    for (int i = availableTeams.length - 1; i >= 0; i--) {
      if (availableTeams[i] <= students) {
        return availableTeams[i];
      }
    }
    return availableTeams[0];
  }

  List<int> _getFilteredTeams(int students) {
    return availableTeams.where((team) => team <= students).toList();
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
                Expanded(child: Center(child: _buildTeamForm())),
                SizedBox(height: 80),
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

  Widget DropdownJumlahTim() {
    List<int> teamsToShow = studentCount != null
        ? _getFilteredTeams(studentCount!)
        : availableTeams;

    return Container(
      width: 247,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(38),
        border: Border.all(color: const Color(0xFF444444), width: 1),
      ),
      child: Center(
        child: DropdownButtonFormField<int>(
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          hint: const Text(
            'Pilih Jumlah Tim',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Satoshi',
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500),
          ),
          value: selectedTeamCount,
          isExpanded: true,
          menuMaxHeight: 200,
          dropdownColor: Colors.white,
          elevation: 8,
          items: teamsToShow
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        '$e Tim',
                        style: const TextStyle(
                          color: Color(0xFF444444),
                          fontSize: 16,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedTeamCount = value;
              if (studentCount == null) {
                isTeamFilledFirst = true;
                isStudentFilledFirst = false;
              } else {
                // If student count is already filled and exceeds max, start timer
                if (studentCount! > maxParticipants) {
                  _startInputTimer();
                }
              }
              print('Selected: $value Tim');
            });
          },
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: Color(0xFF444444),
          ),
        ),
      ),
    );
  }

  Widget TextFieldJumlahPeserta() {
    return Container(
      width: 180,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(38),
        border: Border.all(color: const Color(0xFF444444), width: 1),
      ),
      child: Center(
        child: TextFormField(
          controller: jumlahPesertaController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            hintText: 'Jumlah Peserta',
            hintStyle: TextStyle(
              color: Color(0xFF969696),
              fontSize: 16,
              fontFamily: 'Satoshi',
            ),
          ),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Satoshi',
          ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              String cleanValue = value.replaceAll(' peserta', '');
              if (cleanValue.isNotEmpty &&
                  RegExp(r'^\d+$').hasMatch(cleanValue)) {
                int newStudentCount = int.parse(cleanValue);

                setState(() {
                  studentCount = newStudentCount;
                  if (selectedTeamCount == null) {
                    isStudentFilledFirst = true;
                    isTeamFilledFirst = false;
                  } else if (isTeamFilledFirst &&
                      selectedTeamCount! > newStudentCount) {
                    // Case 2: Team filled first, but student count is less than team count
                    int oldTeam = selectedTeamCount!;
                    int newTeam = _getMaxPossibleTeams(newStudentCount);
                    selectedTeamCount = newTeam;
                    _showTeamReducedDialog(oldTeam, newTeam);
                  } else if (isStudentFilledFirst &&
                      selectedTeamCount != null &&
                      selectedTeamCount! > newStudentCount) {
                    // Reset team selection if it exceeds new student count
                    selectedTeamCount = null;
                  }
                });

                // Start timer for max participants validation regardless of order
                _startInputTimer();

                String newValue = '$cleanValue peserta';
                jumlahPesertaController.value = TextEditingValue(
                  text: newValue,
                  selection: TextSelection.collapsed(offset: cleanValue.length),
                );
              }
            } else {
              setState(() {
                studentCount = null;
                isStudentFilledFirst = false;
                // Don't reset selectedTeamCount when clearing student count
              });
              _inputTimer?.cancel();
            }
            print('Jumlah Peserta: $value');
          },
        ),
      ),
    );
  }

  Widget _buildTeamForm() {
    return Container(
      height: 410,
      width: 490,
      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 38),
      decoration: BoxDecoration(
        color: const Color(0xffFFAA0D),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.black, width: 2),
        // boxShadow: [
        //   BoxShadow(
        //     color: const Color(0xff459D93).withOpacity(0.4),
        //     blurRadius: 8,
        //     offset: const Offset(0, 4),
        //     spreadRadius: 1,
        //   ),
        // ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/GroupBattleMode.png',
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 18.26),
                Text(
                  'Silahkan pilih jumlah tim dan masukkan jumlah siswa (Maksimal $maxParticipants peserta)',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontStyle: FontStyle.normal,
                  ),
                ),
                SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        DropdownJumlahTim(),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            TextFieldJumlahPeserta(),
                            const SizedBox(width: 16),
                            GestureDetector(
                              onTap: () {
                                // Validate that both team count and student count are selected
                                if (selectedTeamCount != null &&
                                    studentCount != null) {
                                  // Check if student count exceeds maximum limit
                                  if (studentCount! > maxParticipants) {
                                    _showMaxParticipantsPopup();
                                    return;
                                  }

                                  // Additional validation to ensure student count is sufficient
                                  if (studentCount! >= selectedTeamCount!) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PembagianTim(
                                          teamCount: selectedTeamCount!,
                                          studentCount: studentCount!,
                                        ),
                                      ),
                                    );
                                  } else {
                                    // Show error if student count is less than team count
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Jumlah peserta harus lebih besar atau sama dengan jumlah tim'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                } else {
                                  // Show error if either field is not filled
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Silakan pilih jumlah tim dan masukkan jumlah peserta'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              child: Image.asset(
                                'assets/icons/icon_play.png',
                                width: 48,
                                height: 48,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
