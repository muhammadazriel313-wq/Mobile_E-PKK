class DetailLaporanResponse {
  final int statusCode;
  final String message;
  final Map<String, dynamic>? data;
  final String? error;

  DetailLaporanResponse({
    required this.statusCode,
    required this.message,
    this.data,
    this.error,
  });

  factory DetailLaporanResponse.fromJson(Map<String, dynamic> json) {
    return DetailLaporanResponse(
      statusCode: json['statusCode'] ?? 500,
      message: json['message'] ?? 'Unknown error',
      data: json['data'] != null ? Map<String, dynamic>.from(json['data']) : null,
      error: json['error'] != null ? json['error']['message'] : null,
    );
  }
}