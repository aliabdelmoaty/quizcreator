import 'dart:convert';

class Quiz {
  final int? id;
  final String title;
  final List<Map<String, dynamic>> questions;

  Quiz({
    this.id,
    required this.title,
    required this.questions,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'questions': jsonEncode(questions),
    };
  }

  factory Quiz.fromMap(Map<String, dynamic> map) {
    return Quiz(
      id: map['id']?.toInt(),
      title: map['title'] ?? '',
      questions: List<Map<String, dynamic>>.from(
          jsonDecode(map['questions']).map((x) => Map<String, dynamic>.from(x))),
    );
  }
}
