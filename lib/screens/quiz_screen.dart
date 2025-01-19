import 'package:flutter/material.dart';
import 'package:quizcreator/model/questions.dart';
import 'package:quizcreator/screens/button_app.dart';
import 'package:quizcreator/screens/progress.dart';
import 'package:quizcreator/screens/quiz_card.dart';
import 'package:quizcreator/screens/start.dart';
import 'package:quizcreator/theme/theme.dart';

class QuizScreen extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> questions;

  const QuizScreen({
    super.key,
    required this.title,
    required this.questions,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late Map<String, dynamic> question;
  int currentQuestionIndex = 0;
  int score = 0;
  bool isAnswered = false;
  String? selectedAnswer;
  int? selectedAnswerIndex;
  bool isCorrect = false;
  late List<Question> shuffledQuestions;

  @override
  void initState() {
    super.initState();
    // Initialize and shuffle questions only once
    shuffledQuestions = QuizQuestions.fromJsonList(widget.questions);
    shuffledQuestions.shuffle();

    if (widget.questions.isNotEmpty) {
      question = widget.questions[currentQuestionIndex];
    } else {
      question = {
        "question": "No questions available",
        "options": [],
        "answer": ""
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold)),
        leading: GestureDetector(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Start()),
                  (route) => false);
            },
            child: Icon(Icons.arrow_back)),
        actions: [
          Text('${currentQuestionIndex + 1}/${shuffledQuestions.length}'),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.03,
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Progress(indexQ: currentQuestionIndex, questions: shuffledQuestions),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          QuizCard(questions: shuffledQuestions, indexQ: currentQuestionIndex),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          Expanded(
              child: ListView.builder(
                  itemCount: shuffledQuestions[currentQuestionIndex].options.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    bool isAnswerCorrect =
                        shuffledQuestions[currentQuestionIndex].options[index] ==
                            shuffledQuestions[currentQuestionIndex].answer;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedAnswerIndex = index;
                          isCorrect = isAnswerCorrect;
                        });
                      },
                      child: Card(
                        color: selectedAnswerIndex == index
                            ? (isCorrect
                                ? AppTheme.correctAnswer
                                : AppTheme.incorrectAnswer)
                            : (isAnswerCorrect && selectedAnswerIndex != null)
                                ? AppTheme.correctAnswer
                                : AppTheme.buttonColor,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.width * 0.05),
                        ),
                        margin: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.02,
                            vertical:
                                MediaQuery.of(context).size.height * 0.01),
                        child: Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.04),
                          child: Wrap(children: [
                            Text(
                              shuffledQuestions[currentQuestionIndex].options[index],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: AppTheme.primaryText,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ]),
                        ),
                      ),
                    );
                  })),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          if (currentQuestionIndex == 0 && shuffledQuestions.length > 1)
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.03),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ButtonApp(
                    onPressed: () {
                      setState(() {
                        currentQuestionIndex++;
                        selectedAnswerIndex = null;
                        selectedAnswer = null;
                        isAnswered = false;
                      });
                    },
                    text: 'Next',
                  ),
                ],
              ),
            ),
          if (currentQuestionIndex > 0 &&
              currentQuestionIndex < shuffledQuestions.length - 1)
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.03),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ButtonApp(
                    text: 'Previous',
                    onPressed: () {
                      setState(() {
                        currentQuestionIndex--;
                        selectedAnswerIndex = null;
                        selectedAnswer = null;
                        isAnswered = false;
                      });
                    },
                  ),
                  ButtonApp(
                    onPressed: () {
                      setState(() {
                        currentQuestionIndex++;
                        selectedAnswerIndex = null;
                        selectedAnswer = null;
                        isAnswered = false;
                      });
                    },
                    text: 'Next',
                  ),
                ],
              ),
            ),
          if (currentQuestionIndex == shuffledQuestions.length - 1 &&
              shuffledQuestions.length > 1)
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.03),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ButtonApp(
                    text: 'Previous',
                    onPressed: () {
                      setState(() {
                        currentQuestionIndex--;
                        selectedAnswerIndex = null;
                        selectedAnswer = null;
                        isAnswered = false;
                      });
                    },
                  ),
                  ButtonApp(
                    text: 'Finish',
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Start(),
                        ),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        ],
      ),
    );
  }
}
