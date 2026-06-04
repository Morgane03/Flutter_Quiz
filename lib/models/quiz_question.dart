/// modèle pour une question de quiz
class QuizQuestion {
  final int id;
  final int themeId;
  final String label;
  final List<String> proposals;

  final String? userAnswer;
  final String? answer;
  final bool isCorrect;

  QuizQuestion({
    required this.id,
    required this.themeId,
    required this.label,
    required this.proposals,
    this.userAnswer,
    this.answer,
    required this.isCorrect,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'],
      themeId: json['theme_id'],
      label: json['label'],
      proposals: List<String>.from(json['proposals'] ?? []),
      userAnswer: json['user_answer'],
      answer: json['answer'],
      isCorrect: json['is_correct'] == true || json['is_correct'] == 1,
    );
  }
}
