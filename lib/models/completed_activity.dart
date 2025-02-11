class CompletedActivity {
  final String activity;
  final String user;
   int? score;

  CompletedActivity({
    required this.activity,
    required this.user,
     this.score,
  });

  factory CompletedActivity.fromJson(Map<String, dynamic> json) {
    return CompletedActivity(
      activity: json['activity'],
      user: json['user'],
      score: json['score'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activity': activity,
      'user': user,
      if (score != null) 'score': score,
    };
  }
}
