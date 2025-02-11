

import 'package:equatable/equatable.dart';

abstract class LanguageState extends Equatable {
  const LanguageState();

  @override
  List<Object> get props => [];
}

class LanguageInitial extends LanguageState {}

class LanguageSelectedState extends LanguageState {
  final String selectedLanguage;
  const LanguageSelectedState(this.selectedLanguage);

  @override
  List<Object> get props => [selectedLanguage];
}
