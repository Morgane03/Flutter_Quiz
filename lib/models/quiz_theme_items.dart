import 'quiz_theme.dart';

class QuizThemeItem {
  final QuizTheme? theme;
  final bool isRandom;

  QuizThemeItem.theme(this.theme) : isRandom = false;

  QuizThemeItem.random()
      : theme = null,
        isRandom = true;
}