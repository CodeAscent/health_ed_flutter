class Activity {
  final String name;
  final String status; // "completed", "incomplete", "not_started"
  final String emoji;

  Activity({
    required this.name,
    required this.status,
    required this.emoji,
  });
}
