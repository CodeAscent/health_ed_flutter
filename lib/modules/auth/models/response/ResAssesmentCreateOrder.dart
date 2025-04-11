class ResAssesmentCreateOrder {
  bool? success;
  String? message;
  Data? data;

  ResAssesmentCreateOrder({this.success, this.message, this.data});

  ResAssesmentCreateOrder.fromJson(Map<String, dynamic> json) {
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

  Data({this.orderId, this.amount, this.currency, this.receipt, this.key});

  Data.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    amount = json['amount'];
    currency = json['currency'];
    receipt = json['receipt'];
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['amount'] = this.amount;
    data['currency'] = this.currency;
    data['receipt'] = this.receipt;
    data['key'] = this.key;
    return data;
  }
}