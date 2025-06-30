import 'package:flutter/material.dart';
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
        for (var team in gameState.teams)
          TeamCard(
            teamID: i++,
            playerNames: {for (int id in team.playerIDs) gameState.players[id]},
          ),
      ],
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              var result = gameState.answerQuestion(teamID, true);
              //print('answerQuestion returned with ${result}');
              print(
                '$teamID. csapat új pontszáma: ${gameState.teams[teamID].score}',
              );
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
