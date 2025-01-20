import 'package:flutter/material.dart';
import 'package:quizcreator/model/questions.dart';
import 'package:quizcreator/theme/theme.dart';

class Progress extends StatelessWidget {
  const Progress({
    super.key,
    required this.indexQ,
    required this.questions,
  });

  final int indexQ;
  final List<Question> questions;

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: (indexQ + 1) / questions.length,
      borderRadius:
          BorderRadius.circular(MediaQuery.of(context).size.width * 0.05),
      backgroundColor: AppTheme.progressBarBackground,
      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryText),
    );
  }
}
