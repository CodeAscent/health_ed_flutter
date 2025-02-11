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
