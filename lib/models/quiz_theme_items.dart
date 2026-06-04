import 'quiz_theme.dart';

/// classe pour représenter un item dans la liste des thèmes de quiz
class QuizThemeItem {
  final QuizTheme? theme;
  final bool isRandom;

  QuizThemeItem.theme(this.theme) : isRandom = false;

  QuizThemeItem.random()
      : theme = null,
        isRandom = true;
}