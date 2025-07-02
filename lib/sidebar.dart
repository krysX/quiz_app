import 'package:flutter/material.dart';
import 'package:quiz_app/timer_state.dart';
import 'backend.dart';
import 'package:provider/provider.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    var gameState = context.watch<GameStateModel>();
    int i = 0;
    return ListView(
      children: [
        TimerCard(),
        for (var team in gameState.teams)
          TeamCard(
            teamID: i++,
            playerNames: {for (int id in team.playerIDs) gameState.players[id]},
          ),
      ],
    );
  }
}

class TimerCard extends StatelessWidget {
  const TimerCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var timerState = context.watch<TimeModel>();

    final onPrimary = theme.colorScheme.onPrimary;
    final textStyle = theme.textTheme.displayMedium!.copyWith(color: onPrimary);

    return Card.filled(
      color: theme.primaryColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              timerState.asString,
              style: textStyle,
              textAlign: TextAlign.center,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: timerState.isInitialized && timerState.isRunning
                    ? Icon(Icons.pause)
                    : Icon(Icons.play_arrow),
                onPressed: timerState.isInitialized && timerState.isRunning
                    ? () => timerState.pause()
                    : () => timerState.start(),
                color: onPrimary,
              ),
              IconButton(
                icon: Icon(Icons.replay),
                onPressed: () => timerState.reset(),
                color: onPrimary,
              ),
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {},
                color: onPrimary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TeamCard extends StatelessWidget {
  const TeamCard({super.key, required this.teamID, required this.playerNames});

  final int teamID;
  final Set<String> playerNames;

  @override
  Widget build(BuildContext context) {
    var gameState = context.watch<GameStateModel>();

    return Card(
      child: Column(
        children: [
          Wrap(
            children: [for (var name in playerNames) Chip(label: Text(name))],
          ),
          TeamCounter(teamID: teamID /*,score: gameState.teams[teamID].score*/),
        ],
      ),
    );
  }
}

class TeamCounter extends StatefulWidget {
  const TeamCounter({super.key, required this.teamID});

  final int teamID;

  @override
  State<TeamCounter> createState() => TeamCounterState();
}

class TeamCounterState extends State<TeamCounter> {
  @override
  Widget build(BuildContext context) {
    var textStyle = Theme.of(context).textTheme.displaySmall!;
    var gameState = context.watch<GameStateModel>();

    var child = gameState.currentQuestion != null
        ? TeamScoreButtons(teamID: widget.teamID)
        : Text('${gameState.teams[widget.teamID].score}', style: textStyle);

    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(20.0),
      child: child,
    );
  }
}

class TeamScoreButtons extends StatelessWidget {
  const TeamScoreButtons({
    super.key,
    required this.teamID,
    //required this.onPressed,
  });

  final int teamID;

  @override
  Widget build(BuildContext context) {
    var gameState = context.watch<GameStateModel>();

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () {
              var result = gameState.answerQuestion(teamID, true);
              //print('answerQuestion returned with ${result}');
            },
            icon: Icon(Icons.check),
          ),
          IconButton(
            onPressed: () {
              gameState.answerQuestion(teamID, false);
              print(
                '$teamID. csapat új pontszáma: ${gameState.teams[teamID].score}',
              );
            },
            icon: Icon(Icons.clear),
          ),
        ],
      ),
    );
  }
}
