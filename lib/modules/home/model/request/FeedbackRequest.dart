class FeedbackRequest {
  final String message;

  FeedbackRequest({
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }

  factory FeedbackRequest.fromJson(Map<String, dynamic> json) {
    return FeedbackRequest(
      message: json['message'] as String,
    );
  }
}
