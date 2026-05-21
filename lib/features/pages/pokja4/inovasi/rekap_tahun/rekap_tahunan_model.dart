class ReportRekapDesaTahunanModel {
  final int statusCode;

  final String message;

  final RekapDesaTahunanEntry data;

  final dynamic error;

  ReportRekapDesaTahunanModel({
    required this.statusCode,
    required this.message,
    required this.data,
    this.error,
  });

  factory ReportRekapDesaTahunanModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ReportRekapDesaTahunanModel(
      statusCode: json['status_code'] ?? 0,
      message: json['message'] ?? '',
      data: RekapDesaTahunanEntry.fromJson(json['data'] ?? {}),
      error: json['error'],
    );
  }
}

class RekapDesaTahunanEntry {
  final String? idRekapDesaTahunan;

  final String? uuid;

  final String? idUser;

  final String? kategori;

  final String? kaderKesehatan;

  final String? gizi;

  final String? kesling;

  final String? phbs;

  final String? kb;

  final String? posyandu;

  final String? imunisasiVaksinasiBayiBalita;

  final String? pkg;

  final String? tbc;

  final String? jambanWc;

  final String? spal;

  final String? tps;

  final String? jumlahMck;

  final String? pdam;

  final String? sumur;

  final String? lainLain;

  final String? jmlPus;

  final String? jmlWus;

  final String? akseptorKbL;

  final String? akseptorKbP;

  final String? jmlKkTabungan;

  final String? jmlKkAsuransi;

  final String? kesehatanProgram;

  final String? kelestarianLingkunganHidup;

  final String? perencanaanSehatProgram;

  final String? catatan;

  final String? status;

  final String? createdAt;

  final String? updatedAt;

  final dynamic role;

  final dynamic organization;

  RekapDesaTahunanEntry({
    this.idRekapDesaTahunan,
    this.uuid,
    this.idUser,
    this.kategori,
    this.kaderKesehatan,
    this.gizi,
    this.kesling,
    this.phbs,
    this.kb,
    this.posyandu,
    this.imunisasiVaksinasiBayiBalita,
    this.pkg,
    this.tbc,
    this.jambanWc,
    this.spal,
    this.tps,
    this.jumlahMck,
    this.pdam,
    this.sumur,
    this.lainLain,
    this.jmlPus,
    this.jmlWus,
    this.akseptorKbL,
    this.akseptorKbP,
    this.jmlKkTabungan,
    this.jmlKkAsuransi,
    this.kesehatanProgram,
    this.kelestarianLingkunganHidup,
    this.perencanaanSehatProgram,
    this.catatan,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.role,
    this.organization,
  });

  factory RekapDesaTahunanEntry.fromJson(
    Map<String, dynamic> json,
  ) {
    return RekapDesaTahunanEntry(
      idRekapDesaTahunan:
          json['id_rekap_desa_tahunan']?.toString(),

      uuid: json['uuid']?.toString(),

      idUser: json['id_user']?.toString(),

      kategori: json['kategori']?.toString(),

      kaderKesehatan:
          json['kader_kesehatan']?.toString(),

      gizi: json['gizi']?.toString(),

      kesling: json['kesling']?.toString(),

      phbs: json['phbs']?.toString(),

      kb: json['kb']?.toString(),

      posyandu: json['posyandu']?.toString(),

      imunisasiVaksinasiBayiBalita:
          json['imunisasi_vaksinasi_bayi_balita']
              ?.toString(),

      pkg: json['pkg']?.toString(),

      tbc: json['tbc']?.toString(),

      jambanWc: json['jamban_wc']?.toString(),

      spal: json['spal']?.toString(),

      tps: json['tps']?.toString(),

      jumlahMck: json['jumlah_mck']?.toString(),

      pdam: json['pdam']?.toString(),

      sumur: json['sumur']?.toString(),

      lainLain: json['lain_lain']?.toString(),

      jmlPus: json['jml_pus']?.toString(),

      jmlWus: json['jml_wus']?.toString(),

      akseptorKbL:
          json['akseptor_kb_l']?.toString(),

      akseptorKbP:
          json['akseptor_kb_p']?.toString(),

      jmlKkTabungan:
          json['jml_kk_tabungan']?.toString(),

      jmlKkAsuransi:
          json['jml_kk_asuransi']?.toString(),

      kesehatanProgram:
          json['kesehatan_program']?.toString(),

      kelestarianLingkunganHidup:
          json['kelestarian_lingkungan_hidup']
              ?.toString(),

      perencanaanSehatProgram:
          json['perencanaan_sehat_program']
              ?.toString(),

      catatan: json['catatan']?.toString(),

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
      'kader_kesehatan': kaderKesehatan,
      'gizi': gizi,
      'kesling': kesling,
      'phbs': phbs,
      'kb': kb,
      'posyandu': posyandu,
      'imunisasi_vaksinasi_bayi_balita':
          imunisasiVaksinasiBayiBalita,
      'pkg': pkg,
      'tbc': tbc,
      'jamban_wc': jambanWc,
      'spal': spal,
      'tps': tps,
      'jumlah_mck': jumlahMck,
      'pdam': pdam,
      'sumur': sumur,
      'lain_lain': lainLain,
      'jml_pus': jmlPus,
      'jml_wus': jmlWus,
      'akseptor_kb_l': akseptorKbL,
      'akseptor_kb_p': akseptorKbP,
      'jml_kk_tabungan': jmlKkTabungan,
      'jml_kk_asuransi': jmlKkAsuransi,
      'kesehatan_program': kesehatanProgram,
      'kelestarian_lingkungan_hidup':
          kelestarianLingkunganHidup,
      'perencanaan_sehat_program':
          perencanaanSehatProgram,
      'catatan': catatan,
    };
  }
}

/// ===============================
/// EMPTY EXTENSION
/// ===============================

extension RekapDesaTahunanEntryExtension
    on RekapDesaTahunanEntry {
  static RekapDesaTahunanEntry empty() {
    return RekapDesaTahunanEntry(
      idRekapDesaTahunan: '',
      uuid: '',
      idUser: '',
      kategori: '',
      kaderKesehatan: '',
      gizi: '',
      kesling: '',
      phbs: '',
      kb: '',
      posyandu: '',
      imunisasiVaksinasiBayiBalita: '',
      pkg: '',
      tbc: '',
      jambanWc: '',
      spal: '',
      tps: '',
      jumlahMck: '',
      pdam: '',
      sumur: '',
      lainLain: '',
      jmlPus: '',
      jmlWus: '',
      akseptorKbL: '',
      akseptorKbP: '',
      jmlKkTabungan: '',
      jmlKkAsuransi: '',
      kesehatanProgram: '',
      kelestarianLingkunganHidup: '',
      perencanaanSehatProgram: '',
      catatan: '',
      status: '',
      createdAt: '',
      updatedAt: '',
      role: null,
      organization: null,
    );
  }
}