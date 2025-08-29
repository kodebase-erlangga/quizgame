// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:quizgame/pages/mode.dart';

class PanduanSingle extends StatelessWidget {
  const PanduanSingle({super.key});

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
                Expanded(child: Center(child: buildTabLayout())),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Image.asset(
                'assets/images/footer.png',
                width: 400,
                fit: BoxFit.fitWidth,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset(
                'assets/images/footer.png',
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
        ],
      ),
    );
  }
}

Widget buildTabLayout() {
  return Container(
    height: 490,
    width: 590,
    padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
    decoration: BoxDecoration(
      color: const Color(0xff459D93),
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
    child: DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              'assets/images/PanduanKuisSingle.png',
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 24),
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(35),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TabBar(
              indicator: BoxDecoration(
                color: Color(0xffFFAA0D),
                borderRadius: BorderRadius.circular(35),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: const EdgeInsets.all(2),
              dividerColor: Colors.transparent,
              labelColor: Colors.white,
              unselectedLabelColor: const Color(0xFF444444),
              labelStyle: const TextStyle(
                fontFamily: 'Straw Milky',
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              unselectedLabelStyle: const TextStyle(
                fontFamily: 'Straw Milky',
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              tabs: const [
                Tab(text: 'Aturan Main'),
                Tab(text: 'Tips'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: 378,
            height: 250,
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(13),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TabBarView(
              children: [
                // Aturan Main Tab
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRuleItem('Masukkan nama dan mulai kuis'),
                      _buildRuleItem(
                        'Diberikan waktu dengan waktu 90 detik setiap pertanyaan',
                      ),
                      _buildRuleItem('Setiap soal hanya bisa dijawab 1x'),
                      _buildRuleItem(
                        'Terdapat 5 pertanyaan dari berbagai topik',
                      ),
                      _buildRuleItem(
                        'Jawaban benar akan mendapatkan 10 poin, kalau salah 0 poin',
                      ),
                      _buildRuleItem(
                        'Hasil : Benar salah, skor, dan analisis performa',
                      ),
                    ],
                  ),
                ),

                // Tips Tab
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTipItem(
                        'Baca soal dengan teliti dan perhatikan detailnya',
                      ),
                      _buildTipItem(
                        'Manfaatkan waktu dengan baik, jangan terburu-buru',
                      ),
                      _buildTipItem(
                        'Jika ragu, pilih jawaban yang paling masuk akal',
                      ),
                      _buildTipItem(
                        'Fokus pada soal yang sedang dihadapi, jangan terpaku pada soal sebelumnya',
                      ),
                      _buildTipItem(
                        'Gunakan metode eliminasi untuk mempersempit pilihan jawaban',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildRuleItem(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6),
          child: Icon(Icons.star, size: 16, color: Colors.amber),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            textAlign: TextAlign.left,
            style: const TextStyle(
              color: Color(0xFF444444),
              fontFamily: 'Satoshi',
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildTipItem(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6),
          child: Icon(Icons.lightbulb, size: 16, color: Colors.orange),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            textAlign: TextAlign.left,
            style: const TextStyle(
              color: Color(0xFF444444),
              fontFamily: 'Satoshi',
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}
