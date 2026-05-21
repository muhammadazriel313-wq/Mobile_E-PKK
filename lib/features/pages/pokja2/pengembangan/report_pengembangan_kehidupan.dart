class ReportPengembanganKehidupanModel {
  final int statusCode;
  final String message;
  final PengembanganKehidupanEntry? data;
  final ErrorMessage? error;

  ReportPengembanganKehidupanModel({
    required this.statusCode,
    required this.message,
    required this.data,
    this.error,
  });

  factory ReportPengembanganKehidupanModel.fromJson(Map<String, dynamic> json) {
    return ReportPengembanganKehidupanModel(
      statusCode: json['statusCode'] ?? 500,
      message: json['message'] ?? 'Unknown error',
      data: json['data'] != null
          ? PengembanganKehidupanEntry.fromJson(json['data'])
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

class PengembanganKehidupanEntry {
  final String idPokja2Bidang2;
  final String uuid;
  final String idUser;

  final String jumlahKelompokPemula;
  final String jumlahPesertaPemula;
  final String jumlahKelompokMadya;
  final String jumlahPesertaMadya;
  final String jumlahKelompokUtama;
  final String jumlahPesertaUtama;
  final String jumlahKelompokMandiri;
  final String jumlahPesertaMandiri;
  final String jumlahKelompokHukum;
  final String jumlahPesertaHukum;

  final String? catatan;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Role role;
  final Organization organization;

  PengembanganKehidupanEntry({
    required this.idPokja2Bidang2,
    required this.uuid,
    required this.idUser,
    required this.jumlahKelompokPemula,
    required this.jumlahPesertaPemula,
    required this.jumlahKelompokMadya,
    required this.jumlahPesertaMadya,
    required this.jumlahKelompokUtama,
    required this.jumlahPesertaUtama,
    required this.jumlahKelompokMandiri,
    required this.jumlahPesertaMandiri,
    required this.jumlahKelompokHukum,
    required this.jumlahPesertaHukum,
    this.catatan,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.role,
    required this.organization,
  });

  factory PengembanganKehidupanEntry.fromJson(Map<String, dynamic> json) {
    if (json['role'] == null || json['organization'] == null) {
      throw Exception('Missing required fields: role or organization');
    }

    return PengembanganKehidupanEntry(
      idPokja2Bidang2: json['id_pokja2_bidang2']?.toString() ?? '',
      uuid: json['uuid'] ?? '',
      idUser: json['id_user']?.toString() ?? '',

      jumlahKelompokPemula:
          json['jumlah_kelompok_pemula']?.toString() ?? '',
      jumlahPesertaPemula:
          json['jumlah_peserta_pemula']?.toString() ?? '',

      jumlahKelompokMadya:
          json['jumlah_kelompok_madya']?.toString() ?? '',
      jumlahPesertaMadya:
          json['jumlah_peserta_madya']?.toString() ?? '',

      jumlahKelompokUtama:
          json['jumlah_kelompok_utama']?.toString() ?? '',
      jumlahPesertaUtama:
          json['jumlah_peserta_utama']?.toString() ?? '',

      jumlahKelompokMandiri:
          json['jumlah_kelompok_mandiri']?.toString() ?? '',
      jumlahPesertaMandiri:
          json['jumlah_peserta_mandiri']?.toString() ?? '',

      jumlahKelompokHukum:
          json['jumlah_kelompok_hukum']?.toString() ?? '',
      jumlahPesertaHukum:
          json['jumlah_peserta_hukum']?.toString() ?? '',

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
      'id_pokja2_bidang2': idPokja2Bidang2,
      'uuid': uuid,
      'id_user': idUser,

      'jumlah_kelompok_pemula': jumlahKelompokPemula,
      'jumlah_peserta_pemula': jumlahPesertaPemula,
      'jumlah_kelompok_madya': jumlahKelompokMadya,
      'jumlah_peserta_madya': jumlahPesertaMadya,
      'jumlah_kelompok_utama': jumlahKelompokUtama,
      'jumlah_peserta_utama': jumlahPesertaUtama,
      'jumlah_kelompok_mandiri': jumlahKelompokMandiri,
      'jumlah_peserta_mandiri': jumlahPesertaMandiri,
      'jumlah_kelompok_hukum': jumlahKelompokHukum,
      'jumlah_peserta_hukum': jumlahPesertaHukum,

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
      id: json['id']?.toString() ?? '',
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
      id: json['id']?.toString() ?? '',
      uuid: json['uuid'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'uuid': uuid, 'name': name};
  }
}

extension PengembanganKehidupanEntryExtension
    on PengembanganKehidupanEntry {
  static PengembanganKehidupanEntry empty() {
    return PengembanganKehidupanEntry(
      idPokja2Bidang2: '',
      uuid: '',
      idUser: '',
      jumlahKelompokPemula: '',
      jumlahPesertaPemula: '',
      jumlahKelompokMadya: '',
      jumlahPesertaMadya: '',
      jumlahKelompokUtama: '',
      jumlahPesertaUtama: '',
      jumlahKelompokMandiri: '',
      jumlahPesertaMandiri: '',
      jumlahKelompokHukum: '',
      jumlahPesertaHukum: '',
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

      'jumlah_kelompok_pemula':
          int.tryParse(jumlahKelompokPemula) ?? 0,
      'jumlah_peserta_pemula':
          int.tryParse(jumlahPesertaPemula) ?? 0,

      'jumlah_kelompok_madya':
          int.tryParse(jumlahKelompokMadya) ?? 0,
      'jumlah_peserta_madya':
          int.tryParse(jumlahPesertaMadya) ?? 0,

      'jumlah_kelompok_utama':
          int.tryParse(jumlahKelompokUtama) ?? 0,
      'jumlah_peserta_utama':
          int.tryParse(jumlahPesertaUtama) ?? 0,

      'jumlah_kelompok_mandiri':
          int.tryParse(jumlahKelompokMandiri) ?? 0,
      'jumlah_peserta_mandiri':
          int.tryParse(jumlahPesertaMandiri) ?? 0,

      'jumlah_kelompok_hukum':
          int.tryParse(jumlahKelompokHukum) ?? 0,
      'jumlah_peserta_hukum':
          int.tryParse(jumlahPesertaHukum) ?? 0,

      'id_role': idRole,
      'id_organization': idOrganization,

      if (catatan != null) 'catatan': catatan,
    };
  }
}