import 'package:flutter/material.dart';

/// helper pour associer une icône à un thème de quiz
class ThemeIconHelper {
  static IconData getIcon(String label) {
    switch (label.toLowerCase()) {
      case 'automobile':
        return Icons.directions_car;

      case 'culture g':
        return Icons.public;

      case 'film':
        return Icons.movie;

      case 'histoire':
        return Icons.account_balance;

      case 'informatique':
        return Icons.computer;

      case 'littérature':
      case 'litterature':
        return Icons.menu_book;

      case 'manga':
        return Icons.auto_stories;

      case 'quiz aléatoire':
      case 'quiz aleatoire':
        return Icons.shuffle;

      default:
        return Icons.quiz;
    }
  }
}