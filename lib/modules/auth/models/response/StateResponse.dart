class StateResponse {
  final bool success;
  final String message;
  final List<StateData> data;

  StateResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory StateResponse.fromJson(Map<String, dynamic> json) {
    return StateResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data']['states'] as List?)
              ?.map((x) => StateData.fromJson(x))
              .toList() ??
          [],
    );
  }
}

class StateData {
  final int stateId;
  final String state;

  StateData({
    required this.stateId,
    required this.state,
  });

  factory StateData.fromJson(Map<String, dynamic> json) {
    return StateData(
      stateId: json['stateId'] ?? '',
      state: json['state'] ?? '',
    );
  }
}
