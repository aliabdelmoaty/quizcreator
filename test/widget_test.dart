import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quizcreator/main.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // Initialize sqflite_common_ffi for testing
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('Quiz Creator App Tests', () {
    testWidgets('Initial state: Verify home screen is displayed',
        (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(const MyApp());

      // Verify that the home screen is displayed
      expect(find.text('Quizzes'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('Create a quiz with valid input', (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(const MyApp());

      // Tap the floating action button to create a new quiz
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle(); // Wait for navigation

      // Verify that the CreateQuiz screen is displayed
      expect(find.text('Create Quiz'), findsOneWidget);

      // Enter a quiz title
      await tester.enterText(find.byType(TextFormField).first, 'Test Quiz');
      await tester.pump();

      // Enter JSON-formatted questions
      final jsonQuestions = '''
      [
        {
          "question": "What is the capital of France?",
          "options": ["Paris", "London", "Berlin"],
          "answer": "Paris",
          "type": "MSQ"
        }
      ]
      ''';
      await tester.enterText(find.byType(TextFormField).last, jsonQuestions);
      await tester.pump();

      // Tap the "Create Quiz" button
      await tester.tap(find.text('Create Quiz'));
      await tester.pumpAndSettle(); // Wait for the quiz to be saved

      // Verify that the home screen is displayed again
      expect(find.text('Quizzes'), findsOneWidget);

      // Verify that the new quiz is displayed
      expect(find.text('Test Quiz'), findsOneWidget);
    });

    testWidgets('Create a quiz with invalid JSON input',
        (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(const MyApp());

      // Tap the floating action button to create a new quiz
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Enter a quiz title
      await tester.enterText(find.byType(TextFormField).first, 'Invalid Quiz');
      await tester.pump();

      // Enter invalid JSON
      await tester.enterText(find.byType(TextFormField).last, 'Invalid JSON');
      await tester.pump();

      // Tap the "Create Quiz" button
      await tester.tap(find.text('Create Quiz'));
      await tester.pumpAndSettle();

      // Verify that an error message is displayed
      expect(find.text('Invalid JSON format. Please check your input.'),
          findsOneWidget);
    });

    testWidgets('Create a quiz with empty title', (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(const MyApp());

      // Tap the floating action button to create a new quiz
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Enter JSON-formatted questions
      final jsonQuestions = '''
      [
        {
          "question": "What is the capital of France?",
          "options": ["Paris", "London", "Berlin"],
          "answer": "Paris",
          "type": "MSQ"
        }
      ]
      ''';
      await tester.enterText(find.byType(TextFormField).last, jsonQuestions);
      await tester.pump();

      // Tap the "Create Quiz" button
      await tester.tap(find.text('Create Quiz'));
      await tester.pumpAndSettle();

      // Verify that an error message is displayed
      expect(find.text('Please enter a title for the quiz.'), findsOneWidget);
    });

    testWidgets('Take a quiz and finish', (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(const MyApp());

      // Tap the floating action button to create a new quiz
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Enter a quiz title
      await tester.enterText(find.byType(TextFormField).first, 'Test Quiz');
      await tester.pump();

      // Enter JSON-formatted questions
      final jsonQuestions = '''
      [
        {
          "question": "What is the capital of France?",
          "options": ["Paris", "London", "Berlin"],
          "answer": "Paris",
          "type": "MSQ"
        }
      ]
      ''';
      await tester.enterText(find.byType(TextFormField).last, jsonQuestions);
      await tester.pump();

      // Tap the "Create Quiz" button
      await tester.tap(find.text('Create Quiz'));
      await tester.pumpAndSettle();

      // Tap the newly created quiz card to start the quiz
      await tester.tap(find.text('Test Quiz'));
      await tester.pumpAndSettle();

      // Verify that the quiz screen is displayed
      expect(find.text('Test Quiz'), findsOneWidget);

      // Select an answer (Paris)
      await tester.tap(find.text('Paris'));
      await tester.pump();

      // Tap the "Next" button
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Tap the "Finish" button
      await tester.tap(find.text('Finish'));
      await tester.pumpAndSettle();

      // Verify that the results screen is displayed
      expect(find.text('Quiz Results'), findsOneWidget);
      expect(find.text('100.0%'), findsOneWidget); // Verify the score
    });

    testWidgets('Delete a quiz', (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(const MyApp());

      // Tap the floating action button to create a new quiz
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Enter a quiz title
      await tester.enterText(find.byType(TextFormField).first, 'Test Quiz');
      await tester.pump();

      // Enter JSON-formatted questions
      final jsonQuestions = '''
      [
        {
          "question": "What is the capital of France?",
          "options": ["Paris", "London", "Berlin"],
          "answer": "Paris",
          "type": "MSQ"
        }
      ]
      ''';
      await tester.enterText(find.byType(TextFormField).last, jsonQuestions);
      await tester.pump();

      // Tap the "Create Quiz" button
      await tester.tap(find.text('Create Quiz'));
      await tester.pumpAndSettle();

      // Long press the quiz card to delete it
      await tester.longPress(find.text('Test Quiz'));
      await tester.pumpAndSettle();

      // Confirm deletion
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Verify that the quiz is deleted
      expect(find.text('Test Quiz'), findsNothing);
    });
  });
}
