class ResAllQuestion {
  bool? success;
  String? message;
  Data? data;

  ResAllQuestion({this.success, this.message, this.data});

  ResAllQuestion.fromJson(Map<String, dynamic>? json) {
    success = json?['success'];
    message = json?['message'];
    data = json?['data'] != null ? new Data.fromJson(json?['data']) : null;
  }

  Map<String, dynamic>? toJson() {
    final Map<String, dynamic>? data = new Map<String, dynamic>();
    data?['success'] = this.success;
    data?['message'] = this.message;
    if (this.data != null) {
      data?['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Activity? activity;

  Data({this.activity});

  Data.fromJson(Map<String, dynamic>? json) {
    activity = json?['activity'] != null
        ? new Activity.fromJson(json?['activity'])
        : null;
  }

  Map<String, dynamic>? toJson() {
    final Map<String, dynamic>? data = new Map<String, dynamic>();
    if (this.activity != null) {
      data?['activity'] = this.activity!.toJson();
    }
    return data;
  }
}

class Activity {
  ActivityName? activityName;
  ActivityName? activityDescription;
  ActivityName? activityInstructions;
  Understandings? understandings;
  Matching? matchings;
  PictureUnderstandings? pictureUnderstandings;
  Understandings1? pictureExpressions;
  PictureSequencings? pictureSequencings;
  String? sId;
  String? day;
  int? level;
  int? iV;

  Activity(
      {this.activityName,
        this.activityDescription,
        this.activityInstructions,
        this.understandings,
        this.matchings,
        this.pictureUnderstandings,
        this.pictureExpressions,
        this.pictureSequencings,
        this.sId,
        this.day,
        this.level,
        this.iV});

  Activity.fromJson(Map<String, dynamic>? json) {
    activityName = json?['activityName'] != null
        ? new ActivityName.fromJson(json?['activityName'])
        : null;
    activityDescription = json?['activityDescription'] != null
        ? new ActivityName.fromJson(json?['activityDescription'])
        : null;
    activityInstructions = json?['activityInstructions'] != null
        ? new ActivityName.fromJson(json?['activityInstructions'])
        : null;
    understandings = json?['understandings'] != null
        ? new Understandings.fromJson(json?['understandings'])
        : null;
    matchings = json?['matchings'] != null
        ? new Matching.fromJson(json?['matchings'])
        : null;
    pictureUnderstandings = json?['pictureUnderstandings'] != null
        ? new PictureUnderstandings.fromJson(json?['pictureUnderstandings'])
        : null;
    pictureExpressions = json?['pictureExpressions'] != null
        ? new Understandings1.fromJson(json?['pictureExpressions'])
        : null;
    pictureSequencings = json?['pictureSequencings'] != null
        ? new PictureSequencings.fromJson(json?['pictureSequencings'])
        : null;
    sId = json?['_id'];
    day = json?['day'];
    level = json?['level'];
    iV = json?['__v'];
  }

  Map<String, dynamic>? toJson() {
    final Map<String, dynamic>? data = new Map<String, dynamic>();
    if (this.activityName != null) {
      data?['activityName'] = this.activityName!.toJson();
    }
    if (this.activityDescription != null) {
      data?['activityDescription'] = this.activityDescription!.toJson();
    }
    if (this.activityInstructions != null) {
      data?['activityInstructions'] = this.activityInstructions!.toJson();
    }
    if (this.understandings != null) {
      data?['understandings'] = this.understandings!.toJson();
    }
    if (this.matchings != null) {
      data?['matchings'] = this.matchings!.toJson();
    }
    if (this.pictureUnderstandings != null) {
      data?['pictureUnderstandings'] = this.pictureUnderstandings!.toJson();
    }
    if (this.pictureExpressions != null) {
      data?['pictureExpressions'] = this.pictureExpressions!.toJson();
    }
    if (this.pictureSequencings != null) {
      data?['pictureSequencings'] = this.pictureSequencings!.toJson();
    }
    data?['_id'] = this.sId;
    data?['day'] = this.day;
    data?['level'] = this.level;
    data?['__v'] = this.iV;
    return data;
  }
}

class ActivityName {
  String? en;
  String? hi;
  String? or;

  ActivityName({this.en, this.hi, this.or});

  ActivityName.fromJson(Map<String, dynamic>? json) {
    en = json?['en'];
    hi = json?['hi'];
    or = json?['or'];
  }

  Map<String, dynamic>? toJson() {
    final Map<String, dynamic>? data = new Map<String, dynamic>();
    data?['en'] = this.en;
    data?['hi'] = this.hi;
    data?['or'] = this.or;
    return data;
  }
}

class Understandings {
  List<Learnings>? learnings;
  Instruction? instruction;

  Understandings({this.learnings, this.instruction});

  Understandings.fromJson(Map<String, dynamic>? json) {
    if (json?['learnings'] != null) {
      learnings = <Learnings>[];
      json?['learnings'].forEach((v) {
        learnings!.add(new Learnings.fromJson(v));
      });
    }
    instruction = json?['instruction'] != null
        ? new Instruction.fromJson(json?['instruction'])
        : null;
  }

  Map<String, dynamic>? toJson() {
    final Map<String, dynamic>? data = new Map<String, dynamic>();
    if (this.learnings != null) {
      data?['learnings'] = this.learnings!.map((v) => v.toJson()).toList();
    }
    if (this.instruction != null) {
      data?['instruction'] = this.instruction!.toJson();
    }
    return data;
  }
}

class Understandings1 {
  List<Learnings1>? learnings;
  Learnings1? instruction;

  Understandings1({this.learnings, this.instruction});

  Understandings1.fromJson(Map<String, dynamic>? json) {
    if (json?['learnings'] != null) {
      learnings = <Learnings1>[];
      json?['learnings'].forEach((v) {
        learnings!.add(new Learnings1.fromJson(v));
      });
    }
    instruction = json?['instruction'] != null
        ? new Learnings1.fromJson(json?['instruction'])
        : null;
  }

  Map<String, dynamic>? toJson() {
    final Map<String, dynamic>? data = new Map<String, dynamic>();
    if (this.learnings != null) {
      data?['learnings'] = this.learnings!.map((v) => v.toJson()).toList();
    }
    if (this.instruction != null) {
      data?['instruction'] = this.instruction!.toJson();
    }
    return data;
  }
}

class Matching {
  List<Learnings3>? learnings;
  Learnings3? instruction;

  Matching({this.learnings, this.instruction});

  Matching.fromJson(Map<String, dynamic>? json) {
    if (json?['learnings'] != null) {
      learnings = <Learnings3>[];
      json?['learnings'].forEach((v) {
        learnings!.add(new Learnings3.fromJson(v));
      });
    }
    instruction = json?['instruction'] != null
        ? new Learnings3.fromJson(json?['instruction'])
        : null;
  }

  Map<String, dynamic>? toJson() {
    final Map<String, dynamic>? data = new Map<String, dynamic>();
    if (this.learnings != null) {
      data?['learnings'] = this.learnings!.map((v) => v.toJson()).toList();
    }
    if (this.instruction != null) {
      data?['instruction'] = this.instruction!.toJson();
    }
    return data;
  }
}

class Learnings {
  ActivityName? title;
  String? sId;
  int? level;
  String? createdBy;
  String? type;
  List<Media>? media;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Learnings(
      {this.title,
        this.sId,
        this.level,
        this.createdBy,
        this.type,
        this.media,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Learnings.fromJson(Map<String, dynamic>? json) {
    title =
    json?['title'] != null ? new ActivityName.fromJson(json?['title']) : null;
    sId = json?['_id'];
    level = json?['level'];
    createdBy = json?['createdBy'];
    type = json?['type'];
    if (json?['media'] != null) {
      media = <Media>[];
      json?['media'].forEach((v) {
        media!.add(new Media.fromJson(v));
      });
    }
    createdAt = json?['createdAt'];
    updatedAt = json?['updatedAt'];
    iV = json?['__v'];
  }

  Map<String, dynamic>? toJson() {
    final Map<String, dynamic>? data = new Map<String, dynamic>();
    if (this.title != null) {
      data?['title'] = this.title!.toJson();
    }
    data?['_id'] = this.sId;
    data?['level'] = this.level;
    data?['createdBy'] = this.createdBy;
    data?['type'] = this.type;
    if (this.media != null) {
      data?['media'] = this.media!.map((v) => v.toJson()).toList();
    }
    data?['createdAt'] = this.createdAt;
    data?['updatedAt'] = this.updatedAt;
    data?['__v'] = this.iV;
    return data;
  }
}

class Media {
  String? url;
  String? type;
  String? sId;

  Media({this.url, this.type, this.sId});

  Media.fromJson(Map<String, dynamic>? json) {
    url = json?['url'];
    type = json?['type'];
    sId = json?['_id'];
  }

  Map<String, dynamic>? toJson() {
    final Map<String, dynamic>? data = new Map<String, dynamic>();
    data?['url'] = this.url;
    data?['type'] = this.type;
    data?['_id'] = this.sId;
    return data;
  }
}

class Instruction {
  ActivityName? body;
  ActivityName? title;
  String? sId;
  String? createdBy;
  String? type;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Instruction(
      {this.body,
        this.title,
        this.sId,
        this.createdBy,
        this.type,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Instruction.fromJson(Map<String, dynamic>? json) {
    body =
    json?['body'] != null ? new ActivityName.fromJson(json?['body']) : null;
    title =
    json?['title'] != null ? new ActivityName.fromJson(json?['title']) : null;
    sId = json?['_id'];
    createdBy = json?['createdBy'];
    type = json?['type'];
    createdAt = json?['createdAt'];
    updatedAt = json?['updatedAt'];
    iV = json?['__v'];
  }

  Map<String, dynamic>? toJson() {
    final Map<String, dynamic>? data = new Map<String, dynamic>();
    if (this.body != null) {
      data?['body'] = this.body!.toJson();
    }
    if (this.title != null) {
      data?['title'] = this.title!.toJson();
    }
    data?['_id'] = this.sId;
    data?['createdBy'] = this.createdBy;
    data?['type'] = this.type;
    data?['createdAt'] = this.createdAt;
    data?['updatedAt'] = this.updatedAt;
    data?['__v'] = this.iV;
    return data;
  }
}

class Learnings3 {
  ActivityName? title;
  String? sId;
  int? level;
  String? type;
  List<MatchingQuestions>? matchingQuestions;
  List<MatchingQuestions>? matchingAnswers;
  String? direction;
  bool? drag;
  String? matchType;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Learnings3(
      {this.title,
        this.sId,
        this.level,
        this.type,
        this.matchingQuestions,
        this.matchingAnswers,
        this.direction,
        this.drag,
        this.matchType,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Learnings3.fromJson(Map<String, dynamic>? json) {
    title =
    json?['title'] != null ? new ActivityName.fromJson(json?['title']) : null;
    sId = json?['_id'];
    level = json?['level'];
    type = json?['type'];
    if (json?['matchingQuestions'] != null) {
      matchingQuestions = <MatchingQuestions>[];
      json?['matchingQuestions'].forEach((v) {
        matchingQuestions!.add(new MatchingQuestions.fromJson(v));
      });
    }
    if (json?['matchingAnswers'] != null) {
      matchingAnswers = <MatchingQuestions>[];
      json?['matchingAnswers'].forEach((v) {
        matchingAnswers!.add(new MatchingQuestions.fromJson(v));
      });
    }
    direction = json?['direction'];
    drag = json?['drag'];
    matchType = json?['matchType'];
    createdAt = json?['createdAt'];
    updatedAt = json?['updatedAt'];
    iV = json?['__v'];
  }

  Map<String, dynamic>? toJson() {
    final Map<String, dynamic>? data = new Map<String, dynamic>();
    if (this.title != null) {
      data?['title'] = this.title!.toJson();
    }
    data?['_id'] = this.sId;
    data?['level'] = this.level;
    data?['type'] = this.type;
    if (this.matchingQuestions != null) {
      data?['matchingQuestions'] =
          this.matchingQuestions!.map((v) => v.toJson()).toList();
    }
    if (this.matchingAnswers != null) {
      data?['matchingAnswers'] =
          this.matchingAnswers!.map((v) => v.toJson()).toList();
    }
    data?['direction'] = this.direction;
    data?['drag'] = this.drag;
    data?['matchType'] = this.matchType;
    data?['createdAt'] = this.createdAt;
    data?['updatedAt'] = this.updatedAt;
    data?['__v'] = this.iV;
    return data;
  }
}

class MatchingQuestions {
  String? image;
  int? correctIndex;
  String? sId;

  MatchingQuestions({this.image, this.correctIndex, this.sId});

  MatchingQuestions.fromJson(Map<String, dynamic>? json) {
    image = json?['image'];
    correctIndex = json?['correctIndex'];
    sId = json?['_id'];
  }

  Map<String, dynamic>? toJson() {
    final Map<String, dynamic>? data = new Map<String, dynamic>();
    data?['image'] = this.image;
    data?['correctIndex'] = this.correctIndex;
    data?['_id'] = this.sId;
    return data;
  }
}

class Instruction1 {
  ActivityName? title;
  String? sId;
  String? createdBy;
  String? type;
  List<MatchingQuestions>? matchingQuestions;
  List<MatchingQuestions>? matchingAnswers;
  String? direction;
  bool? drag;
  String? matchType;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Instruction1(
      {this.title,
        this.sId,
        this.createdBy,
        this.type,
        this.matchingQuestions,
        this.matchingAnswers,
        this.direction,
        this.drag,
        this.matchType,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Instruction1.fromJson(Map<String, dynamic>? json) {
    title =
    json?['title'] != null ? new ActivityName.fromJson(json?['title']) : null;
    sId = json?['_id'];
    createdBy = json?['createdBy'];
    type = json?['type'];
    if (json?['matchingQuestions'] != null) {
      matchingQuestions = <MatchingQuestions>[];
      json?['matchingQuestions'].forEach((v) {
        matchingQuestions!.add(new MatchingQuestions.fromJson(v));
      });
    }
    if (json?['matchingAnswers'] != null) {
      matchingAnswers = <MatchingQuestions>[];
      json?['matchingAnswers'].forEach((v) {
        matchingAnswers!.add(new MatchingQuestions.fromJson(v));
      });
    }
    direction = json?['direction'];
    drag = json?['drag'];
    matchType = json?['matchType'];
    createdAt = json?['createdAt'];
    updatedAt = json?['updatedAt'];
    iV = json?['__v'];
  }

  Map<String, dynamic>? toJson() {
    final Map<String, dynamic>? data = new Map<String, dynamic>();
    if (this.title != null) {
      data?['title'] = this.title!.toJson();
    }
    data?['_id'] = this.sId;
    data?['createdBy'] = this.createdBy;
    data?['type'] = this.type;
    if (this.matchingQuestions != null) {
      data?['matchingQuestions'] =
          this.matchingQuestions!.map((v) => v.toJson()).toList();
    }
    if (this.matchingAnswers != null) {
      data?['matchingAnswers'] =
          this.matchingAnswers!.map((v) => v.toJson()).toList();
    }
    data?['direction'] = this.direction;
    data?['drag'] = this.drag;
    data?['matchType'] = this.matchType;
    data?['createdAt'] = this.createdAt;
    data?['updatedAt'] = this.updatedAt;
    data?['__v'] = this.iV;
    return data;
  }
}
class PictureSequencings {
  List<Instruction2>? learnings;
  Instruction2? instruction;

  PictureSequencings({this.learnings, this.instruction});

  PictureSequencings.fromJson(Map<String, dynamic>? json) {
    if (json?['learnings'] != null) {
      learnings = <Instruction2>[];
      json?['learnings'].forEach((v) {
        learnings!.add(new Instruction2.fromJson(v));
      });
    }
    instruction = json?['instruction'] != null
        ? new Instruction2.fromJson(json?['instruction'])
        : null;
  }

  Map<String, dynamic>? toJson() {
    final Map<String, dynamic>? data = new Map<String, dynamic>();
    if (this.learnings != null) {
      data?['learnings'] = this.learnings!.map((v) => v.toJson()).toList();
    }
    if (this.instruction != null) {
      data?['instruction'] = this.instruction!.toJson();
    }
    return data;
  }
}


class PictureUnderstandings {
  List<Learnings1>? learnings;
  Instruction? instruction;

  PictureUnderstandings({this.learnings, this.instruction});

  PictureUnderstandings.fromJson(Map<String, dynamic>? json) {
    if (json?['learnings'] != null) {
      learnings = <Learnings1>[];
      json?['learnings'].forEach((v) {
        learnings!.add(new Learnings1.fromJson(v));
      });
    }
    instruction = json?['instruction'] != null
        ? new Instruction.fromJson(json?['instruction'])
        : null;
  }

  Map<String, dynamic>? toJson() {
    final Map<String, dynamic>? data = new Map<String, dynamic>();
    if (this.learnings != null) {
      data?['learnings'] = this.learnings!.map((v) => v.toJson()).toList();
    }
    if (this.instruction != null) {
      data?['instruction'] = this.instruction!.toJson();
    }
    return data;
  }
}

class Learnings1 {
  Media1? media;
  ActivityName? title;
  String? sId;
  String? createdBy;
  String? type;
  String? subType;
  List<Options>? options;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Learnings1(
      {this.media,
        this.title,
        this.sId,
        this.createdBy,
        this.type,
        this.subType,
        this.options,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Learnings1.fromJson(Map<String, dynamic>? json) {
    media = json?['media'] != null ? new Media1.fromJson(json?['media']) : null;
    title =
    json?['title'] != null ? new ActivityName.fromJson(json?['title']) : null;
    sId = json?['_id'];
    createdBy = json?['createdBy'];
    type = json?['type'];
    subType = json?['subType'];
    if (json?['options'] != null) {
      options = <Options>[];
      json?['options'].forEach((v) {
        options!.add(new Options.fromJson(v));
      });
    }
    createdAt = json?['createdAt'];
    updatedAt = json?['updatedAt'];
    iV = json?['__v'];
  }

  Map<String, dynamic>? toJson() {
    final Map<String, dynamic>? data = new Map<String, dynamic>();
    if (this.media != null) {
      data?['media'] = this.media!.toJson();
    }
    if (this.title != null) {
      data?['title'] = this.title!.toJson();
    }
    data?['_id'] = this.sId;
    data?['createdBy'] = this.createdBy;
    data?['type'] = this.type;
    data?['subType'] = this.subType;
    if (this.options != null) {
      data?['options'] = this.options!.map((v) => v.toJson()).toList();
    }
    data?['createdAt'] = this.createdAt;
    data?['updatedAt'] = this.updatedAt;
    data?['__v'] = this.iV;
    return data;
  }
}

class Media1 {
  String? url;
  String? type;

  Media1({this.url, this.type});

  Media1.fromJson(Map<String, dynamic>? json) {
    url = json?['url'];
    type = json?['type'];
  }

  Map<String, dynamic>? toJson() {
    final Map<String, dynamic>? data = new Map<String, dynamic>();
    data?['url'] = this.url;
    data?['type'] = this.type;
    return data;
  }
}

class Options {
  ActivityName? option;
  bool? correct;
  String? sId;

  Options({this.option, this.correct, this.sId});

  Options.fromJson(Map<String, dynamic>? json) {
    option = json?['option'] != null
        ? new ActivityName.fromJson(json?['option'])
        : null;
    correct = json?['correct'];
    sId = json?['_id'];
  }

  Map<String, dynamic>? toJson() {
    final Map<String, dynamic>? data = new Map<String, dynamic>();
    if (this.option != null) {
      data?['option'] = this.option!.toJson();
    }
    data?['correct'] = this.correct;
    data?['_id'] = this.sId;
    return data;
  }
}

class Instruction2 {
  ActivityName? title;
  String? sId;
  String? createdBy;
  String? type;
  List<SequenceImages>? sequenceImages;
  List<SequenceAudios>? sequenceAudios;
  bool? drag;
  String? direction;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Instruction2(
      {this.title,
        this.sId,
        this.createdBy,
        this.type,
        this.sequenceImages,
        this.sequenceAudios,
        this.drag,
        this.direction,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Instruction2.fromJson(Map<String, dynamic>? json) {
    title =
    json?['title'] != null ? new ActivityName.fromJson(json?['title']) : null;
    sId = json?['_id'];
    createdBy = json?['createdBy'];
    type = json?['type'];
    if (json?['sequenceImages'] != null) {
      sequenceImages = <SequenceImages>[];
      json?['sequenceImages'].forEach((v) {
        sequenceImages!.add(new SequenceImages.fromJson(v));
      });
    }
    if (json?['sequenceAudios'] != null) {
      sequenceAudios = <SequenceAudios>[];
      json?['sequenceAudios'].forEach((v) {
        sequenceAudios!.add(new SequenceAudios.fromJson(v));
      });
    }
    drag = json?['drag'];
    direction = json?['direction'];
    createdAt = json?['createdAt'];
    updatedAt = json?['updatedAt'];
    iV = json?['__v'];
  }

  Map<String, dynamic>? toJson() {
    final Map<String, dynamic>? data = new Map<String, dynamic>();
    if (this.title != null) {
      data?['title'] = this.title!.toJson();
    }
    data?['_id'] = this.sId;
    data?['createdBy'] = this.createdBy;
    data?['type'] = this.type;
    if (this.sequenceImages != null) {
      data?['sequenceImages'] =
          this.sequenceImages!.map((v) => v.toJson()).toList();
    }
    if (this.sequenceAudios != null) {
      data?['sequenceAudios'] =
          this.sequenceAudios!.map((v) => v.toJson()).toList();
    }
    data?['drag'] = this.drag;
    data?['direction'] = this.direction;
    data?['createdAt'] = this.createdAt;
    data?['updatedAt'] = this.updatedAt;
    data?['__v'] = this.iV;
    return data;
  }
}

class SequenceAudios {
  String? audio;
  int? correctIndex;
  String? sId;

  SequenceAudios({this.audio, this.correctIndex, this.sId});

  SequenceAudios.fromJson(Map<String, dynamic>? json) {
    audio = json?['audio'];
    correctIndex = json?['correctIndex'];
    sId = json?['_id'];
  }

  Map<String, dynamic>? toJson() {
    final Map<String, dynamic>? data = new Map<String, dynamic>();
    data?['audio'] = this.audio;
    data?['correctIndex'] = this.correctIndex;
    data?['_id'] = this.sId;
    return data;
  }
}

class SequenceImages {
  String? image;
  int? correctIndex;
  String? sId;

  SequenceImages({this.image, this.correctIndex, this.sId});

  SequenceImages.fromJson(Map<String, dynamic>? json) {
    image = json?['image'];
    correctIndex = json?['correctIndex'];
    sId = json?['_id'];
  }

  Map<String, dynamic>? toJson() {
    final Map<String, dynamic>? data = new Map<String, dynamic>();
    data?['audio'] = this.image;
    data?['correctIndex'] = this.correctIndex;
    data?['_id'] = this.sId;
    return data;
  }
}