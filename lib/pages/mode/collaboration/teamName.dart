import 'package:flutter/material.dart';
import 'package:quizgame/pages/mode.dart';
import 'package:quizgame/pages/mode/collaboration/anggotaTim.dart';
import 'package:quizgame/pages/mode/single/panduan_single.dart';

class Teamname extends StatefulWidget {
  const Teamname({super.key});

  @override
  State<Teamname> createState() => TeamnameState();
}

class TeamnameState extends State<Teamname> {
  final TextEditingController namaGrupController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Color(0xffFEFFE8)),
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
                'assets/images/colaborationmode.png',
                width: 400,
                fit: BoxFit.fitWidth,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset(
                'assets/images/colaborationmode.png',
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

  Widget _buildTeamForm() {
    return Container(
      height: 410,
      width: 490,
      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 90),
      decoration: BoxDecoration(
        color: const Color(0xff3689EF),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff459D93).withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
        ],
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
                    'assets/images/ColaborationModeText.png',
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 18.26),
                Text(
                  'Silahkan masukkan nama tim kamu sebelum memulai permainan',
                  textAlign: TextAlign.center,
                  style: TextStyle(
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
                    Expanded(
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 350),
                        child: TextFormField(
                          controller: namaGrupController,
                          decoration: InputDecoration(
                            hintText: 'Ex : Tim Hore',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide(color: Color(0xFF444444)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: const BorderSide(
                                color: Color(0xFF444444),
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          textCapitalization: TextCapitalization.words,
                          // maxLength: 50,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Nama lengkap harus diisi!';
                            }
                            if (value.trim().length < 2) {
                              return 'Nama minimal 2 karakter!';
                            }
                            return null;
                          },
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TeamPlayer(
                                teamName: namaGrupController.text.trim(),
                              ),
                            ),
                          );
                        }
                      },
                      // onTap: () {
                      //   if (_formKey.currentState!.validate()) {
                      //     Navigator.pushReplacement(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => SpinSoal(
                      //           mode: 'single',
                      //           currentPlayer: namaController.text.trim(),
                      //           availableQuestions: List.generate(
                      //             30,
                      //             (index) => index + 1,
                      //           ),
                      //           onAllQuestionsComplete: () {
                      //             Navigator.pushReplacementNamed(
                      //               context,
                      //               '/hasil',
                      //               arguments: {
                      //                 'nama': namaController.text.trim(),
                      //                 'point': 0,
                      //                 'benar': 0,
                      //                 'salah': 0,
                      //                 'total': 30,
                      //               },
                      //             );
                      //           },
                      //         ),
                      //       ),
                      //     );
                      //   }
                      // },
                      child: Image.asset(
                        'assets/icons/icon_play.png',
                        width: 48,
                        height: 48,
                      ),
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
