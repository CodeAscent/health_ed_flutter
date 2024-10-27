// Bloc Events
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class DragEvent {
  const DragEvent();
}

class DragAccepted extends DragEvent {
  final String shape;

  DragAccepted(this.shape);
}

class DragState {
  final List<String> matchedShapes;

  DragState({this.matchedShapes = const []});
}

class DragBloc extends Bloc<DragEvent, DragState> {
  DragBloc() : super(DragState());

  @override
  Stream<DragState> mapEventToState(DragEvent event) async* {
    if (event is DragAccepted) {
      yield DragState(
        matchedShapes: List.from(state.matchedShapes)..add(event.shape),
      );
    }
  }
}

