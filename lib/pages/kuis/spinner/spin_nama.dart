import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart' as fortune;
import 'spin_soal_refactored.dart';

class SpinNama extends StatefulWidget {
  final String mode;
  final List<String> availableNames;
  final String? currentTeam;
  final bool removeAfterSpin;
  final Function(String)? onNameSelected;
  final Function()? onAllNamesComplete;

  const SpinNama({
    super.key,
    required this.mode,
    required this.availableNames,
    this.currentTeam,
    this.removeAfterSpin = true,
    this.onNameSelected,
    this.onAllNamesComplete,
  });

  @override
  State<SpinNama> createState() => _SpinNamaState();
}

class _SpinNamaState extends State<SpinNama> with TickerProviderStateMixin {
  List<String> _availableNames = [];
  String? _selectedName;
  bool _isSpinning = false;
  int? _selectedIndex; // Menambahkan variabel untuk menyimpan index terpilih
  List<int> _globalAvailableQuestions =
      []; // Menyimpan soal yang tersisa secara global
  // Fortune wheel controller
  StreamController<int>? _fortuneWheelController;

  @override
  void initState() {
    super.initState();
    _availableNames = List.from(widget.availableNames);
    _fortuneWheelController = StreamController<int>();

    // Inisialisasi soal yang tersedia berdasarkan mode
    _globalAvailableQuestions = _generateQuestionsForMode();

    // Auto-select when there's only one name available
    if (_availableNames.length == 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _selectedName = _availableNames[0];
          });
          // Langsung ke halaman jawab soal tanpa delay
          _continueToNextStep();
        }
      });
    }
  }

  @override
  void dispose() {
    _fortuneWheelController?.close();
    super.dispose();
  }

  void _spinWheel() {
    if (_availableNames.isEmpty) {
      _showNoNamesDialog();
      return;
    }

    setState(() {
      _isSpinning = true;
      _selectedName = null;
      _selectedIndex = null;
    });

    // Select a random index and add it to the fortune wheel controller
    final random = Random();
    final index = random.nextInt(_availableNames.length);
    _selectedIndex = index; // Simpan index yang dipilih

    // Trigger the wheel animation
    _fortuneWheelController?.add(index);

    // Note: Nama akan dipilih di onAnimationEnd untuk sinkronisasi yang tepat
  }

  void _showNoNamesDialog() {
    // Langsung ke halaman hasil tanpa menampilkan dialog
    if (widget.onAllNamesComplete != null) {
      widget.onAllNamesComplete!();
    } else {
      Navigator.pop(context);
    }
  }

  void _showAllQuestionsCompletedDialog() {
    // Langsung ke halaman hasil tanpa menampilkan dialog
    if (widget.onAllNamesComplete != null) {
      widget.onAllNamesComplete!();
    } else {
      Navigator.pop(context);
    }
  }

  List<int> _generateQuestionsForMode() {
    List<int> questions;
    if (widget.mode == 'collaboration') {
      if (widget.removeAfterSpin) {
        // Mode "sesuai siswa": jumlah soal = jumlah siswa
        // Setiap siswa menjawab 1 soal, lalu nama siswa dihapus
        final totalStudents = widget.availableNames.length;
        questions = List.generate(totalStudents, (i) => i + 1);
      } else {
        // Mode "tetap 30": 30 soal tersedia, nama tidak dihapus
        // Siswa bisa menjawab berulang kali sampai 30 soal habis
        questions = List.generate(30, (i) => i + 1);
      }
    } else if (widget.mode == 'battle') {
      // Mode battle: 30 soal tersedia untuk semua tim
      // Soal yang dihapus, nama tim tetap (bisa menjawab lebih dari 1 soal)
      questions = List.generate(30, (i) => i + 1);
    } else {
      // Mode lainnya, gunakan default
      questions = List.generate(30, (i) => i + 1);
    }
    return questions;
  }

  void _continueToNextStep() {
    if (_selectedName != null) {
      if (widget.mode == 'collaboration' || widget.mode == 'battle') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SpinSoal(
              mode: widget.mode,
              currentPlayer: _selectedName,
              currentTeam: widget.currentTeam,
              availableQuestions: List.from(_globalAvailableQuestions),
              onAllQuestionsComplete: () {
                if (mounted) {
                  // Kembali ke halaman spin nama setelah selesai menjawab soal
                  Navigator.of(context).pop();
                }
              },
            ),
          ),
        ).then((answeredQuestionNumber) {
          // Setelah kembali dari SpinSoal, persiapkan untuk spin berikutnya
          if (mounted) {
            if (widget.mode == 'collaboration') {
              // Mode collaboration: gunakan removeAfterSpin untuk menentukan behavior
              if (widget.removeAfterSpin) {
                // Sesuai siswa: hapus nama dan soal
                setState(() {
                  _availableNames.remove(_selectedName);
                  if (answeredQuestionNumber != null) {
                    _globalAvailableQuestions.remove(answeredQuestionNumber);
                  }
                  _selectedName = null;
                  _selectedIndex = null;
                });
              } else {
                // Tetap 30: nama tidak dihapus, hanya soal yang dihapus
                setState(() {
                  if (answeredQuestionNumber != null) {
                    _globalAvailableQuestions.remove(answeredQuestionNumber);
                  }
                  _selectedName = null;
                  _selectedIndex = null;
                });
              }
            } else if (widget.mode == 'battle') {
              // Mode battle: hapus soal, nama tetap di daftar
              setState(() {
                if (answeredQuestionNumber != null) {
                  _globalAvailableQuestions.remove(answeredQuestionNumber);
                }
                _selectedName = null;
                _selectedIndex = null;
              });
            } else {
              // Mode lainnya gunakan removeAfterSpin
              if (widget.removeAfterSpin) {
                setState(() {
                  _availableNames.remove(_selectedName);
                  if (answeredQuestionNumber != null) {
                    _globalAvailableQuestions.remove(answeredQuestionNumber);
                  }
                  _selectedName = null;
                  _selectedIndex = null;
                });
              } else {
                setState(() {
                  if (answeredQuestionNumber != null) {
                    _globalAvailableQuestions.remove(answeredQuestionNumber);
                  }
                  _selectedName = null;
                  _selectedIndex = null;
                });
              }
            }

            // Cek kondisi akhir game berdasarkan mode
            if (widget.mode == 'collaboration') {
              if (widget.removeAfterSpin) {
                // Mode "sesuai siswa": game selesai ketika semua nama habis (setiap siswa sudah menjawab)
                if (_availableNames.isEmpty) {
                  _showNoNamesDialog();
                } else if (_availableNames.length == 1) {
                  // Jika tinggal 1 nama, langsung pilih dan lanjut ke soal
                  Future.delayed(const Duration(milliseconds: 500), () {
                    if (mounted) {
                      setState(() {
                        _selectedName = _availableNames[0];
                      });
                      _continueToNextStep();
                    }
                  });
                }
              } else {
                // Mode "tetap 30": game selesai ketika semua soal habis
                if (_globalAvailableQuestions.isEmpty) {
                  _showAllQuestionsCompletedDialog();
                } else if (_availableNames.length == 1) {
                  // Jika tinggal 1 nama, langsung pilih dan lanjut ke soal
                  Future.delayed(const Duration(milliseconds: 500), () {
                    if (mounted) {
                      setState(() {
                        _selectedName = _availableNames[0];
                      });
                      _continueToNextStep();
                    }
                  });
                }
              }
            } else if (widget.mode == 'battle') {
              // Mode battle: game selesai ketika semua soal habis
              if (_globalAvailableQuestions.isEmpty) {
                _showAllQuestionsCompletedDialog();
              } else if (_availableNames.length == 1) {
                // Jika tinggal 1 nama, langsung pilih dan lanjut ke soal
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (mounted) {
                    setState(() {
                      _selectedName = _availableNames[0];
                    });
                    _continueToNextStep();
                  }
                });
              }
            } else {
              // Mode lainnya
              if (_availableNames.isEmpty) {
                _showNoNamesDialog();
              } else if (_globalAvailableQuestions.isEmpty) {
                _showAllQuestionsCompletedDialog();
              } else if (_availableNames.length == 1) {
                // Jika tinggal 1 nama, langsung pilih dan lanjut ke soal
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (mounted) {
                    setState(() {
                      _selectedName = _availableNames[0];
                    });
                    _continueToNextStep();
                  }
                });
              }
            }
          }
        });
      } else if (widget.onNameSelected != null) {
        widget.onNameSelected!(_selectedName!);
      }
    } else {
      // _selectedName adalah null, tidak bisa melanjutkan
    }
  }

  Widget _buildAppBar() {
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
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.arrow_back_ios, color: Colors.white);
                },
              ),
              onPressed: () async {
                final shouldExit = await _showExitConfirmationDialog();
                if (shouldExit == true && context.mounted) {
                  Navigator.pop(context);
                }
              },
              tooltip: 'Kembali',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeImage() {
    return Align(
      alignment: Alignment.center,
      child: Image.asset(
        'assets/images/spinGiliranSiswa.png',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildInstructionText() {
    return Text(
      'Klik spin wheel dibawah ini untuk memilih nama',
      style: const TextStyle(
        fontStyle: FontStyle.normal,
        fontFamily: 'Satoshi',
        fontSize: 15,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildPlayerInfo() {
    if (widget.currentTeam == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset(
                'assets/icons/icon_kelas.png',
                width: 12,
                height: 12,
                color: Colors.white,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.group, size: 12, color: Colors.white);
                },
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${widget.currentTeam}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNamesRemaining() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/icons/icon_nama.png', width: 45, height: 45),
        const SizedBox(width: 12),
        Container(
          width: 230,
          height: 45,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(38),
            border: Border.all(color: Colors.black87, width: 1),
          ),
          child: Text(
            'Sisa nama: ${_availableNames.length}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainContent() {
    if (_availableNames.isNotEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 250,
            height: 250,
            child: GestureDetector(
              onTap: _isSpinning ? null : _spinWheel,
              child: _buildSpinningWheel(),
            ),
          ),
          // if (_selectedName != null && !_isSpinning)
          // _buildSelectedNameDisplay(),
        ],
      );
    }

    if (_isSpinning) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 16),
            Text(
              'Memilih nama...',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  // Widget _buildSelectedNameDisplay() {
  //   return Container(
  //     margin: const EdgeInsets.only(top: 20),
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Colors.white.withOpacity(0.9),
  //       borderRadius: BorderRadius.circular(12),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.1),
  //           blurRadius: 10,
  //           offset: const Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       children: [
  //         const Icon(Icons.check_circle, color: Colors.green, size: 32),
  //         const SizedBox(height: 8),
  //         const Text(
  //           'Nama Terpilih:',
  //           style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
  //         ),
  //         const SizedBox(height: 4),
  //         Text(
  //           _selectedName!,
  //           style: const TextStyle(
  //             fontSize: 18,
  //             fontWeight: FontWeight.bold,
  //             color: Colors.green,
  //           ),
  //           textAlign: TextAlign.center,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildSpinningWheel() {
    final List<Color> wheelColors = [
      Colors.purple.shade500,
      Colors.blue.shade500,
      Colors.teal.shade500,
      Colors.green.shade500,
      Colors.amber.shade500,
      Colors.orange.shade500,
      Colors.red.shade500,
      Colors.pink.shade500,
    ];

    // If there's only one name, show it without the wheel
    if (_availableNames.length == 1) {
      final colorIndex = 0; // Use first color for single item
      return Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: wheelColors[colorIndex],
          border: Border.all(color: Colors.white, width: 4),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _availableNames[0],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  shadows: [
                    Shadow(
                      color: Colors.black38,
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                "Langsung ke soal...",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
      );
    }

    final items = _availableNames.map((name) {
      // Menggunakan warna yang berbeda untuk setiap nama
      final colorIndex = _availableNames.indexOf(name) % wheelColors.length;

      return fortune.FortuneItem(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: Text(
              name,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: _availableNames.length <= 6 ? 14 : 12,
                fontFamily: 'Poppins',
                shadows: const [
                  Shadow(
                    color: Colors.black38,
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        style: fortune.FortuneItemStyle(
          color: wheelColors[colorIndex],
          borderWidth: 2,
          borderColor: Colors.white,
        ),
      );
    }).toList();

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: fortune.FortuneWheel(
        animateFirst: false,
        selected: _fortuneWheelController!.stream,
        items: items,
        duration: const Duration(seconds: 4),
        physics: fortune.CircularPanPhysics(
          duration: const Duration(seconds: 2),
          curve: Curves.decelerate,
        ),
        onAnimationEnd: () {
          if (mounted && _selectedIndex != null) {
            // Pilih nama berdasarkan index yang sudah ditentukan
            final selectedName = _availableNames[_selectedIndex!];

            setState(() {
              _isSpinning = false;
              _selectedName = selectedName;
            });

            // Langsung lanjut ke spin soal setelah nama dipilih
            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted) {
                _continueToNextStep();
              }
            });
          }
        },
        styleStrategy: fortune.UniformStyleStrategy(
          borderWidth: 4,
          borderColor: Colors.white,
        ),
      ),
    );
  }

  Future<bool?> _showExitConfirmationDialog() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Yakin ingin keluar?'),
        content: const Text(
          'Jika Anda keluar sekarang, semua progress akan terhapus.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // Stay on the page
            child: const Text('Tidak'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), // Allow exit
            child: const Text('Ya, keluar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) return;

        final shouldExit = await _showExitConfirmationDialog();
        if (shouldExit == true && context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(color: Color(0xffFEFFE8)),
          child: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    _buildAppBar(),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Center(
                        child: Container(
                          width: 853.96,
                          height: 460.53,
                          padding: const EdgeInsets.fromLTRB(100, 36, 100, 36),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(41),
                            color: const Color(0xFF3689EF),
                            border: Border.all(color: Colors.black, width: 3),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildModeImage(),
                                    const SizedBox(height: 20),
                                    _buildInstructionText(),
                                    const SizedBox(height: 20),
                                    _buildPlayerInfo(),
                                    const SizedBox(height: 16),
                                    _buildNamesRemaining(),
                                  ],
                                ),
                              ),
                              Container(
                                width: 2,
                                height: double.infinity,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                color: Colors.white.withOpacity(0.3),
                              ),
                              Expanded(flex: 1, child: _buildMainContent()),
                            ],
                          ),
                        ),
                      ),
                    ),
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
        ),
      ),
    );
  }
}
