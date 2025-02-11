// event.dart
abstract class ScreenEvent {}

class ChangeSlideEvent extends ScreenEvent {
  final int index;
  ChangeSlideEvent(this.index);
}

class ChangeLanguageEvent extends ScreenEvent {
  final String language;
  ChangeLanguageEvent(this.language);
}

// state.dart
abstract class ScreenState {}

class ScreenInitialState extends ScreenState {}

class SlideChangedState extends ScreenState {
  final int index;
  SlideChangedState(this.index);
}

class LanguageChangedState extends ScreenState {
  final String language;
  LanguageChangedState(this.language);
}


