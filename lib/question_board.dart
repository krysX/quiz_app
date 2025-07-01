import 'package:flutter/material.dart';
import 'package:quiz_app/backend.dart';
import 'package:provider/provider.dart';

class QuestionBoard extends StatelessWidget {
  const QuestionBoard({super.key});

  @override
  Widget build(BuildContext context) {
    var gameState = context.watch<GameStateModel>();
    var colorScheme = Theme.of(context).colorScheme;
    var textStyle = Theme.of(context).textTheme.displayMedium!;

    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: Card.filled(
        color: colorScheme.primaryContainer,
        child: Center(
          child: Text(
            gameState.getQuestionText(gameState.currentQuestion),
            textAlign: TextAlign.center,
            style: textStyle,
          ),
        ),
      ),
    );
  }
}
