import 'package:flutter/material.dart';
import '../services/quiz_service.dart';
import '../models/quiz_theme.dart';
import '../models/quiz_theme_items.dart';
import '../widgets/quiz_theme_card.dart';
import '../assets/const/color.dart';
import 'quiz_game_screen.dart';

class QuizScreen extends StatefulWidget {
  final int? themeId;
  final String? themeLabel;

  const QuizScreen({
    super.key,
    this.themeId,
    this.themeLabel,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final QuizService service = QuizService();

  late Future<List<QuizTheme>> futureThemes;

  @override
  void initState() {
    super.initState();
    futureThemes = service.getThemes();
  }

  Future<void> refresh() async {
    setState(() {
      futureThemes = service.getThemes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightSable,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder<List<QuizTheme>>(
            future: futureThemes,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(child: Text("Erreur de chargement"));
              }

              final themes = snapshot.data ?? [];

              /// 🔥 LISTE ITEMS (themes + random)
              final items = [
                ...themes.map((t) => QuizThemeItem.theme(t)),
                QuizThemeItem.random(),
              ];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Tous les Quiz",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "${themes.length} quiz disponibles",
                    style: TextStyle(color: Colors.grey[600]),
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: refresh,
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];

                          /// quiz aléatoire
                          if (item.isRandom) {
                            return Container(
                              margin: const EdgeInsets.only(top: 12),
                              child: QuizThemeCard(
                                theme: QuizTheme(
                                  id: 0,
                                  label: "Quiz aléatoire",
                                  questionsCount: 10,
                                  createdAt: "",
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const QuizGameScreen(
                                        themeId: null,
                                        themeLabel: "Quiz aléatoire",
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }

                          /// quiz thématique
                          final theme = item.theme!;

                          return QuizThemeCard(
                            theme: theme,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => QuizGameScreen(
                                    themeId: theme.id,
                                    themeLabel: theme.label,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}