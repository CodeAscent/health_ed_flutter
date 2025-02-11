class CityResponse {
  final bool success;
  final String message;
  final List<CityData> data;

  CityResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CityResponse.fromJson(Map<String, dynamic> json) {
    return CityResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data']['cities'] as List?)
              ?.map((x) => CityData.fromJson(x))
              .toList() ??
          [],
    );
  }
}

class CityData {
  final String city;

  CityData({
    required this.city,
  });

  factory CityData.fromJson(Map<String, dynamic> json) {
    return CityData(
      city: json['city'] ?? '',
    );
  }
}
