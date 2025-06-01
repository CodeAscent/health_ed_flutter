class ResFeedback {
  final bool success;
  final FeedbackData? data;

  ResFeedback({
    required this.success,
    this.data,
  });

  factory ResFeedback.fromJson(Map<String, dynamic> json) {
    return ResFeedback(
      success: json['success'] ?? false,
      data: json['data'] != null ? FeedbackData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.toJson(),
    };
  }
}

class FeedbackData {
  final String? message;
  final String? userId;
  final String? status;
  final String? id;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  FeedbackData({
    this.message,
    this.userId,
    this.status,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory FeedbackData.fromJson(Map<String, dynamic> json) {
    return FeedbackData(
      message: json['message'],
      userId: json['userId'],
      status: json['status'],
      id: json['_id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'userId': userId,
      'status': status,
      '_id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}
