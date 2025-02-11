// bottom_navigation_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

enum BottomNavItem { home, search, notifications, messages, profile }

class BottomNavigationCubit extends Cubit<BottomNavItem> {
  BottomNavigationCubit() : super(BottomNavItem.home);

  void updateNavItem(BottomNavItem item) {
    emit(item);
  }
}
