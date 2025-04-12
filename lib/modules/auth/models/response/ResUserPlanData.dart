class ResUserPlanData {
  bool? success;
  String? message;
  Data? data;

  ResUserPlanData({this.success, this.message, this.data});

  ResUserPlanData.fromJson(Map<String, dynamic> json) {
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
  String? status;
  String? endDate;
  String? startDate;
  String? type;
  Plan? plan;

  Data({this.status, this.endDate, this.startDate, this.type, this.plan});

  Data.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    endDate = json['endDate'];
    startDate = json['startDate'];
    type = json['type'];
    plan = json['plan'] != null ? new Plan.fromJson(json['plan']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['endDate'] = this.endDate;
    data['startDate'] = this.startDate;
    data['type'] = this.type;
    if (this.plan != null) {
      data['plan'] = this.plan!.toJson();
    }
    return data;
  }
}

class Plan {
  String? sId;
  String? name;
  String? description;
  String? duration;
  int? price;
  List<String>? features;
  bool? isActive;
  String? razorpayPlanId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Plan(
      {this.sId,
      this.name,
      this.description,
      this.duration,
      this.price,
      this.features,
      this.isActive,
      this.razorpayPlanId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Plan.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    description = json['description'];
    duration = json['duration'];
    price = json['price'];
    features = json['features'].cast<String>();
    isActive = json['isActive'];
    razorpayPlanId = json['razorpayPlanId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['duration'] = this.duration;
    data['price'] = this.price;
    data['features'] = this.features;
    data['isActive'] = this.isActive;
    data['razorpayPlanId'] = this.razorpayPlanId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}