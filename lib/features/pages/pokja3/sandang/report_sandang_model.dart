class ReportSandangModel {
  final int statusCode;
  final String message;
  final SandangEntry? data;
  final ErrorMessage? error;

  ReportSandangModel({
    required this.statusCode,
    required this.message,
    required this.data,
    this.error,
  });

  factory ReportSandangModel.fromJson(Map<String, dynamic> json) {
    return ReportSandangModel(
      statusCode: json['statusCode'] ?? 500,
      message: json['message']?.toString() ?? 'Unknown error',
      data: json['data'] != null
          ? SandangEntry.fromJson(json['data'])
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

class SandangEntry {
  final String idPokja3Bidang2;
  final String uuid;
  final String idUser;
  final String pangan;
  final String sandang;
  final String jasa;
  final String? catatan;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Role role;
  final Organization organization;

  SandangEntry({
    required this.idPokja3Bidang2,
    required this.uuid,
    required this.idUser,
    required this.pangan,
    required this.sandang,
    required this.jasa,
    this.catatan,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.role,
    required this.organization,
  });

  factory SandangEntry.fromJson(Map<String, dynamic> json) {
    if (json['role'] == null || json['organization'] == null) {
      throw Exception('Missing required fields: role or organization');
    }

    return SandangEntry(
      idPokja3Bidang2: json['id_pokja3_bidang2']?.toString() ?? '',
      uuid: json['uuid']?.toString() ?? '',
      idUser: json['id_user']?.toString() ?? '',

      // 🔥 WAJIB .toString()
      pangan: json['pangan']?.toString() ?? '0',
      sandang: json['sandang']?.toString() ?? '0',
      jasa: json['jasa']?.toString() ?? '0',

      catatan: json['catatan']?.toString(),

      status: json['status']?.toString() ?? 'Proses',

      createdAt: DateTime.tryParse(json['created_at'] ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ??
          DateTime.now(),

      role: Role.fromJson(json['role']),
      organization: Organization.fromJson(json['organization']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_pokja3_bidang2': idPokja3Bidang2,
      'uuid': uuid,
      'id_user': idUser,
      'pangan': pangan,
      'sandang': sandang,
      'jasa': jasa,
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