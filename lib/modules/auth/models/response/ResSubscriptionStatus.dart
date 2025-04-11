class ResSubscriptionStatus {
  bool? success;
  String? message;
  Data? data;

  ResSubscriptionStatus({this.success, this.message, this.data});

  ResSubscriptionStatus.fromJson(Map<String, dynamic> json) {
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

  Data({this.status, this.endDate, this.startDate, this.type});

  Data.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    endDate = json['endDate'];
    startDate = json['startDate'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['endDate'] = this.endDate;
    data['startDate'] = this.startDate;
    data['type'] = this.type;
    return data;
  }
}