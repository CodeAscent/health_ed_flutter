class AllActivityResponse {
  bool? success;
  String? message;
  Data? data;

  AllActivityResponse({this.success, this.message, this.data});

  AllActivityResponse.fromJson(Map<String, dynamic> json) {
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
  List<Activities>? activities;

  Data({this.activities});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['activities'] != null) {
      activities = <Activities>[];
      json['activities'].forEach((v) {
        activities!.add(new Activities.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.activities != null) {
      data['activities'] = this.activities!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Activities {
  ActivityName? activityName;
  ActivityName? activityDescription;
  ActivityName? activityInstructions;
  String? sId;
  String? progress;
  String? status;

  Activities(
      {this.activityName,
        this.activityDescription,
        this.activityInstructions,
        this.sId,
        this.progress,
        this.status});

  Activities.fromJson(Map<String, dynamic> json) {
    activityName = json['activityName'] != null
        ? new ActivityName.fromJson(json['activityName'])
        : null;
    activityDescription = json['activityDescription'] != null
        ? new ActivityName.fromJson(json['activityDescription'])
        : null;
    activityInstructions = json['activityInstructions'] != null
        ? new ActivityName.fromJson(json['activityInstructions'])
        : null;
    sId = json['_id'];
    progress = json['progress'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.activityName != null) {
      data['activityName'] = this.activityName!.toJson();
    }
    if (this.activityDescription != null) {
      data['activityDescription'] = this.activityDescription!.toJson();
    }
    if (this.activityInstructions != null) {
      data['activityInstructions'] = this.activityInstructions!.toJson();
    }
    data['_id'] = this.sId;
    data['progress'] = this.progress;
    data['status'] = this.status;
    return data;
  }
}

class ActivityName {
  String? en;
  String? hi;
  String? or;

  ActivityName({this.en, this.hi, this.or});

  ActivityName.fromJson(Map<String, dynamic> json) {
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