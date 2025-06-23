import 'package:flutter/material.dart';
import 'backend.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz Program',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Kvízprogram demó'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              for (int i = 0; i < 5; i++)
                QuizColumn(topicName: QuizState.topicNames[i], col: i),
            ],
          ),
        ),
      ),
    );
  }
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

    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 20.0,
          children: [
            SizedBox(height: 20.0),
            Text(topicName, style: textStyle),
            for (int j = 0; j < 6; j++)
              QuizButton(row: j, col: col, value: values[j]),
          ],
        ),
        SizedBox(width: 20.0),
      ],
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
    var theme = Theme.of(context);
    var textStyle = theme.textTheme.displaySmall!.copyWith(color: Colors.white);
    var widgetColor = _isClicked == false
        ? theme.primaryColor
        : theme.disabledColor;

    //var buttonStyle = theme.buttonTheme.copyWith(
    //  minWidth: 150.0,
    //  height: 60.0,
    //  buttonColor: theme.primaryColor,
    //)

    return TextButton(
      onPressed: () {
        if (_isClicked == false) {
          print('${widget.value}-es kérdés megjelölve');
          setState(() {
            _isClicked = true;
          });
          showQuestion(widget.row, widget.col);
        }
      },
      style: ButtonStyle(
        //overlayColor: WidgetStateProperty.all<Color>(Colors.blue),
        backgroundColor: WidgetStateProperty.all<Color>(widgetColor),
        //foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
        //textStyle: WidgetStateProperty.all<TextStyle>(textStyle),
        minimumSize: WidgetStateProperty.all<Size>(Size(150.0, 60.0)),
      ),
      child: Text('${widget.value}', style: textStyle),
    );
  }
}

void showQuestion(int row, int col) {
  print(QuizState.questions[col][row]);
}
