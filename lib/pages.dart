import 'package:flutter/material.dart';
import '../screens/home_screen.dart';

final List<Widget> appPages = [
  const HomeScreen(),
  const Center(child: Text("Quiz")),
  const Center(child: Text("Config")),
];