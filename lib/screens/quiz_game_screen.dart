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

  bool showCorrection = false;

  @override
  void initState() {
    super.initState();
    initQuiz();
  }

  Future<void> initQuiz() async {
    try {
      final id = await service.startQuiz(widget.themeId);

      final questions = await service.getQuestions(
        themeId: widget.themeId,
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
    if (showCorrection) return;

    setState(() {
      answers[q.id] = answer;
    });
  }

  Future<void> next(List<QuizQuestion> questions) async {
    setState(() {
      showCorrection = true;
    });

    await Future.delayed(const Duration(milliseconds: 700));

    setState(() {
      showCorrection = false;
    });

    if (currentIndex < questions.length - 1) {
      setState(() => currentIndex++);
    } else {
      finish(questions);
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
          questions: questions,
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
            if (futureQuestions == null || !snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final questions = snapshot.data!;
            final question = questions[currentIndex];

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  /// HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.themeLabel,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: darkGreen,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        "${currentIndex + 1}/${questions.length}",
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

                  /// QUESTION
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

                  /// ANSWERS
                  Expanded(
                    child: ListView.builder(
                      itemCount: question.proposals.length,
                      itemBuilder: (context, i) {
                        final p = question.proposals[i];

                        final selected = answers[question.id] == p;
                        final isCorrectAnswer = p == question.answer;
                        final isWrongSelected = selected && p != question.answer;

                        final letters = ["A", "B", "C", "D"];

                        return GestureDetector(
                          onTap: () => selectAnswer(question, p),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              //couleur de fond des réponses en fonction de l'état (sélectionné, correct, incorrect)
                              color: showCorrection
                                  ? (isCorrectAnswer
                                      ? Colors.green.withOpacity(0.25)
                                      : isWrongSelected
                                          ? Colors.red.withOpacity(0.25)
                                          : Colors.white)
                                  : (selected ? pink : Colors.white),
                              borderRadius: BorderRadius.circular(16),
                              //bordure des réponses en fonction de l'état (sélectionné, correct, incorrect)
                              border: Border.all(
                                color: showCorrection
                                    ? (isCorrectAnswer
                                        ? Colors.green
                                        : isWrongSelected
                                            ? Colors.red
                                            : darkGrey)
                                    : (selected ? orange : darkGrey),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 14,
                                  backgroundColor:
                                      selected ? orange : Colors.white,
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

                  /// button suivant / terminer
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