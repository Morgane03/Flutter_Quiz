import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/quiz_screen.dart';
//import '../screens/config_screen.dart';

final List<Widget> appPages = [
  const HomeScreen(),
  const QuizScreen(themeId: null, themeLabel: null,),
  const Center(child: Text("Config")),
];