class ReportKaderPokja1Model {
  final int statusCode;
  final String message;
  final KaderPokja1Entry? data;
  final ErrorMessage? error;

  ReportKaderPokja1Model({
    required this.statusCode,
    required this.message,
    this.data,
    this.error,
  });

  factory ReportKaderPokja1Model.fromJson(Map<String, dynamic> json) {
    return ReportKaderPokja1Model(
      statusCode: json['statusCode'] ?? 500,
      message: json['message'] ?? 'Unknown error',
      data: json['data'] != null
          ? KaderPokja1Entry.fromJson(json['data'])
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

class KaderPokja1Entry {
  final String idKaderPokja1;
  final String uuid;
  final String idUser;
  final String pkbn;
  final String pkdrt;
  final String polaAsuh;
  final String? catatan;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Role? role;
  final Organization? organization;

  KaderPokja1Entry({
    required this.idKaderPokja1,
    required this.uuid,
    required this.idUser,
    required this.pkbn,
    required this.pkdrt,
    required this.polaAsuh,
    this.catatan,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.role,
    this.organization,
  });

  factory KaderPokja1Entry.fromJson(Map<String, dynamic> json) {
    return KaderPokja1Entry(
      idKaderPokja1: json['id_kader_pokja1']?.toString() ?? '',
      uuid: json['uuid'] ?? '',
      idUser: json['id_user']?.toString() ?? '',
      pkbn: json['PKBN']?.toString() ?? '',
      pkdrt: json['PKDRT']?.toString() ?? '',
      polaAsuh: json['pola_asuh']?.toString() ?? '',
      catatan: json['catatan'],
      status: json['status'] ?? 'Proses',
      createdAt:
          DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt:
          DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      role: json['role'] != null ? Role.fromJson(json['role']) : null,
      organization: json['organization'] != null
          ? Organization.fromJson(json['organization'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_kader_pokja1': idKaderPokja1,
      'uuid': uuid,
      'id_user': idUser,
      'PKBN': pkbn,
      'PKDRT': pkdrt,
      'pola_asuh': polaAsuh,
      'catatan': catatan,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'role': role?.toJson(), // 🔥 aman null
      'organization': organization?.toJson(), // 🔥 aman null
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
      uuid: json['uuid'] ?? '',
      name: json['name'] ?? '',
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
      uuid: json['uuid'] ?? '',
      name: json['name'] ?? '',
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
      message: json['message'] ?? 'Unknown error',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}