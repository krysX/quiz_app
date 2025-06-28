import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
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
    required this.nLevels,
    required this.players,
    required this.teams,
  }) {
    final file = File(path);
    Stream<String> lines = file
        .openRead()
        .transform(utf8.decoder)
        .transform(LineSplitter());

    var _questions = List<List<String>>.generate(
      nTopics,
      (_) => List<String>.generate(nLevels, (_) => ""),
    );

    var _topicNames = List<String>.generate(nTopics, (_) => "");

    try {
      _questions = List<List<String>>.generate(
        nTopics,
        (int topic) => List<String>.generate(nLevels, (int level) {
          String question = "";
          lines.elementAt(topic * (nLevels + 1 + 1) + (level + 1)).then((str) {
            question = str;
          });
          return question;
        }),
      );

      _topicNames = List<String>.generate(nTopics, (int topic) {
        String topicName = "";
        lines.elementAt(topic * (nLevels + 1 + 1)).then((str) {
          topicName = str;
        });
        return topicName;
      });
    } catch (e) {
      print('Error: $e');
    }

    questions = _questions;
    topicNames = _topicNames;
  }

  final String path;
  final int nTopics, nLevels;

  final List<int> levelValues = [1000, 2000, 3000, 4000, 5000, 8000];
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
    if (currentAnswer.teamId == -1) return false;
    var questionPoints = getValue(currentQuestion);
    currentAnswer = AnswerScoringModel(
      teamId: teamId,
      points: questionPoints,
      isCorrect: isCorrect,
    );

    if (isCorrect)
      teams[currentAnswer.teamId].score += currentAnswer.points;
    else
      teams[currentAnswer.teamId].score -= currentAnswer.points;

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
