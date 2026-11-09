import 'package:epkk_nganjuk/features/draft/draft_model.dart';
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
    );
  }
}
