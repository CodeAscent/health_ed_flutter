
import 'package:equatable/equatable.dart';


abstract class LanguageEvent extends Equatable {
  const LanguageEvent();
}

class SelectLanguageEvent extends LanguageEvent {
  final String selectedLanguage;
  const SelectLanguageEvent(this.selectedLanguage);

  @override
  List<Object> get props => [selectedLanguage];
}
