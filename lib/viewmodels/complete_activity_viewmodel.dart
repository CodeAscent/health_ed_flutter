import 'package:health_ed_flutter/core/utils/custom_snackbar.dart';
import 'package:health_ed_flutter/models/completed_activity.dart';
import 'package:health_ed_flutter/repositories/complete_activity_repo.dart';

class CompleteActivityViewModel {
  final CompleteActivityRepo _completeActivityRepo = CompleteActivityRepo();

  Future<bool> createCompletedActivity(
      CompletedActivity completedActivity) async {
    try {
      return await _completeActivityRepo
          .createCompletedActivity(completedActivity);
    } catch (e) {
      customSnackbar(e.toString(), ContentType.failure);
      return false;
    }
  }
}
