import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizgame/pages/mode.dart';
import 'package:quizgame/pages/mode/collaboration/anggotaTim.dart';
import 'package:quizgame/pages/mode/single/panduan_single.dart';

class JumlahSoal extends StatefulWidget {
  const JumlahSoal({super.key});

  @override
  State<JumlahSoal> createState() => JumlahSoalState();
}

class JumlahSoalState extends State<JumlahSoal> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? selectedQuestionOption;
  List<String> questionOptions = [
    '30 Soal (Standar)',
    'Jumlah Soal sesuai jumlah peserta'
  ];

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

  Widget DropdownJumlahSoal() {
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
        child: DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          hint: const Text(
            'Pilih Jumlah Soal',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Satoshi',
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500),
          ),
          value: selectedQuestionOption,
          isExpanded: true,
          menuMaxHeight: 200,
          dropdownColor: Colors.white,
          elevation: 8,
          items: questionOptions
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        e,
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
              selectedQuestionOption = value;
              print('Selected: $value');
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
              // Handle button press
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
        const SizedBox(width: 16),
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
              // Handle button press
            },
            child: const Text(
              'Mulai',
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
                const Text(
                  'Silahkan pilih jumlah soal yang akan ditampilkan',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontFamily: 'Satoshi',
                    fontStyle: FontStyle.normal,
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        DropdownJumlahSoal(),
                        const SizedBox(height: 28),
                        Tombol(),
                      ],
                    ),
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
