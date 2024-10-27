import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/Activity.dart';

class ActivityCubit extends Cubit<List<Activity>> {
  ActivityCubit() : super(_initialActivities);

  static List<Activity> get _initialActivities => [
    Activity(name: 'Activity 1', status: 'completed', emoji: '😇'),
    Activity(name: 'Activity 2', status: 'incomplete', emoji: '😕'),
    Activity(name: 'Activity 3', status: 'not_started', emoji: '👉🏼'),
    Activity(name: 'Activity 4', status: 'not_started', emoji: '👉🏼'),
    Activity(name: 'Activity 5', status: 'completed', emoji: '😉'),
    Activity(name: 'Activity 6', status: 'completed', emoji: '😇'),
    Activity(name: 'Activity 7', status: 'not_started', emoji: '👉🏼'),
    Activity(name: 'Activity 8', status: 'not_started', emoji: '👉🏼'),
    Activity(name: 'Activity 2', status: 'incomplete', emoji: '😕'),
    Activity(name: 'Activity 10', status: 'completed', emoji: '😇'),
  ];
}
