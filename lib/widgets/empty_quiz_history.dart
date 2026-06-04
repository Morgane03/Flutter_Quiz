import 'package:flutter/material.dart';

import '../assets/const/color.dart';

class EmptyQuizHistory extends StatelessWidget {
  final VoidCallback onGoHome;

  const EmptyQuizHistory({
    super.key,
    required this.onGoHome,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Icon(
              Icons.emoji_events_outlined,
              size: 90,
              color: darkGrey,
            ),

            const SizedBox(height: 24),

            Text(
              "Aucun score",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 12),

            Text(
              "Commencer un quiz pour voir vos scores ici.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onGoHome,
                style: ElevatedButton.styleFrom(
                  backgroundColor: orange,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.home, size: 18, color: Colors.white),
                    const SizedBox(width: 8),
                    const Text(
                      "Aller à l’accueil",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}