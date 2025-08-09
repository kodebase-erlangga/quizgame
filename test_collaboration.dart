// Test file untuk debug collaboration
import 'package:flutter/material.dart';
import 'lib/pages/mode/collaboration/CollaborationGameManager.dart';

void main() {
  // Test CollaborationGameManager secara langsung
  print('=== Testing CollaborationGameManager ===');

  final gameManager = CollaborationGameManager(
    studentNames: ['Alice', 'Bob', 'Charlie'],
    totalQuestions: 3,
    removeNamesAfterSpin: true,
    groupName: 'Test Tim',
  );

  print('Initial state:');
  print('- studentNames: ${gameManager.studentNames}');
  print('- availableNames: ${gameManager.availableNames}');
  print('- removeNamesAfterSpin: ${gameManager.removeNamesAfterSpin}');
  print('- studentResults: ${gameManager.studentResults}');
  print('- studentsWhoAnswered: ${gameManager.studentsWhoAnswered}');

  // Simulasi Alice menjawab benar
  print('\n=== Simulasi Alice menjawab BENAR ===');
  gameManager.setCurrentStudent('Alice');
  print('Current student set to: ${gameManager.currentStudent}');

  gameManager.recordAnswer(true);
  print('After recordAnswer(true):');
  print('- studentResults: ${gameManager.studentResults}');
  print('- studentsWhoAnswered: ${gameManager.studentsWhoAnswered}');
  print('- currentScore: ${gameManager.currentScore}');
  print('- correctAnswers: ${gameManager.correctAnswers}');

  gameManager.removeSelectedName('Alice');
  print('After removeSelectedName(Alice):');
  print('- availableNames: ${gameManager.availableNames}');
  print('- studentsWhoAnswered: ${gameManager.studentsWhoAnswered}');

  // Simulasi Bob menjawab salah
  print('\n=== Simulasi Bob menjawab SALAH ===');
  gameManager.setCurrentStudent('Bob');
  gameManager.recordAnswer(false);
  print('After recordAnswer(false):');
  print('- studentResults: ${gameManager.studentResults}');
  print('- studentsWhoAnswered: ${gameManager.studentsWhoAnswered}');
  print('- currentScore: ${gameManager.currentScore}');
  print('- wrongAnswers: ${gameManager.wrongAnswers}');

  gameManager.removeSelectedName('Bob');
  print('After removeSelectedName(Bob):');
  print('- availableNames: ${gameManager.availableNames}');
  print('- studentsWhoAnswered: ${gameManager.studentsWhoAnswered}');

  // Final results
  print('\n=== Final Results ===');
  final results = gameManager.getGameResults();
  print('Game results: $results');
  print('Final studentResults: ${gameManager.studentResults}');
  print('Final studentsWhoAnswered: ${gameManager.studentsWhoAnswered}');
}
