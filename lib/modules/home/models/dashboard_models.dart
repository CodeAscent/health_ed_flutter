class DashboardResponse {
  final bool success;
  final String message;
  final DashboardData data;

  DashboardResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      success: json['success'],
      message: json['message'],
      data: DashboardData.fromJson(json['data']),
    );
  }
}

class DashboardData {
  final Map<String, bool> weeklyStreak;
  final Progress progress;
  final List<RecentQuiz> recentQuizzes;
  final ActivityTypeStats activityTypeStats;
  final WeeklyReport weeklyReport;

  DashboardData({
    required this.weeklyStreak,
    required this.progress,
    required this.recentQuizzes,
    required this.activityTypeStats,
    required this.weeklyReport,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      weeklyStreak: Map<String, bool>.from(json['weeklyStreak']),
      progress: Progress.fromJson(json['progress']),
      recentQuizzes: (json['recentQuizzes'] as List)
          .map((quiz) => RecentQuiz.fromJson(quiz))
          .toList(),
      activityTypeStats: ActivityTypeStats.fromJson(json['activityTypeStats']),
      weeklyReport: WeeklyReport.fromJson(json['weeklyReport']),
    );
  }
}

class Progress {
  final ProgressStats weekly;
  final ProgressStats monthly;

  Progress({required this.weekly, required this.monthly});

  factory Progress.fromJson(Map<String, dynamic> json) {
    return Progress(
      weekly: ProgressStats.fromJson(json['weekly']),
      monthly: ProgressStats.fromJson(json['monthly']),
    );
  }
}

class ProgressStats {
  final int completed;
  final int total;
  final int percentage;
  final int startDayNumber;

  ProgressStats({
    required this.completed,
    required this.total,
    required this.percentage,
    required this.startDayNumber,
  });

  factory ProgressStats.fromJson(Map<String, dynamic> json) {
    return ProgressStats(
      completed: json['completed'],
      total: json['total'],
      percentage: json['percentage'],
      startDayNumber: json['startDayNumber'],
    );
  }
}

class RecentQuiz {
  final int dayNumber;
  final String lastAttempted;
  final int totalActivities;
  final int completedActivities;
  final int progress;

  RecentQuiz({
    required this.dayNumber,
    required this.lastAttempted,
    required this.totalActivities,
    required this.completedActivities,
    required this.progress,
  });

  factory RecentQuiz.fromJson(Map<String, dynamic> json) {
    return RecentQuiz(
      dayNumber: json['dayNumber'],
      lastAttempted: json['lastAttempted'],
      totalActivities: json['totalActivities'],
      completedActivities: json['completedActivities'],
      progress: json['progress'],
    );
  }
}

class ActivityTypeStats {
  final List<ActivityTypeStat> weeklyStats;
  final List<ActivityTypeStat> monthlyStats;
  final List<ActivityTypeStat> overallStats;

  ActivityTypeStats({
    required this.weeklyStats,
    required this.monthlyStats,
    required this.overallStats,
  });

  factory ActivityTypeStats.fromJson(Map<String, dynamic> json) {
    return ActivityTypeStats(
      weeklyStats: (json['weeklyStats'] as List)
          .map((e) => ActivityTypeStat.fromJson(e))
          .toList(),
      monthlyStats: (json['monthlyStats'] as List)
          .map((e) => ActivityTypeStat.fromJson(e))
          .toList(),
      overallStats: (json['overallStats'] as List)
          .map((e) => ActivityTypeStat.fromJson(e))
          .toList(),
    );
  }
}

class ActivityTypeStat {
  final String label;
  final int completed;
  final int total;
  final int percentage;
  final int score;

  ActivityTypeStat(
      {required this.label,
      required this.completed,
      required this.total,
      required this.percentage,
      required this.score});

  factory ActivityTypeStat.fromJson(Map<String, dynamic> json) {
    return ActivityTypeStat(
      label: json['label'],
      completed: json['completed'],
      total: json['total'],
      percentage: json['percentage'],
      score: json['score'],
    );
  }
}

class WeeklyReport {
  final int totalScreenTime;
  final List<DayReport> days;

  WeeklyReport({
    required this.totalScreenTime,
    required this.days,
  });

  factory WeeklyReport.fromJson(Map<String, dynamic> json) {
    return WeeklyReport(
      totalScreenTime: json['totalScreenTime'],
      days:
          (json['days'] as List).map((day) => DayReport.fromJson(day)).toList(),
    );
  }
}

class DayReport {
  final int dayNumber;
  final String date;
  final int totalScreenTime;
  final List<ActivityReport> activities;

  DayReport({
    required this.dayNumber,
    required this.date,
    required this.totalScreenTime,
    required this.activities,
  });

  factory DayReport.fromJson(Map<String, dynamic> json) {
    return DayReport(
      dayNumber: json['dayNumber'],
      date: json['date'],
      totalScreenTime: json['totalScreenTime'],
      activities: (json['activities'] as List)
          .map((activity) => ActivityReport.fromJson(activity))
          .toList(),
    );
  }
}

class ActivityReport {
  final int activityNumber;
  final String status;
  final int screenTime;

  ActivityReport({
    required this.activityNumber,
    required this.status,
    required this.screenTime,
  });

  factory ActivityReport.fromJson(Map<String, dynamic> json) {
    return ActivityReport(
      activityNumber: json['activityNumber'],
      status: json['status'],
      screenTime: json['screenTime'],
    );
  }
}
