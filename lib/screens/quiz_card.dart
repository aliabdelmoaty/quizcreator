import 'package:flutter/material.dart';
import 'package:quizcreator/model/questions.dart';
import 'package:quizcreator/theme/theme.dart';

class QuizCard extends StatelessWidget {
  const QuizCard({
    super.key,
    required this.questions,
    required this.indexQ,
  });

  final List<Question> questions;
  final int indexQ;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: AppTheme.progressBarBackground,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(MediaQuery.of(context).size.width * 0.05),
        ),
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.02),
        child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
            child: Wrap(
              children: [
                Text(
                  questions[indexQ].question,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            )),
      ),
    );
  }
}
