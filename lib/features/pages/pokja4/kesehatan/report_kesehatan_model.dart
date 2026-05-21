class ReportKesehatanModel {
  final int statusCode;
  final String message;
  final KesehatanEntry? data;
  final ErrorMessage? error;

  ReportKesehatanModel({
    required this.statusCode,
    required this.message,
    required this.data,
    this.error,
  });

  factory ReportKesehatanModel.fromJson(Map<String, dynamic> json) {
    return ReportKesehatanModel(
      statusCode: json['statusCode'] ?? 500,
      message: json['message'] ?? 'Unknown error',
      data: json['data'] != null ? KesehatanEntry.fromJson(json['data']) : null,
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

class KesehatanEntry {
  final String idPokja4Bidang1;
  final String uuid;
  final String idUser;
  final String jumlahPosyandu;
  final String jumlahPosyanduIterasi;
  final String jumlahKip;
  final String jumlahAnggota;
  final String jumlahKartuGratis;
  final String? catatan;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Role role;
  final Organization organization;

  KesehatanEntry({
    required this.idPokja4Bidang1,
    required this.uuid,
    required this.idUser,
    required this.jumlahPosyandu,
    required this.jumlahPosyanduIterasi,
    required this.jumlahKip,
    required this.jumlahAnggota,
    required this.jumlahKartuGratis,
    this.catatan,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.role,
    required this.organization,
  });

  factory KesehatanEntry.fromJson(Map<String, dynamic> json) {
    if (json['role'] == null || json['organization'] == null) {
      throw Exception('Missing required fields: role or organization');
    }

    return KesehatanEntry(
      idPokja4Bidang1: json['id_pokja4_bidang1']?.toString() ?? '',
      uuid: json['uuid']?.toString() ?? '',
      idUser: json['id_user']?.toString() ?? '',
      jumlahPosyandu: json['jumlah_posyandu']?.toString() ?? '0',
      jumlahPosyanduIterasi: json['jumlah_posyandu_iterasi']?.toString() ?? '0',
      jumlahKip: json['jumlah_klp']?.toString() ?? '0',
      jumlahAnggota: json['jumlah_anggota']?.toString() ?? '0',
      jumlahKartuGratis: json['jumlah_kartu_gratis']?.toString() ?? '0',
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
      'id_pokja4_bidang1': idPokja4Bidang1,
      'uuid': uuid,
      'id_user': idUser,
      'jumlah_posyandu': jumlahPosyandu,
      'jumlah_posyandu_iterasi': jumlahPosyanduIterasi,
      'jumlah_klp': jumlahKip,
      'jumlah_anggota': jumlahAnggota,
      'jumlah_kartu_gratis': jumlahKartuGratis,
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
