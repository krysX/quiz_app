import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'backend.dart';

class ButtonBoard extends StatelessWidget {
  const ButtonBoard({
    super.key,
    //required this.onQuizButtonPressed,
    //required this.levelPoints,
    //required this.topicNames,
  });
  //final Function(int, int) onQuizButtonPressed;
  //final List<int> levelPoints;
  //final List<String> topicNames;

  @override
  Widget build(BuildContext context) {
    var gameState = context.watch<GameStateModel>();
    return Row(
      spacing: 20.0,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        for (int i = 0; i < 5; i++)
          QuizColumn(
            //topicName: gameState.topicNames[i],
            col: i,
            //onButtonPressed: gameState.pickQuestion,
            //levelPoints: gameState.levelValues,
          ),
      ],
    );
  }

  //
}

class QuizColumn extends StatelessWidget {
  const QuizColumn({
    super.key,
    //required this.topicName,
    required this.col,
    //required this.onButtonPressed,
    //required this.levelPoints,
  });
  //final Function(int, int) onButtonPressed;
  //final List<int> levelPoints;

  //final String topicName;
  final int col;
  //final TextStyle bigText =

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textStyle = theme.textTheme.headlineSmall!.copyWith();
    var gameState = Provider.of<GameStateModel>(context);

    return Expanded(
      child: Flexible(
        flex: 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 20.0,
          children: [
            Flexible(
              flex: 1,
              child: Text(gameState.topicNames[col], style: textStyle),
            ),
            for (int j = 0; j < gameState.levelValues.length; j++)
              Flexible(
                flex: 1,
                child: QuizButton(
                  row: j,
                  col: col,
                  //value: gameState.levelValues[j],
                  //onPressed: gameState.pickQuestion(col, j),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class QuizButton extends StatefulWidget {
  const QuizButton({
    super.key,
    required this.row,
    required this.col,
    //required this.value,
    //required this.onPressed,
  });

  //final Function(int, int) onPressed;

  //final int value;
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
      print('${value}-es kérdés megjelölve');
      setState(() {
        _isClicked = true;
      });
      gameState.pickQuestion(widget.col, widget.row);
    }

    final buttonStyle = ButtonStyle(
      backgroundColor: WidgetStateProperty.all<Color>(widgetColor),
    );

    //final expand = BoxConstraints.expand();

    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Container(
        constraints: BoxConstraints(
          minWidth: 100.0,
          minHeight: 40.0,
          maxWidth: double.infinity,
          maxHeight: 60.0,
        ),
        child: ElevatedButton(
          onPressed: () => _onTap(),
          style: buttonStyle,
          child: Text('${value}', style: textStyle),
        ),
      ),
    );
  }
}
