import 'package:flutter/material.dart';
import 'backend.dart';

class ButtonBoard extends StatelessWidget {
  const ButtonBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 20.0,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        for (int i = 0; i < 5; i++)
          QuizColumn(topicName: QuizState.topicNames[i], col: i),
      ],
    );
  }

  //
}

class QuizColumn extends StatelessWidget {
  const QuizColumn({super.key, required this.topicName, required this.col});

  final String topicName;
  final int col;
  //final TextStyle bigText =
  static const values = [1000, 2000, 3500, 4000, 5000, 8000];

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textStyle = theme.textTheme.headlineSmall!.copyWith();

    return Expanded(
      child: Flexible(
        flex: 1,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 20.0,
            children: [
              Flexible(flex: 1, child: Text(topicName, style: textStyle)),
              for (int j = 0; j < 6; j++)
                Flexible(
                  flex: 1,
                  child: QuizButton(row: j, col: col, value: values[j]),
                ),
            ],
          ),
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
    required this.value,
  });

  final int value;
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

    void _onTap() {
      print('${widget.value}-es kérdés megjelölve');
      setState(() {
        _isClicked = true;
      });
      askQuestion(widget.row, widget.col);
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
          child: Text('${widget.value}', style: textStyle),
        ),
      ),
    );
  }
}
