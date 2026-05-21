class RiwayatResponse {
  final int statusCode;
  final String message;
  final List<Laporan> data;
  final ErrorMessage? error;

  RiwayatResponse({
    required this.statusCode,
    required this.message,
    required this.data,
    this.error,
  });

  factory RiwayatResponse.fromJson(Map<String, dynamic> json) {
    return RiwayatResponse(
      statusCode: json['statusCode'] ?? 500,
      message: json['message'] ?? 'Unknown error',
      data: (json['data'] as List<dynamic>)
          .map((e) => Laporan.fromJson(e))
          .toList(),
      error: json['error'] != null
          ? ErrorMessage.fromJson(json['error'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
      'error': error?.toJson(),
    };
  }
}

class Laporan {
  final String uuid;
  final int idUser;
  final String status;
  final DateTime createdAt;
  final int idRole;
  final int idOrganization;

  Laporan({
    required this.uuid,
    required this.idUser,
    required this.status,
    required this.createdAt,
    required this.idRole,
    required this.idOrganization,
  });

  factory Laporan.fromJson(Map<String, dynamic> json) {
    return Laporan(
      uuid: json['uuid'] ?? '',
      idUser: json['id_user'] ?? 0,
      status: json['status'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      idRole: json['id_role'] ?? 0,
      idOrganization: json['id_organization'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'id_user': idUser,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'id_role': idRole,
      'id_organization': idOrganization,
    };
  }
}

class ErrorMessage {
  final String message;

  ErrorMessage({required this.message});

  factory ErrorMessage.fromJson(Map<String, dynamic> json) {
    return ErrorMessage(
      message: json['message'] ?? 'Unknown error',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}
