import 'dart:async';

import 'package:flutter/material.dart';

class ToDoItem {
  final String id;
  String title;
  String? description;
  DateTime? dueDate;
  ValueNotifier<Duration>? timeLeft;
  Timer? _timer;
  ValueNotifier<bool> hasTimePassed;
  final bool wasTimeSet;
  ToDoItem({
    required this.id,
    required this.title,
    required this.description,
    required this.hasTimePassed,
    required this.wasTimeSet,
    this.dueDate,
  }) {
    resetTimeLeft();
  }

  void resetTimeLeft() {
    if (dueDate == null) {
      return;
    }
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }

    timeLeft = ValueNotifier(dueDate!.difference(DateTime.now()));
    //print(timeLeft!.value);
    _startDecrement();
  }

  void endTask() {
    if (timeLeft != null) {
      timeLeft!.value = Duration.zero;
    }
    _timer!.cancel();
  }

  Duration? get _decrementDuration {
    if (timeLeft == null) return null;
    Duration decrementDuration;
    if (timeLeft!.value.inDays > 1) {
      decrementDuration = const Duration(hours: 2, minutes: 24);
    } else if (timeLeft!.value.inHours > 1) {
      decrementDuration = const Duration(minutes: 6);
    } else if (timeLeft!.value.inMinutes > 1) {
      decrementDuration = const Duration(seconds: 6);
    } else {
      decrementDuration = const Duration(seconds: 1);
    }
    return decrementDuration;
  }

  void _startDecrement() {
    //First we'll get the highest time value from dueDate
    Duration? decrementDuration = _decrementDuration;
    if (decrementDuration == null || timeLeft == null) {
      return;
    }
    _timer = Timer.periodic(decrementDuration, (tim) {
      timeLeft!.value = timeLeft!.value - decrementDuration;
      if (timeLeft!.value.inSeconds == 0 || timeLeft!.value.isNegative) {
        hasTimePassed.value = true;
        _timer!.cancel();
        return;
      }
      if (timeLeft!.value < decrementDuration) {
        _timer!.cancel();
        _startDecrement();
        return;
      }
    });
  }
}
