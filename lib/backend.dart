import 'dart:io';
//import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:provider/provider.dart';

class TeamModel {
  TeamModel({required this.playerIDs});

  final Set<int> playerIDs;
  int score = 0;
}

class QuestionModel {
  const QuestionModel({required this.topic, required this.level});

  final int topic;
  final int level;
}

class AnswerScoringModel {
  AnswerScoringModel({teamId, points, isCorrect});

  int teamId = -1;
  int points = 0;
  bool isCorrect = true;
}

class GameStateModel extends ChangeNotifier {
  GameStateModel({
    required this.path,
    required this.nTopics,
    required this.levelValues,
    required this.players,
    required this.teams,
  }) {
    final file = File(path);
    final List<String> lines = List.empty(growable: true);

    file
        .openRead()
        .transform(utf8.decoder)
        .transform(LineSplitter())
        .listen(
          (data) {
            lines.add(data);
          },
          onError: (e) {
            topicNames = List.generate(nTopics, (_) => "");
            questions = List.generate(
              nTopics,
              (_) => List.generate(levelValues.length, (_) => ""),
            );
            notifyListeners();
          },
          onDone: () {
            topicNames = List.generate(
              nTopics,
              (topic) => lines[topic * (levelValues.length + 2)],
            );
            questions = List.generate(
              nTopics,
              (topic) => List.generate(
                levelValues.length,
                (level) => lines[topic * (levelValues.length + 2) + 1 + level],
              ),
            );
            notifyListeners();
          },
        );
  }

  final String path;
  final int nTopics;

  final List<int> levelValues;
  late final List<List<String>> questions;
  late final List<String> topicNames;

  QuestionModel? currentQuestion;
  List<TeamModel> teams;
  List<String> players;

  var currentAnswer = AnswerScoringModel(
    teamId: -1,
    points: 0,
    isCorrect: true,
  );

  int getValue(QuestionModel? question) {
    if (question == null) return 0;
    return levelValues[question.level];
  }

  String getQuestionText(QuestionModel? question) {
    if (question == null) return "";
    return questions[question.topic][question.level];
  }

  void pickQuestion(int topic, int diff) {
    currentQuestion = QuestionModel(topic: topic, level: diff);
    notifyListeners();
  }

  bool answerQuestion(int teamId, bool isCorrect) {
    if (teamId == -1 || currentAnswer.teamId != -1) return false;
    var questionPoints = getValue(currentQuestion);
    currentAnswer = AnswerScoringModel(
      teamId: teamId,
      points: questionPoints,
      isCorrect: isCorrect,
    );

    if (isCorrect)
      teams[teamId].score += questionPoints;
    else
      teams[teamId].score -= questionPoints;

    print('$teamId. csapat új pontszáma: ${teams[teamId].score}');
    currentQuestion = null;
    notifyListeners();
    return true;
  }

  bool revertPoints() {
    if (currentAnswer.teamId == -1) return false;

    if (currentAnswer.isCorrect)
      teams[currentAnswer.teamId].score -= currentAnswer.points;
    else
      teams[currentAnswer.teamId].score += currentAnswer.points;

    currentAnswer.teamId = -1;

    notifyListeners();
    return true;
  }
}
