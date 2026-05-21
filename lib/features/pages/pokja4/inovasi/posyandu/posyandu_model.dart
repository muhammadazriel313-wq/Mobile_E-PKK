
/// =======================================================
/// FILE : report_posyandu_model.dart
/// =======================================================

class ReportPosyanduModel {
  final int statusCode;

  final String message;

  final PosyanduEntry data;

  final dynamic error;

  ReportPosyanduModel({
    required this.statusCode,
    required this.message,
    required this.data,
    this.error,
  });

  factory ReportPosyanduModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ReportPosyanduModel(
      statusCode: json['status_code'] ?? 0,

      message: json['message'] ?? '',

      data: PosyanduEntry.fromJson(
        json['data'] ?? {},
      ),

      error: json['error'],
    );
  }
}

/// =======================================================
/// POSYANDU ENTRY
/// =======================================================

class PosyanduEntry {
  final String? idPosyandu;

  final String? uuid;

  final String? idUser;

  final String? kategori;

  final String? bulan;

  final String? jmlIbuHamil;

  final String? diperiksa;

  final String? feTabletDarah;

  final String? jmlIbuMenyusui;

  final String? kondom;

  final String? pil;

  final String? implant;

  final String? mop;

  final String? mow;

  final String? iud;

  final String? suntikan;

  /// ================= TAMBAHAN =================

  final String? lainLainKb;

  final String? jmlBalitaL;

  final String? jmlBalitaP;

  final String? bukuKiaL;

  final String? bukuKiaP;

  final String? datangL;

  final String? datangP;

  final String? naikL;

  final String? naikP;

  final String? vitAL;

  final String? vitAP;

  final String? pmtL;

  final String? pmtP;

  final String? imunisasiTt1;

  final String? imunisasiTt2;

  final String? status;

  final String? createdAt;

  final String? updatedAt;

  final dynamic role;

  final dynamic organization;

  PosyanduEntry({
    this.idPosyandu,
    this.uuid,
    this.idUser,
    this.kategori,
    this.bulan,
    this.jmlIbuHamil,
    this.diperiksa,
    this.feTabletDarah,
    this.jmlIbuMenyusui,
    this.kondom,
    this.pil,
    this.implant,
    this.mop,
    this.mow,
    this.iud,
    this.suntikan,

    /// ================= TAMBAHAN =================
    this.lainLainKb,

    this.jmlBalitaL,
    this.jmlBalitaP,
    this.bukuKiaL,
    this.bukuKiaP,
    this.datangL,
    this.datangP,
    this.naikL,
    this.naikP,
    this.vitAL,
    this.vitAP,
    this.pmtL,
    this.pmtP,
    this.imunisasiTt1,
    this.imunisasiTt2,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.role,
    this.organization,
  });

