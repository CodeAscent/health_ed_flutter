class AssessmentQuestionResponse {
  bool? success;
  String? message;
  Data? data;

  AssessmentQuestionResponse({this.success, this.message, this.data});

  AssessmentQuestionResponse.fromJson(Map<String, dynamic> json) {
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
  List<Questions>? questions;

  Data({this.questions});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(new Questions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.questions != null) {
      data['questions'] = this.questions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Questions {
  String? sId;
  String? example;
  QuestionText? questionText;
  List<Options>? options;
  int? selectedOption;

  Questions({this.sId, this.questionText, this.options, this.selectedOption});

  Questions.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    example = json['example'];
    questionText = json['questionText'] != null
        ? new QuestionText.fromJson(json['questionText'])
        : null;
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(new Options.fromJson(v));
      });
    }
    selectedOption = json['selectedOption'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['example'] = this.example;
    if (this.questionText != null) {
      data['questionText'] = this.questionText!.toJson();
    }
    if (this.options != null) {
      data['options'] = this.options!.map((v) => v.toJson()).toList();
    }
    data['selectedOption'] = this.selectedOption;
    return data;
  }
}

class QuestionText {
  String? en;
  String? hi;
  String? or;

  QuestionText({this.en, this.hi, this.or});

  QuestionText.fromJson(Map<String, dynamic> json) {
    en = json['en'];
    hi = json['hi'];
    or = json['or'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['en'] = this.en;
    data['hi'] = this.hi;
    data['or'] = this.or;
    return data;
  }
}

class Options {
  String? en;
  String? hi;
  String? or;
  int? margin;

  Options({this.en, this.hi, this.or, this.margin});

  Options.fromJson(Map<String, dynamic> json) {
    en = json['en'];
    hi = json['hi'];
    or = json['or'];
    margin = json['margin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['en'] = this.en;
    data['hi'] = this.hi;
    data['or'] = this.or;
    data['margin'] = this.margin;
    return data;
  }
}