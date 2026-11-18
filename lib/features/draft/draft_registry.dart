import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:epkk_nganjuk/features/draft/draft_model.dart';
import 'package:epkk_nganjuk/features/laporan/laporan_umum/laporan_umum_controller.dart';
import 'package:epkk_nganjuk/features/laporan/upload_galeri/upload_galerii_controller.dart';
import 'package:epkk_nganjuk/features/pages/pokja1/gotongroyong/gotong_royong_controller.dart';
import 'package:epkk_nganjuk/features/pages/pokja1/kaderpokja1/kader_pokja1_controller.dart';
import 'package:epkk_nganjuk/features/pages/pokja2/pendidikan/pendidikan_ketrampilan_controller.dart';
import 'package:epkk_nganjuk/features/pages/pokja2/pengembangan/pengembangan_kehidupan_controller.dart';
import 'package:epkk_nganjuk/features/pages/pokja3/jumlah_kader/kader_pokja3_controller.dart';
import 'package:epkk_nganjuk/features/pages/pokja3/pangan/pangan_controller.dart';
import 'package:epkk_nganjuk/features/pages/pokja3/perumahan/perumahan_controller.dart';
import 'package:epkk_nganjuk/features/pages/pokja3/sandang/sandang_controller.dart';
import 'package:epkk_nganjuk/features/pages/pokja4/jumlah_rumah/perencanaan_controller.dart';
import 'package:epkk_nganjuk/features/pages/pokja4/kader_pokja4/kader_pokja4_controller.dart';
import 'package:epkk_nganjuk/features/pages/pokja4/kelestarian/kelestarian_controller.dart';
import 'package:epkk_nganjuk/features/pages/pokja4/kesehatan/kesehatan_controller.dart';
import 'package:epkk_nganjuk/features/pages/pokja4/inovasi/kegiatanpokja4/kegiatan_pokja4_controller.dart';
import 'package:epkk_nganjuk/features/pages/pokja4/inovasi/posyandu/posyandu_controller.dart';
import 'package:epkk_nganjuk/routes/app_routes.dart';
import 'package:get/get.dart';

class DraftSendResult {
  final bool success;
  final String? message;
  final bool networkFailure;

  const DraftSendResult({
    required this.success,
    this.message,
    this.networkFailure = false,
  });
}

class DraftRegistration {
  final String key;
  final String title;
  final String route;
  final bool galeri;
  final Future<DraftSendResult> Function(DraftModel draft)? sender;

  const DraftRegistration({
    required this.key,
    required this.title,
    required this.route,
    this.galeri = false,
    this.sender,
  });
}

class DraftRegistry {
  static final Map<String, DraftRegistration> entries = {
    'pancasila': DraftRegistration(
      key: 'pancasila',
      title: 'Penghayatan & Pengamalan Pancasila',
      route: Routes.PENGHAYATAN,
    ),
    'gotong_royong': DraftRegistration(
      key: 'gotong_royong',
      title: 'Gotong Royong',
      route: Routes.GOTONG_ROYONG,
      sender: _sendGotongRoyong,
    ),
    'kader_pokja1': DraftRegistration(
      key: 'kader_pokja1',
      title: 'Kader Pokja 1',
      route: Routes.KADER_POKJA1,
      sender: _sendKaderPokja1,
    ),
    'galeri': DraftRegistration(
      key: 'galeri',
      title: 'Upload Kegiatan',
      route: Routes.UPLOAD_GALERI,
      galeri: true,
      sender: _sendGaleri,
    ),
    'laporan_umum': DraftRegistration(
      key: 'laporan_umum',
      title: 'Laporan Umum',
      route: Routes.LAPORAN_UMUM1,
      sender: _sendLaporanUmum,
    ),
    'pengembangan': DraftRegistration(
      key: 'pengembangan',
      title: 'Pengembangan Kehidupan Berkoperasi',
      route: Routes.PENGEMBANGAN1,
      sender: _sendPengembangan,
    ),
    'pendidikan': DraftRegistration(
      key: 'pendidikan',
      title: 'Pendidikan Ketrampilan',
      route: Routes.PENDIDIKAN1,
      sender: _sendPendidikan,
    ),
    'kader_pokja3': DraftRegistration(
      key: 'kader_pokja3',
      title: 'Kader Pokja III',
      route: Routes.KADER_POKJA3,
      sender: _sendKaderPokja3,
    ),
    'pangan': DraftRegistration(
      key: 'pangan',
      title: 'Pangan',
      route: Routes.PANGAN1,
      sender: _sendPangan,
    ),
    'sandang': DraftRegistration(
      key: 'sandang',
      title: 'Industri Rumah Tangga',
      route: Routes.SANDANG,
      sender: _sendSandang,
    ),
    'perumahan': DraftRegistration(
      key: 'perumahan',
      title: 'Perumahan & Tata Laksana',
      route: Routes.PERUMAHAN,
      sender: _sendPerumahan,
    ),
    'kader_pokja4': DraftRegistration(
      key: 'kader_pokja4',
      title: 'Kader Pokja IV',
      route: Routes.KADER_POKJA4,
      sender: _sendKaderPokja4,
    ),
    'kesehatan': DraftRegistration(
      key: 'kesehatan',
      title: 'Kesehatan',
      route: Routes.KESEHATAN,
      sender: _sendKesehatan,
    ),
    'perencanaan': DraftRegistration(
      key: 'perencanaan',
      title: 'Jumlah Rumah Yang Memiliki',
      route: Routes.PERENCANAAN,
      sender: _sendPerencanaan,
    ),
    'kelestarian': DraftRegistration(
      key: 'kelestarian',
      title: 'Kelestarian Lingkungan',
      route: Routes.KELESTARIAN1,
      sender: _sendKelestarian,
    ),
    'inovasi_kegiatan': DraftRegistration(
      key: 'inovasi_kegiatan',
      title: 'Inovasi - Kegiatan Pokja 4',
      route: Routes.KEGIATAN_POKJA4_1,
      sender: _sendInovasiKegiatan,
    ),
    'inovasi_posyandu': DraftRegistration(
      key: 'inovasi_posyandu',
      title: 'Inovasi - Posyandu',
      route: Routes.POSYANDU_1,
      sender: _sendInovasiPosyandu,
    ),
  };

