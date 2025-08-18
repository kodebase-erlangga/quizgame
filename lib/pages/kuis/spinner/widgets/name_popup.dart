import 'package:flutter/material.dart';

class NamePopup extends StatefulWidget {
  final String selectedName;
  final VoidCallback? onContinue;
  final VoidCallback? onClose;
  final bool autoClose;
  final Duration autoCloseDuration;

  const NamePopup({
    super.key,
    required this.selectedName,
    this.onContinue,
    this.onClose,
    this.autoClose = false,
    this.autoCloseDuration = const Duration(seconds: 3),
  });

  static Future<void> show(
    BuildContext context, {
    required String selectedName,
    VoidCallback? onContinue,
    bool barrierDismissible = false,
    bool autoClose = false,
    Duration autoCloseDuration = const Duration(seconds: 3),
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => NamePopup(
        selectedName: selectedName,
        onContinue: onContinue,
        onClose: barrierDismissible ? () => Navigator.of(context).pop() : null,
        autoClose: autoClose,
        autoCloseDuration: autoCloseDuration,
      ),
    );
  }

  @override
  State<NamePopup> createState() => _NamePopupState();
}

class _NamePopupState extends State<NamePopup> {
  @override
  void initState() {
    super.initState();

    if (widget.autoClose) {
      Future.delayed(widget.autoCloseDuration, () {
        if (mounted) {
          Navigator.of(context).pop();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Center(
        child: SizedBox(
          width: 350,
          height: 320,
          child: Stack(
            children: [
              Positioned(
                top: 60,
                left: 0,
                right: 0,
                child: Container(
                  width: 350,
                  height: 190,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A9B8E),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFFEFFE8),
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2D5A52),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              Text(
                                widget.selectedName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Straw Milky',
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        if (widget.autoClose)
                          TweenAnimationBuilder<double>(
                            duration: widget.autoCloseDuration,
                            tween: Tween(begin: 0.0, end: 1.0),
                            builder: (context, value, child) {
                              return Column(
                                children: [
                                  LinearProgressIndicator(
                                    value: value,
                                    backgroundColor:
                                        Colors.white.withOpacity(0.3),
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                            Colors.white),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Melanjutkan dalam ${((1 - value) * widget.autoCloseDuration.inSeconds).ceil()} detik...',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              );
                            },
                          )
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 15,
                left: 0,
                right: 0,
                child: Container(
                  width: 350,
                  height: 60,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 33,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEFFE8),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                        spreadRadius: -2,
                      ),
                    ],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.05),
                          Colors.transparent,
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.2, 1.0],
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(27),
                      ),
                      child: const Text(
                        'Terpilih',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF459D93),
                          fontSize: 28,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontFamily: 'Straw Milky',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (widget.onClose != null && !widget.autoClose)
                Positioned(
                  top: 63,
                  right: 15,
                  child: GestureDetector(
                    onTap: widget.onClose,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Color(0xFF4A9B8E),
                        size: 16,
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
