import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter/material.dart';

class HomeService {
  final String baseUrl = dotenv.env['API_URL']!;

  Future<Map<String, dynamic>> getHomeData(String token) async {
    final response = await http.get(
      Uri.parse("$baseUrl/home"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erreur home API");
    }
  }

  Future<List<dynamic>> getUserQuizzes(String token) async {
    final response = await http.get(
      Uri.parse("$baseUrl/quiz/quizzes"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["data"] ?? [];
    } else {
      throw Exception("Erreur quizzes API");
    }
  }

  Future<Map<String, dynamic>> getMe(String token) async {
    final String apiUrl = dotenv.env['API_URL']!;
    final String url = "$apiUrl/users/me";

    debugPrint("========== GET ME ==========");
    debugPrint("URL : $url");
    debugPrint("TOKEN : $token");

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    debugPrint("STATUS CODE : ${response.statusCode}");
    debugPrint("BODY : ${response.body}");

    final data = jsonDecode(response.body);

    debugPrint("DATA DECODED : $data");

    if (response.statusCode == 200) {
      debugPrint("USER DATA : ${data["data"]}");
      return data["data"];
    } else {
      debugPrint("ERROR : ${data["errors"]}");
      throw Exception(data["errors"] ?? "Erreur utilisateur");
    }
  }

  Future<List<dynamic>> getLeaderboard(String token) async {
    final response = await http.get(
      Uri.parse("$baseUrl/users/leaderboard"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["data"] ?? [];
    } else {
      throw Exception("Erreur leaderboard API");
    }
  }
}
