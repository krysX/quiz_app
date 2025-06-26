import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (int i = 0; i < 5; i++)
          TeamCard(playerNames: {'Aladár', 'Béla', 'Cecil'}),
      ],
    );
  }
}

class TeamCard extends StatelessWidget {
  const TeamCard({super.key, required this.playerNames});

  final Set<String> playerNames;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Wrap(
            children: [for (var name in playerNames) Chip(label: Text(name))],
          ),
          TeamCounter(score: 35000),
        ],
      ),
    );
  }
}

class TeamCounter extends StatefulWidget {
  const TeamCounter({super.key, required this.score});

  final int score;

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
        Positioned(child: TeamScoreButtons()),
      ],
    );
  }
}

class TeamScoreButtons extends StatelessWidget {
  const TeamScoreButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(onPressed: () {}, icon: Icon(Icons.check)),
          IconButton(onPressed: () {}, icon: Icon(Icons.circle)),
        ],
      ),
    );
  }
}
