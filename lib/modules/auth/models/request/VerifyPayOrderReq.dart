class VerifyPayOrderReq {
  final String orderId;
  final String paymentId;
  final String razorpaySignature;
  final String? subscriptionId; // Made optional

  VerifyPayOrderReq({
    required this.orderId,
    required this.paymentId,
    required this.razorpaySignature,
    this.subscriptionId,
  });

  Map<String, dynamic> toJson() {
    final data = {
      "razorpay_order_id": orderId,
      "razorpay_payment_id": paymentId,
      "razorpay_signature": razorpaySignature,
    };

    if (subscriptionId != null) {
      data["subscriptionId"] = subscriptionId!;
    }

    return data;
  }
}
