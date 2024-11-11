import 'package:flutter/foundation.dart';

@immutable
abstract class QuestionState {}

class QuestionInitial extends QuestionState {}

class QuestionUpdated extends QuestionState {
  final Map<String, dynamic> question;

  QuestionUpdated(this.question);
}
