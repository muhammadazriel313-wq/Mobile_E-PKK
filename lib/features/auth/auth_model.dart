class LoginResponse {
  final int statusCode;
  final String message;

  /// TOKEN
  final String? token;

  final UserData? data;

  final ErrorResponse? error;

  LoginResponse({
    required this.statusCode,
    required this.message,
    this.token,
    this.data,
    this.error,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      statusCode: json['statusCode'] ?? 500,

      message: json['message'] ?? '',

      /// AMBIL TOKEN
      token: json['token'],

      data: json['data'] != null
          ? UserData.fromJson(json['data'])
          : null,

      error: json['error'] != null
          ? ErrorResponse.fromJson(json['error'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,

      'message': message,

      'token': token,

      'data': data?.toJson(),

      'error': error,
    };
  }
}


// coba register
class RegisterResponse {
  final int? statusCode;
  final String message;
  final UserData? data;
  final ErrorResponse? error;

  RegisterResponse({
    required this.statusCode,
    required this.message,
    this.data,
    this.error,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      statusCode: json['statusCode'] ?? 0,
      message: json['message'],
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
      error: json['error'] != null ? ErrorResponse.fromJson(json['error']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'message': message,
      'data': data?.toJson(),
      'error': error,
    };
  }
}

// auth_model.dart
class ForgotPasswordResponse {
  final String message;
  final int statusCode;
  final String? errorMessage;

  ForgotPasswordResponse({
    required this.message,
    required this.statusCode,
    this.errorMessage,
  });

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponse(
      message: json['message'],
      statusCode: json['statusCode'],
      errorMessage: json['error']?['message'], // aman walau tidak ada error
    );
  }
}



class UserData {
  final String id;
  final String uuid; // Tambahkan
  final String fullName;
  final String phoneNumber;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Subdistrict? subdistrict;
  final Village? village;
  final Role? role;
  final Organization? organization;

  UserData({
    required this.id,
    required this.uuid,
    required this.fullName,
    required this.phoneNumber,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.subdistrict,
    this.village,
    this.role,
    this.organization,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'].toString(),
      uuid: json['uuid'] ?? '',
      fullName: json['fullName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      status: json['status'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      subdistrict: json['subdistrict'] != null ? Subdistrict.fromJson(json['subdistrict']) : null,
      village: json['village'] != null ? Village.fromJson(json['village']) : null,
      role: json['role'] != null ? Role.fromJson(json['role']) : null,
      organization: json['organization'] != null ? Organization.fromJson(json['organization']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'subdistrict': subdistrict?.toJson(),
      'village': village?.toJson(),
      'role': role?.toJson(),
      'organization': organization?.toJson(),
    };
  }
}

class Subdistrict {
  final String id;
  final String uuid; // Tambahkan
  final String name;

  Subdistrict({
    required this.id,
    required this.uuid,
    required this.name,
  });

  factory Subdistrict.fromJson(Map<String, dynamic> json) {
    return Subdistrict(
      id: json['id'].toString(),
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

class Village {
  final String id;
  final String uuid; // Tambahkan
  final String name;

  Village({
    required this.id,
    required this.uuid,
    required this.name,
  });

  factory Village.fromJson(Map<String, dynamic> json) {
    return Village(
      id: json['id'].toString(),
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

class Role {
  final String id;
  final String uuid; // Tambahkan
  final String name;

  Role({
    required this.id,
    required this.uuid,
    required this.name,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'].toString(),
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
  final String uuid; // Tambahkan
  final String name;

  Organization({
    required this.id,
    required this.uuid,
    required this.name,
  });

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      id: json['id'].toString(),
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

// Model Error Khusus
class ErrorResponse {
  final String message;

  ErrorResponse({required this.message});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      message: json['message'] ?? 'Unknown error',
    );
  }
}
