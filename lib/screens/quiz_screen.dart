import 'package:flutter/material.dart';
import '../services/quiz_service.dart';
import '../models/quiz_theme.dart';
import '../widgets/quiz_theme_card.dart';
import '../assets/const/color.dart';
import 'quiz_game_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

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
      backgroundColor: colorbackground,
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

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  const Text(
                    "Tous les Quiz",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "${themes.length} quiz disponibles",
                    style: TextStyle(color: Colors.grey[600]),
                  ),

                  const SizedBox(height: 20),

                  // Liste des thèmes de quiz
                  Expanded(
                    child: FutureBuilder<List<QuizTheme>>(
                      future: futureThemes,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(child: Text("Erreur de chargement"));
                        }

                        final themes = snapshot.data ?? [];

                        return RefreshIndicator(
                          onRefresh: refresh,
                          child: ListView.builder(
                            itemCount: themes.length,
                            itemBuilder: (context, index) {
                              final theme = themes[index];

                              return QuizThemeCard(
                                theme: theme,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          QuizGameScreen(themeId: theme.id, themeLabel: theme.label),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        );
                      },
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
