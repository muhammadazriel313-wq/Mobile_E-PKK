class ReportPerencanaanModel {
  final int statusCode;
  final String message;
  final PerencanaanEntry? data;
  final ErrorMessage? error;

  ReportPerencanaanModel({
    required this.statusCode,
    required this.message,
    required this.data,
    this.error,
  });

  factory ReportPerencanaanModel.fromJson(Map<String, dynamic> json) {
    return ReportPerencanaanModel(
      statusCode: json['statusCode'] ?? 500,
      message: json['message'] ?? 'Unknown error',
      data: json['data'] != null
          ? PerencanaanEntry.fromJson(json['data'])
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

class PerencanaanEntry {
  final String idPokja4Bidang3;
  final String uuid;
  final String idUser;
  final String jumlahPriaSubur;
  final String jumlahWanitaSubur;
  final String kbPria;
  final String kbWanita;
  final String kkTabungan;
  final String? catatan;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Role role;
  final Organization organization;

  PerencanaanEntry({
    required this.idPokja4Bidang3,
    required this.uuid,
    required this.idUser,
    required this.jumlahPriaSubur,
    required this.jumlahWanitaSubur,
    required this.kbPria,
    required this.kbWanita,
    required this.kkTabungan,
    this.catatan,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.role,
    required this.organization,
  });

  factory PerencanaanEntry.fromJson(Map<String, dynamic> json) {
    if (json['role'] == null || json['organization'] == null) {
      throw Exception('Missing required fields: role or organization');
    }

    return PerencanaanEntry(
      idPokja4Bidang3: json['id_pokja4_bidang3']?.toString() ?? '',
      uuid: json['uuid']?.toString() ?? '',
      idUser: json['id_user']?.toString() ?? '',
      jumlahPriaSubur: json['J_Psubur']?.toString() ?? '0',
      jumlahWanitaSubur: json['J_Wsubur']?.toString() ?? '0',
      kbPria: json['Kb_p']?.toString() ?? '0',
      kbWanita: json['Kb_w']?.toString() ?? '0',
      kkTabungan: json['Kk_tbg']?.toString() ?? '0',
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
      'id_pokja4_bidang3': idPokja4Bidang3,
      'uuid': uuid,
      'id_user': idUser,
      'J_Psubur': jumlahPriaSubur,
      'J_Wsubur': jumlahWanitaSubur,
      'Kb_p': kbPria,
      'Kb_w': kbWanita,
      'Kk_tbg': kkTabungan,
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
