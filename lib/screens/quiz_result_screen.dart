import 'package:flutter/material.dart';
import '../models/quiz_question.dart';
import '../assets/const/color.dart';

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
      backgroundColor: lightSable,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 20),

              Icon(Icons.emoji_events, size: 70, color: orange),

              const SizedBox(height: 10),

              Text(
                "Résultat",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: darkGreen,
                ),
              ),

              const SizedBox(height: 20),

              /// SCORE CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    Text(
                      "${(percent * 100).round()}%",
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: orange,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      grade(),
                      style: TextStyle(
                        color: darkGreen,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "$score / $total bonnes réponses",
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// DETAILS
              Expanded(
                child: ListView.builder(
                  itemCount: questions.length,
                  itemBuilder: (context, i) {
                    final q = questions[i];
                    final user = answers[q.id];
                    final correct = q.answer;
                    final isGood = user == correct;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isGood ? pink : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isGood ? orange : Colors.black12,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            q.label,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: darkGreen,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text("Votre réponse : ${user ?? '-'}"),
                          if (!isGood)
                            Text(
                              "Bonne réponse : $correct",
                              style: TextStyle(color: darkGreen),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orange,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Retour",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