  static DraftRegistration? lookup(String key) => entries[key];

  static List<String> get laporanJenis =>
      entries.values.where((entry) => !entry.galeri).map((entry) => entry.key).toList();

  static List<String> get galeriJenis =>
      entries.values.where((entry) => entry.galeri).map((entry) => entry.key).toList();

  static Future<DraftSendResult> _sendGotongRoyong(DraftModel draft) async {
    final controller = Get.isRegistered<GotongRoyongController>()
        ? Get.find<GotongRoyongController>()
        : Get.put(GotongRoyongController());
    final data = draft.dataForm;
    final success = await controller.submitGotongRoyong(
      idUser: draft.idAkun,
      idRole: data['id_role']?.toString() ?? '',
      idOrganization: data['id_organization']?.toString() ?? '',
      kerjaBaktiKegiatan: data['kerja_bakti_kegiatan']?.toString(),
      kerjaBaktiVol: data['kerja_bakti_vol']?.toString(),
      kerjaBaktiMetode: data['kerja_bakti_metode']?.toString(),
      kerjaBaktiSasaran: data['kerja_bakti_sasaran']?.toString(),
      bantuanYatimKegiatan: data['bantuan_yatim_kegiatan']?.toString(),
      bantuanYatimVol: data['bantuan_yatim_vol']?.toString(),
      bantuanYatimMetode: data['bantuan_yatim_metode']?.toString(),
      bantuanYatimSasaran: data['bantuan_yatim_sasaran']?.toString(),
      kegiatanSosialKegiatan: data['kegiatan_sosial_kegiatan']?.toString(),
      kegiatanSosialVol: data['kegiatan_sosial_vol']?.toString(),
      kegiatanSosialMetode: data['kegiatan_sosial_metode']?.toString(),
      kegiatanSosialSasaran: data['kegiatan_sosial_sasaran']?.toString(),
      sumberDana: data['sumber_dana']?.toString(),
      hasilKegiatan: data['hasil_kegiatan']?.toString(),
    );
    return DraftSendResult(
      success: success,
      message: success ? null : controller.errorMessage.value,
    );
  }

  static Future<DraftSendResult> _sendKaderPokja1(DraftModel draft) async {
    final controller = Get.isRegistered<UploadReportController>()
        ? Get.find<UploadReportController>()
        : Get.put(UploadReportController());
    controller.reportKaderPokja1Model.value = null;
    final data = draft.dataForm;
    await controller.createKaderPokja1Controller(
      id_user: draft.idAkun,
      kader_umum: data['kader_umum']?.toString() ?? '',
      kader_khusus: data['kader_khusus']?.toString() ?? '',
      id_role: data['id_role']?.toString() ?? '',
      id_organization: data['id_organization']?.toString() ?? '',
    );
    final result = controller.reportKaderPokja1Model.value;
    return DraftSendResult(
      success: result?.statusCode == 200,
      message: result?.message ?? controller.errorMessage.value,
      networkFailure: controller.lastFailureWasNetwork.value,
    );
  }

