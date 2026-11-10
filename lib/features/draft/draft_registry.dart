import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:epkk_nganjuk/features/draft/draft_model.dart';
import 'package:epkk_nganjuk/features/laporan/laporan_umum/laporan_umum_controller.dart';
import 'package:epkk_nganjuk/features/laporan/upload_galeri/upload_galerii_controller.dart';
import 'package:epkk_nganjuk/features/pages/pokja1/gotongroyong/gotong_royong_controller.dart';
import 'package:epkk_nganjuk/features/pages/pokja1/kaderpokja1/kader_pokja1_controller.dart';
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
      namaPeserta: data['nama_peserta']?.toString(),
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
}
