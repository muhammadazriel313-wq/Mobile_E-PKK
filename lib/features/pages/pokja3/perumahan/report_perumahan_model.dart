class ReportPerumahanModel {
  final int statusCode;
  final String message;
  final PerumahanEntry? data;
  final ErrorMessage? error;

  ReportPerumahanModel({
    required this.statusCode,
    required this.message,
    required this.data,
    this.error,
  });

  factory ReportPerumahanModel.fromJson(Map<String, dynamic> json) {
    return ReportPerumahanModel(
      statusCode: json['statusCode'] ?? 500,
      message: json['message']?.toString() ?? 'Unknown error',
      data: json['data'] != null
          ? PerumahanEntry.fromJson(json['data'])
          : null,
      error: json['error'] != null
          ? ErrorMessage.fromJson(json['error'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'message': message,
      'data': data?.toJson(),
      'error': error?.toJson(),
    };
  }
}

class PerumahanEntry {
  final String idPokja3Bidang3;
  final String uuid;
  final String idUser;
  final String layakHuni;
  final String tidakLayak;
  final String? catatan;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Role role;
  final Organization organization;

  PerumahanEntry({
    required this.idPokja3Bidang3,
    required this.uuid,
    required this.idUser,
    required this.layakHuni,
    required this.tidakLayak,
    this.catatan,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.role,
    required this.organization,
  });

  factory PerumahanEntry.fromJson(Map<String, dynamic> json) {
    if (json['role'] == null || json['organization'] == null) {
      throw Exception('Missing required fields: role or organization');
    }

    return PerumahanEntry(
      idPokja3Bidang3:
          json['id_pokja3_bidang3']?.toString() ?? '',
      uuid: json['uuid']?.toString() ?? '',
      idUser: json['id_user']?.toString() ?? '',

      //  FIX UTAMA
      layakHuni: json['layak_huni']?.toString() ?? '',
      tidakLayak: json['tidak_layak']?.toString() ?? '',

      catatan: json['catatan']?.toString(),
      status: json['status']?.toString() ?? 'Proses',

      createdAt: DateTime.tryParse(
              json['created_at']?.toString() ?? '') ??
          DateTime.now(),

      updatedAt: DateTime.tryParse(
              json['updated_at']?.toString() ?? '') ??
          DateTime.now(),

      role: Role.fromJson(json['role']),
      organization: Organization.fromJson(json['organization']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_pokja3_bidang3': idPokja3Bidang3,
      'uuid': uuid,
      'id_user': idUser,
      'layak_huni': layakHuni,
      'tidak_layak': tidakLayak,
      'catatan': catatan,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'role': role.toJson(),
      'organization': organization.toJson(),
    };
  }
}

class ErrorMessage {
  final String message;

  ErrorMessage({required this.message});

  factory ErrorMessage.fromJson(Map<String, dynamic> json) {
    return ErrorMessage(
      message: json['message']?.toString() ?? 'Unknown error',
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message};
  }
}

class Role {
  final String id;
  final String uuid;
  final String name;

  Role({
    required this.id,
    required this.uuid,
    required this.name,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id']?.toString() ?? '',
      uuid: json['uuid']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'name': name,
    };
  }
}

class Organization {
  final String id;
  final String uuid;
  final String name;

  Organization({
    required this.id,
    required this.uuid,
    required this.name,
  });

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      id: json['id']?.toString() ?? '',
      uuid: json['uuid']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'name': name,
    };
  }
}