class Question {
  final String question;
  final List<String> options;
  final String answer;
  final String type;

  Question({
    required this.question,
    required this.options,
    required this.answer,
    required this.type,
  });

  // Convert from JSON to Question object
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'] as String,
      options: List<String>.from(json['options'] as List),
      answer: json['answer'] as String,
      type: json['type'] as String,
    );
  }

  // Convert Question object to JSON
  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'options': options,
      'answer': answer,
      'type': type,
    };
  }
}

class QuizQuestions {
  // Helper method to parse JSON string into List<Question>
  static List<Question> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Question.fromJson(json)).toList();
  }
}
