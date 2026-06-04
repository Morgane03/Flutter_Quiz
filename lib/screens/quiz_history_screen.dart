import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/home_service.dart';
import '../widgets/quiz_card.dart';

class QuizHistoryScreen extends StatefulWidget {
  const QuizHistoryScreen({super.key});

  @override
  State<QuizHistoryScreen> createState() => _QuizHistoryScreenState();
}

class _QuizHistoryScreenState extends State<QuizHistoryScreen> {
  final HomeService service = HomeService();

  List quizzes = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadQuizzes();
  }

  Future<void> loadQuizzes() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token") ?? "";

    try {
      final data = await service.getUserQuizzes(token);

      setState(() {
        quizzes = data;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
    }
  }

  String timeAgo(String date) {
    try {
      final createdAt = DateTime.parse(date);
      final diff = DateTime.now().difference(createdAt);

      if (diff.inDays > 0) {
        return "Il y a ${diff.inDays} jour${diff.inDays > 1 ? 's' : ''}";
      }

      if (diff.inHours > 0) {
        return "Il y a ${diff.inHours} heure${diff.inHours > 1 ? 's' : ''}";
      }

      if (diff.inMinutes > 0) {
        return "Il y a ${diff.inMinutes} minute${diff.inMinutes > 1 ? 's' : ''}";
      }

      return "À l'instant";
    } catch (_) {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Historique des quiz"),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : quizzes.isEmpty
              ? const Center(child: Text("Aucun quiz trouvé"))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: quizzes.length,
                  itemBuilder: (context, index) {
                    final quiz = quizzes[index];
                    final theme = quiz["theme"];

                    return QuizCard(
                      title: theme?["label"] ?? "Quiz",
                      subtitle:
                          "Score : ${quiz["final_score"] ?? 0} • ${timeAgo(quiz["created_at"])}",
                      onPressed: () {
                        // Relancer le quiz ici
                      },
                    );
                  },
                ),
    );
  }
}