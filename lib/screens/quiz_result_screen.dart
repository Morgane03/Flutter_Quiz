import 'package:flutter/material.dart';
import '../models/quiz_question.dart';

class QuizResultScreen extends StatelessWidget {
  final Map<String, dynamic> result;
  final List<QuizQuestion> questions;
  final Map<int, String> answers;

  const QuizResultScreen({
    super.key,
    required this.result,
    required this.questions,
    required this.answers,
  });

  @override
  Widget build(BuildContext context) {
  final data = result['data'] ?? {};

  final score = (data['final_score'] ?? 0) as num;
  final questions = (data['questions'] as List? ?? [])
    .map((e) => QuizQuestion.fromJson(e))
    .toList();

  final total = questions.length;
  final percent = total == 0 ? 0 : (score / total);

  String grade() {
    if (percent >= 0.9) return "Excellent!";
    if (percent >= 0.7) return "Très bien!";
    if (percent >= 0.5) return "Bien";
    return "À améliorer";
  }

    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange, Colors.deepOrange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 60),

            const Icon(Icons.emoji_events, size: 80, color: Colors.white),

            const SizedBox(height: 20),

            Text(
              "${(percent * 100).round()}%",
              style: const TextStyle(
                fontSize: 50,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              grade(),
              style: const TextStyle(color: Colors.white70, fontSize: 18),
            ),

            const SizedBox(height: 20),

            Text(
              "$score / $total",
              style: const TextStyle(color: Colors.white),
            ),

            const SizedBox(height: 30),

            /// DETAILS
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, i) {
                  final q = questions[i];
                  final user = q.userAnswer;
                  final correct = q.answer;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(q.label),
                        const SizedBox(height: 6),
                        Text("Votre réponse: ${user ?? '-'}"),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Valider"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