  static Future<DraftSendResult> _sendGaleri(DraftModel draft) async {
    final controller = Get.isRegistered<GaleriController>()
        ? Get.find<GaleriController>()
        : Get.put(GaleriController());
    controller.galeriData.value = null;
    final data = draft.dataForm;

    Uint8List? gambarBytes;
    String gambarPath = '';
    String? namaFile;

    if (kIsWeb) {
      final base64Str = data['foto_base64']?.toString();
      if (base64Str != null && base64Str.isNotEmpty) {
        try {
          gambarBytes = base64Decode(base64Str);
        } catch (_) {}
      }
      namaFile = data['foto_nama']?.toString() ?? 'upload.jpg';
      gambarPath = namaFile;
    } else {
      if (draft.daftarFoto.isNotEmpty) {
        gambarPath = draft.daftarFoto.first;
      }
      namaFile = data['foto_nama']?.toString();
    }

    double? lat;
    if (data['latitude'] != null) {
      lat = double.tryParse(data['latitude'].toString());
    }
    double? lng;
    if (data['longitude'] != null) {
      lng = double.tryParse(data['longitude'].toString());
    }

    await controller.submitDataGaleri(
      idUser: draft.idAkun,
      deskripsi: data['deskripsi']?.toString() ?? '',
      gambar: gambarPath,
      gambarBytes: gambarBytes,
      namaFile: namaFile,
      pokja: data['pokja']?.toString() ?? '',
      bidang: data['bidang']?.toString() ?? '',
      idRole: data['id_role']?.toString() ?? '',
      idOrganization: data['id_organization']?.toString() ?? '',
      namaPeserta: () {
        final raw = data['nama_peserta'];
        if (raw == null) return <String>[];
        if (raw is List) return raw.map((e) => e.toString()).toList();
        if (raw is String && raw.trim().isNotEmpty) {
          try {
            final decoded = jsonDecode(raw);
            if (decoded is List) return decoded.map((e) => e.toString()).toList();
          } catch (_) {}
          return [raw];
        }
        return <String>[];
      }(),
      lokasi: data['lokasi']?.toString(),
      latitude: lat,
      longitude: lng,
      status: data['status']?.toString(),
    );

    final success = controller.galeriData.value != null;
    return DraftSendResult(
      success: success,
      message: success ? null : controller.errorMessage.value,
      networkFailure: controller.lastFailureWasNetwork.value,
    );
  }

  static Future<DraftSendResult> _sendLaporanUmum(DraftModel draft) async {
    final controller = Get.isRegistered<LaporanUmumController>()
        ? Get.find<LaporanUmumController>()
        : Get.put(LaporanUmumController());
    controller.reportData.value = null;
    final data = draft.dataForm;

    final requiredKeys = [
      'dusun_lingkungan',
      'PKK_RW',
      'PKK_RT',
      'desa_wisma',
      'KRT',
      'KK',
      'jiwa_laki',
      'jiwa_perempuan',
      'anggota_laki',
      'anggota_perempuan',
      'umum_laki',
      'umum_perempuan',
      'khusus_laki',
      'khusus_perempuan',
      'honorer_laki',
      'honorer_perempuan',
      'bantuan_laki',
      'bantuan_perempuan',
    ];

    final isComplete = requiredKeys.every((k) {
      final val = data[k]?.toString().trim() ?? '';
      return val.isNotEmpty;
    });

    if (!isComplete) {
      return const DraftSendResult(
        success: false,
        message: 'Draf belum lengkap. Buka Edit dan lengkapi isian.',
      );
    }

    await controller.submitUmumData(
      idUser: draft.idAkun,
      dusunLingkungan: data['dusun_lingkungan']?.toString() ?? '',
      pkkRw: data['PKK_RW']?.toString() ?? '',
      pkkRt: data['PKK_RT']?.toString() ?? '',
      desaWisma: data['desa_wisma']?.toString() ?? '',
      krt: data['KRT']?.toString() ?? '',
      kk: data['KK']?.toString() ?? '',
      jiwaLaki: data['jiwa_laki']?.toString() ?? '',
      jiwaPerempuan: data['jiwa_perempuan']?.toString() ?? '',
      anggotaLaki: data['anggota_laki']?.toString() ?? '',
      anggotaPerempuan: data['anggota_perempuan']?.toString() ?? '',
      umumLaki: data['umum_laki']?.toString() ?? '',
      umumPerempuan: data['umum_perempuan']?.toString() ?? '',
      khususLaki: data['khusus_laki']?.toString() ?? '',
      khususPerempuan: data['khusus_perempuan']?.toString() ?? '',
      honorerLaki: data['honorer_laki']?.toString() ?? '',
      honorerPerempuan: data['honorer_perempuan']?.toString() ?? '',
      bantuanLaki: data['bantuan_laki']?.toString() ?? '',
      bantuanPerempuan: data['bantuan_perempuan']?.toString() ?? '',
      idRole: data['id_role']?.toString() ?? '',
      idOrganization: data['id_organization']?.toString() ?? '',
      catatan: data['catatan']?.toString(),
    );

    final success = controller.reportData.value != null;
    return DraftSendResult(
      success: success,
      message: success ? null : controller.errorMessage.value,
      networkFailure: controller.lastFailureWasNetwork.value,
    );
  }

