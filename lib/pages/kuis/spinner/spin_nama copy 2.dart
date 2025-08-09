// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart' as fortune;

// class SpinNama extends StatefulWidget {
//   final String mode; // 'kolaborasi', 'battle'
//   final List<String> availableNames; // Daftar nama yang tersedia
//   final String? currentTeam; // Tim yang sedang bermain (untuk battle mode)
//   final bool removeAfterSpin; // Apakah nama dihapus setelah terpilih
//   final Function(String)? onNameSelected; // Callback ketika nama terpilih
//   final Function()? onAllNamesComplete; // Callback ketika semua nama selesai

//   const SpinNama({
//     super.key,
//     required this.mode,
//     required this.availableNames,
//     this.currentTeam,
//     this.removeAfterSpin = true,
//     this.onNameSelected,
//     this.onAllNamesComplete,
//   });

//   @override
//   State<SpinNama> createState() => _SpinNamaState();
// }

// class _SpinNamaState extends State<SpinNama> with TickerProviderStateMixin {
//   List<String> _availableNames = [];
//   String? _selectedName;
//   bool _isSpinning = false;
//   // Fortune wheel controller
//   StreamController<int>? _fortuneWheelController;

//   @override
//   void initState() {
//     super.initState();
//     _availableNames = List.from(widget.availableNames);
//     _fortuneWheelController = StreamController<int>();

//     // Auto-select when there's only one name available
//     if (_availableNames.length == 1) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (mounted) {
//           setState(() {
//             _selectedName = _availableNames[0];
//           });
//           // Langsung ke halaman jawab soal tanpa delay
//           _continueToNextStep();
//         }
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _fortuneWheelController?.close();
//     super.dispose();
//   }

//   void _spinWheel() {
//     if (_availableNames.isEmpty) {
//       _showNoNamesDialog();
//       return;
//     }

//     setState(() {
//       _isSpinning = true;
//       _selectedName = null;
//     });

//     // Select a random index and add it to the fortune wheel controller
//     final random = Random();
//     final index = random.nextInt(_availableNames.length);

//     // Trigger the wheel animation
//     _fortuneWheelController?.add(index);

//     // Set the selected name after a delay for dramatic effect
//     Future.delayed(const Duration(seconds: 4), () {
//       if (index < _availableNames.length && mounted) {
//         final selectedName = _availableNames[index];
//         setState(() {
//           _selectedName = selectedName;
//         });
//       }
//     });
//   }

//   void _showNoNamesDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         title: const Text('Nama Habis'),
//         content: const Text('Semua nama telah terpilih!'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               if (widget.onAllNamesComplete != null) {
//                 widget.onAllNamesComplete!();
//               } else {
//                 Navigator.pop(context);
//               }
//             },
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _continueToNextStep() {
//     if (_selectedName != null) {
//       // For both collaboration and battle modes, return the selected name
//       if (widget.mode == 'collaboration' || widget.mode == 'battle') {
//         Navigator.pop(context, _selectedName);
//       }
//       // For other modes, the original callback mechanism is preserved.
//       else if (widget.onNameSelected != null) {
//         widget.onNameSelected!(_selectedName!);
//       }
//     }
//   }

//   String _getTitle() {
//     switch (widget.mode) {
//       case 'kolaborasi':
//         return 'Spin Nama Siswa - Kolaborasi';
//       case 'battle':
//         return 'Spin Anggota - ${widget.currentTeam ?? "Battle"}';
//       default:
//         return 'Spin Nama';
//     }
//   }

//   Widget _buildSpinningWheel() {
//     final List<Color> wheelColors = [
//       Colors.purple.shade500,
//       Colors.blue.shade500,
//       Colors.teal.shade500,
//       Colors.green.shade500,
//       Colors.amber.shade500,
//       Colors.orange.shade500,
//       Colors.red.shade500,
//       Colors.pink.shade500,
//     ];

//     // If there's only one name, show it without the wheel
//     if (_availableNames.length == 1) {
//       final colorIndex = 0; // Use first color for single item
//       return Center(
//         child: Container(
//           width: 340,
//           height: 340,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: wheelColors[colorIndex],
//             border: Border.all(color: Colors.white, width: 4),
//           ),
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   _availableNames[0],
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 24,
//                     fontFamily: 'Poppins',
//                     shadows: [
//                       Shadow(
//                         color: Colors.black38,
//                         blurRadius: 2,
//                         offset: Offset(0, 1),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 const Text(
//                   "Langsung ke soal...",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontFamily: 'Poppins',
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     }

//     final items = _availableNames.map((name) {
//       // Menggunakan warna yang berbeda untuk setiap nama
//       final colorIndex = _availableNames.indexOf(name) % wheelColors.length;

