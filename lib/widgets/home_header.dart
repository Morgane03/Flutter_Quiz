import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final String firstname;
  final String lastname;

  const HomeHeader({
    super.key,
    required this.firstname,
    required this.lastname,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Quiz",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "Bienvenue $firstname $lastname",
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}