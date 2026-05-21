class ReportKaderPokja3Model {
  final int statusCode;
  final String message;
  final KaderPokja3Entry? data;
  final ErrorMessage? error;

  ReportKaderPokja3Model({
    required this.statusCode,
    required this.message,
    required this.data,
    this.error,
  });

  factory ReportKaderPokja3Model.fromJson(Map<String, dynamic> json) {
    return ReportKaderPokja3Model(
      statusCode: json['statusCode'] ?? 500,
      message: json['message'] ?? 'Unknown error',
      data: json['data'] != null
          ? KaderPokja3Entry.fromJson(json['data'])
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

class KaderPokja3Entry {
  final String idKaderPokja3;
  final String uuid;
  final String idUser;
  final String pangan;
  final String sandang;
  final String tataLaksanaRumah;
  final String? catatan;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Role role;
  final Organization organization;

  KaderPokja3Entry({
    required this.idKaderPokja3,
    required this.uuid,
    required this.idUser,
    required this.pangan,
    required this.sandang,
    required this.tataLaksanaRumah,
    this.catatan,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.role,
    required this.organization,
  });

  factory KaderPokja3Entry.fromJson(Map<String, dynamic> json) {
    return KaderPokja3Entry(
      idKaderPokja3: json['id_kader_pokja3']?.toString() ?? '',
      uuid: json['uuid'] ?? '',
      idUser: json['id_user']?.toString() ?? '',
      pangan: json['pangan']?.toString() ?? '',
      sandang: json['sandang']?.toString() ?? '',
      tataLaksanaRumah: json['tata_laksana_rumah']?.toString() ?? '',
      catatan: json['catatan'],
      status: json['status'] ?? 'Proses',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      role: json['role'] != null
          ? Role.fromJson(json['role'])
          : Role(id: '0', uuid: '', name: ''),
      organization: json['organization'] != null
          ? Organization.fromJson(json['organization'])
          : Organization(id: '0', uuid: '', name: ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_kader_pokja3': idKaderPokja3,
      'uuid': uuid,
      'id_user': idUser,
      'pangan': pangan,
      'sandang': sandang,
      'tata_laksana_rumah': tataLaksanaRumah,
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

/// =======================================================
///  EXTENSION (PENTING UNTUK FORM & API)
/// =======================================================

extension KaderPokja3EntryExtension on KaderPokja3Entry {
  ///  FORM KOSONG
  static KaderPokja3Entry empty() {
    return KaderPokja3Entry(
      idKaderPokja3: '',
      uuid: '',
      idUser: '',
      pangan: '',
      sandang: '',
      tataLaksanaRumah: '',
      catatan: null,
      status: 'Proses',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      role: Role(id: '0', uuid: '', name: ''),
      organization: Organization(id: '0', uuid: '', name: ''),
    );
  }

  ///  REQUEST KE API (HANYA FIELD YANG DIPERLUKAN)
  Map<String, dynamic> toRequest({
    required String idUser,
    required String idRole,
    required String idOrganization,
  }) {
    return {
      'id_user': idUser,
      'pangan': pangan,
      'sandang': sandang,
      'tata_laksana_rumah': tataLaksanaRumah,
      'id_role': idRole,
      'id_organization': idOrganization,
      if (catatan != null) 'catatan': catatan,
    };
  }
}
