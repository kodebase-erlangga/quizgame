import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quizgame/pages/mode.dart';
import 'package:quizgame/utils/quiz_calculator.dart';

class HasilKolaborasi extends StatefulWidget {
  const HasilKolaborasi({
    super.key,
  });

  @override
  State<HasilKolaborasi> createState() => _HasilKolaborasiState();
}

class _HasilKolaborasiState extends State<HasilKolaborasi> {
  late QuizResult _quizResult;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
        return false;
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            color: Color(0xffFEFFE8),
            image: DecorationImage(
              image: AssetImage('assets/images/bg_line.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildAppBar(context),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(250, 20, 250, 20),
                    child: Column(
                      children: [
                        infoUmum(),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            formSiswaBenar(),
                            const SizedBox(width: 20),
                            formSiswaSalah(),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
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
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ModePermainan(),
                  ),
                  (route) => false,
                );
              },
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Hasil',
                style: TextStyle(
                  color: Color(0xFF444444),
                  fontFamily: 'Straw Milky',
                  fontSize: 32,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          Image.asset(
            'assets/images/Quizverse.png',
            width: 153,
            height: 47,
          ),
        ],
      ),
    );
  }

  Widget infoUmum() {
    return Container(
      width: 1040,
      height: 74,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: Colors.black, width: 2),
        color: const Color(0xFF3689EF),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/icon_namatim.png',
            width: 34,
            height: 34,
          ),
          const Text(
            'Gamers', //DIisi dengan nama tim
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Straw Milky',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
            ),
          ),
          const Spacer(),
          Center(
            child: Row(
              children: [
                Image.asset(
                  'assets/icons/icon_group.png',
                  width: 34,
                  height: 34,
                ),
                const Text(
                  '30 Orang', //Diisi dengan jumlah peserta
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Straw Milky',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Image.asset(
            'assets/icons/icon_mode.png',
            width: 34,
            height: 34,
          ),
          const Text(
            'Mode Soal Sesuai Siswa', //Diisi dengan mode soal yang dipilih
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Straw Milky',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget formSiswaBenar() {
    // Sample student names for demonstration
    List<String> siswaBenar = [
      'Lucky Febrian',
      'Lucky Febrian',
      'Lucky Febrian',
      'Lucky Febrian'
    ];

    return Container(
      width: 510,
      height: 507,
      padding: const EdgeInsets.fromLTRB(26, 21, 26, 21),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black, width: 2),
        color: Color(0xFF459D93),
      ),
      child: Column(
        children: [
          const Text(
            'Siswa yang Benar',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Straw Milky',
              fontSize: 18,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
            ),
          ),
          const SizedBox(height: 18),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 4.5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: siswaBenar.length,
              itemBuilder: (context, index) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black.withOpacity(0.25),
                    // border: Border.all(
                    //     color: Colors.black.withOpacity(0.8), width: 1),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '${index + 1}. ',
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Straw Milky',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          siswaBenar[index],
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Straw Milky',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          overflow: TextOverflow.ellipsis,
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

  Widget formSiswaSalah() {
    // Sample student names for demonstration
    List<String> siswaBenar = [
      'Lucky Febrian',
      'Lucky Febrian',
      'Lucky Febrian',
      'Lucky Febrian'
    ];

    return Container(
      width: 510,
      height: 507,
      padding: const EdgeInsets.fromLTRB(26, 21, 26, 21),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black, width: 2),
        color: const Color(0xFFEA4C37),
      ),
      child: Column(
        children: [
          const Text(
            'Siswa yang salah',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Straw Milky',
              fontSize: 18,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
            ),
          ),
          const SizedBox(height: 18),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 4.5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: siswaBenar.length,
              itemBuilder: (context, index) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black.withOpacity(0.25),
                    // border: Border.all(
                    //     color: Colors.black.withOpacity(0.8), width: 1),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '${index + 1}. ',
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Straw Milky',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          siswaBenar[index],
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Straw Milky',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          overflow: TextOverflow.ellipsis,
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
}