class ReportGotongRoyongModel {
  final int statusCode;
  final String message;
  final GotongRoyongEntry? data;
  final ErrorMessage? error;

  ReportGotongRoyongModel({
    required this.statusCode,
    required this.message,
    required this.data,
    this.error,
  });

  factory ReportGotongRoyongModel.fromJson(Map<String, dynamic> json) {
    return ReportGotongRoyongModel(
      statusCode: json['statusCode'] ?? 500,
      message: json['message'] ?? 'Unknown error',
      data: json['data'] != null
          ? GotongRoyongEntry.fromJson(json['data'])
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

class GotongRoyongEntry {
  final String idPokja1Bidang2;
  final String uuid;
  final String idUser;
  final String kerjaBakti;
  final String rukunKematian;
  final String keagamaan;
  final String jimpitan;
  final String arisan;
  final String? catatan;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Role role;
  final Organization organization;

  GotongRoyongEntry({
    required this.idPokja1Bidang2,
    required this.uuid,
    required this.idUser,
    required this.kerjaBakti,
    required this.rukunKematian,
    required this.keagamaan,
    required this.jimpitan,
    required this.arisan,
    this.catatan,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.role,
    required this.organization,
  });

  factory GotongRoyongEntry.fromJson(Map<String, dynamic> json) {
    if (json['role'] == null || json['organization'] == null) {
      throw Exception('Missing required fields: role or organization');
    }

    return GotongRoyongEntry(
      idPokja1Bidang2: json['id_pokja1_bidang2']?.toString() ?? '',
      uuid: json['uuid'] ?? '',
      idUser: json['id_user']?.toString() ?? '',
      kerjaBakti: json['kerja_bakti']?.toString() ?? '',
      rukunKematian: json['rukun_kematian']?.toString() ?? '',
      keagamaan: json['keagamaan']?.toString() ?? '',
      jimpitan: json['jimpitan']?.toString() ?? '',
      arisan: json['arisan']?.toString() ?? '',
      catatan: json['catatan'],
      status: json['status'] ?? 'Proses',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      role: Role.fromJson(json['role']),
      organization: Organization.fromJson(json['organization']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_pokja1_bidang2': idPokja1Bidang2,
      'uuid': uuid,
      'id_user': idUser,
      'kerja_bakti': kerjaBakti,
      'rukun_kematian': rukunKematian,
      'keagamaan': keagamaan,
      'jimpitan': jimpitan,
      'arisan': arisan,
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
