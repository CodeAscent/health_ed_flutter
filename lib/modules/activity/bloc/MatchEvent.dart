abstract class MatchEvent {}

class SelectShapeEvent extends MatchEvent {
  final String shapeName;

  SelectShapeEvent(this.shapeName);
}

abstract class MatchState {}

class ShapeInitial extends MatchState {}

class ShapeSelected extends MatchState {
  final String selectedShape;

  ShapeSelected(this.selectedShape);
}
