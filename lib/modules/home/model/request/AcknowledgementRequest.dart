class AcknowledgementRequest {
  final String activity;
  final String? learning;
  final String? learningInstruction;
  final String acknowledgement;
  final int score;

  // Constructor with validation logic
  AcknowledgementRequest({
    required this.activity,
    this.learning,
    this.learningInstruction,
    required this.acknowledgement,
    required this.score,
  }) : assert(
  (learning == null && learningInstruction != null) ||
      (learning != null && learningInstruction == null),
  'Only one of "learning" or "learningInstruction" should be provided.');

  // Convert JSON to model
  factory AcknowledgementRequest.fromJson(Map<String, dynamic> json) {
    return AcknowledgementRequest(
      activity: json['activity'],
      learning: json['learning'],
      learningInstruction: json['learningInstruction'],
      acknowledgement: json['acknowledgement'],
      score: json['score'],
    );
  }

  // Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'activity': activity,
      if (learning != null) 'learning': learning,
      if (learningInstruction != null)
        'learningInstruction': learningInstruction,
      'acknowledgement': acknowledgement,
      'score': score,
    };
  }
}
