import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizgame/pages/mode.dart';

class JawabSoal extends StatefulWidget {
  final int nomorSoal;
  final void Function(bool benar)? onAnswered;
  const JawabSoal({super.key, required this.nomorSoal, this.onAnswered});

  @override
  State<JawabSoal> createState() => _JawabSoalState();
}

class _JawabSoalState extends State<JawabSoal> {
  Map<String, dynamic>? soal;
  int? selectedIndex;
  bool loading = true;

  // Progress value - can be calculated based on current question and total questions
  double progressValue = 0.3;

  @override
  void initState() {
    super.initState();
    loadSoal();
  }

  Future<void> loadSoal() async {
    final String data = await rootBundle.loadString(
      'assets/soal/soal_umum.json',
    );
    final List<dynamic> listSoal = json.decode(data);
    setState(() {
      soal = listSoal[widget.nomorSoal - 1];
      loading = false;

      // Calculate progress as remaining questions
      // Higher value means more questions remaining (inverse of completion)
      if (listSoal.isNotEmpty) {
        // For remaining questions indicator: (total - current) / total
        // This means the bar gets shorter as you progress through questions
        int remainingQuestions = listSoal.length - widget.nomorSoal;
        progressValue = remainingQuestions / listSoal.length;
      }
    });
  }

  Widget _buildQuestionCard() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 200, right: 200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/images/target.png',
                width: 26,
                height: 26,
              ),
              const SizedBox(width: 15),
              const Text(
                'Soal',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontStyle: FontStyle.normal,
                  fontFamily: 'Straw Milky',
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Container(
            width: 548,
            constraints: const BoxConstraints(
              minHeight: 72,
            ),
            padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
            decoration: BoxDecoration(
              color: const Color(0XFF459D93),
              borderRadius: BorderRadius.circular(17),
              border: Border.all(
                color: Colors.black,
                width: 2,
              ),
            ),
            child: Text(
              soal!["soal"],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
                color: Colors.white,
                fontFamily: 'Satoshi',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerButton(int index) {
    final bool isSelected = selectedIndex == index;
    final String optionLetter =
        String.fromCharCode(65 + index); // A, B, C, D, E...

    return Container(
      margin: const EdgeInsets.only(bottom: 12, left: 200, right: 200),
      // width: double.infinity,
      constraints: const BoxConstraints(
        minWidth: 200, // Tambahkan min width
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });

          Future.delayed(const Duration(milliseconds: 500), () {
            _submitAnswer();
          });
        },
        borderRadius: BorderRadius.circular(38),
        child: Container(
          padding: const EdgeInsets.fromLTRB(8, 8, 18, 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(38),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF459D93)
                  : const Color(0xFFFFE2AD),
              width: 1,
            ),
            color: isSelected ? const Color(0xFF459D93) : Colors.white,
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFFFAA0D)
                      : const Color(0xFFFFE2AD),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    optionLetter,
                    style: TextStyle(
                      color:
                          isSelected ? Colors.white : const Color(0xFF444444),
                      fontFamily: 'Satoshi',
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  soal!["pilihan"][index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF444444),
                    fontFamily: 'Satoshi',
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitAnswer() async {
    if (selectedIndex == null) return;

    final jawaban = soal!["pilihan"][selectedIndex!];
    final bool benar = jawaban == soal!["jawaban"];

    print('DEBUG JawabSoal: _submitAnswer called');
    print('DEBUG JawabSoal: selectedIndex=$selectedIndex, jawaban=$jawaban');
    print('DEBUG JawabSoal: correct answer=${soal!["jawaban"]}, benar=$benar');
    print(
      'DEBUG JawabSoal: onAnswered callback available: ${widget.onAnswered != null}',
    );

    // Call the onAnswered callback immediately
    if (widget.onAnswered != null) {
      print('DEBUG JawabSoal: Calling onAnswered callback with benar=$benar');
      widget.onAnswered!(benar);
      print('DEBUG JawabSoal: onAnswered callback completed');
    } else {
      print('DEBUG JawabSoal: WARNING - onAnswered callback is null!');
    }

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                width: 302,
                height: 400,
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border:
                        Border.all(color: const Color(0xFFFEFFE8), width: 8),
                    color: benar
                        ? const Color(0xFF459D93)
                        : const Color(0xffEA4C37)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      benar
                          ? 'assets/images/jawabBenar.png'
                          : 'assets/images/jawabSalah.png',
                      width: 184,
                      height: 115,
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.fromLTRB(22, 14, 22, 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color:
                            benar ? const Color(0xFF459D93) : Color(0xff763F37),
                      ),
                      child: Column(
                        children: [
                          Text(
                            benar
                                ? 'jawaban kamu\nbenar'
                                : 'jawaban kamu\nsalah',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Straw Milky',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              height: 2.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: const Color(0xFFFFAA0D),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xFFDA9006),
                              offset: Offset(0, -6),
                              blurRadius: 0,
                              // inset: true,
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(dialogContext);
                            await Future.delayed(
                                const Duration(milliseconds: 100));
                            if (mounted) {
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.fromLTRB(55, 15, 55, 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Selanjutnya',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
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
          const Spacer(),
          Image.asset(
            'assets/images/Quizverse.png',
            width: 153,
            height: 47,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading || soal == null) {
      return const Scaffold(
        backgroundColor: Color(0xffFEFFE8),
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return Scaffold(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(context),
              const SizedBox(
                height: 78,
              ),
              _buildQuestionCard(),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(
                      soal!["pilihan"].length,
                      (i) => _buildAnswerButton(i),
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
