class AllPlanResponse {
  bool? success;
  String? message;
  List<PlanData>? data;

  AllPlanResponse({this.success, this.message, this.data});

  AllPlanResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <PlanData>[];
      json['data'].forEach((v) {
        data!.add(new PlanData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PlanData {
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

  PlanData(
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

  PlanData.fromJson(Map<String, dynamic> json) {
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