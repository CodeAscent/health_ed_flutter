class SubmitQuestionResponse {
  bool? success;
  String? message;
  Data? data;

  SubmitQuestionResponse({this.success, this.message, this.data});

  SubmitQuestionResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? onboardingScore;

  Data({this.onboardingScore});

  Data.fromJson(Map<String, dynamic> json) {
    onboardingScore = json['onboardingScore'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['onboardingScore'] = this.onboardingScore;
    return data;
  }
}