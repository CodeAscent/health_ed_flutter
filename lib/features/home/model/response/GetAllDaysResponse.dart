class GetAllDaysResponse {
  bool? success;
  String? message;
  Data? data;

  GetAllDaysResponse({this.success, this.message, this.data});

  GetAllDaysResponse.fromJson(Map<String, dynamic> json) {
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
  List<Days>? days;

  Data({this.days});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['days'] != null) {
      days = <Days>[];
      json['days'].forEach((v) {
        days!.add(new Days.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.days != null) {
      data['days'] = this.days!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Days {
  String? sId;
  int? dayNumber;
  int? progress;
  bool? locked;

  Days({this.sId, this.dayNumber});

  Days.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    dayNumber = json['dayNumber'];
    progress = json['progress'];
    locked = json['locked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['dayNumber'] = this.dayNumber;
    data['progress'] = this.progress;
    data['locked'] = this.locked;
    return data;
  }
}