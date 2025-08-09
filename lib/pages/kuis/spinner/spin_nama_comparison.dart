// import 'package:flutter/material.dart';
// import 'spin_nama.dart';
// // import 'spin_nama_refactored.dart'; // Commented out for now

// // Comparison page to test both UI/UX designs
// class SpinNamaComparisonPage extends StatelessWidget {
//   const SpinNamaComparisonPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Spin Nama UI/UX Comparison'),
//         backgroundColor: Colors.pink,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               'Pilih Design untuk Dibandingkan:',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 30),

//             // Original Design
//             Container(
//               width: double.infinity,
//               margin: const EdgeInsets.symmetric(horizontal: 32),
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const SpinNama(
//                         mode: 'single',
//                         availableNames: [
//                           'Alice',
//                           'Bob',
//                           'Charlie',
//                           'Diana',
//                           'Eve',
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue,
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: const Column(
//                   children: [
//                     Text(
//                       'Design Baru (Horizontal Layout)',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       'UI/UX sama dengan Spin Soal',
//                       style: TextStyle(fontSize: 12),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 16),

//             // Refactored Design - Temporarily disabled
//             Container(
//               width: double.infinity,
//               margin: const EdgeInsets.symmetric(horizontal: 32),
//               child: ElevatedButton(
//                 onPressed: null, // Disabled for now
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.grey,
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: const Column(
//                   children: [
//                     Text(
//                       'Design Modular (Coming Soon)',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       'Arsitektur modular dengan UI/UX horizontal',
//                       style: TextStyle(fontSize: 12),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 30),

//             const Text(
//               'Test dengan Mode Berbeda:',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//             ),

//             const SizedBox(height: 16),

//             // Battle Mode Test
//             Container(
//               width: double.infinity,
//               margin: const EdgeInsets.symmetric(horizontal: 32),
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const SpinNama(
//                         mode: 'battle',
//                         currentTeam: 'Tim Merah',
//                         availableNames: ['Player 1', 'Player 2', 'Player 3'],
//                       ),
//                     ),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.red,
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: const Text(
//                   'Test Battle Mode (New Design)',
//                   style: TextStyle(fontSize: 14),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 8),

//             // Collaboration Mode Test
//             Container(
//               width: double.infinity,
//               margin: const EdgeInsets.symmetric(horizontal: 32),
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const SpinNama(
//                         mode: 'collaboration',
//                         availableNames: [
//                           'Team A',
//                           'Team B',
//                           'Team C',
//                           'Team D',
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.purple,
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: const Text(
//                   'Test Collaboration Mode (New Design)',
//                   style: TextStyle(fontSize: 14),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
