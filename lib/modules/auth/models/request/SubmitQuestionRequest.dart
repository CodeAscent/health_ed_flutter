class SubmitQuestionRequest {
  List<Answers>? answers;

  SubmitQuestionRequest({this.answers});

  SubmitQuestionRequest.fromJson(Map<String, dynamic> json) {
    if (json['answers'] != null) {
      answers = <Answers>[];
      json['answers'].forEach((v) {
        answers!.add(new Answers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.answers != null) {
      data['answers'] = this.answers!.map((v) => v.toJson()).toList();
    }
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