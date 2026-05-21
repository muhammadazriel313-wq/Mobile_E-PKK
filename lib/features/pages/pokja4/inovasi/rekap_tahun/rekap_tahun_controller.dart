/// =======================================================
/// FILE : rekap_tahunan_controller.dart
/// =======================================================

import 'package:dio/dio.dart';

import 'package:epkk_nganjuk/core/api_helper.dart';

import 'package:epkk_nganjuk/services/preferences/preferences_service.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

class RekapDesaTahunanController extends GetxController {
  final ApiHelper apiHelper = ApiHelper();

  /// ================= STATE =================

  var isLoading = false.obs;

  var errorMessage = ''.obs;

  /// ================= USER =================

  String idUser = '';

  String idRole = '';

  String idOrganization = '';

  @override
  void onInit() {
    super.onInit();

    loadUser();
  }

  /// ================= LOAD USER =================

  Future<void> loadUser() async {
    final user = await PreferencesService.getUser();

    idUser = user?.id?.toString() ?? '';

    idRole = user?.role?.id?.toString() ?? '';

    idOrganization = user?.organization?.id?.toString() ?? '';
  }

  /// ================= SUBMIT =================

  Future<bool> submitDataRekapDesaTahunan({
    required String kategori,

    required String kaderKesehatan,

    required String gizi,

    required String kesling,

    required String phbs,

    required String kb,

    required String posyandu,

    required String imunisasiVaksinasiBayiBalita,

    required String pkg,

    required String tbc,

    required String jambanWc,

    required String spal,

    required String tps,

    required String jumlahMck,

    required String pdam,

    required String sumur,

    required String lainLain,

    required String jmlPus,

    required String jmlWus,

    required String akseptorKbL,

    required String akseptorKbP,

    required String jmlKkTabungan,

    required String jmlKkAsuransi,

    required String kesehatanProgram,

    required String kelestarianLingkunganHidup,

    required String perencanaanSehatProgram,
  }) async {
    if (isLoading.value) {
      return false;
    }

    if (idUser.isEmpty || idRole.isEmpty || idOrganization.isEmpty) {
      Get.snackbar(
        'Error',

        'Session user belum siap',

        snackPosition: SnackPosition.TOP,

        backgroundColor: Colors.red,

        colorText: Colors.white,
      );

      return false;
    }

    try {
      isLoading(true);

      errorMessage('');

      final response = await apiHelper.post(
        '/report/rekap-desa-tahunan',

        data: {
          'id_user': idUser,

          'id_role': idRole,

          'id_organization': idOrganization,

          'kategori': kategori.toLowerCase(),

          'kader_kesehatan': kaderKesehatan,

          'gizi': gizi,

          'kesling': kesling,

          'phbs': phbs,

          'kb': kb,

          'posyandu': posyandu,

          'imunisasi_vaksinasi_bayi_balita': imunisasiVaksinasiBayiBalita,

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

          'kelestarian_lingkungan_hidup': kelestarianLingkunganHidup,

          'perencanaan_sehat_program': perencanaanSehatProgram,

          'catatan': '',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Berhasil',
          'Data berhasil terkirim',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF3F8FC1),
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
          borderRadius: 12,
          duration: const Duration(seconds: 3),
        );

        return true;
      } else {
        Get.snackbar(
          'Gagal',

          'Upload gagal',

          snackPosition: SnackPosition.TOP,

          backgroundColor: Colors.red,

          colorText: Colors.white,
        );

        return false;
      }
    } catch (e) {
      errorMessage(e.toString());

      if (e is DioException) {
        debugPrint(e.response?.data.toString());

        Get.snackbar(
          'Server Error',

          e.response?.data?['message'] ??
              e.response?.data.toString() ??
              'Terjadi kesalahan',

          snackPosition: SnackPosition.TOP,

          backgroundColor: Colors.red,

          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',

          e.toString(),

          snackPosition: SnackPosition.TOP,

          backgroundColor: Colors.red,

          colorText: Colors.white,
        );
      }

      return false;
    } finally {
      isLoading(false);
    }
  }
}
