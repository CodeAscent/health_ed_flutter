class CreatePayOrderReq {
  final String planId;
  CreatePayOrderReq({
    required this.planId,
  });

  Map<String, dynamic> toJson() {
    return {
      "planId": planId,
    };
  }
}
