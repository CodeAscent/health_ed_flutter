class SubmitQuestionRequest {
  List<Answers>? answers;
  String? userId;

  SubmitQuestionRequest({this.answers, this.userId});

  SubmitQuestionRequest.fromJson(Map<String, dynamic> json) {
    if (json['answers'] != null) {
      answers = <Answers>[];
      json['answers'].forEach((v) {
        answers!.add(Answers.fromJson(v));
      });
    }
    userId = json['userId']; 
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (answers != null) {
      data['answers'] = answers!.map((v) => v.toJson()).toList();
    }
    data['userId'] = userId;
    return data;
  }
}


class Answers {
  String? questionId;
  int? selectedOptionIndex;

  Answers({this.questionId, this.selectedOptionIndex});

  Answers.fromJson(Map<String, dynamic> json) {
    questionId = json['questionId'];
    selectedOptionIndex = json['selectedOptionIndex'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['questionId'] = this.questionId;
    data['selectedOptionIndex'] = this.selectedOptionIndex;
    return data;
  }
}