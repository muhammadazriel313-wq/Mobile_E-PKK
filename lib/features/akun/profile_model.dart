class ProfilResponse {
  final int statusCode;
  final String message;
  final List<Profil> data;
  final ErrorMessage? error;

  ProfilResponse({
    required this.statusCode,
    required this.message,
    required this.data,
    this.error,
  });

  factory ProfilResponse.fromJson(Map<String, dynamic> json) {
    List<Profil> dataList = [];

    if (json['data'] != null && json['data'] is List) {
      dataList = (json['data'] as List).map((item) {
        return Profil.fromJson(item as Map<String, dynamic>);
      }).toList();
    }

    return ProfilResponse(
      statusCode: json['statusCode'] ?? 200,
      message: json['message'] ?? '',
      data: dataList,
      error: json['error'] != null
          ? ErrorMessage.fromJson(json['error'])
          : null,
    );
  }
}

class Profil {
  final String id;
  final String uuid;
  final String phoneNumber;
  final String fullName;
  final String? password;
  final String kodeOtp;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String idSubdistrict;
  final String idVillage;
  final String idRole;
  final String idOrganization;
  // [PERUBAHAN 08-10-2026] Menambahkan field foto
  final String? foto;

  Profil({
    required this.id,
    required this.uuid,
    required this.phoneNumber,
    required this.fullName,
    this.password,
    required this.kodeOtp,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.idSubdistrict,
    required this.idVillage,
    required this.idRole,
    required this.idOrganization,
    this.foto,
  });

  factory Profil.fromJson(Map<String, dynamic> json) {
    print('PROFILE JSON : $json');

    return Profil(
      id: json['id']?.toString() ?? '0',
      uuid: json['uuid']?.toString() ?? '',
      phoneNumber: json['phone_number']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
      idSubdistrict: json['id_subdistrict']?.toString() ?? '0',
      idVillage: json['id_village']?.toString() ?? '0',
      idRole: json['id_role']?.toString() ?? '0',

      idOrganization: json['organization'] != null
          ? json['organization']['id'].toString()
          : json['id_organization']?.toString() ?? '0',

      password: '',
      kodeOtp: '',
      // [PERUBAHAN 08-10-2026] Parsing foto
      foto: json['foto']?.toString(),
    );
  }

  Map<String, dynamic> toUpdateJson({
    bool includeNameAndPhone = false,
    bool includePassword = false,
    String? currentPassword,
  }) {
    assert(
      !includePassword || currentPassword != null,
      'Current password required for password update',
    );

    final data = <String, dynamic>{'id': id};

    if (includeNameAndPhone) {
      data.addAll({'full_name': fullName, 'phone_number': phoneNumber});
    }

    if (includePassword) {
      data.addAll({
        'current_password': currentPassword,
        'new_password': password,
      });
    }

    return data;
  }

  static DateTime _parseDateTime(dynamic date) {
    try {
      return DateTime.parse(date.toString());
    } catch (_) {
      return DateTime.now();
    }
  }

  Profil copyWith({
    String? fullName,
    String? phoneNumber,
    String? password,
    String? foto,
  }) {
    return Profil(
      id: id,
      uuid: uuid,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      fullName: fullName ?? this.fullName,
      password: password ?? this.password,
      kodeOtp: kodeOtp,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
      idSubdistrict: idSubdistrict,
      idVillage: idVillage,
      idRole: idRole,
      idOrganization: idOrganization,
      foto: foto ?? this.foto,
    );
  }
}

class ErrorMessage {
  final String message;
  final int? code;

  ErrorMessage({required this.message, this.code});

  factory ErrorMessage.fromJson(Map<String, dynamic> json) {
    return ErrorMessage(
      message: json['message']?.toString() ?? 'Unknown error',
      code: json['code'],
    );
  }
}
