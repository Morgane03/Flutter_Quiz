import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tp_prise_en_main/screens/quiz_screen.dart';
import 'package:tp_prise_en_main/screens/quiz_history_screen.dart';

import '../services/home_service.dart';
import '../widgets/quiz_card.dart';
import '../widgets/home_header.dart';
import '../widgets/stats_row.dart';
import '../assets/const/color.dart';

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
  int userRank = 0;

  List quizzes = [];
  List leaderboard = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadHome();
  }

  Future<void> loadHome() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token") ?? "";

    // charger les données de l'utilisateur, ses quiz et le classement
    try {
      final userData = await service.getMe(token);
      final quizData = await service.getUserQuizzes(token);
      final leaderboardData = await service.getLeaderboard(token);

      setState(() {
        firstname = userData["firstname"] ?? "";
        lastname = userData["lastname"] ?? "";

        score = userData["score"] ?? 0;
        quizCount = quizData.length;

        quizzes = quizData.take(3).toList();

        leaderboard = leaderboardData;

        // trouver le rang de l'utilisateur connecté
        final userId = userData["id"];

        final index = leaderboard.indexWhere((u) => u["id"] == userId);

        userRank = index != -1 ? index + 1 : 0;
        loading = false;
      });
    } catch (e) {
      debugPrint("ERREUR LOAD HOME : $e");
      setState(() => loading = false);
    }
  }

  // Fonction pour formater la date au format "dd/MM/yyyy"
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
  // build du home avec les stats de l'utilisateur, ses quiz récents et un accès au classement
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightSable,
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
                      userRank: userRank,
                    ),

                    const SizedBox(height: 25),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Quiz récents",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const QuizHistoryScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "Voir tout",
                            style: TextStyle(
                              color: orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // liste des quiz récents de l'utilisateur
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
                                        builder: (_) => QuizScreen(
                                          themeId: themeId,
                                          themeLabel: theme?["label"] ?? "Quiz",
                                        ),
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