//       return fortune.FortuneItem(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Text(
//             name,
//             style: const TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//               fontSize: 18,
//               fontFamily: 'Poppins',
//               shadows: [
//                 Shadow(
//                   color: Colors.black38,
//                   blurRadius: 2,
//                   offset: Offset(0, 1),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         style: fortune.FortuneItemStyle(
//           color: wheelColors[colorIndex],
//           borderWidth: 1,
//           borderColor: Colors.white30,
//         ),
//       );
//     }).toList();

//     return SizedBox(
//       width: 340, // Wheel yang lebih besar
//       height: 340, // Wheel yang lebih besar
//       child: GestureDetector(
//         onTap: _isSpinning ? null : _spinWheel,
//         child: fortune.FortuneWheel(
//           animateFirst: false,
//           selected: _fortuneWheelController!.stream,
//           items: items,
//           duration: const Duration(seconds: 5), // Animasi lebih lama (5 detik)
//           rotationCount: 20, // Putaran lebih banyak untuk efek dramatis
//           physics: fortune.CircularPanPhysics(
//             duration: const Duration(seconds: 2),
//             curve: Curves.decelerate,
//           ),
//           onAnimationEnd: () {
//             if (mounted) {
//               setState(() {
//                 _isSpinning = false;
//               });

//               // After the animation ends, navigate to next step
//               if (_selectedName != null) {
//                 // Tunggu sebentar untuk menampilkan nama terpilih, lalu lanjut ke soal
//                 Future.delayed(const Duration(seconds: 1), () {
//                   if (mounted) {
//                     _continueToNextStep();
//                   }
//                 });
//               }
//             }
//           },
//           styleStrategy: fortune.UniformStyleStrategy(
//             borderWidth: 4,
//             borderColor: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }

//   Future<bool?> _showExitConfirmationDialog() async {
//     return showDialog<bool>(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         title: const Text('Yakin ingin keluar?'),
//         content: const Text(
//           'Jika Anda keluar sekarang, semua progress akan terhapus.',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false), // Stay on the page
//             child: const Text('Tidak'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context, true), // Allow exit
//             child: const Text('Ya, keluar'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: false, 
//       onPopInvoked: (bool didPop) async {
//         if (didPop) return;

//         final shouldExit = await _showExitConfirmationDialog();
//         if (shouldExit == true && context.mounted) {
//           Navigator.pop(context);
//         }
//       },
//       child: Scaffold(
//         body: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xFF9F7FFF), Color(0xFF8055FE)],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//           ),
//           child: SafeArea(
//             child: Column(
//               children: [
//                 // Custom App Bar
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Row(
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.2),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: IconButton(
//                           icon: const Icon(
//                             Icons.arrow_back_ios,
//                             color: Colors.white,
//                           ),
//                           onPressed: () async {
//                             // Use the same confirmation dialog as PopScope
//                             final shouldExit =
//                                 await _showExitConfirmationDialog();
//                             if (shouldExit == true && context.mounted) {
//                               Navigator.pop(context);
//                             }
//                           },
//                           tooltip: 'Kembali',
//                         ),
//                       ),
//                       Expanded(
//                         child: Text(
//                           _getTitle(),
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                             fontFamily: 'Poppins',
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 48, height: 48),
//                     ],
//                   ),
//                 ),

