// slider_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import 'nextpage_event.dart';

class SliderBloc extends Bloc<SliderEvent, SliderState> {
  SliderBloc() : super(PageChangedState(0)) {
    on<NextPageEvent>((event, emit) {
      if (state.pageIndex < 2) {
        emit(PageChangedState(state.pageIndex + 1));
      }
    });
  }
}
