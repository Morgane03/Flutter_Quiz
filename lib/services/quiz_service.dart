import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/quiz_theme.dart';
import '../models/quiz_question.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizService {
  final String baseUrl = dotenv.env['API_URL']!;

  Future<List<QuizTheme>> getThemes() async {
    final response = await http.get(Uri.parse("$baseUrl/quiz/themes"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List list = data['data'];

      return list.map((e) => QuizTheme.fromJson(e)).toList();
    }

    throw Exception("Erreur chargement quiz themes");
  }

  Future<List<QuizQuestion>> getQuestions({int? themeId}) async {
    final uri = themeId == null
        ? Uri.parse("$baseUrl/quiz/questions")
        : Uri.parse("$baseUrl/quiz/questions?theme_id=$themeId");

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List list = data['data'];

      return list.map((e) => QuizQuestion.fromJson(e)).toList();
    }

    throw Exception("Erreur chargement questions");
  }

  /// START QUIZ (FIX RANDOM PROPRE)
  Future<int> startQuiz(int? themeId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final body = themeId == null
        ? {
            "question_limit": 10,
            "random": true,
          }
        : {
            "theme_id": themeId,
            "question_limit": 10,
          };

    final response = await http.post(
      Uri.parse("$baseUrl/quiz/quizzes/start"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(body),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return data['data']['id'];
    }

    throw Exception(data['message'] ?? "Erreur start quiz");
  }

  Future<Map<String, dynamic>> submitQuiz(
    int quizId,
    Map<int, String> answers,
  ) async {
    final formattedAnswers = answers.entries.map((e) {
      return {
        "question_id": e.key,
        "user_answer": e.value,
      };
    }).toList();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse("$baseUrl/quiz/quizzes/$quizId/submit"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"answers": formattedAnswers}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception("Erreur submit quiz: ${response.body}");
  }
}