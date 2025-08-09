// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:quizgame/pages/mode/battle/home_battle.dart';
import 'package:quizgame/pages/mode/collaboration/teamName.dart';
import 'package:quizgame/pages/mode/single/home_single.dart';

class ModePermainan extends StatelessWidget {
  const ModePermainan({super.key});

  Widget _buildModeCard({
    required String description,
    required String imageAsset,
    required String imageAssetTitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 400,
        height: 450,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 34, vertical: 0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: Colors.black, width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Image.asset(
                'assets/images/$imageAssetTitle',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      Icons.broken_image,
                      size: 64,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  );
                },
              ),
            ),

            SizedBox(
              width: double.infinity,
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFFFFFFF),
                  fontFamily: 'poppins',
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            Expanded(
              child: Image.asset(
                'assets/images/$imageAsset',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      Icons.broken_image,
                      size: 64,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            'Quizverse',
            style: TextStyle(
              fontSize: 100,
              fontWeight: FontWeight.w400,
              fontFamily: 'Straw Milky',
              fontStyle: FontStyle.normal,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 14
                ..color = Colors.green,
            ),
            textAlign: TextAlign.center,
          ),

          Text(
            'Quizverse',
            style: TextStyle(
              fontSize: 100,
              fontWeight: FontWeight.w400,
              fontFamily: 'Straw Milky',
              fontStyle: FontStyle.normal,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 10
                ..color = Colors.white,
            ),
            textAlign: TextAlign.center,
          ),

          const Text(
            'Quizverse',
            style: TextStyle(
              fontSize: 100,
              fontWeight: FontWeight.w400,
              color: Color(0xFF444444),
              fontFamily: 'Straw Milky',
              fontStyle: FontStyle.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Color(0xFFFEFFE8)),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 102),
              _buildHeader(),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildModeCard(
                          imageAssetTitle: 'singlePlayerMode.png',
                          description:
                              'Latihan mandiri untuk mengasah kemampuan secara personal',
                          imageAsset: 'singleplayer.png',
                          color: const Color(0xff459D93),
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Home(),
                              ),
                            );
                          },
                        ),
                        _buildModeCard(
                          imageAssetTitle: 'ColaborationModeText.png',
                          description:
                              'Bekerja sama menjawab soal dan raih skor terbaik sebagai tim',
                          imageAsset: 'colaborationmode.png',
                          color: Color(0xffEA4C37),
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                // builder: (context) => const HomeColaboration(),
                                builder: (context) => Teamname(),
                              ),
                            );
                          },
                        ),
                        _buildModeCard(
                          imageAssetTitle: 'GroupBattleMode.png',
                          description:
                              'Adu cepat dan tepat melawan temanmu dalam kuis seru!',
                          imageAsset: 'groupBattle.png',
                          color: Color(0xFFFFAA0D),
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeBattle(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
