class RoleUserResponse {
  final int statusCode;
  final String message;
  final List<RoleUser> data;
  final String? error;

  RoleUserResponse({
    required this.statusCode,
    required this.message,
    required this.data,
    this.error,
  });

  factory RoleUserResponse.fromJson(Map<String, dynamic> json) {
    return RoleUserResponse(
      statusCode: json['statusCode'],
      message: json['message'],
      data: (json['data'] as List).map((i) => RoleUser.fromJson(i)).toList(),
      error: json['error'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'message': message,
      'data': data.map((roleUser) => roleUser.toJson()).toList(),
      'error': error,
    };
  }
}

class RoleUser {
  final String id;
  final String name;

  RoleUser({
    required this.id,
    required this.name,
  });

  factory RoleUser.fromJson(Map<String, dynamic> json) {
    return RoleUser(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
