// import 'package:flutter/material.dart';
// // import 'package:quizgame/pages/mode/battle/home_battle.dart';

// class PanduanBattle extends StatelessWidget {
//   const PanduanBattle({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFF9F7FFF), Color(0xFF8055FE)],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               // Custom App Bar
//               _buildAppBar(context),

//               // Content
//               Expanded(
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.all(24.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildTitle(),
//                       const SizedBox(height: 24),
//                       _buildRuleCard(
//                         icon: Icons.groups,
//                         iconColor: Colors.red,
//                         backgroundColor: Colors.red[100]!,
//                         title: 'Langkah 1: Pengaturan Tim',
//                         subtitle:
//                             'Buat 2-10 tim dengan nama unik untuk berkompetisi',
//                       ),
//                       _buildRuleCard(
//                         icon: Icons.person_add,
//                         iconColor: Colors.blue,
//                         backgroundColor: Colors.blue[100]!,
//                         title: 'Langkah 2: Tambah Anggota Tim',
//                         subtitle:
//                             'Input kustom atau distribusi acak siswa ke tim',
//                       ),
//                       _buildRuleCard(
//                         icon: Icons.quiz,
//                         iconColor: Colors.purple,
//                         backgroundColor: Colors.purple[100]!,
//                         title: 'Langkah 3: Pilih Mode Soal',
//                         subtitle:
//                             'Sesuai siswa: 1 soal = 1 siswa | Tetap 30: soal standar',
//                       ),
//                       _buildRuleCard(
//                         icon: Icons.settings,
//                         iconColor: Colors.teal,
//                         backgroundColor: Colors.teal[100]!,
//                         title: 'Perbedaan Mode Soal',
//                         subtitle:
//                             'Mode sesuai siswa lebih personal, mode 30 lebih standar',
//                       ),
//                       _buildRuleCard(
//                         icon: Icons.help_outline,
//                         iconColor: Colors.orange,
//                         backgroundColor: Colors.orange[100]!,
//                         title: 'Aturan Bermain',
//                         subtitle:
//                             'Setiap soal hanya bisa dijawab 1 kali per anggota tim',
//                       ),
//                       _buildRuleCard(
//                         icon: Icons.emoji_events,
//                         iconColor: Colors.amber,
//                         backgroundColor: Colors.amber[100]!,
//                         title: 'Sistem Penilaian',
//                         subtitle:
//                             'Jawaban benar = +10 poin | Tim dengan skor tertinggi menang',
//                       ),
//                       _buildRuleCard(
//                         icon: Icons.leaderboard,
//                         iconColor: Colors.green,
//                         backgroundColor: Colors.green[100]!,
//                         title: 'Hasil Battle',
//                         subtitle:
//                             'Lihat ranking tim, skor detail, dan analisis performa',
//                       ),
//                       _buildRuleCard(
//                         icon: Icons.drag_indicator,
//                         iconColor: Colors.indigo,
//                         backgroundColor: Colors.indigo[100]!,
//                         title: 'Fitur Drag and Drop',
//                         subtitle:
//                             'Atur anggota tim dengan menyeret (drag) siswa ke tim yang diinginkan. Sistem akan memastikan pembagian tim seimbang.',
//                       ),
//                       _buildTipsCard(),
//                       const SizedBox(height: 32),
//                       _buildBackButton(context),
//                       const SizedBox(height: 24),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildAppBar(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Row(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               // ignore: deprecated_member_use
//               color: Colors.white.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: IconButton(
//               icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//               onPressed: () {
//                 // Navigator.pushReplacement(
//                 //   // context,
//                 //   // MaterialPageRoute(builder: (context) => const HomeBattle()),
//                 // );
//               },
//               tooltip: 'Kembali ke Battle',
//             ),
//           ),
//           const Expanded(
//             child: Text(
//               'Panduan Battle',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//                 fontFamily: 'Poppins',
//               ),
//             ),
//           ),
//           SizedBox(width: 48, height: 48),
//         ],
//       ),
//     );
//   }

//   Widget _buildTitle() {
//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.15),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
//       ),
//       child: Column(
//         children: [
//           Icon(
//             Icons.emoji_events,
//             size: 64,
//             color: Colors.white.withOpacity(0.9),
//           ),
//           const SizedBox(height: 16),
//           const Text(
//             'Cara Bermain Mode Battle',
//             style: TextStyle(
//               fontSize: 28,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//               fontFamily: 'Poppins',
//             ),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 8),
//           const Text(
//             'Mode battle memungkinkan tim-tim berkompetisi satu sama lain dalam format kuis. Buat tim, jawab pertanyaan, dan lihat siapa yang menang!',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.white,
//               fontFamily: 'Poppins',
//               height: 1.4,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildRuleCard({
//     required IconData icon,
//     required Color iconColor,
//     required Color backgroundColor,
//     required String title,
//     required String subtitle,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.9),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Row(
//           children: [
//             Container(
//               width: 50,
//               height: 50,
//               decoration: BoxDecoration(
//                 color: backgroundColor,
//                 borderRadius: BorderRadius.circular(25),
//               ),
//               child: Icon(icon, size: 30, color: iconColor),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       fontFamily: 'Poppins',
//                       color: Color(0xFF2D2D2D),
//                     ),
//                   ),
//                   Text(
//                     subtitle,
//                     style: const TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey,
//                       fontFamily: 'Poppins',
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTipsCard() {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.9),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Container(
//                   width: 50,
//                   height: 50,
//                   decoration: BoxDecoration(
//                     color: Colors.amber[100],
//                     borderRadius: BorderRadius.circular(25),
//                   ),
//                   child: Icon(
//                     Icons.lightbulb,
//                     size: 30,
//                     color: Colors.amber[700],
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 const Text(
//                   'Tips Sukses Battle',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: 'Poppins',
//                     color: Color(0xFF2D2D2D),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: Colors.grey.withOpacity(0.2)),
//               ),
//               child: Column(
//                 children: [
//                   _buildTipItem(
//                     'Koordinasi tim yang baik adalah kunci kemenangan',
//                   ),
//                   _buildTipItem(
//                     'Distribusikan anggota secara merata untuk performa optimal',
//                   ),
//                   _buildTipItem('Diskusikan strategi sebelum memulai battle'),
//                   _buildTipItem('Manfaatkan keahlian setiap anggota tim'),
//                   _buildTipItem(
//                     'Jangan terburu-buru - akurasi lebih penting dari kecepatan',
//                   ),
//                   _buildTipItem(
//                     'Gunakan mode soal yang sesuai dengan jumlah siswa',
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTipItem(String text) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('🏆', style: const TextStyle(fontSize: 18)),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               text,
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey[700],
//                 fontFamily: 'Poppins',
//                 height: 1.3,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBackButton(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       height: 56,
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF8055FE).withOpacity(0.3),
//             blurRadius: 15,
//             offset: const Offset(0, 8),
//             spreadRadius: 2,
//           ),
//         ],
//       ),
//       child: ElevatedButton(
//         onPressed: () {
//           // Navigator.pushReplacement(
//           //   context,
//           //   MaterialPageRoute(builder: (context) => const HomeBattle()),
//           // );
//         },
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.transparent,
//           shadowColor: Colors.transparent,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//         ),
//         child: const Text(
//           'Kembali ke Pengaturan Battle',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//             fontFamily: 'Poppins',
//           ),
//         ),
//       ),
//     );
//   }
// }
