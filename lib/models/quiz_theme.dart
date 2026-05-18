class QuizTheme {
  final int id;
  final String label;
  final int questionsCount;
  final String createdAt;

  QuizTheme({
    required this.id,
    required this.label,
    required this.questionsCount,
    required this.createdAt,
  });

  factory QuizTheme.fromJson(Map<String, dynamic> json) {
    return QuizTheme(
      id: json['id'],
      label: json['label'],
      questionsCount: json['questions_count'],
      createdAt: json['created_at'],
    );
  }
}