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

  // KERJA BAKTI
  final String? kerjaBaktiKegiatan;
  final String? kerjaBaktiVol;
  final String? kerjaBaktiMetode;
  final String? kerjaBaktiSasaran;

  // BANTUAN ANAK YATIM
  final String? bantuanYatimKegiatan;
  final String? bantuanYatimVol;
  final String? bantuanYatimMetode;
  final String? bantuanYatimSasaran;

  // KEGIATAN SOSIAL
  final String? kegiatanSosialKegiatan;
  final String? kegiatanSosialVol;
  final String? kegiatanSosialMetode;
  final String? kegiatanSosialSasaran;

  // LEGACY
  final String kerjaBakti;
  final String rukunKematian;
  final String keagamaan;
  final String jimpitan;
  final String arisan;
  final String? jenisKegiatan;

  // TAMBAHAN
  final String? sumberDana;
  final String? hasilKegiatan;
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
    this.kerjaBaktiKegiatan,
    this.kerjaBaktiVol,
    this.kerjaBaktiMetode,
    this.kerjaBaktiSasaran,
    this.bantuanYatimKegiatan,
    this.bantuanYatimVol,
    this.bantuanYatimMetode,
    this.bantuanYatimSasaran,
    this.kegiatanSosialKegiatan,
    this.kegiatanSosialVol,
    this.kegiatanSosialMetode,
    this.kegiatanSosialSasaran,
    required this.kerjaBakti,
    required this.rukunKematian,
    required this.keagamaan,
    required this.jimpitan,
    required this.arisan,
    this.jenisKegiatan,
    this.sumberDana,
    this.hasilKegiatan,
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

      kerjaBaktiKegiatan: json['kerja_bakti_kegiatan']?.toString(),
      kerjaBaktiVol: json['kerja_bakti_vol']?.toString(),
      kerjaBaktiMetode: json['kerja_bakti_metode']?.toString(),
      kerjaBaktiSasaran: json['kerja_bakti_sasaran']?.toString(),

      bantuanYatimKegiatan: json['bantuan_yatim_kegiatan']?.toString(),
      bantuanYatimVol: json['bantuan_yatim_vol']?.toString(),
      bantuanYatimMetode: json['bantuan_yatim_metode']?.toString(),
      bantuanYatimSasaran: json['bantuan_yatim_sasaran']?.toString(),

      kegiatanSosialKegiatan: json['kegiatan_sosial_kegiatan']?.toString(),
      kegiatanSosialVol: json['kegiatan_sosial_vol']?.toString(),
      kegiatanSosialMetode: json['kegiatan_sosial_metode']?.toString(),
      kegiatanSosialSasaran: json['kegiatan_sosial_sasaran']?.toString(),

      kerjaBakti: json['kerja_bakti']?.toString() ?? '',
      rukunKematian: json['rukun_kematian']?.toString() ?? '',
      keagamaan: json['keagamaan']?.toString() ?? '',
      jimpitan: json['jimpitan']?.toString() ?? '',
      arisan: json['arisan']?.toString() ?? '',
      jenisKegiatan: json['jenis_kegiatan']?.toString(),

      sumberDana: json['sumber_dana']?.toString(),
      hasilKegiatan: json['hasil_kegiatan']?.toString(),
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
      'kerja_bakti_kegiatan': kerjaBaktiKegiatan,
      'kerja_bakti_vol': kerjaBaktiVol,
      'kerja_bakti_metode': kerjaBaktiMetode,
      'kerja_bakti_sasaran': kerjaBaktiSasaran,
      'bantuan_yatim_kegiatan': bantuanYatimKegiatan,
      'bantuan_yatim_vol': bantuanYatimVol,
      'bantuan_yatim_metode': bantuanYatimMetode,
      'bantuan_yatim_sasaran': bantuanYatimSasaran,
      'kegiatan_sosial_kegiatan': kegiatanSosialKegiatan,
      'kegiatan_sosial_vol': kegiatanSosialVol,
      'kegiatan_sosial_metode': kegiatanSosialMetode,
      'kegiatan_sosial_sasaran': kegiatanSosialSasaran,
      'kerja_bakti': kerjaBakti,
      'rukun_kematian': rukunKematian,
      'keagamaan': keagamaan,
      'jimpitan': jimpitan,
      'arisan': arisan,
      'jenis_kegiatan': jenisKegiatan,
      'sumber_dana': sumberDana,
      'hasil_kegiatan': hasilKegiatan,
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