import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/leaderboard_user.dart';

class LeaderboardService {
  final String apiUrl = dotenv.env['API_URL']!;

  Future<List<LeaderboardUser>> getLeaderboard() async {
    final url = Uri.parse('$apiUrl/users/leaderboard');

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      return (json['data'] as List)
          .map((e) => LeaderboardUser.fromJson(e))
          .toList();
    } else {
      throw Exception("Erreur API leaderboard");
    }
  }
}