  static Future<DraftSendResult> _sendPengembangan(DraftModel draft) async {
    final controller = Get.isRegistered<PengembanganKehidupanController>()
        ? Get.find<PengembanganKehidupanController>()
        : Get.put(PengembanganKehidupanController());
    controller.reportData.value = null;
    final data = draft.dataForm;

    final requiredKeys = [
      'jumlah_kelompok_pemula',
      'jumlah_peserta_pemula',
      'jumlah_kelompok_madya',
      'jumlah_peserta_madya',
      'jumlah_kelompok_utama',
      'jumlah_peserta_utama',
      'jumlah_kelompok_mandiri',
      'jumlah_peserta_mandiri',
      'jumlah_kelompok_hukum',
      'jumlah_peserta_hukum',
    ];

    final isComplete = requiredKeys.every((k) {
      final val = data[k]?.toString().trim() ?? '';
      return val.isNotEmpty;
    });

    if (!isComplete) {
      return const DraftSendResult(
        success: false,
        message: 'Draf belum lengkap. Buka Edit dan lengkapi isian.',
      );
    }

    controller.idUser = draft.idAkun;
    controller.idRole = data['id_role']?.toString() ?? '';
    controller.idOrganization = data['id_organization']?.toString() ?? '';

    controller.setField(
      jumlahKelompokPemula: data['jumlah_kelompok_pemula']?.toString(),
      jumlahPesertaPemula: data['jumlah_peserta_pemula']?.toString(),
      jumlahKelompokMadya: data['jumlah_kelompok_madya']?.toString(),
      jumlahPesertaMadya: data['jumlah_peserta_madya']?.toString(),
      jumlahKelompokUtama: data['jumlah_kelompok_utama']?.toString(),
      jumlahPesertaUtama: data['jumlah_peserta_utama']?.toString(),
      jumlahKelompokMandiri: data['jumlah_kelompok_mandiri']?.toString(),
      jumlahPesertaMandiri: data['jumlah_peserta_mandiri']?.toString(),
      jumlahKelompokHukum: data['jumlah_kelompok_hukum']?.toString(),
      jumlahPesertaHukum: data['jumlah_peserta_hukum']?.toString(),
      catatan: data['catatan']?.toString(),
    );

    final success = await controller.submit();
    return DraftSendResult(
      success: success,
      message: success ? null : controller.errorMessage.value,
      networkFailure: controller.lastFailureWasNetwork.value,
    );
  }

  static Future<DraftSendResult> _sendPendidikan(DraftModel draft) async {
    final controller = Get.isRegistered<PendidikanKeterampilanController>()
        ? Get.find<PendidikanKeterampilanController>()
        : Get.put(PendidikanKeterampilanController());
    controller.reportData.value = null;
    final data = draft.dataForm;

    final requiredKeys = [
      'warga_buta',
      'kel_belajarA',
      'warga_belajarA',
      'kel_belajarB',
      'warga_belajarB',
      'kel_belajarC',
      'warga_belajarC',
      'kel_belajarKF',
      'warga_belajarKF',
      'paud',
      'taman_bacaan',
      'jumlah_klp',
      'jumlah_ibu_peserta',
      'jumlah_ape',
      'jumlah_kel_simulasi',
      'KF',
      'paud_tutor',
      'BKB',
      'koperasi',
      'ketrampilan',
      'LP3PKK',
      'TP3PKK',
      'damas_pkk',
    ];

    final isComplete = requiredKeys.every((k) {
      final val = data[k]?.toString().trim() ?? '';
      return val.isNotEmpty;
    });

    if (!isComplete) {
      return const DraftSendResult(
        success: false,
        message: 'Draf belum lengkap. Buka Edit dan lengkapi isian.',
      );
    }

    controller.idUser = draft.idAkun;
    controller.idRole = data['id_role']?.toString() ?? '';
    controller.idOrganization = data['id_organization']?.toString() ?? '';

    controller.restoreDraft(data);

    controller.setStep1(
      wargaButaVal: data['warga_buta']?.toString() ?? '',
      kelA: data['kel_belajarA']?.toString() ?? '',
      wargaA: data['warga_belajarA']?.toString() ?? '',
      kelB: data['kel_belajarB']?.toString() ?? '',
      wargaB: data['warga_belajarB']?.toString() ?? '',
    );

    controller.setStep2(
      kelC: data['kel_belajarC']?.toString() ?? '',
      wargaC: data['warga_belajarC']?.toString() ?? '',
      kelKF: data['kel_belajarKF']?.toString() ?? '',
      wargaKF: data['warga_belajarKF']?.toString() ?? '',
      paudVal: data['paud']?.toString() ?? '',
      taman: data['taman_bacaan']?.toString() ?? '',
    );

    controller.setStep3(
      klp: data['jumlah_klp']?.toString() ?? '',
      ibu: data['jumlah_ibu_peserta']?.toString() ?? '',
      ape: data['jumlah_ape']?.toString() ?? '',
      simulasi: data['jumlah_kel_simulasi']?.toString() ?? '',
      kfVal: data['KF']?.toString() ?? '',
      paudTutorVal: data['paud_tutor']?.toString() ?? '',
      bkbVal: data['BKB']?.toString() ?? '',
      koperasiVal: data['koperasi']?.toString() ?? '',
      ketrampilanVal: data['ketrampilan']?.toString() ?? '',
    );

    controller.setStep4(
      lp3: data['LP3PKK']?.toString() ?? '',
      tp3: data['TP3PKK']?.toString() ?? '',
      damas: data['damas_pkk']?.toString() ?? '',
    );

    final success = await controller.submitDraftData(data);
    return DraftSendResult(
      success: success,
      message: success ? null : controller.errorMessage.value,
      networkFailure: controller.lastFailureWasNetwork.value,
    );
  }

