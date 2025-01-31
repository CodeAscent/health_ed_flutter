class ResUserAcknowledgement {
  bool? success;
  String? message;
  Data? data;

  ResUserAcknowledgement({this.success, this.message, this.data});

  ResUserAcknowledgement.fromJson(Map<String, dynamic> json) {
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
  UserAcknowledgement? userAcknowledgement;

  Data({this.userAcknowledgement});

  Data.fromJson(Map<String, dynamic> json) {
    userAcknowledgement = json['userAcknowledgement'] != null
        ? new UserAcknowledgement.fromJson(json['userAcknowledgement'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userAcknowledgement != null) {
      data['userAcknowledgement'] = this.userAcknowledgement!.toJson();
    }
    return data;
  }
}

class UserAcknowledgement {
  String? user;
  String? activity;
  String? learning;
  String? acknowledgement;
  int? score;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  UserAcknowledgement(
      {this.user,
        this.activity,
        this.learning,
        this.acknowledgement,
        this.score,
        this.sId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  UserAcknowledgement.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    activity = json['activity'];
    learning = json['learning'];
    acknowledgement = json['acknowledgement'];
    score = json['score'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user'] = this.user;
    data['activity'] = this.activity;
    data['learning'] = this.learning;
    data['acknowledgement'] = this.acknowledgement;
    data['score'] = this.score;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}