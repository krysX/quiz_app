import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/question_board.dart';
import 'backend.dart';
import 'button_board.dart';
import 'sidebar.dart';
import 'timer_state.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GameStateModel(
            path: 'demo.txt',
            nTopics: 5,
            levelValues: [1000, 2000, 3000, 4000, 5000, 8000],
            players: ['Aladár', 'Béla', 'Cecil', 'Dénes', 'Elemér', 'Ferenc'],
            teams: [
              TeamModel(playerIDs: {0, 1, 2}),
              TeamModel(playerIDs: {1, 2, 4}),
              TeamModel(playerIDs: {3, 5}),
            ],
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => TimeModel(totalTimeInS: 360),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz Program',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
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
    var gameState = context.watch<GameStateModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Row(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ButtonBoard(),
                Visibility(
                  visible: gameState.currentQuestion != null,
                  child: QuestionBoard(),
                ),
              ],
            ),
          ),
          Expanded(flex: 1, child: Sidebar()),
        ],
      ),
    );
  }
}