//                 // Content
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       children: [
//                         // Team Info (for battle mode)
//                         if (widget.currentTeam != null)
//                           Container(
//                             decoration: BoxDecoration(
//                               color: Colors.white.withOpacity(0.15),
//                               borderRadius: BorderRadius.circular(16),
//                               border: Border.all(
//                                 color: Colors.white.withOpacity(0.2),
//                                 width: 1,
//                               ),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(16.0),
//                               child: Row(
//                                 children: [
//                                   Container(
//                                     padding: const EdgeInsets.all(8),
//                                     decoration: BoxDecoration(
//                                       color: Colors.white.withOpacity(0.2),
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                     child: const Icon(
//                                       Icons.groups,
//                                       color: Colors.white,
//                                       size: 24,
//                                     ),
//                                   ),
//                                   const SizedBox(width: 12),
//                                   Expanded(
//                                     child: Text(
//                                       'Tim: ${widget.currentTeam}',
//                                       style: const TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.white,
//                                         fontFamily: 'Poppins',
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         if (widget.currentTeam != null)
//                           const SizedBox(height: 20),

//                         // Names remaining info
//                         Container(
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.15),
//                             borderRadius: BorderRadius.circular(16),
//                             border: Border.all(
//                               color: Colors.white.withOpacity(0.2),
//                               width: 1,
//                             ),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: Row(
//                               children: [
//                                 Container(
//                                   padding: const EdgeInsets.all(8),
//                                   decoration: BoxDecoration(
//                                     color: Colors.white.withOpacity(0.2),
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   child: const Icon(
//                                     Icons.people,
//                                     color: Colors.white,
//                                     size: 20,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 12),
//                                 Text(
//                                   widget.removeAfterSpin
//                                       ? 'Sisa Nama: ${_availableNames.length}'
//                                       : 'Total Nama: ${_availableNames.length}',
//                                   style: const TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w600,
//                                     color: Colors.white,
//                                     fontFamily: 'Poppins',
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 30),

//                         // Instructions
//                         if (_availableNames.isNotEmpty && _selectedName == null)
//                           Container(
//                             decoration: BoxDecoration(
//                               color: Colors.white.withOpacity(0.15),
//                               borderRadius: BorderRadius.circular(16),
//                               border: Border.all(
//                                 color: Colors.white.withOpacity(0.2),
//                                 width: 1,
//                               ),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(16.0),
//                               child: Row(
//                                 children: [
//                                   Container(
//                                     padding: const EdgeInsets.all(8),
//                                     decoration: BoxDecoration(
//                                       color: Colors.white.withOpacity(0.2),
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                     child: const Icon(
//                                       Icons.touch_app,
//                                       color: Colors.white,
//                                       size: 20,
//                                     ),
//                                   ),
//                                   const SizedBox(width: 12),
//                                   const Expanded(
//                                     child: Text(
//                                       'Tap pada wheel untuk memutar dan memilih nama!',
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.white,
//                                         fontFamily: 'Poppins',
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         const SizedBox(height: 20),

//                         // Spinning Wheel
//                         if (_availableNames.isNotEmpty)
//                           Expanded(child: Center(child: _buildSpinningWheel())),

//                         // Loading indicator during spin
//                         if (_isSpinning)
//                           Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: Center(
//                               child: Column(
//                                 children: [
//                                   CircularProgressIndicator(
//                                     color: Colors.white,
//                                   ),
//                                   const SizedBox(height: 16),
//                                   const Text(
//                                     'Memilih nama...',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold,
//                                       fontFamily: 'Poppins',
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),

//                         // Selected Name Display
//                         if (_selectedName != null && !_isSpinning)
//                           Container(
//                             decoration: BoxDecoration(
//                               color: Colors.white.withOpacity(0.9),
//                               borderRadius: BorderRadius.circular(16),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.1),
//                                   blurRadius: 10,
//                                   offset: const Offset(0, 4),
//                                 ),
//                               ],
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(24.0),
//                               child: Column(
//                                 children: [
//                                   const Icon(
//                                     Icons.person,
//                                     size: 48,
//                                     color: Color(0xFF8055FE),
//                                   ),
//                                   const SizedBox(height: 12),
//                                   const Text(
//                                     'Nama Terpilih:',
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       color: Color(0xFF666666),
//                                       fontFamily: 'Poppins',
//                                     ),
//                                   ),
//                                   const SizedBox(height: 8),
//                                   Text(
//                                     _selectedName!,
//                                     style: const TextStyle(
//                                       fontSize: 24,
//                                       fontWeight: FontWeight.bold,
//                                       color: Color(0xFF8055FE),
//                                       fontFamily: 'Poppins',
//                                     ),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                   const SizedBox(height: 8),
//                                   const Text(
//                                     'Menuju ke soal...',
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       fontStyle: FontStyle.italic,
//                                       color: Color(0xFF666666),
//                                       fontFamily: 'Poppins',
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),

//                         const SizedBox(height: 20),

//                         // Buttons
//                         Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               ElevatedButton.icon(
//                                 onPressed: _isSpinning ? null : _spinWheel,
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: const Color(0xFF8055FE),
//                                   foregroundColor: Colors.white,
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 24,
//                                     vertical: 14,
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   elevation: 3,
//                                 ),
//                                 icon: const Icon(Icons.refresh),
//                                 label: const Text(
//                                   'Putar',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                     fontFamily: 'Poppins',
//                                   ),
//                                 ),
//                               ),
//                               ElevatedButton.icon(
//                                 onPressed: _isSpinning
//                                     ? null
//                                     : () {
//                                         if (mounted) {
//                                           setState(() {
//                                             _availableNames = List.from(
//                                               widget.availableNames,
//                                             );
//                                             _selectedName = null;
//                                           });
//                                         }
//                                       },
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: const Color(0xFFE0E0E0),
//                                   foregroundColor: const Color(0xFF555555),
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 24,
//                                     vertical: 14,
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   elevation: 2,
//                                 ),
//                                 icon: const Icon(Icons.delete_outline),
//                                 label: const Text(
//                                   'Reset',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                     fontFamily: 'Poppins',
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
