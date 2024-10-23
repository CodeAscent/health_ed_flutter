abstract class SliderEvent {}

class NextPageEvent extends SliderEvent {}
class PreviousPageEvent extends SliderEvent {}

// state.dart
abstract class SliderState {
  final int pageIndex;
  SliderState(this.pageIndex);
}

class PageChangedState extends SliderState {
  PageChangedState(int pageIndex) : super(pageIndex);
}
