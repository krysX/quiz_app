import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'backend.dart';

class ButtonBoard extends StatelessWidget {
  const ButtonBoard({super.key});

  @override
  Widget build(BuildContext context) {
    var gameState = context.watch<GameStateModel>();
    return Row(
      spacing: 20.0,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[for (int i = 0; i < 5; i++) QuizColumn(col: i)],
    );
  }

  //
}

class QuizColumn extends StatelessWidget {
  const QuizColumn({super.key, required this.col});

  final int col;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textStyle = theme.textTheme.headlineSmall!.copyWith();
    var gameState = context.watch<GameStateModel>();

    return Expanded(
      child: Expanded(
        flex: 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 5.0,
          children: [
            Spacer(),
            Text(gameState.topicNames[col], style: textStyle),
            Spacer(),
            for (int j = 0; j < gameState.levelValues.length; j++) ...[
              QuizButton(row: j, col: col),
              Spacer(),
            ],
          ],
        ),
      ),
    );
  }
}

class QuizButton extends StatefulWidget {
  const QuizButton({super.key, required this.row, required this.col});

  final int row, col;

  @override
  State<QuizButton> createState() => QuizButtonState();
}

class QuizButtonState extends State<QuizButton> {
  bool _isClicked = false;

  //const ButtonStyle style = copy
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.displaySmall!.copyWith(
      color: Colors.white,
    );
    final widgetColor = _isClicked == false
        ? theme.primaryColor
        : theme.disabledColor;

    var gameState = context.watch<GameStateModel>();
    var value = gameState.levelValues[widget.row];

    void _onTap() {
      if (_isClicked == true) return;
      print('${value}-es kérdés megjelölve');
      setState(() {
        _isClicked = true;
      });
      gameState.pickQuestion(widget.col, widget.row);
    }

    final buttonStyle = ButtonStyle(
      backgroundColor: WidgetStateProperty.all<Color>(widgetColor),
    );

    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _onTap(),
        style: buttonStyle,
        child: Text('$value', style: textStyle),
      ),
    );
  }
}