  factory PosyanduEntry.fromJson(
    Map<String, dynamic> json,
  ) {
    return PosyanduEntry(
      idPosyandu:
          json['id_posyandu']?.toString(),

      uuid: json['uuid']?.toString(),

      idUser:
          json['id_user']?.toString(),

      kategori:
          json['kategori']?.toString(),

      bulan:
          json['bulan']?.toString(),

      jmlIbuHamil:
          json['jml_ibu_hamil']
              ?.toString(),

      diperiksa:
          json['diperiksa']
              ?.toString(),

      feTabletDarah:
          json['fe_tablet_darah']
              ?.toString(),

      jmlIbuMenyusui:
          json['jml_ibu_menyusui']
              ?.toString(),

      kondom:
          json['kondom']
              ?.toString(),

      pil:
          json['pil']
              ?.toString(),

      implant:
          json['implant']
              ?.toString(),

      mop:
          json['mop']
              ?.toString(),

      mow:
          json['mow']
              ?.toString(),

      iud:
          json['iud']
              ?.toString(),

      suntikan:
          json['suntikan']
              ?.toString(),

      /// ================= TAMBAHAN =================

      lainLainKb:
          json['lain_lain_kb']
              ?.toString(),

      jmlBalitaL:
          json['jml_balita_l']
              ?.toString(),

      jmlBalitaP:
          json['jml_balita_p']
              ?.toString(),

      bukuKiaL:
          json['buku_kia_l']
              ?.toString(),

      bukuKiaP:
          json['buku_kia_p']
              ?.toString(),

      datangL:
          json['datang_l']
              ?.toString(),

      datangP:
          json['datang_p']
              ?.toString(),

      naikL:
          json['naik_l']
              ?.toString(),

      naikP:
          json['naik_p']
              ?.toString(),

      vitAL:
          json['vit_a_l']
              ?.toString(),

      vitAP:
          json['vit_a_p']
              ?.toString(),

      pmtL:
          json['pmt_l']
              ?.toString(),

      pmtP:
          json['pmt_p']
              ?.toString(),

      imunisasiTt1:
          json['imunisasi_tt_1']
              ?.toString(),

      imunisasiTt2:
          json['imunisasi_tt_2']
              ?.toString(),

      status:
          json['status']
              ?.toString(),

      createdAt:
          json['created_at']
              ?.toString(),

      updatedAt:
          json['updated_at']
              ?.toString(),

      role: json['role'],

      organization:
          json['organization'],
    );
  }

  /// =======================================================
  /// TO REQUEST
  /// =======================================================

  Map<String, dynamic> toRequest({
    required String idUser,
    required String idRole,
    required String idOrganization,
  }) {
    return {
      'id_user': idUser,

      'id_role': idRole,

      'id_organization':
          idOrganization,

      'kategori': kategori,

      'bulan': bulan,

      'jml_ibu_hamil':
          jmlIbuHamil,

      'diperiksa': diperiksa,

      'fe_tablet_darah':
          feTabletDarah,

      'jml_ibu_menyusui':
          jmlIbuMenyusui,

      'kondom': kondom,

      'pil': pil,

      'implant': implant,

      'mop': mop,

      'mow': mow,

      'iud': iud,

      'suntikan': suntikan,

      /// ================= TAMBAHAN =================

      'lain_lain_kb':
          lainLainKb,

      'jml_balita_l':
          jmlBalitaL,

      'jml_balita_p':
          jmlBalitaP,

      'buku_kia_l':
          bukuKiaL,

      'buku_kia_p':
          bukuKiaP,

      'datang_l':
          datangL,

      'datang_p':
          datangP,

      'naik_l':
          naikL,

      'naik_p':
          naikP,

      'vit_a_l':
          vitAL,

      'vit_a_p':
          vitAP,

      'pmt_l':
          pmtL,

      'pmt_p':
          pmtP,

      'imunisasi_tt_1':
          imunisasiTt1,

      'imunisasi_tt_2':
          imunisasiTt2,
    };
  }
}

/// =======================================================
/// EMPTY EXTENSION
/// =======================================================

extension PosyanduEntryExtension
    on PosyanduEntry {
  static PosyanduEntry empty() {
    return PosyanduEntry(
      idPosyandu: '',

      uuid: '',

      idUser: '',

      kategori: '',

      bulan: '',

      jmlIbuHamil: '',

      diperiksa: '',

      feTabletDarah: '',

      jmlIbuMenyusui: '',

      kondom: '',

      pil: '',

      implant: '',

      mop: '',

      mow: '',

      iud: '',

      suntikan: '',

      /// ================= TAMBAHAN =================

      lainLainKb: '',

      jmlBalitaL: '',

      jmlBalitaP: '',

      bukuKiaL: '',

      bukuKiaP: '',

      datangL: '',

      datangP: '',

      naikL: '',

      naikP: '',

      vitAL: '',

      vitAP: '',

      pmtL: '',

      pmtP: '',

      imunisasiTt1: '',

      imunisasiTt2: '',

      status: '',

      createdAt: '',

      updatedAt: '',

      role: null,

      organization: null,
    );
  }
}