  static Future<DraftSendResult> _sendKaderPokja3(DraftModel draft) async {
    final controller = Get.isRegistered<KaderPokja3Controller>()
        ? Get.find<KaderPokja3Controller>()
        : Get.put(KaderPokja3Controller());
    controller.reportData.value = null;
    final data = draft.dataForm;

    final requiredKeys = ['pangan', 'sandang', 'tata_laksana_rumah'];
    final isComplete = requiredKeys.every((k) {
      final val = data[k]?.toString().trim() ?? '';
      return val.isNotEmpty;
    });

    if (!isComplete) {
      return const DraftSendResult(
        success: false,
        message: 'Draf belum lengkap. Buka Edit dan lengkapi isian.',
      );
    }

    controller.idUser = draft.idAkun;
    controller.idRole = data['id_role']?.toString() ?? '';
    controller.idOrganization = data['id_organization']?.toString() ?? '';

    controller.setField(
      pangan: data['pangan']?.toString(),
      sandang: data['sandang']?.toString(),
      tataLaksanaRumah: data['tata_laksana_rumah']?.toString(),
      catatan: data['catatan']?.toString(),
    );

    final success = await controller.submit();
    return DraftSendResult(
      success: success,
      message: success ? null : controller.errorMessage.value,
      networkFailure: controller.lastFailureWasNetwork.value,
    );
  }

  static Future<DraftSendResult> _sendPangan(DraftModel draft) async {
    final controller = Get.isRegistered<PanganController>()
        ? Get.find<PanganController>()
        : Get.put(PanganController());
    controller.reportData.value = null;
    final data = draft.dataForm;

    final requiredKeys = [
      'beras',
      'non_beras',
      'peternakan',
      'perikanan',
      'warung_hidup',
      'lumbung_hidup',
      'toga',
      'tanaman_keras',
      'tanaman_lainnya',
    ];
    final isComplete = requiredKeys.every((k) {
      final val = data[k]?.toString().trim() ?? '';
      return val.isNotEmpty;
    });

    if (!isComplete) {
      return const DraftSendResult(
        success: false,
        message: 'Draf belum lengkap. Buka Edit dan lengkapi isian.',
      );
    }

    final success = await controller.submitDataPangan(
      beras: data['beras']?.toString() ?? '',
      nonBeras: data['non_beras']?.toString() ?? '',
      peternakan: data['peternakan']?.toString() ?? '',
      perikanan: data['perikanan']?.toString() ?? '',
      warungHidup: data['warung_hidup']?.toString() ?? '',
      lumbungHidup: data['lumbung_hidup']?.toString() ?? '',
      toga: data['toga']?.toString() ?? '',
      tanamanKeras: data['tanaman_keras']?.toString() ?? '',
      tanamanLainnya: data['tanaman_lainnya']?.toString() ?? '',
      idUser: draft.idAkun,
      idRole: data['id_role']?.toString() ?? '',
      idOrganization: data['id_organization']?.toString() ?? '',
      catatan: data['catatan']?.toString(),
    );

    return DraftSendResult(
      success: success,
      message: success ? null : controller.errorMessage.value,
      networkFailure: controller.lastFailureWasNetwork.value,
    );
  }

  static Future<DraftSendResult> _sendSandang(DraftModel draft) async {
    final controller = Get.isRegistered<SandangController>()
        ? Get.find<SandangController>()
        : Get.put(SandangController());
    controller.reportData.value = null;
    final data = draft.dataForm;

    final requiredKeys = ['pangan', 'sandang', 'jasa'];
    final isComplete = requiredKeys.every((k) {
      final val = data[k]?.toString().trim() ?? '';
      return val.isNotEmpty;
    });

    if (!isComplete) {
      return const DraftSendResult(
        success: false,
        message: 'Draf belum lengkap. Buka Edit dan lengkapi isian.',
      );
    }

    final success = await controller.submitDataSandang(
      pangan: data['pangan']?.toString() ?? '',
      sandang: data['sandang']?.toString() ?? '',
      jasa: data['jasa']?.toString() ?? '',
      idRole: data['id_role']?.toString() ?? '',
      idOrganization: data['id_organization']?.toString() ?? '',
      idUser: draft.idAkun,
      catatan: data['catatan']?.toString(),
    );

    return DraftSendResult(
      success: success,
      message: success ? null : controller.errorMessage.value,
      networkFailure: controller.lastFailureWasNetwork.value,
    );
  }

