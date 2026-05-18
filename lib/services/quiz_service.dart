import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/quiz_theme.dart';

class QuizService {
  final String baseUrl = dotenv.env['API_URL']!;

  Future<List<QuizTheme>> getThemes() async {
    final response = await http.get(
      Uri.parse("$baseUrl/quiz/themes"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List list = data['data'];

      return list.map((e) => QuizTheme.fromJson(e)).toList();
    } else {
      throw Exception("Erreur chargement quiz themes");
    }
  }
}