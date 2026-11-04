import 'dart:convert';

class DraftModel {
  final String id; // UUID
  final String idAkun; // id_user
  final String jenis; // 'pancasila', 'gotong_royong', 'kader_pokja1', 'galeri'
  final Map<String, dynamic> dataForm;
  final List<String> daftarFoto; // Local paths
  final String tanggalDibuat; // ISO 8601 string
  final String status; // 'draf', 'mengirim', 'gagal_kirim'
  final String? pesanError;

  DraftModel({
    required this.id,
    required this.idAkun,
    required this.jenis,
    required this.dataForm,
    required this.daftarFoto,
    required this.tanggalDibuat,
    required this.status,
    this.pesanError,
  });

  DraftModel copyWith({
    String? id,
    String? idAkun,
    String? jenis,
    Map<String, dynamic>? dataForm,
    List<String>? daftarFoto,
    String? tanggalDibuat,
    String? status,
    String? pesanError,
  }) {
    return DraftModel(
      id: id ?? this.id,
      idAkun: idAkun ?? this.idAkun,
      jenis: jenis ?? this.jenis,
      dataForm: dataForm ?? this.dataForm,
      daftarFoto: daftarFoto ?? this.daftarFoto,
      tanggalDibuat: tanggalDibuat ?? this.tanggalDibuat,
      status: status ?? this.status,
      pesanError: pesanError ?? this.pesanError,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_akun': idAkun,
      'jenis': jenis,
      'data_form': jsonEncode(dataForm),
      'daftar_foto': jsonEncode(daftarFoto),
      'tanggal_dibuat': tanggalDibuat,
      'status': status,
      'pesan_error': pesanError,
    };
  }

  factory DraftModel.fromMap(Map<String, dynamic> map) {
    Map<String, dynamic> parsedDataForm = {};
    if (map['data_form'] != null) {
      if (map['data_form'] is String) {
        try {
          parsedDataForm = jsonDecode(map['data_form'] as String);
        } catch (_) {}
      } else if (map['data_form'] is Map) {
        parsedDataForm = Map<String, dynamic>.from(map['data_form'] as Map);
      }
    }

    List<String> parsedFoto = [];
    if (map['daftar_foto'] != null) {
      if (map['daftar_foto'] is String) {
        try {
          final decoded = jsonDecode(map['daftar_foto'] as String);
          if (decoded is List) {
            parsedFoto = decoded.map((e) => e.toString()).toList();
          }
        } catch (_) {}
      } else if (map['daftar_foto'] is List) {
        parsedFoto = (map['daftar_foto'] as List).map((e) => e.toString()).toList();
      }
    }

    return DraftModel(
      id: map['id']?.toString() ?? '',
      idAkun: map['id_akun']?.toString() ?? '',
      jenis: map['jenis']?.toString() ?? '',
      dataForm: parsedDataForm,
      daftarFoto: parsedFoto,
      tanggalDibuat: map['tanggal_dibuat']?.toString() ?? DateTime.now().toIso8601String(),
      status: map['status']?.toString() ?? 'draf',
      pesanError: map['pesan_error']?.toString(),
    );
  }

  String getRingkasan() {
    switch (jenis) {
      case 'pancasila':
        for (final k in ['kisah_kegiatan', 'krisan_kegiatan', 'kilas_kegiatan', 'kiat_kegiatan', 'kisak_kegiatan', 'pkbn_kegiatan']) {
          final val = dataForm[k]?.toString().trim() ?? '';
          if (val.isNotEmpty) return val;
        }
        return 'Penghayatan & Pengamalan Pancasila';
      case 'gotong_royong':
        for (final k in ['kerja_bakti_kegiatan', 'bantuan_yatim_kegiatan', 'kegiatan_sosial_kegiatan']) {
          final val = dataForm[k]?.toString().trim() ?? '';
          if (val.isNotEmpty) return val;
        }
        return 'Gotong Royong';
      case 'kader_pokja1':
        final umum = dataForm['kader_umum']?.toString().trim() ?? '';
        final khusus = dataForm['kader_khusus']?.toString().trim() ?? '';
        if (umum.isNotEmpty || khusus.isNotEmpty) {
          return 'Kader Umum: ${umum.isEmpty ? "0" : umum}, Khusus: ${khusus.isEmpty ? "0" : khusus}';
        }
        return 'Kader Pokja 1';
      case 'galeri':
        final desc = dataForm['deskripsi']?.toString().trim() ?? '';
        if (desc.isNotEmpty) return desc;
        return 'Galeri Kegiatan';
      default:
        return 'Laporan Draf';
    }
  }

  String getJudulJenis() {
    switch (jenis) {
      case 'pancasila':
        return 'Pengamalan Pancasila';
      case 'gotong_royong':
        return 'Gotong Royong';
      case 'kader_pokja1':
        return 'Kader Pokja 1';
      case 'galeri':
        return 'Galeri';
      default:
        return 'Laporan';
    }
  }
}

