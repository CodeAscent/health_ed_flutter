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
  dynamic completedQuiz;

  Data({this.onboardingScore, this.completedQuiz});

  Data.fromJson(Map<String, dynamic> json) {
    onboardingScore = json['onboardingScore'];
    completedQuiz = json['completedQuiz'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['onboardingScore'] = this.onboardingScore;
    data['completedQuiz'] = this.completedQuiz;
    return data;
  }
}
