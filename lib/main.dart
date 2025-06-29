import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/question_board.dart';
import 'backend.dart';
import 'button_board.dart';
import 'sidebar.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GameStateModel(
        path: 'demo.txt',
        nTopics: 5,
        levelValues: [1000, 2000, 3000, 4000, 5000, 8000],
        players: ['A', 'B', 'C', 'D', 'E', 'F'],
        teams: [
          TeamModel(playerIDs: {0, 1, 2}),
          TeamModel(playerIDs: {1, 2, 4}),
          TeamModel(playerIDs: {3, 5, 4}),
        ],
      ),
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
  //bool isQuestionSelected = false;
  //String currentQuestion

  @override
  Widget build(BuildContext context) {
    var gameState = context.watch<GameStateModel>();
    Widget bigArea = gameState.currentQuestion != null
        ? QuestionBoard(
            //questionText: gameState.getQuestionText(gameState.currentQuestion),
          )
        : ButtonBoard(
            //onQuizButtonPressed: gameState.pickQuestion,
            //levelPoints: gameState.levelValues,
            //topicNames: gameState.topicNames,
          );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Row(
        children: <Widget>[
          Expanded(flex: 4, child: bigArea),
          Expanded(
            flex: 1,
            child: Sidebar(
              //playerNames: gameState.players,
              //teams: gameState.teams,
              //onPressed: gameState.answerQuestion,
            ),
          ),
        ],
      ),
    );
  }
}
