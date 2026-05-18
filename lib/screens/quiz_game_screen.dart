import 'package:flutter/material.dart';
import '../models/quiz_question.dart';
import '../services/quiz_service.dart';
import 'quiz_result_screen.dart';

class QuizGameScreen extends StatefulWidget {
  final int themeId;

  const QuizGameScreen({super.key, required this.themeId});

  @override
  State<QuizGameScreen> createState() => _QuizGameScreenState();
}

class _QuizGameScreenState extends State<QuizGameScreen> {
  final QuizService service = QuizService();

  Future<List<QuizQuestion>>? futureQuestions;
  int? quizId;

  int currentIndex = 0;
  Map<int, String> answers = {};

  @override
  void initState() {
    super.initState();
    initQuiz();
  }

  Future<void> initQuiz() async {
    try {
      final id = await service.startQuiz(widget.themeId);

      final questions = await service.getQuestions(themeId: widget.themeId);

      setState(() {
        quizId = id;
        futureQuestions = Future.value(questions);
      });
    } catch (e) {
      print("INIT QUIZ ERROR: $e");
    }
  }

  void selectAnswer(QuizQuestion q, String answer) {
    setState(() {
      answers[q.id] = answer;
    });
  }

  void next(List<QuizQuestion> questions) {
    if (currentIndex < questions.length - 1) {
      setState(() => currentIndex++);
    }
  }

  Future<void> finish(List<QuizQuestion> questions) async {
    if (quizId == null) return;

    final result = await service.submitQuiz(quizId!, answers);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => QuizResultScreen(
          result: result,
          questions: questions.map((e) => e).toList(),
          answers: answers,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: SafeArea(
        child: FutureBuilder<List<QuizQuestion>>(
          future: futureQuestions,
          builder: (context, snapshot) {
            if (futureQuestions == null) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final questions = snapshot.data!;
            final question = questions[currentIndex];

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  /// PROGRESSION
                  LinearProgressIndicator(
                    value: (currentIndex + 1) / questions.length,
                  ),

                  const SizedBox(height: 20),

                  /// QUESTION
                  Text(
                    question.label,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// ANSWERS
                  ...question.proposals.map((p) {
                    final selected = answers[question.id] == p;

                    return GestureDetector(
                      onTap: () => selectAnswer(question, p),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: selected ? Colors.orange : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(p),
                      ),
                    );
                  }),

                  const Spacer(),

                  /// BUTTON NEXT / FINISH
                  ElevatedButton(
                    onPressed: () {
                      if (currentIndex == questions.length - 1) {
                        finish(questions);
                      } else {
                        next(questions);
                      }
                    },
                    child: Text(
                      currentIndex == questions.length - 1
                          ? "Terminer"
                          : "Suivant",
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
