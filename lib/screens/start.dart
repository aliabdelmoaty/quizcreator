import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:quizcreator/database/database_helper.dart';
import 'package:quizcreator/screens/create_quiz.dart';
import 'package:quizcreator/screens/quiz_screen.dart';
import 'package:quizcreator/theme/theme.dart';

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  List<Map<String, dynamic>> _quizzes = [];

  @override
  void initState() {
    super.initState();
    _loadQuizzes();
  }

  Future<void> _loadQuizzes() async {
    final quizzes = await DatabaseHelper.instance.getQuizzes();
    setState(() {
      _quizzes = quizzes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quizzes'),
        elevation: 2,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.2,
                    crossAxisCount: 2,
                  ),
                  itemCount: _quizzes.length,
                  itemBuilder: (context, index) {
                    final quiz = _quizzes[index];
                    List<dynamic> questions = json.decode(quiz['questions']);
                    return CardLec(
                      title: quiz['title'],
                      questions: questions,
                      questionCount: questions.length,
                    );
                  },
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: Text(
                'Developed by Ali Abdelmoaty',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateQuiz()),
          );
          _loadQuizzes();
        },
        child: const Icon(Icons.create),
      ),
    );
  }
}

class CardLec extends StatefulWidget {
  const CardLec({
    super.key,
    required this.title,
    required this.questions,
    required this.questionCount,
  });

  final String title;
  final List<dynamic> questions;
  final int questionCount;

  @override
  State<CardLec> createState() => _CardLecState();
}

class _CardLecState extends State<CardLec> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Delete Quiz'),
              content:
                  Text('Are you sure you want to delete "${widget.title}"?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    // Delete from database
                    await DatabaseHelper.instance.deleteQuiz(widget.title);

                    setState(() {
                      Navigator.pop(context);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const Start()),
                        (route) => false,
                      );
                    });
                    // Close dialog

                    // // Navigator.pop(context);
                    // Navigator.pushAndRemoveUntil(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => const Start()),
                    //   (route) => false,
                    // );
                  },
                  child: Text('Delete', style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        );
      },
      onTap: () {
        final formattedQuestions =
            widget.questions.map((q) => Map<String, dynamic>.from(q)).toList();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizScreen(
              title: widget.title,
              questions: formattedQuestions,
            ),
          ),
        );
      },
      child: Card(
        color: AppTheme.progressBarBackground,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: const EdgeInsets.all(4),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    widget.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${widget.questionCount} Questions',
                style: TextStyle(
                  color: Colors.grey[300],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
