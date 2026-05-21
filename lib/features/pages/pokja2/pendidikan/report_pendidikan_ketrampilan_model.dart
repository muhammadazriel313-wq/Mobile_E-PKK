class ReportPendidikanKeterampilanModel {
  final int statusCode;
  final String message;
  final PendidikanKeterampilanEntry? data;
  final ErrorMessage? error;

  ReportPendidikanKeterampilanModel({
    required this.statusCode,
    required this.message,
    this.data,
    this.error,
  });

  factory ReportPendidikanKeterampilanModel.fromJson(Map<String, dynamic> json) {
    return ReportPendidikanKeterampilanModel(
      statusCode: json['statusCode'] ?? 500,
      message: json['message'] ?? 'Unknown error',
      data: json['data'] != null
          ? PendidikanKeterampilanEntry.fromJson(json['data'])
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

class PendidikanKeterampilanEntry {
  final String idPokja2Bidang1;
  final String uuid;
  final String idUser;
  final String wargaButa;
  final String kelBelajarA;
  final String wargaBelajarA;
  final String kelBelajarB;
  final String wargaBelajarB;
  final String kelBelajarC;
  final String wargaBelajarC;
  final String kelBelajarKF;
  final String wargaBelajarKF;
  final String paud;
  final String tamanBacaan;
  final String jumlahKlp;
  final String jumlahIbuPeserta; // 🔥 FIX NAMA
  final String jumlahApe;
  final String jumlahKelSimulasi;
  final String kf;
  final String paudTutor;
  final String bkb;
  final String koperasi;
  final String ketrampilan;
  final String lp3pkk;
  final String tp3pkk;
  final String damasPkk;
  final String? catatan;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Role role;
  final Organization organization;

  PendidikanKeterampilanEntry({
    required this.idPokja2Bidang1,
    required this.uuid,
    required this.idUser,
    required this.wargaButa,
    required this.kelBelajarA,
    required this.wargaBelajarA,
    required this.kelBelajarB,
    required this.wargaBelajarB,
    required this.kelBelajarC,
    required this.wargaBelajarC,
    required this.kelBelajarKF,
    required this.wargaBelajarKF,
    required this.paud,
    required this.tamanBacaan,
    required this.jumlahKlp,
    required this.jumlahIbuPeserta,
    required this.jumlahApe,
    required this.jumlahKelSimulasi,
    required this.kf,
    required this.paudTutor,
    required this.bkb,
    required this.koperasi,
    required this.ketrampilan,
    required this.lp3pkk,
    required this.tp3pkk,
    required this.damasPkk,
    this.catatan,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.role,
    required this.organization,
  });

  factory PendidikanKeterampilanEntry.fromJson(Map<String, dynamic> json) {
    return PendidikanKeterampilanEntry(
      idPokja2Bidang1: json['id_pokja2_bidang1']?.toString() ?? '',
      uuid: json['uuid']?.toString() ?? '',
      idUser: json['id_user']?.toString() ?? '',
      wargaButa: json['warga_buta']?.toString() ?? '',
      kelBelajarA: json['kel_belajarA']?.toString() ?? '',
      wargaBelajarA: json['warga_belajarA']?.toString() ?? '',
      kelBelajarB: json['kel_belajarB']?.toString() ?? '',
      wargaBelajarB: json['warga_belajarB']?.toString() ?? '',
      kelBelajarC: json['kel_belajarC']?.toString() ?? '',
      wargaBelajarC: json['warga_belajarC']?.toString() ?? '',
      kelBelajarKF: json['kel_belajarKF']?.toString() ?? '',
      wargaBelajarKF: json['warga_belajarKF']?.toString() ?? '',
      paud: json['paud']?.toString() ?? '',
      tamanBacaan: json['taman_bacaan']?.toString() ?? '',
      jumlahKlp: json['jumlah_klp']?.toString() ?? '',
      jumlahIbuPeserta: json['jumlah_ibu_peserta']?.toString() ?? '', // 🔥 FIX
      jumlahApe: json['jumlah_ape']?.toString() ?? '',
      jumlahKelSimulasi: json['jumlah_kel_simulasi']?.toString() ?? '',
      kf: json['KF']?.toString() ?? '',
      paudTutor: json['paud_tutor']?.toString() ?? '',
      bkb: json['BKB']?.toString() ?? '',
      koperasi: json['koperasi']?.toString() ?? '',
      ketrampilan: json['ketrampilan']?.toString() ?? '',
      lp3pkk: json['LP3PKK']?.toString() ?? '',
      tp3pkk: json['TP3PKK']?.toString() ?? '',
      damasPkk: json['damas_pkk']?.toString() ?? '',
      catatan: json['catatan']?.toString(),
      status: json['status']?.toString() ?? 'Proses',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),

      // 🔥 AMAN (TIDAK CRASH)
      role: json['role'] != null
          ? Role.fromJson(json['role'])
          : Role(id: '', uuid: '', name: ''),

      organization: json['organization'] != null
          ? Organization.fromJson(json['organization'])
          : Organization(id: '', uuid: '', name: ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_pokja2_bidang1': idPokja2Bidang1,
      'uuid': uuid,
      'id_user': idUser,
      'warga_buta': wargaButa,
      'kel_belajarA': kelBelajarA,
      'warga_belajarA': wargaBelajarA,
      'kel_belajarB': kelBelajarB,
      'warga_belajarB': wargaBelajarB,
      'kel_belajarC': kelBelajarC,
      'warga_belajarC': wargaBelajarC,
      'kel_belajarKF': kelBelajarKF,
      'warga_belajarKF': wargaBelajarKF,
      'paud': paud,
      'taman_bacaan': tamanBacaan,
      'jumlah_klp': jumlahKlp,
      'jumlah_ibu_peserta': jumlahIbuPeserta, // 🔥 FIX
      'jumlah_ape': jumlahApe,
      'jumlah_kel_simulasi': jumlahKelSimulasi,
      'KF': kf,
      'paud_tutor': paudTutor,
      'BKB': bkb,
      'koperasi': koperasi,
      'ketrampilan': ketrampilan,
      'LP3PKK': lp3pkk,
      'TP3PKK': tp3pkk,
      'damas_pkk': damasPkk,
      'catatan': catatan,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'role': role.toJson(),
      'organization': organization.toJson(),
    };
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