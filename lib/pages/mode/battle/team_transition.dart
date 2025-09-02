import 'package:flutter/material.dart';

class TeamTransition extends StatefulWidget {
  final String currentTeamName;
  final String nextTeamName;
  final int currentTeamIndex;
  final int totalTeams;
  final Map<String, int> teamScores;
  final VoidCallback onContinue;

  const TeamTransition({
    super.key,
    required this.currentTeamName,
    required this.nextTeamName,
    required this.currentTeamIndex,
    required this.totalTeams,
    required this.teamScores,
    required this.onContinue,
  });

  @override
  State<TeamTransition> createState() => _TeamTransitionState();
}

class _TeamTransitionState extends State<TeamTransition>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _progressAnimation = Tween<double>(
      begin: widget.currentTeamIndex / widget.totalTeams,
      end: (widget.currentTeamIndex + 1) / widget.totalTeams,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _animationController.forward();
    _progressController.forward();

    // Auto continue after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        widget.onContinue();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _progressController.dispose();
    super.dispose();
  }

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
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  _buildProgressBar(),
                  Expanded(
                    child: Center(
                      child: AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return FadeTransition(
                            opacity: _fadeAnimation,
                            child: ScaleTransition(
                              scale: _scaleAnimation,
                              child: Container(
                                width: 800,
                                height: 500,
                                padding: const EdgeInsets.all(40),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF459D93),
                                  borderRadius: BorderRadius.circular(41),
                                  border:
                                      Border.all(color: Colors.black, width: 3),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 5,
                                      blurRadius: 15,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Completed team info
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 30,
                                        vertical: 15,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            color: Colors.white, width: 2),
                                      ),
                                      child: Column(
                                        children: [
                                          const Text(
                                            '✅ TIM SELESAI',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                              fontFamily: 'Satoshi',
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            widget.currentTeamName,
                                            style: const TextStyle(
                                              fontSize: 32,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                              fontFamily: 'Straw Milky',
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            'Skor: ${widget.teamScores[widget.currentTeamName] ?? 0}',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                              fontFamily: 'Satoshi',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(height: 30),

                                    // Arrow or transition indicator
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.black, width: 2),
                                      ),
                                      child: const Icon(
                                        Icons.arrow_downward,
                                        size: 30,
                                        color: Color(0xFF459D93),
                                      ),
                                    ),

                                    const SizedBox(height: 30),

                                    // Next team info
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 30,
                                        vertical: 15,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFAA0D),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            color: Colors.black, width: 2),
                                      ),
                                      child: Column(
                                        children: [
                                          const Text(
                                            '🎯 GILIRAN SELANJUTNYA',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                              fontFamily: 'Satoshi',
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            widget.nextTeamName,
                                            style: const TextStyle(
                                              fontSize: 32,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                              fontFamily: 'Straw Milky',
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            'Skor: ${widget.teamScores[widget.nextTeamName] ?? 0}',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              fontFamily: 'Satoshi',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(height: 30),

                                    // Continue button
                                    ElevatedButton(
                                      onPressed: widget.onContinue,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor:
                                            const Color(0xFF459D93),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 40,
                                          vertical: 15,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          side: const BorderSide(
                                              color: Colors.black, width: 2),
                                        ),
                                      ),
                                      child: const Text(
                                        'Lanjutkan',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Satoshi',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              // Footer decorations
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
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text(
            'Progress Battle: Tim ${widget.currentTeamIndex + 1}/${widget.totalTeams}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontFamily: 'Satoshi',
            ),
          ),
          const SizedBox(height: 10),
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return Container(
                width: double.infinity,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: _progressAnimation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF459D93),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
