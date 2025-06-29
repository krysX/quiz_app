import 'package:flutter/material.dart';
import 'backend.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({
    super.key,
    required this.playerNames,
    required this.teams,
    required this.onPressed,
  });

  final List<String> playerNames;
  final List<TeamModel> teams;
  final bool Function(int, bool) onPressed;

  @override
  Widget build(BuildContext context) {
    int i = 0;
    return ListView(
      children: [
        for (var team in teams)
          TeamCard(
            teamID: i++,
            playerNames: {for (int id in team.playerIDs) playerNames[id]},
            score: team.score,
            onPressed: onPressed,
          ),
      ],
    );
  }
}

class TeamCard extends StatelessWidget {
  const TeamCard({
    super.key,
    required this.teamID,
    required this.playerNames,
    required this.score,
    required this.onPressed,
  });

  final int teamID;
  final Set<String> playerNames;
  final int score;
  final bool Function(int, bool) onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Wrap(
            children: [for (var name in playerNames) Chip(label: Text(name))],
          ),
          TeamCounter(teamID: teamID, score: score, onPressed: onPressed),
        ],
      ),
    );
  }
}

class TeamCounter extends StatefulWidget {
  const TeamCounter({
    super.key,
    required this.teamID,
    required this.score,
    required this.onPressed,
  });

  final int teamID;
  final int score;
  final bool Function(int, bool) onPressed;

  //
  @override
  State<TeamCounter> createState() => TeamCounterState();
}

class TeamCounterState extends State<TeamCounter> {
  //int _score;

  @override
  Widget build(BuildContext context) {
    var textStyle = Theme.of(context).textTheme.displaySmall!;

    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Center(child: Text('${widget.score}', style: textStyle)),
          ),
        ),
        Positioned(
          child: TeamScoreButtons(
            teamID: widget.teamID,
            onPressed: widget.onPressed,
          ),
        ),
      ],
    );
  }
}

class TeamScoreButtons extends StatelessWidget {
  const TeamScoreButtons({
    super.key,
    required this.teamID,
    required this.onPressed,
  });

  final int teamID;
  final bool Function(int, bool) onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () => onPressed(teamID, true),
            icon: Icon(Icons.check),
          ),
          IconButton(
            onPressed: () => onPressed(teamID, false),
            icon: Icon(Icons.circle),
          ),
        ],
      ),
    );
  }
}
