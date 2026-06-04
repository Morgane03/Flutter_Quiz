import 'package:flutter/material.dart';

import 'stat_card.dart';

class StatsRow extends StatelessWidget {
  final int quizCount;
  final int score;
  final int userRank;

  const StatsRow({
    super.key,
    required this.quizCount,
    required this.score,
    required this.userRank,
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
          label: "Rang",
          value: userRank.toString(),
        ),
      ],
    );
  }
}