  static Future<DraftSendResult> _sendPerumahan(DraftModel draft) async {
    final controller = Get.isRegistered<PerumahanController>()
        ? Get.find<PerumahanController>()
        : Get.put(PerumahanController());
    controller.reportData.value = null;
    final data = draft.dataForm;

    final requiredKeys = ['layak_huni', 'tidak_layak'];
    final isComplete = requiredKeys.every((k) {
      final val = data[k]?.toString().trim() ?? '';
      return val.isNotEmpty;
    });

    if (!isComplete) {
      return const DraftSendResult(
        success: false,
        message: 'Draf belum lengkap. Buka Edit dan lengkapi isian.',
      );
    }

    final success = await controller.submitDataPerumahan(
      layakHuni: data['layak_huni']?.toString() ?? '',
      tidakLayak: data['tidak_layak']?.toString() ?? '',
      idRole: data['id_role']?.toString() ?? '',
      idOrganization: data['id_organization']?.toString() ?? '',
      idUser: draft.idAkun,
      catatan: data['catatan']?.toString(),
    );

    return DraftSendResult(
      success: success,
      message: success ? null : controller.errorMessage.value,
      networkFailure: controller.lastFailureWasNetwork.value,
    );
  }

  static Future<DraftSendResult> _sendKaderPokja4(DraftModel draft) async {
    final controller = Get.isRegistered<KaderPokja4Controller>()
        ? Get.find<KaderPokja4Controller>()
        : Get.put(KaderPokja4Controller());
    controller.reportData.value = null;
    final data = draft.dataForm;

    final requiredKeys = [
      'posyandu',
      'gizi',
      'kesling',
      'penyuluhan_narkoba',
      'PHBS',
      'KB',
    ];
    final isComplete = requiredKeys.every((k) {
      final val = data[k]?.toString().trim() ?? '';
      return val.isNotEmpty;
    });

    if (!isComplete) {
      return const DraftSendResult(
        success: false,
        message: 'Draf belum lengkap. Buka Edit dan lengkapi isian.',
      );
    }

    final success = await controller.submitDataKaderPokja4(
      posyandu: data['posyandu']?.toString() ?? '',
      gizi: data['gizi']?.toString() ?? '',
      kesling: data['kesling']?.toString() ?? '',
      penyuluhanNarkoba: data['penyuluhan_narkoba']?.toString() ?? '',
      phbs: data['PHBS']?.toString() ?? '',
      kb: data['KB']?.toString() ?? '',
      idRole: data['id_role']?.toString() ?? '',
      idOrganization: data['id_organization']?.toString() ?? '',
      idUser: draft.idAkun,
      catatan: data['catatan']?.toString(),
    );

    return DraftSendResult(
      success: success,
      message: success ? null : controller.errorMessage.value,
      networkFailure: controller.lastFailureWasNetwork.value,
    );
  }

  static Future<DraftSendResult> _sendKesehatan(DraftModel draft) async {
    final controller = Get.isRegistered<KesehatanController>()
        ? Get.find<KesehatanController>()
        : Get.put(KesehatanController());
    controller.reportData.value = null;
    final data = draft.dataForm;

    final requiredKeys = [
      'jumlah_posyandu',
      'jumlah_posyandu_iterasi',
      'jumlah_klp',
      'jumlah_anggota',
      'jumlah_kartu_gratis',
    ];
    final isComplete = requiredKeys.every((k) {
      final val = data[k]?.toString().trim() ?? '';
      return val.isNotEmpty;
    });

    if (!isComplete) {
      return const DraftSendResult(
        success: false,
        message: 'Draf belum lengkap. Buka Edit dan lengkapi isian.',
      );
    }

    final success = await controller.submitKesehatanData(
      jumlahPosyandu: data['jumlah_posyandu']?.toString() ?? '',
      jumlahPosyanduIterasi: data['jumlah_posyandu_iterasi']?.toString() ?? '',
      jumlahKip: data['jumlah_klp']?.toString() ?? '',
      jumlahAnggota: data['jumlah_anggota']?.toString() ?? '',
      jumlahKartuGratis: data['jumlah_kartu_gratis']?.toString() ?? '',
      idRole: data['id_role']?.toString() ?? '',
      idOrganization: data['id_organization']?.toString() ?? '',
      idUser: draft.idAkun,
      catatan: data['catatan']?.toString(),
    );

    return DraftSendResult(
      success: success,
      message: success ? null : controller.errorMessage.value,
      networkFailure: controller.lastFailureWasNetwork.value,
    );
  }

