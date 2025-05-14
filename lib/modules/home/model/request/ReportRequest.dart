class ReportRequest {
  final String userId;

  ReportRequest({required this.userId});

  factory ReportRequest.fromJson(Map<String, dynamic> json) {
    return ReportRequest(
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
    };
  }
}
