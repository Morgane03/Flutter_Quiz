import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tp_prise_en_main/screens/quiz_screen.dart';

import '../services/home_service.dart';
import '../widgets/quiz_card.dart';
import '../widgets/home_header.dart';
import '../widgets/stats_row.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeService service = HomeService();

  String firstname = "";
  String lastname = "";

  int score = 0;
  int quizCount = 0;
  int userCount = 0;

  List quizzes = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadHome();
  }

  Future<void> loadHome() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token") ?? "";

    try {
      final userData = await service.getMe(token);
      final quizData = await service.getUserQuizzes(token);

      setState(() {
        firstname = userData["firstname"] ?? "";
        lastname = userData["lastname"] ?? "";

        score = userData["score"] ?? 0;
        quizCount = userData["quizzes_count"] ?? 0;
        userCount = userData["users_count"] ?? 0;

        quizzes = quizData.take(3).toList();

        loading = false;
      });
    } catch (e) {
      debugPrint("ERREUR LOAD HOME : $e");
      setState(() => loading = false);
    }
  }

  String formatDate(String date) {
    try {
      final dt = DateTime.parse(date);
      return "${dt.day}/${dt.month}/${dt.year}";
    } catch (e) {
      return "";
    }
  }

  // Fonction pour afficher "Il y a X jours/heures/minutes"
  String timeAgo(String date) {
    try {
      final createdAt = DateTime.parse(date);
      final difference = DateTime.now().difference(createdAt);

      if (difference.inDays > 0) {
        return "Il y a ${difference.inDays} jour${difference.inDays > 1 ? 's' : ''}";
      }

      if (difference.inHours > 0) {
        return "Il y a ${difference.inHours} heure${difference.inHours > 1 ? 's' : ''}";
      }

      if (difference.inMinutes > 0) {
        return "Il y a ${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}";
      }

      return "À l'instant";
    } catch (_) {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HomeHeader(firstname: firstname, lastname: lastname),

                    const SizedBox(height: 20),

                    StatsRow(
                      quizCount: quizCount,
                      score: score,
                      userCount: userCount,
                    ),

                    const SizedBox(height: 25),

                    const Text(
                      "Quiz récents",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Expanded(
                      child: quizzes.isEmpty
                          ? const Center(child: Text("Aucun quiz trouvé"))
                          : ListView.builder(
                              itemCount: quizzes.length,
                              itemBuilder: (context, index) {
                                final quiz = quizzes[index];
                                final theme = quiz["theme"];

                                return QuizCard(
                                  title: theme?["label"] ?? "Quiz",
                                  subtitle:
                                      "Score : ${quiz["final_score"] ?? 0} • ${timeAgo(quiz["created_at"])}",
                                  onPressed: () {
                                    final themeId = quiz["theme_id"];

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            QuizScreen(themeId: themeId, themeLabel: theme?["label"] ?? "Quiz"),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
