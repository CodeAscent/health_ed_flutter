class VerifyPayOrderReq {
  final String orderId;
  final String paymentId;
  final String razorpaySignature;
  VerifyPayOrderReq({
    required this.orderId,
    required this.paymentId,
    required this.razorpaySignature,
  });

  Map<String, dynamic> toJson() {
    return {
      "razorpay_order_id": orderId,
      "razorpay_payment_id": paymentId,
      "razorpay_signature": razorpaySignature,
    };
  }
}
