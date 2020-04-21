import 'package:flutter/material.dart';

class BakingStep {
  BakingStep(
      {@required this.duration,
      @required this.durationUnit,
      @required this.stepName});

  int duration;
  String durationUnit;
  String stepName;
  DateTime stepStartTime;
}
