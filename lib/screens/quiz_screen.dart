import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizcreator/features/quiz/data/models/questions.dart';
import 'package:quizcreator/screens/build_legend_item.dart';
import 'package:quizcreator/screens/button_app.dart';
import 'package:quizcreator/screens/progress.dart';
import 'package:quizcreator/screens/quiz_card.dart';
import 'package:quizcreator/screens/review_screen.dart';
import 'package:quizcreator/screens/start.dart';
import 'package:quizcreator/utils/constant/colors.dart';

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
  late List<Question> shuffledQuestions;
  int currentQuestionIndex = 0;
  int? selectedAnswerIndex;
  bool isCorrect = false;
  bool hasAnswered = false;
  TextEditingController controller = TextEditingController();
  List<Map<String, dynamic>> _userAnswers = [];

  @override
  void initState() {
    super.initState();
    assert(widget.questions.isNotEmpty, 'Questions list cannot be empty');
    shuffledQuestions = QuizQuestions.fromJsonList(widget.questions);
    shuffledQuestions.shuffle();
    _userAnswers = List.generate(
        shuffledQuestions.length,
        (index) => {
              'answer': null,
              'isCorrect': false,
            });
  }

  void _nextQuestion() {
    if (!hasAnswered) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please answer the question before proceeding.'),
        ),
      );
      return;
    }

    // Validate the answer before proceeding
    final userAnswer = controller.text.trim().toLowerCase();
    if (shuffledQuestions[currentQuestionIndex].type == 'MSQ') {
      if (selectedAnswerIndex == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select an answer.'),
            backgroundColor: ColorsApp.incorrectAnswer,
          ),
        );
        return;
      }
    } else if (userAnswer.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an answer.'),
          backgroundColor: ColorsApp.incorrectAnswer,
        ),
      );
      return;
    }

    // Store the user's answer and correctness
    _userAnswers[currentQuestionIndex] = {
      'answer': userAnswer,
      'isCorrect': isCorrect,
    };

    setState(() {
      if (currentQuestionIndex < shuffledQuestions.length - 1) {
        currentQuestionIndex++;
        selectedAnswerIndex = null;
        hasAnswered = false;
        isCorrect = false;
        controller.clear();
      } else {
        _finishQuiz();
      }
    });
  }

  void _previousQuestion() {
    setState(() {
      if (currentQuestionIndex > 0) {
        currentQuestionIndex--;
        selectedAnswerIndex =
            _userAnswers[currentQuestionIndex]['answer'] != null ? 0 : null;
        hasAnswered = _userAnswers[currentQuestionIndex]['answer'] != null;
        isCorrect = _userAnswers[currentQuestionIndex]['isCorrect'];
        controller.text = _userAnswers[currentQuestionIndex]['answer'] ?? '';
      }
    });
  }

  void _finishQuiz() {
    int correctAnswers =
        _userAnswers.where((answer) => answer['isCorrect']).length;
    double percentage = (correctAnswers / shuffledQuestions.length) * 100;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: ColorsApp.surfaceColor,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.assessment_rounded,
                  size: 64,
                  color: Colors.blue,
                ),
                const SizedBox(height: 16),
                Text(
                  'Quiz Results',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: ColorsApp.primaryText,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: ColorsApp.primaryText,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$correctAnswers out of ${shuffledQuestions.length} correct',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: ColorsApp.secondaryText,
                      ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsApp.buttonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Text(
                          'Home',
                          style: TextStyle(color: ColorsApp.primaryText),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsApp.buttonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _showReviewMode();
                      },
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Text(
                          'Review',
                          style: TextStyle(color: ColorsApp.primaryText),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showReviewMode() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewScreen(
          questions: shuffledQuestions,
          userAnswers: _userAnswers,
        ),
      ),
    );
  }

  Widget _buildCompleteQuestion() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextFormField(
            controller: controller,
            autofocus: true,
            enableSuggestions: false,
            keyboardType: TextInputType.text,
            style: TextStyle(color: ColorsApp.primaryText),
            maxLines: null,
            onFieldSubmitted: (value) {
              setState(() {
                hasAnswered = value.trim().isNotEmpty;
                isCorrect = value.trim().toLowerCase() ==
                    shuffledQuestions[currentQuestionIndex]
                        .answer
                        .toLowerCase();
              });

              if (isCorrect) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Correct! Well done!'),
                    backgroundColor: ColorsApp.correctAnswer,
                    duration: const Duration(milliseconds: 300),
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }
            },
            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
              setState(() {
                hasAnswered = controller.text.trim().isNotEmpty;
                isCorrect = controller.text.trim().toLowerCase() ==
                    shuffledQuestions[currentQuestionIndex]
                        .answer
                        .toLowerCase();
              });

              if (isCorrect) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Correct! Well done!'),
                    backgroundColor: ColorsApp.correctAnswer,
                    duration: const Duration(milliseconds: 300),
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }
            },
            onChanged: (value) {
              setState(() {
                hasAnswered = value.trim().isNotEmpty;
                isCorrect = value.trim().toLowerCase() ==
                    shuffledQuestions[currentQuestionIndex]
                        .answer
                        .toLowerCase();
              });

              if (isCorrect) {
                FocusScope.of(context).unfocus();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Correct! Well done!'),
                    backgroundColor: ColorsApp.correctAnswer,
                    duration: const Duration(milliseconds: 300),
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }
            },
            decoration: InputDecoration(
              hintText: 'Enter your answer in complete words...',
              hintStyle: TextStyle(
                color: ColorsApp.secondaryText,
                fontSize: 12,
              ),
              filled: true,
              fillColor: isCorrect
                  ? ColorsApp.correctAnswer
                  : hasAnswered
                      ? ColorsApp.incorrectAnswer
                      : ColorsApp.surfaceColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: ColorsApp.borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: isCorrect
                      ? ColorsApp.correctAnswer
                      : ColorsApp.incorrectAnswer,
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: ColorsApp.borderColor),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              suffixIcon: hasAnswered
                  ? Icon(
                      isCorrect ? Icons.check_circle : Icons.cancel,
                      color: isCorrect
                          ? ColorsApp.correctAnswer
                          : ColorsApp.incorrectAnswer,
                    )
                  : null,
            ),
          ),
          if (!hasAnswered)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Please enter your answer before proceeding.',
                style:
                    TextStyle(color: ColorsApp.incorrectAnswer, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (currentQuestionIndex > 0)
            ButtonApp(
              text: 'Previous',
              onPressed: _previousQuestion,
            ),
          if (currentQuestionIndex < shuffledQuestions.length - 1)
            ButtonApp(
              text: 'Next',
              onPressed: hasAnswered ? _nextQuestion : null,
            ),
          if (currentQuestionIndex == shuffledQuestions.length - 1)
            ButtonApp(
              text: 'Finish',
              onPressed: hasAnswered ? _finishQuiz : null,
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => const Start(),
              ),
              (route) => false,
            );
          },
        ),
        actions: [
          Text('${currentQuestionIndex + 1}/${shuffledQuestions.length}'),
          SizedBox(width: MediaQuery.of(context).size.width * 0.03),
          Builder(builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            );
          }),
        ],
      ),
      endDrawer: Drawer(
        child: Container(
          color: ColorsApp.surfaceColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: ColorsApp.secondaryText,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Progress: ${_userAnswers.where((answer) => answer['answer'] != null).length}/${shuffledQuestions.length} questions',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: ColorsApp.secondaryText,
                          ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Questions Overview',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: ColorsApp.primaryText,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: shuffledQuestions.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        setState(() {
                          currentQuestionIndex = index;
                          selectedAnswerIndex =
                              _userAnswers[index]['answer'] != null ? 0 : null;
                          hasAnswered = _userAnswers[index]['answer'] != null;
                          isCorrect = _userAnswers[index]['isCorrect'];
                          controller.text = _userAnswers[index]['answer'] ?? '';
                          Navigator.pop(context);
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: _getQuestionColor(index),
                          borderRadius: BorderRadius.circular(8),
                          border: currentQuestionIndex == index
                              ? Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 2,
                                )
                              : null,
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: currentQuestionIndex == index
                                    ? Theme.of(context).primaryColor
                                    : ColorsApp.primaryText,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (_userAnswers[index]['answer'] != null)
                              Icon(
                                Icons.check_circle,
                                size: 12,
                                color: ColorsApp.primaryText,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    BuildLegendItem(
                      label: 'Current',
                      color: Theme.of(context).primaryColor,
                    ),
                    BuildLegendItem(
                      label: 'Answered',
                      color: ColorsApp.correctAnswer,
                    ),
                    BuildLegendItem(
                      label: 'Unanswered',
                      color: ColorsApp.buttonColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // Progress Widget
          SliverToBoxAdapter(
            child: Column(
              children: [
                Progress(
                  indexQ: currentQuestionIndex,
                  questions: shuffledQuestions,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.015),
              ],
            ),
          ),

          // Quiz Card (Question)
          SliverToBoxAdapter(
            child: Column(
              children: [
                QuizCard(
                  questions: shuffledQuestions,
                  indexQ: currentQuestionIndex,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              ],
            ),
          ),

          // Answer Options (MSQ)
          if (shuffledQuestions[currentQuestionIndex].type == 'MSQ')
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  bool isAnswerCorrect =
                      shuffledQuestions[currentQuestionIndex].options[index] ==
                          shuffledQuestions[currentQuestionIndex].answer;
                  return GestureDetector(
                    onTap: () {
                      if (!hasAnswered) {
                        setState(() {
                          selectedAnswerIndex = index;
                          isCorrect = isAnswerCorrect;
                          hasAnswered = true;
                          _userAnswers[currentQuestionIndex] = {
                            'answer': shuffledQuestions[currentQuestionIndex]
                                .options[index],
                            'isCorrect': isCorrect,
                          };
                        });
                      }
                    },
                    child: Card(
                      color: selectedAnswerIndex == index
                          ? (isCorrect
                              ? ColorsApp.correctAnswer
                              : ColorsApp.incorrectAnswer)
                          : (isAnswerCorrect && selectedAnswerIndex != null)
                              ? ColorsApp.correctAnswer
                              : ColorsApp.buttonColor,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.width * 0.05),
                      ),
                      margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.02,
                        vertical: MediaQuery.of(context).size.height * 0.01,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.04),
                        child: Wrap(
                          children: [
                            Text(
                              shuffledQuestions[currentQuestionIndex]
                                  .options[index],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: ColorsApp.primaryText,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount:
                    shuffledQuestions[currentQuestionIndex].options.length,
              ),
            ),

          // Complete Question
          if (shuffledQuestions[currentQuestionIndex].type == 'complete')
            SliverToBoxAdapter(
              child: _buildCompleteQuestion(),
            ),

          // Navigation Buttons
          SliverToBoxAdapter(
            child: _buildNavigationButtons(),
          ),

          // Add some padding at the bottom
          SliverToBoxAdapter(
            child: SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          ),
        ],
      ),
    );
  }

  Color _getQuestionColor(int index) {
    if (_userAnswers[index]['answer'] != null) {
      return _userAnswers[index]['isCorrect']
          ? ColorsApp.correctAnswer.withValues(alpha: 0.7)
          : ColorsApp.incorrectAnswer.withValues(alpha: 0.7);
    }
    return ColorsApp.buttonColor;
  }
}
