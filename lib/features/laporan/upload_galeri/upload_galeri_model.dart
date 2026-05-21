class GaleriModel {
  final int statusCode;
  final String message;
  final GaleriEntry? data;
  final ErrorMessage? error;

  GaleriModel({
    required this.statusCode,
    required this.message,
    required this.data,
    this.error,
  });

  factory GaleriModel.fromJson(Map<String, dynamic> json) {
    return GaleriModel(
      statusCode: json['statusCode'] ?? 500,
      message: json['message'] ?? 'Unknown error',
      data: json['data'] != null ? GaleriEntry.fromJson(json['data']) : null,
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

class GaleriEntry {
  final String id;
  final String uuid;
  final String idUser;
  final String deskripsi;
  final String gambar;
  final String pokja;
  final String bidang;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Role role;
  final Organization organization;

  //TAMBAHAN LOKASI
  final String? lokasi;
  final double? latitude;
  final double? longitude;

  GaleriEntry({
    required this.id,
    required this.uuid,
    required this.idUser,
    required this.deskripsi,
    required this.gambar,
    required this.pokja,
    required this.bidang,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.role,
    required this.organization,
    this.lokasi,
    this.latitude,
    this.longitude,
  });

  factory GaleriEntry.fromJson(Map<String, dynamic> json) {
    return GaleriEntry(
      id: json['id'].toString(),
      uuid: json['uuid'] ?? '',
      idUser: json['id_user'].toString(),
      deskripsi: json['deskripsi'] ?? '',
      gambar: json['gambar'] ?? '',
      pokja: json['pokja'] ?? '',
      bidang: json['bidang'] ?? '',
      status: json['status'] ?? 'Draft',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      role: Role.fromJson(json['role']),
      organization: Organization.fromJson(json['organization']),

      //LOKASI
      lokasi: json['lokasi'],
      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString())
          : null,
      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'id_user': idUser,
      'deskripsi': deskripsi,
      'gambar': gambar,
      'pokja': pokja,
      'bidang': bidang,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'role': role.toJson(),
      'organization': organization.toJson(),

     // LOKASI
      'lokasi': lokasi,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

// ErrorMessage, Role, dan Organization menggunakan definisi yang sama seperti contoh sebelumnya
class ErrorMessage {
  final String message;

  ErrorMessage({required this.message});

  factory ErrorMessage.fromJson(Map<String, dynamic> json) {
    return ErrorMessage(message: json['message'] ?? 'Unknown error');
  }

  Map<String, dynamic> toJson() => {'message': message};
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

  Map<String, dynamic> toJson() => {'id': id, 'uuid': uuid, 'name': name};
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

  Map<String, dynamic> toJson() => {'id': id, 'uuid': uuid, 'name': name};
}
