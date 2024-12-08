class ResAllQuestion {
  bool? success;
  String? message;
  Data? data;

  ResAllQuestion({this.success, this.message, this.data});

  ResAllQuestion.fromJson(Map<String, dynamic> json) {
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
  List<Understanding>? understanding;
  List<Learning>? learning;

  Data({this.understanding, this.learning});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['understanding'] != null) {
      understanding = <Understanding>[];
      json['understanding'].forEach((v) {
        understanding!.add(new Understanding.fromJson(v));
      });
    }
    if (json['learning'] != null) {
      learning = <Learning>[];
      json['learning'].forEach((v) {
        learning!.add(new Learning.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.understanding != null) {
      data['understanding'] =
          this.understanding!.map((v) => v.toJson()).toList();
    }
    if (this.learning != null) {
      data['learning'] = this.learning!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Understanding {
  String? sId;
  String? questionType;
  int? level;
  Title? title;
  List<Media>? media;
  int? iV;

  Understanding(
      {this.sId,
        this.questionType,
        this.level,
        this.title,
        this.media,
        this.iV});

  Understanding.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    questionType = json['questionType'];
    level = json['level'];
    title = json['title'] != null ? new Title.fromJson(json['title']) : null;
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(new Media.fromJson(v));
      });
    }
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['questionType'] = this.questionType;
    data['level'] = this.level;
    if (this.title != null) {
      data['title'] = this.title!.toJson();
    }
    if (this.media != null) {
      data['media'] = this.media!.map((v) => v.toJson()).toList();
    }
    data['__v'] = this.iV;
    return data;
  }
}

class Title {
  String? en;
  String? hi;
  String? or;

  Title({this.en, this.hi, this.or});

  Title.fromJson(Map<String, dynamic> json) {
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

class Media {
  String? url;
  String? type;
  String? sId;

  Media({this.url, this.type, this.sId});

  Media.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    type = json['type'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['type'] = this.type;
    data['_id'] = this.sId;
    return data;
  }
}

class Learning {
  String? sId;
  String? questionType;
  int? level;
  Title? title;
  String? type;
  List<Media>? media;
  List<Options>? options;
  Title? answer;
  int? iV;
  List<MatchingQuestions>? matchingQuestions;
  List<MatchingQuestions>? matchingAnswers;
  String? direction;
  bool? drag;

  Learning(
      {this.sId,
        this.questionType,
        this.level,
        this.title,
        this.type,
        this.media,
        this.options,
        this.answer,
        this.iV,
        this.matchingQuestions,
        this.matchingAnswers,
        this.direction,
        this.drag});

  Learning.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    questionType = json['questionType'];
    level = json['level'];
    title = json['title'] != null ? new Title.fromJson(json['title']) : null;
    type = json['type'];
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(new Media.fromJson(v));
      });
    }
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(new Options.fromJson(v));
      });
    }
    answer = json['answer'] != null ? new Title.fromJson(json['answer']) : null;
    iV = json['__v'];
    if (json['matchingQuestions'] != null) {
      matchingQuestions = <MatchingQuestions>[];
      json['matchingQuestions'].forEach((v) {
        matchingQuestions!.add(new MatchingQuestions.fromJson(v));
      });
    }
    if (json['matchingAnswers'] != null) {
      matchingAnswers = <MatchingQuestions>[];
      json['matchingAnswers'].forEach((v) {
        matchingAnswers!.add(new MatchingQuestions.fromJson(v));
      });
    }
    direction = json['direction'];
    drag = json['drag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['questionType'] = this.questionType;
    data['level'] = this.level;
    if (this.title != null) {
      data['title'] = this.title!.toJson();
    }
    data['type'] = this.type;
    if (this.media != null) {
      data['media'] = this.media!.map((v) => v.toJson()).toList();
    }
    if (this.options != null) {
      data['options'] = this.options!.map((v) => v.toJson()).toList();
    }
    if (this.answer != null) {
      data['answer'] = this.answer!.toJson();
    }
    data['__v'] = this.iV;
    if (this.matchingQuestions != null) {
      data['matchingQuestions'] =
          this.matchingQuestions!.map((v) => v.toJson()).toList();
    }
    if (this.matchingAnswers != null) {
      data['matchingAnswers'] =
          this.matchingAnswers!.map((v) => v.toJson()).toList();
    }
    data['direction'] = this.direction;
    data['drag'] = this.drag;
    return data;
  }
}

class Options {
  String? en;
  String? hi;
  String? or;
  String? sId;

  Options({this.en, this.hi, this.or, this.sId});

  Options.fromJson(Map<String, dynamic> json) {
    en = json['en'];
    hi = json['hi'];
    or = json['or'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['en'] = this.en;
    data['hi'] = this.hi;
    data['or'] = this.or;
    data['_id'] = this.sId;
    return data;
  }
}

class MatchingQuestions {
  String? image;
  int? index;
  String? sId;

  MatchingQuestions({this.image, this.index, this.sId});

  MatchingQuestions.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    index = json['index'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['index'] = this.index;
    data['_id'] = this.sId;
    return data;
  }
}