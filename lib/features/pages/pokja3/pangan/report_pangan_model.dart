class ReportPanganModel {
  final int statusCode;
  final String message;
  final PanganEntry? data;
  final ErrorMessage? error;

  ReportPanganModel({
    required this.statusCode,
    required this.message,
    required this.data,
    this.error,
  });

  factory ReportPanganModel.fromJson(Map<String, dynamic> json) {
    return ReportPanganModel(
      statusCode: json['statusCode'] ?? 500,
      message: json['message'] ?? 'Unknown error',
      data: json['data'] != null ? PanganEntry.fromJson(json['data']) : null,
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

class PanganEntry {
  final String idPokja3Bidang1;
  final String uuid;
  final String idUser;
  final String beras;
  final String nonBeras;
  final String peternakan;
  final String perikanan;
  final String warungHidup;
  final String lumbungHidup;
  final String toga;
  final String tanamanKeras;
  final String tanamanLainnya; // 🔥 TAMBAHAN
  final String? catatan;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Role role;
  final Organization organization;

  PanganEntry({
    required this.idPokja3Bidang1,
    required this.uuid,
    required this.idUser,
    required this.beras,
    required this.nonBeras,
    required this.peternakan,
    required this.perikanan,
    required this.warungHidup,
    required this.lumbungHidup,
    required this.toga,
    required this.tanamanKeras,
    required this.tanamanLainnya, // 🔥
    this.catatan,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.role,
    required this.organization,
  });

  factory PanganEntry.fromJson(Map<String, dynamic> json) {
    return PanganEntry(
      idPokja3Bidang1: json['id_pokja3_bidang1']?.toString() ?? '',
      uuid: json['uuid'] ?? '',
      idUser: json['id_user']?.toString() ?? '',
      beras: json['beras']?.toString() ?? '0',
      nonBeras: json['non_beras']?.toString() ?? '0',
      peternakan: json['peternakan']?.toString() ?? '0',
      perikanan: json['perikanan']?.toString() ?? '0',
      warungHidup: json['warung_hidup']?.toString() ?? '0',
      lumbungHidup: json['lumbung_hidup']?.toString() ?? '0',
      toga: json['toga']?.toString() ?? '0',
      tanamanKeras: json['tanaman_keras']?.toString() ?? '0',
      tanamanLainnya: json['tanaman_lainnya']?.toString() ?? '0',
      catatan: json['catatan']?.toString(),
      status: json['status']?.toString() ?? 'Proses',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      role: Role.fromJson(json['role']),
      organization: Organization.fromJson(json['organization']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_pokja3_bidang1': idPokja3Bidang1,
      'uuid': uuid,
      'id_user': idUser,
      'beras': beras,
      'non_beras': nonBeras,
      'peternakan': peternakan,
      'perikanan': perikanan,
      'warung_hidup': warungHidup,
      'lumbung_hidup': lumbungHidup,
      'toga': toga,
      'tanaman_keras': tanamanKeras,

      // 🔥 TAMBAHAN
      'tanaman_lainnya': tanamanLainnya,

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

extension PanganEntryExtension on PanganEntry {
  static PanganEntry empty() {
    return PanganEntry(
      idPokja3Bidang1: '',
      uuid: '',
      idUser: '',
      beras: '',
      nonBeras: '',
      peternakan: '',
      perikanan: '',
      warungHidup: '',
      lumbungHidup: '',
      toga: '',
      tanamanKeras: '',
      tanamanLainnya: '', // 🔥
      catatan: null,
      status: 'Proses',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      role: Role(id: '0', uuid: '', name: ''),
      organization: Organization(id: '0', uuid: '', name: ''),
    );
  }

  Map<String, dynamic> toRequest({
    required String idUser,
    required String idRole,
    required String idOrganization,
  }) {
    return {
      'id_user': idUser,
      'beras': beras,
      'non_beras': nonBeras,
      'peternakan': peternakan,
      'perikanan': perikanan,
      'warung_hidup': warungHidup,
      'lumbung_hidup': lumbungHidup,
      'toga': toga,
      'tanaman_keras': tanamanKeras,
      'tanaman_lainnya': tanamanLainnya, // 🔥
      'id_role': idRole,
      'id_organization': idOrganization,
      if (catatan != null) 'catatan': catatan,
    };
  }
}
