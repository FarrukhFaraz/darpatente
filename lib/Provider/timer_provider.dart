import 'dart:async';

import 'package:flutter/foundation.dart';

class TimerProvider with ChangeNotifier {
  int _secRemaining = 0;

  Duration duration = const Duration(seconds: 1);
  Timer? _timer;

  int get secRemaining => _secRemaining;

  void setSecRemaining(int sec){
    _secRemaining = sec;
  }

  void setInitialTimerInMinute(int minute) {
    _secRemaining = minute * 60;
  }

  void startTimerUp() {
    _timer = Timer.periodic(duration, (Timer t) {
      updateTimerUp();
    });
  }

  void updateTimerUp() {
    _secRemaining++;

    notifyListeners();
  }

  void startTimerDown() {
    _timer = Timer.periodic(duration, (Timer t) {
      updateTimerDown();
    });
  }

  void updateTimerDown() {
    if (_secRemaining < 1) {
      stopTimer();
    } else {
      _secRemaining--;
    }

    notifyListeners();
  }

  void stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
      setTimeComplete();
    }
  }

  void setTimeComplete() {
    print('time completed');
    notifyListeners();
  }

  void resetTimer() {
    _secRemaining = 0;
    notifyListeners();
  }

  void pauseTimer() {
    _timer!.cancel();
    notifyListeners();
  }

  // void playTimer(){
  //   startTimer();
  //   notifyListeners();
  // }

  String get timeToDisplay {
    int minute = _secRemaining ~/ 60;
    int second = _secRemaining % 60;
    String minStr = minute < 10 ? "0$minute" : "$minute";
    String secStr = second < 10 ? "0$second" : "$second";

    return "$minStr:$secStr";
  }
}
