class SpinSoalModel {
  final String mode;
  final String? currentPlayer;
  final String? currentTeam;
  final List<int> availableQuestions;
  final Function(bool)? onQuestionAnswered;
  final Function(int, bool)? onQuestionAnsweredWithNumber;
  final Function()? onAllQuestionsComplete;

  SpinSoalModel({
    required this.mode,
    this.currentPlayer,
    this.currentTeam,
    required this.availableQuestions,
    this.onQuestionAnswered,
    this.onQuestionAnsweredWithNumber,
    this.onAllQuestionsComplete,
  }) {
    print('DEBUG SpinSoalModel constructor:');
    print('- mode: $mode');
    print('- currentPlayer: $currentPlayer');
    print('- onQuestionAnswered available: ${onQuestionAnswered != null}');
    print(
      '- onQuestionAnsweredWithNumber available: ${onQuestionAnsweredWithNumber != null}',
    );
  }

  String getTitle() {
    switch (mode) {
      case 'single':
        return 'Spin Soal - Mode Single';
      case 'kolaborasi':
        return 'Spin Soal - ${currentPlayer ?? "Kolaborasi"}';
      case 'battle':
        return 'Spin Soal - ${currentTeam ?? "Battle"}';
      default:
        return 'Spin Soal';
    }
  }

  String getPlayerInfo() {
    if (mode == 'battle') {
      return 'Tim: ${currentTeam ?? ""}';
    } else {
      return 'Pemain: ${currentPlayer ?? ""}';
    }
  }

  bool get hasPlayerInfo => currentPlayer != null || currentTeam != null;
}
