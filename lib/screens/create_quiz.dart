import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizcreator/database/database_helper.dart';
import 'package:quizcreator/screens/button_app.dart';
import 'package:quizcreator/screens/quiz_screen.dart';
import 'package:quizcreator/theme/theme.dart';

class CreateQuiz extends StatefulWidget {
  const CreateQuiz({super.key});

  @override
  State<CreateQuiz> createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  final _titleController = TextEditingController();
  final _questionsController = TextEditingController();

  String _formatJson(String jsonString) {
    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    final object = json.decode(jsonString);
    return encoder.convert(object);
  }

  String exampleQuestions = """[
  {
    "question": "What is the capital of France?",
    "options": ["Paris", "London", "Berlin", "Madrid"],
    "answer": "Paris",
    "type": "MSQ"
  },
  {
    "question": "Complete the sentence: The Eiffel Tower is located in ______.",
    "options": [],
    "answer": "Paris",
    "type": "complete"
  }
]
""";

  Future<void> _saveQuiz() async {
    try {
      final title = _titleController.text;
      final questionsJson = _questionsController.text;

      // Validate title
      if (title.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a title for the quiz.')),
        );
        return;
      }

      // Validate questions JSON
      if (questionsJson.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please enter questions in JSON format.')),
        );
        return;
      }

      // Validate and parse JSON
      List<dynamic> decodedQuestions;
      try {
        decodedQuestions = jsonDecode(questionsJson);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Invalid JSON format. Please check your input.')),
        );
        return;
      }

      // Validate each question
      for (var q in decodedQuestions) {
        if (q is! Map<String, dynamic>) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'Each question must be a JSON object with "question", "options", "answer", and "type" fields.')),
          );
          return;
        }

        if (!q.containsKey('question') ||
            !q.containsKey('options') ||
            !q.containsKey('answer') ||
            !q.containsKey('type')) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'Each question must contain "question", "options", "answer", and "type" fields.')),
          );
          return;
        }

        if (q['options'] is! List ||
            q['options'].isEmpty && q['type'] == 'MSQ') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('The "options" field must be a non-empty list.')),
          );
          return;
        }

        if (q['type'] != 'MSQ' && q['type'] != 'complete') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'The "type" field must be either "MSQ" or "complete".')),
          );
          return;
        }
      }

      // Save the quiz
      await DatabaseHelper.instance.createQuiz(title, questionsJson);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Quiz saved successfully!')),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => QuizScreen(
              title: title,
              questions: List<Map<String, dynamic>>.from(decodedQuestions),
            ),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text(
          'Create Quiz',
          style: TextStyle(color: AppTheme.primaryText),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: AppTheme.primaryText,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: _titleController,
                style: TextStyle(color: AppTheme.primaryText),
                decoration: InputDecoration(
                  hintText: 'Title Quiz',
                  hintStyle: TextStyle(
                    color: AppTheme.secondaryText,
                    fontSize: 16,
                  ),
                  filled: true,
                  fillColor: AppTheme.surfaceColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppTheme.borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: primaryColor,
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppTheme.borderColor),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Stack(
                  children: [
                    TextFormField(
                      controller: _questionsController,
                      style: TextStyle(color: AppTheme.primaryText),
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'JSON Questions\n e.g.\n $exampleQuestions',
                        hintStyle: TextStyle(
                          color: AppTheme.secondaryText,
                          fontSize: 12,
                        ),
                        filled: true,
                        fillColor: AppTheme.surfaceColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppTheme.borderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: primaryColor,
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppTheme.borderColor),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment.topRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Clipboard.setData(
                                    ClipboardData(text: exampleQuestions),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Example JSON copied!'),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.copy_all_rounded)),
                            IconButton(
                                onPressed: () async {
                                  final clipboardData = await Clipboard.getData(
                                      Clipboard.kTextPlain);
                                  if (clipboardData?.text != null) {
                                    _questionsController.text =
                                        _formatJson(clipboardData!.text!);
                                  }
                                  if(mounted){
                                    // ignore: use_build_context_synchronously
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('✨ JSON data pasted'),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  }
                                },
                                icon: const Icon(Icons.paste)),
                          ],
                        )),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ButtonApp(
                  text: 'Add Quiz',
                  onPressed: _saveQuiz,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _questionsController.dispose();
    super.dispose();
  }
}
