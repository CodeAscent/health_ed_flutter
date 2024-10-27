// screen_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import 'VideoScreenEvent.dart';

class ScreenBloc extends Bloc<ScreenEvent, ScreenState> {
  ScreenBloc() : super(ScreenInitialState());

  @override
  Stream<ScreenState> mapEventToState(ScreenEvent event) async* {
    if (event is ChangeSlideEvent) {
      yield SlideChangedState(event.index);
    } else if (event is ChangeLanguageEvent) {
      yield LanguageChangedState(event.language);
    }
  }
}