class ReportKelestarianModel {
  final int statusCode;
  final String message;
  final KelestarianEntry? data;
  final ErrorMessage? error;

  ReportKelestarianModel({
    required this.statusCode,
    required this.message,
    required this.data,
    this.error,
  });

  factory ReportKelestarianModel.fromJson(Map<String, dynamic> json) {
    return ReportKelestarianModel(
      statusCode: json['statusCode'] ?? 500,
      message: json['message'] ?? 'Unknown error',
      data: json['data'] != null
          ? KelestarianEntry.fromJson(json['data'])
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

class KelestarianEntry {
  final String idPokja4Bidang2;
  final String uuid;
  final String idUser;
  final String jamban;
  final String spal;
  final String tps;
  final String mck;
  final String pdam;
  final String sumur;
  final String lainnya;
  final String? catatan;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Role role;
  final Organization organization;

  KelestarianEntry({
    required this.idPokja4Bidang2,
    required this.uuid,
    required this.idUser,
    required this.jamban,
    required this.spal,
    required this.tps,
    required this.mck,
    required this.pdam,
    required this.sumur,
    required this.lainnya,
    this.catatan,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.role,
    required this.organization,
  });

  factory KelestarianEntry.fromJson(Map<String, dynamic> json) {
    if (json['role'] == null || json['organization'] == null) {
      throw Exception('Missing required fields: role or organization');
    }

    return KelestarianEntry(
      idPokja4Bidang2: json['id_pokja4_bidang2']?.toString() ?? '',
      uuid: json['uuid']?.toString() ?? '',
      idUser: json['id_user']?.toString() ?? '',
      jamban: json['jamban']?.toString() ?? '0',
      spal: json['spal']?.toString() ?? '0',
      tps: json['tps']?.toString() ?? '0',
      mck: json['mck']?.toString() ?? '0',
      pdam: json['pdam']?.toString() ?? '0',
      sumur: json['sumur']?.toString() ?? '0',
      lainnya: json['dll']?.toString() ?? '0',
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
      'id_pokja4_bidang2': idPokja4Bidang2,
      'uuid': uuid,
      'id_user': idUser,
      'jamban': jamban,
      'spal': spal,
      'tps': tps,
      'mck': mck,
      'pdam': pdam,
      'sumur': sumur,
      'dll': lainnya,
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
