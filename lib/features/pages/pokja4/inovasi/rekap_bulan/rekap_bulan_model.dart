class ReportRekapDesaBulananModel {
  final int statusCode;

  final String message;

  final RekapDesaBulananEntry data;

  final dynamic error;

  ReportRekapDesaBulananModel({
    required this.statusCode,

    required this.message,

    required this.data,

    this.error,
  });

  factory ReportRekapDesaBulananModel.fromJson(Map<String, dynamic> json) {
    return ReportRekapDesaBulananModel(
      statusCode: json['status_code'] ?? 0,

      message: json['message'] ?? '',

      data: RekapDesaBulananEntry.fromJson(json['data'] ?? {}),

      error: json['error'],
    );
  }
}

class RekapDesaBulananEntry {
  final String? idRekapDesaBulanan;

  final String? uuid;

  final String? idUser;

  final String? kategori;

  final String? rw;

  final String? rt;

  final String? dasaWisma;

  final String? hamil;

  final String? melahirkan;

  final String? nifas;

  final String? meninggal;

  final String? bayiLahirL;

  final String? bayiLahirP;

  final String? akteKelahiranAda;

  final String? akteKelahiranTidak;

  final String? bayiMeninggalL;

  final String? bayiMeninggalP;

  final String? balitaMeninggalL;

  final String? balitaMeninggalP;

  final String? keterangan;

  final String? status;

  final String? createdAt;

  final String? updatedAt;

  final dynamic role;

  final dynamic organization;

  RekapDesaBulananEntry({
    this.idRekapDesaBulanan,

    this.uuid,

    this.idUser,

    this.kategori,

    this.rw,

    this.rt,

    this.dasaWisma,

    this.hamil,

    this.melahirkan,

    this.nifas,

    this.meninggal,

    this.bayiLahirL,

    this.bayiLahirP,

    this.akteKelahiranAda,

    this.akteKelahiranTidak,

    this.bayiMeninggalL,

    this.bayiMeninggalP,

    this.balitaMeninggalL,

    this.balitaMeninggalP,

    this.keterangan,

    this.status,

    this.createdAt,

    this.updatedAt,

    this.role,

    this.organization,
  });

  factory RekapDesaBulananEntry.fromJson(Map<String, dynamic> json) {
    return RekapDesaBulananEntry(
      idRekapDesaBulanan: json['id_rekap_desa_bulanan']?.toString(),

      uuid: json['uuid']?.toString(),

      idUser: json['id_user']?.toString(),

      kategori: json['kategori']?.toString(),

      rw: json['rw']?.toString(),

      rt: json['rt']?.toString(),

      dasaWisma: json['dasa_wisma']?.toString(),

      hamil: json['hamil']?.toString(),

      melahirkan: json['melahirkan']?.toString(),

      nifas: json['nifas']?.toString(),

      meninggal: json['meninggal']?.toString(),

      bayiLahirL: json['bayi_lahir_l']?.toString(),

      bayiLahirP: json['bayi_lahir_p']?.toString(),

      akteKelahiranAda: json['akte_kelahiran_ada']?.toString(),

      akteKelahiranTidak: json['akte_kelahiran_tidak']?.toString(),

      bayiMeninggalL: json['bayi_meninggal_l']?.toString(),

      bayiMeninggalP: json['bayi_meninggal_p']?.toString(),

      balitaMeninggalL: json['balita_meninggal_l']?.toString(),

      balitaMeninggalP: json['balita_meninggal_p']?.toString(),

      keterangan: json['keterangan']?.toString(),

      status: json['status']?.toString(),

      createdAt: json['created_at']?.toString(),

      updatedAt: json['updated_at']?.toString(),

      role: json['role'],

      organization: json['organization'],
    );
  }

  Map<String, dynamic> toRequest({
    required String idUser,

    required String idRole,

    required String idOrganization,
  }) {
    return {
      'id_user': idUser,

      'id_role': idRole,

      'id_organization': idOrganization,

      'kategori': kategori,

      'rw': rw,

      'rt': rt,

      'dasa_wisma': dasaWisma,

      'hamil': hamil,

      'melahirkan': melahirkan,

      'nifas': nifas,

      'meninggal': meninggal,

      'bayi_lahir_l': bayiLahirL,

      'bayi_lahir_p': bayiLahirP,

      'akte_kelahiran_ada': akteKelahiranAda,

      'akte_kelahiran_tidak': akteKelahiranTidak,

      'bayi_meninggal_l': bayiMeninggalL,

      'bayi_meninggal_p': bayiMeninggalP,

      'balita_meninggal_l': balitaMeninggalL,

      'balita_meninggal_p': balitaMeninggalP,

      'keterangan': keterangan,
    };
  }
}

/// ===============================
/// EMPTY EXTENSION
/// ===============================

extension RekapDesaBulananEntryExtension on RekapDesaBulananEntry {
  static RekapDesaBulananEntry empty() {
    return RekapDesaBulananEntry(
      idRekapDesaBulanan: '',

      uuid: '',

      idUser: '',

      kategori: '',

      rw: '',

      rt: '',

      dasaWisma: '',

      hamil: '',

      melahirkan: '',

      nifas: '',

      meninggal: '',

      bayiLahirL: '',

      bayiLahirP: '',

      akteKelahiranAda: '',

      akteKelahiranTidak: '',

      bayiMeninggalL: '',

      bayiMeninggalP: '',

      balitaMeninggalL: '',

      balitaMeninggalP: '',

      keterangan: '',

      status: '',

      createdAt: '',

      updatedAt: '',

      role: null,

      organization: null,
    );
  }
}