  static Future<DraftSendResult> _sendPerencanaan(DraftModel draft) async {
    final controller = Get.isRegistered<PerencanaanController>()
        ? Get.find<PerencanaanController>()
        : Get.put(PerencanaanController());
    controller.reportData.value = null;
    final data = draft.dataForm;

    final requiredKeys = [
      'J_Psubur',
      'J_Wsubur',
      'Kb_p',
      'Kb_w',
      'Kk_tbg',
    ];
    final isComplete = requiredKeys.every((k) {
      final val = data[k]?.toString().trim() ?? '';
      return val.isNotEmpty;
    });

    if (!isComplete) {
      return const DraftSendResult(
        success: false,
        message: 'Draf belum lengkap. Buka Edit dan lengkapi isian.',
      );
    }

    final success = await controller.submitPerencanaanData(
      jumlahPriaSubur: data['J_Psubur']?.toString() ?? '',
      jumlahWanitaSubur: data['J_Wsubur']?.toString() ?? '',
      kbPria: data['Kb_p']?.toString() ?? '',
      kbWanita: data['Kb_w']?.toString() ?? '',
      kkTabungan: data['Kk_tbg']?.toString() ?? '',
      idRole: data['id_role']?.toString() ?? '',
      idOrganization: data['id_organization']?.toString() ?? '',
      idUser: draft.idAkun,
      catatan: data['catatan']?.toString(),
    );

    return DraftSendResult(
      success: success,
      message: success ? null : controller.errorMessage.value,
      networkFailure: controller.lastFailureWasNetwork.value,
    );
  }

  static Future<DraftSendResult> _sendKelestarian(DraftModel draft) async {
    final controller = Get.isRegistered<KelestarianController>()
        ? Get.find<KelestarianController>()
        : Get.put(KelestarianController());
    controller.reportData.value = null;
    final data = draft.dataForm;

    final requiredKeys = [
      'jamban',
      'spal',
      'tps',
      'mck',
      'pdam',
      'sumur',
      'dll',
    ];
    final isComplete = requiredKeys.every((k) {
      final val = data[k]?.toString().trim() ?? '';
      return val.isNotEmpty;
    });

    if (!isComplete) {
      return const DraftSendResult(
        success: false,
        message: 'Draf belum lengkap. Buka Edit dan lengkapi isian.',
      );
    }

    final success = await controller.submitKelestarianData(
      jamban: data['jamban']?.toString() ?? '',
      spal: data['spal']?.toString() ?? '',
      tps: data['tps']?.toString() ?? '',
      mck: data['mck']?.toString() ?? '',
      pdam: data['pdam']?.toString() ?? '',
      sumur: data['sumur']?.toString() ?? '',
      lainnya: data['dll']?.toString() ?? '',
      idRole: data['id_role']?.toString() ?? '',
      idOrganization: data['id_organization']?.toString() ?? '',
      idUser: draft.idAkun,
      catatan: data['catatan']?.toString(),
    );

    return DraftSendResult(
      success: success,
      message: success ? null : controller.errorMessage.value,
      networkFailure: controller.lastFailureWasNetwork.value,
    );
  }

  static Future<DraftSendResult> _sendInovasiKegiatan(DraftModel draft) async {
    final controller = Get.isRegistered<KegiatanPokja4Controller>()
        ? Get.find<KegiatanPokja4Controller>()
        : Get.put(KegiatanPokja4Controller());
    final data = draft.dataForm;

    final requiredKeys = [
      'kategori',
      'kader_kesehatan',
      'gizi',
      'kesling',
      'phbs',
      'kb',
      'posyandu',
      'imunisasi_vaksinasi_bayi_balita',
      'pkg',
      'tbc',
      'jamban_wc',
      'spal',
      'tps',
      'jumlah_mck',
      'pdam',
      'sumur',
      'lain_lain',
      'jml_pus',
      'jml_wus',
      'akseptor_kb_l',
      'akseptor_kb_p',
      'kk_memiliki_tabungan',
      'kk_memiliki_asuransi',
      'kesehatan',
      'kelestarian_lingkungan_hidup',
      'perencanaan_sehat',
    ];
    final isComplete = requiredKeys.every((k) {
      final val = data[k]?.toString().trim() ?? '';
      return val.isNotEmpty;
    });

    if (!isComplete) {
      return const DraftSendResult(
        success: false,
        message: 'Draf belum lengkap. Buka Edit dan lengkapi isian.',
      );
    }

    final success = await controller.submitDataKegiatanPokja4(
      kategori: data['kategori']?.toString() ?? '',
      kaderKesehatan: data['kader_kesehatan']?.toString() ?? '',
      gizi: data['gizi']?.toString() ?? '',
      kesling: data['kesling']?.toString() ?? '',
      phbs: data['phbs']?.toString() ?? '',
      kb: data['kb']?.toString() ?? '',
      posyandu: data['posyandu']?.toString() ?? '',
      imunisasiVaksinasiBayiBalita:
          data['imunisasi_vaksinasi_bayi_balita']?.toString() ?? '',
      pkg: data['pkg']?.toString() ?? '',
      tbc: data['tbc']?.toString() ?? '',
      jambanWc: data['jamban_wc']?.toString() ?? '',
      spal: data['spal']?.toString() ?? '',
      tps: data['tps']?.toString() ?? '',
      jumlahMck: data['jumlah_mck']?.toString() ?? '',
      pdam: data['pdam']?.toString() ?? '',
      sumur: data['sumur']?.toString() ?? '',
      lainLain: data['lain_lain']?.toString() ?? '',
      jmlPus: data['jml_pus']?.toString() ?? '',
      jmlWus: data['jml_wus']?.toString() ?? '',
      akseptorKbL: data['akseptor_kb_l']?.toString() ?? '',
      akseptorKbP: data['akseptor_kb_p']?.toString() ?? '',
      kkMemilikiTabungan: data['kk_memiliki_tabungan']?.toString() ?? '',
      kkMemilikiAsuransi: data['kk_memiliki_asuransi']?.toString() ?? '',
      kesehatan: data['kesehatan']?.toString() ?? '',
      kelestarianLingkunganHidup:
          data['kelestarian_lingkungan_hidup']?.toString() ?? '',
      perencanaanSehat: data['perencanaan_sehat']?.toString() ?? '',
    );

    return DraftSendResult(
      success: success,
      message: success ? null : controller.errorMessage.value,
      networkFailure: controller.lastFailureWasNetwork.value,
    );
  }

