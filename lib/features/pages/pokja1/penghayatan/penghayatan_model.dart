class ReportPenghayatanPengamalanModel {
  final int statusCode;
  final String message;
  final PenghayatanPengamalanEntry? data;
  final ErrorMessage? error;

  ReportPenghayatanPengamalanModel({
    required this.statusCode,
    required this.message,
    required this.data,
    this.error,
  });

  factory ReportPenghayatanPengamalanModel.fromJson(Map<String, dynamic> json) {
    return ReportPenghayatanPengamalanModel(
      statusCode: json['statusCode'] ?? 500,
      message: json['message'] ?? 'Unknown error',
      data: json['data'] != null
          ? PenghayatanPengamalanEntry.fromJson(json['data'])
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

class PenghayatanPengamalanEntry {
  final String idPokja1Bidang1;
  final String uuid;
  final String idUser;
  final String jumlahKelSimulasi1;
  final String jumlahAnggota1;
  final String jumlahKelSimulasi2;
  final String jumlahAnggota2;
  final String jumlahKelSimulasi3;
  final String jumlahAnggota3;
  final String jumlahKelSimulasi4;
  final String jumlahAnggota4;
  final String? catatan;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Role role;
  final Organization organization;

  PenghayatanPengamalanEntry({
    required this.idPokja1Bidang1,
    required this.uuid,
    required this.idUser,
    required this.jumlahKelSimulasi1,
    required this.jumlahAnggota1,
    required this.jumlahKelSimulasi2,
    required this.jumlahAnggota2,
    required this.jumlahKelSimulasi3,
    required this.jumlahAnggota3,
    required this.jumlahKelSimulasi4,
    required this.jumlahAnggota4,
    this.catatan,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.role,
    required this.organization,
  });

  factory PenghayatanPengamalanEntry.fromJson(Map<String, dynamic> json) {
    if (json['role'] == null || json['organization'] == null) {
      throw Exception('Missing required fields: role or organization');
    }

    return PenghayatanPengamalanEntry(
      idPokja1Bidang1: json['id_pokja1_bidang1']?.toString() ?? '',
      uuid: json['uuid']?.toString() ?? '',
      idUser: json['id_user']?.toString() ?? '',

      jumlahKelSimulasi1: json['jumlah_kel_simulasi1']?.toString() ?? '',
      jumlahAnggota1: json['jumlah_anggota1']?.toString() ?? '',
      jumlahKelSimulasi2: json['jumlah_kel_simulasi2']?.toString() ?? '',
      jumlahAnggota2: json['jumlah_anggota2']?.toString() ?? '',
      jumlahKelSimulasi3: json['jumlah_kel_simulasi3']?.toString() ?? '',
      jumlahAnggota3: json['jumlah_anggota3']?.toString() ?? '',
      jumlahKelSimulasi4: json['jumlah_kel_simulasi4']?.toString() ?? '',
      jumlahAnggota4: json['jumlah_anggota4']?.toString() ?? '',

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
      'id_pokja1_bidang1': idPokja1Bidang1,
      'uuid': uuid,
      'id_user': idUser,
      'jumlah_kel_simulasi1': jumlahKelSimulasi1,
      'jumlah_anggota1': jumlahAnggota1,
      'jumlah_kel_simulasi2': jumlahKelSimulasi2,
      'jumlah_anggota2': jumlahAnggota2,
      'jumlah_kel_simulasi3': jumlahKelSimulasi3,
      'jumlah_anggota3': jumlahAnggota3,
      'jumlah_kel_simulasi4': jumlahKelSimulasi4,
      'jumlah_anggota4': jumlahAnggota4,
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
