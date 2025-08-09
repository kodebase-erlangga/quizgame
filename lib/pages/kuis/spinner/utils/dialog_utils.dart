import 'package:flutter/material.dart';

class DialogUtils {
  static Future<bool?> showExitConfirmationDialog(BuildContext context) async {
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
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Tidak'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ya, keluar'),
          ),
        ],
      ),
    );
  }

  static void showNoQuestionsDialog(
    BuildContext context,
    VoidCallback? onAllQuestionsComplete,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Soal Habis'),
        content: const Text('Semua soal telah selesai!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (onAllQuestionsComplete != null) {
                onAllQuestionsComplete();
              } else {
                Navigator.pop(context);
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
