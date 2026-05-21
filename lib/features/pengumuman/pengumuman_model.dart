class Pagination {
  final int totalData;
  final int totalHalaman;
  final int halamanSekarang;
  final int dataPerHalaman;

  Pagination({
    required this.totalData,
    required this.totalHalaman,
    required this.halamanSekarang,
    required this.dataPerHalaman,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      totalData: json['total_data'] ?? 0,
      totalHalaman: json['total_halaman'] ?? 1,
      halamanSekarang: json['halaman_sekarang'] ?? 1,
      dataPerHalaman: json['data_per_halaman'] ?? 10,
    );
  }
}

class PengumumanResponse {
  final int statusCode;
  final String message;
  final List<Pengumuman> data;
  final Pagination? pagination;
  final ErrorMessage? error;

  PengumumanResponse({
    required this.statusCode,
    required this.message,
    required this.data,
    this.pagination,
    this.error,
  });

  factory PengumumanResponse.fromJson(Map<String, dynamic> json) {
    return PengumumanResponse(
      statusCode: json['statusCode'] ?? 500,
      message: json['message'] ?? 'Unknown error',
      data: (json['data'] as List?)
          ?.map((e) => Pengumuman.fromJson(e))
          .toList() ?? [],
      pagination: json['pagination'] != null 
          ? Pagination.fromJson(json['pagination']) 
          : null,
      error: json['error'] != null ? ErrorMessage.fromJson(json['error']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
      'error': error?.toJson(),
    };
  }
}

class Pengumuman {
  final String id;
  final String judul;
  final String deskripsi;
  final String tempat;
  final DateTime tanggal;
  final DateTime updatedAt;
  final DateTime createdAt;

  Pengumuman({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.tempat,
    required this.tanggal,
    required this.updatedAt,
    required this.createdAt,
  });

  factory Pengumuman.fromJson(Map<String, dynamic> json) {
    return Pengumuman(
      id: json['id']?.toString() ?? '',
      judul: json['judul_pengumuman'] ?? 'Tidak ada judul',
      deskripsi: json['deskripsi_pengumuman'] ?? 'Tidak ada deskripsi',
      tempat: json['tempat_pengumuman'] ?? 'Tidak ada tempat',
      tanggal: DateTime.parse(json['tanggal_pengumuman'] ?? DateTime.now().toString()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toString()),
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul_pengumuman': judul,
      'deskripsi_pengumuman': deskripsi,
      'tempat_pengumuman': tempat,
      'tanggal_pengumuman': tanggal.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
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
    return {'message': message};
  }
}