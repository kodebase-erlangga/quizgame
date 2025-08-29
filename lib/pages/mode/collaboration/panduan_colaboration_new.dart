// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:quizgame/pages/mode.dart';

class PanduanColaboration extends StatelessWidget {
  const PanduanColaboration({super.key});

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
      color: const Color(0xff3689EF),
      borderRadius: BorderRadius.circular(40),
      border: Border.all(color: Colors.black, width: 2),
      boxShadow: [
        BoxShadow(
          color: const Color(0xff3689EF).withOpacity(0.4),
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
              'assets/images/ColaborationModeText.png',
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
                      _buildRuleItem(
                          'Buat tim dan masukkan nama anggota (maksimal 30)'),
                      _buildRuleItem(
                        'Pilih mode soal: Sesuai Siswa atau Standar 30 soal',
                      ),
                      _buildRuleItem(
                          'Sistem spin nama untuk menentukan siapa yang menjawab'),
                      _buildRuleItem(
                        'Setiap anggota mendapat giliran menjawab soal',
                      ),
                      _buildRuleItem(
                        'Waktu 90 detik per soal, jawaban benar +10 poin',
                      ),
                      _buildRuleItem(
                        'Hasil berupa skor tim dan performa individual',
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
                        'Pastikan nama anggota tim ditulis dengan benar',
                      ),
                      _buildTipItem(
                        'Pilih mode "Sesuai Siswa" untuk evaluasi individual',
                      ),
                      _buildTipItem(
                        'Gunakan mode "Standar" untuk latihan intensif',
                      ),
                      _buildTipItem(
                        'Diskusikan strategi tim sebelum memulai',
                      ),
                      _buildTipItem(
                        'Analisis hasil untuk mengetahui kelemahan tim',
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
          child: Icon(Icons.group, size: 16, color: Colors.blue),
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
          child: Icon(Icons.tips_and_updates, size: 16, color: Colors.orange),
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
