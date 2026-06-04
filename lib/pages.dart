import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/quiz_screen.dart';
import '../screens/leaderboard_screen.dart';

final List<Widget> appPages = [
  const HomeScreen(),
  const QuizScreen(themeId: null, themeLabel: null,),
  const LeaderboardPage(),
];