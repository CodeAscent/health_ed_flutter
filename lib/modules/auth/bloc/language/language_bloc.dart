import 'package:flutter_bloc/flutter_bloc.dart';
import 'language_event.dart';
import 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(LanguageInitial()) {
    on<SelectLanguageEvent>((event, emit) {
      emit(LanguageSelectedState(event.selectedLanguage));
    });
  }
}
