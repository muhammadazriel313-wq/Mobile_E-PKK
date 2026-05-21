class ReportKaderPokja4Model {
  final int statusCode;
  final String message;
  final KaderPokja4Entry? data;
  final ErrorMessage? error;

  ReportKaderPokja4Model({
    required this.statusCode,
    required this.message,
    required this.data,
    this.error,
  });

  factory ReportKaderPokja4Model.fromJson(Map<String, dynamic> json) {
    return ReportKaderPokja4Model(
      statusCode: json['statusCode'] ?? 500,
      message: json['message'] ?? 'Unknown error',
      data: json['data'] != null
          ? KaderPokja4Entry.fromJson(json['data'])
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

class KaderPokja4Entry {
  final String idKaderPokja4;
  final String uuid;
  final String idUser;
  final String posyandu;
  final String gizi;
  final String kesling;
  final String penyuluhanNarkoba;
  final String phbs;
  final String kb;
  final String? catatan;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Role role;
  final Organization organization;

  KaderPokja4Entry({
    required this.idKaderPokja4,
    required this.uuid,
    required this.idUser,
    required this.posyandu,
    required this.gizi,
    required this.kesling,
    required this.penyuluhanNarkoba,
    required this.phbs,
    required this.kb,
    this.catatan,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.role,
    required this.organization,
  });

  factory KaderPokja4Entry.fromJson(Map<String, dynamic> json) {
    if (json['role'] == null || json['organization'] == null) {
      throw Exception('Missing required fields: role or organization');
    }

    return KaderPokja4Entry(
      idKaderPokja4: json['id_kader_pokja4']?.toString() ?? '',
      uuid: json['uuid']?.toString() ?? '',
      idUser: json['id_user']?.toString() ?? '',
      posyandu: json['posyandu']?.toString() ?? '',
      gizi: json['gizi']?.toString() ?? '',
      kesling: json['kesling']?.toString() ?? '',
      penyuluhanNarkoba: json['penyuluhan_narkoba']?.toString() ?? '',
      phbs: json['PHBS']?.toString() ?? '',
      kb: json['KB']?.toString() ?? '',
      catatan: json['catatan']?.toString(),
      status: json['status']?.toString() ?? 'Proses',
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(json['updated_at']?.toString() ?? '') ??
          DateTime.now(),
      role: Role.fromJson(json['role']),
      organization: Organization.fromJson(json['organization']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_kader_pokja4': idKaderPokja4,
      'uuid': uuid,
      'id_user': idUser,
      'posyandu': posyandu,
      'gizi': gizi,
      'kesling': kesling,
      'penyuluhan_narkoba': penyuluhanNarkoba,
      'PHBS': phbs,
      'KB': kb,
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
    return ErrorMessage(message: json['message'] ?? 'Unknown error');
  }

  Map<String, dynamic> toJson() {
    return {'message': message};
  }
}

// Role dan Organization class sama seperti sebelumnya
class Role {
  final String id;
  final String uuid;
  final String name;

  Role({required this.id, required this.uuid, required this.name});

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'].toString(),
      uuid: json['uuid'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'uuid': uuid, 'name': name};
  }
}

class Organization {
  final String id;
  final String uuid;
  final String name;

  Organization({required this.id, required this.uuid, required this.name});

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      id: json['id'].toString(),
      uuid: json['uuid'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'uuid': uuid, 'name': name};
  }
}