  static Future<DraftSendResult> _sendInovasiPosyandu(DraftModel draft) async {
    final controller = Get.isRegistered<PosyanduController>()
        ? Get.find<PosyanduController>()
        : Get.put(PosyanduController());
    final data = draft.dataForm;

    final requiredKeys = [
      'bulan',
      'jml_ibu_hamil',
      'diperiksa',
      'fe_tablet_darah',
      'jml_ibu_menyusui',
      'kondom',
      'pil',
      'implant',
      'mop',
      'mow',
      'iud',
      'suntikan',
      'lain_lain_kb',
      'jml_balita_l',
      'jml_balita_p',
      'buku_kia_l',
      'buku_kia_p',
      'datang_l',
      'datang_p',
      'naik_l',
      'naik_p',
      'vit_a_l',
      'vit_a_p',
      'pmt_l',
      'pmt_p',
      'imunisasi_tt_1',
      'imunisasi_tt_2',
    ];
    final isComplete = requiredKeys.every((k) {
      final val = data[k]?.toString().trim() ?? '';
      return val.isNotEmpty;
    });

    if (!isComplete) {
      return const DraftSendResult(
        success: false,
        message: 'Draf belum lengkap. Buka Edit dan lengkapi isian.',
      );
    }

    final success = await controller.submitDataPosyandu(
      kategori: data['kategori']?.toString() ?? '',
      bulan: data['bulan']?.toString() ?? '',
      jmlIbuHamil: data['jml_ibu_hamil']?.toString() ?? '0',
      diperiksa: data['diperiksa']?.toString() ?? '0',
      feTabletDarah: data['fe_tablet_darah']?.toString() ?? '0',
      jmlIbuMenyusui: data['jml_ibu_menyusui']?.toString() ?? '0',
      kondom: data['kondom']?.toString() ?? '0',
      pil: data['pil']?.toString() ?? '0',
      implant: data['implant']?.toString() ?? '0',
      mop: data['mop']?.toString() ?? '0',
      mow: data['mow']?.toString() ?? '0',
      iud: data['iud']?.toString() ?? '0',
      suntikan: data['suntikan']?.toString() ?? '0',
      lainLainKb: data['lain_lain_kb']?.toString() ?? '0',
      jmlBalitaL: data['jml_balita_l']?.toString() ?? '0',
      jmlBalitaP: data['jml_balita_p']?.toString() ?? '0',
      bukuKiaL: data['buku_kia_l']?.toString() ?? '0',
      bukuKiaP: data['buku_kia_p']?.toString() ?? '0',
      datangL: data['datang_l']?.toString() ?? '0',
      datangP: data['datang_p']?.toString() ?? '0',
      naikL: data['naik_l']?.toString() ?? '0',
      naikP: data['naik_p']?.toString() ?? '0',
      vitAL: data['vit_a_l']?.toString() ?? '0',
      vitAP: data['vit_a_p']?.toString() ?? '0',
      pmtL: data['pmt_l']?.toString() ?? '0',
      pmtP: data['pmt_p']?.toString() ?? '0',
      imunisasiTt1: data['imunisasi_tt_1']?.toString() ?? '0',
      imunisasiTt2: data['imunisasi_tt_2']?.toString() ?? '0',
    );

    return DraftSendResult(
      success: success,
      message: success ? null : controller.errorMessage.value,
      networkFailure: controller.lastFailureWasNetwork.value,
    );
  }
}
