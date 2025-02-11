import 'package:health_ed_flutter/core/services/api_urls.dart';
import 'package:health_ed_flutter/core/services/http_wrapper.dart';
import 'package:health_ed_flutter/models/completed_activity.dart';

class CompleteActivityRepo {
  Future<bool> createCompletedActivity(
      CompletedActivity completedActivity) async {
    try {
      final res = await HttpWrapper.postRequest(
        ApiUrls.completed_activity,
        completedActivity.toJson(),
      );
      if (res.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }
}
