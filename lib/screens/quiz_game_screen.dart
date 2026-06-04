import 'package:flutter/material.dart';
import '../models/quiz_question.dart';
import '../services/quiz_service.dart';
import 'quiz_result_screen.dart';
import '../assets/const/color.dart';

class QuizGameScreen extends StatefulWidget {
  final int? themeId;
  final String themeLabel;

  const QuizGameScreen({
    super.key,
    required this.themeId,
    required this.themeLabel,
  });

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

      final questions = await service.getQuestions(
        themeId: widget.themeId, // null accepté
      );

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
      backgroundColor: lightSable,
      body: SafeArea(
        child: FutureBuilder<List<QuizQuestion>>(
          future: futureQuestions,
          builder: (context, snapshot) {
            if (futureQuestions == null) {
              return const Center(child: CircularProgressIndicator());
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
                  /// header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.themeLabel, // nom du quiz
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: darkGreen,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        "${currentIndex + 1}/${10}", // question courante / total
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: darkGreen,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  LinearProgressIndicator(
                    value: (currentIndex + 1) / questions.length,
                    color: orange,
                    backgroundColor: grey,
                  ),

                  const SizedBox(height: 20),

                  /// carte
                  Container(
                    padding: const EdgeInsets.all(18),
                    child: Text(
                      question.label,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: darkGreen,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// Style des réponses
                  Expanded(
                    child: ListView.builder(
                      itemCount: question.proposals.length,
                      itemBuilder: (context, i) {
                        final p = question.proposals[i];
                        final selected = answers[question.id] == p;
                        final letters = ["A", "B", "C", "D"];

                        return GestureDetector(
                          onTap: () => selectAnswer(question, p),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: selected ? pink : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: selected ? orange : darkGrey,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 14,
                                  backgroundColor: selected
                                      ? orange
                                      : Colors.white,
                                  child: Text(
                                    letters[i],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: selected
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    p,
                                    style: TextStyle(
                                      color: darkGreen,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  /// Bouuton suivant/valider
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: orange,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
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
                        style: const TextStyle(color: Colors.white),
                      ),
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
