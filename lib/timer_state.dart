import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import 'dart:async';

class TimeModel extends ChangeNotifier {
  TimeModel({this.totalTimeInS = 0}) {
    countdownInS = totalTimeInS;
  }

  String get asString {
    int mins = (countdownInS / 60).toInt();
    int secs = countdownInS % 60;
    return '$mins:${secs < 10 ? "0" : ""}$secs';
  }

  final int totalTimeInS;
  late int countdownInS;
  late Timer _timer;

  bool get isRunning => _timer.isActive;
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  void start() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      countdownInS--;
      notifyListeners();
      if (countdownInS == 0) _timer.cancel();
    });
    _isInitialized = true;
    notifyListeners();
  }

  void pause() {
    _timer.cancel();
    notifyListeners();
  }

  void reset() {
    countdownInS = totalTimeInS;
    notifyListeners();
  }
}
