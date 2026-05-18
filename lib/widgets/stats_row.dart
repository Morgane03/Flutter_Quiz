import 'package:flutter/material.dart';

import 'stat_card.dart';

class StatsRow extends StatelessWidget {
  final int quizCount;
  final int score;
  final int userCount;

  const StatsRow({
    super.key,
    required this.quizCount,
    required this.score,
    required this.userCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StatCard(
          label: "Quiz",
          value: quizCount.toString(),
        ),
        StatCard(
          label: "Score",
          value: score.toString(),
        ),
        StatCard(
          label: "Users",
          value: userCount.toString(),
        ),
      ],
    );
  }
}