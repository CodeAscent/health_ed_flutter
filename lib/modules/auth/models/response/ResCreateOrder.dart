class ResCreateOrder {
  bool? success;
  String? message;
  Data? data;

  ResCreateOrder({this.success, this.message, this.data});

  ResCreateOrder.fromJson(Map<String, dynamic> json) {
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
  String? orderId;
  int? amount;
  String? currency;
  String? receipt;
  String? key;
  PlanDetails? planDetails;

  Data(
      {this.orderId,
      this.amount,
      this.currency,
      this.receipt,
      this.key,
      this.planDetails});

  Data.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    amount = json['amount'];
    currency = json['currency'];
    receipt = json['receipt'];
    key = json['key'];
    planDetails = json['planDetails'] != null
        ? new PlanDetails.fromJson(json['planDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['amount'] = this.amount;
    data['currency'] = this.currency;
    data['receipt'] = this.receipt;
    data['key'] = this.key;
    if (this.planDetails != null) {
      data['planDetails'] = this.planDetails!.toJson();
    }
    return data;
  }
}

class PlanDetails {
  String? name;
  String? duration;
  List<String>? features;

  PlanDetails({this.name, this.duration, this.features});

  PlanDetails.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    duration = json['duration'];
    features = json['features'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['duration'] = this.duration;
    data['features'] = this.features;
    return data;
  }
}