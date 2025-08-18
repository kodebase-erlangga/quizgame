import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  Widget _buildProgressBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress indicator text
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Row(
            children: [
              const Icon(Icons.timer_outlined, color: Colors.white70, size: 14),
              const SizedBox(width: 4),
              Text(
                'Sisa soal',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.7),
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
        // Progress bar
        Container(
          margin: const EdgeInsets.only(bottom: 24),
          height: 4,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF7446D8),
            borderRadius: BorderRadius.circular(2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progressValue.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFF8C42),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Text(
        soal!["soal"],
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF39258F),
          fontFamily: 'Poppins',
        ),
      ),
    );
  }

  Widget _buildAnswerButton(int index) {
    final bool isSelected = selectedIndex == index;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedIndex = index;
          });

          // Auto-submit after a short delay when an answer is selected
          Future.delayed(const Duration(milliseconds: 500), () {
            _submitAnswer();
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isSelected ? const Color(0xFFFF8C42) : const Color(0xFF8A56F1),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected ? Colors.transparent : Colors.white,
              width: 1,
            ),
          ),
          elevation: isSelected ? 3 : 1,
        ),
        child: Text(
          soal!["pilihan"][index],
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
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

    // Show feedback dialog
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
                          // if (!benar) ...[
                          //   const SizedBox(height: 8),
                          //   Text(
                          //     'Jawaban yang benar:\n${soal!["jawaban"]}',
                          //     textAlign: TextAlign.center,
                          //     style: const TextStyle(
                          //       color: Colors.white,
                          //       fontFamily: 'Straw Milky',
                          //       fontSize: 16,
                          //       fontWeight: FontWeight.w400,
                          //       height: 2.0,
                          //     ),
                          //   ),
                          // ],
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

  @override
  Widget build(BuildContext context) {
    if (loading || soal == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF8A56F1),
        body: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF8A56F1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Bar
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                      tooltip: 'Kembali',
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Question ${soal!["nomor"]}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),

              // Progress Bar
              _buildProgressBar(),

              // Question Card
              _buildQuestionCard(),

              // Answer Options
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
