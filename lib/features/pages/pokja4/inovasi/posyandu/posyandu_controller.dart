/// =======================================================
/// FILE : posyandu_controller.dart
/// =======================================================

import 'package:dio/dio.dart';

import 'package:epkk_nganjuk/core/api_helper.dart';

import 'package:epkk_nganjuk/services/preferences/preferences_service.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

class PosyanduController extends GetxController {
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

  /// ================= SAFE STRING =================

  String safe(dynamic value, {String defaultValue = ''}) {
    if (value == null) return defaultValue;

    return value.toString();
  }

  /// ================= SUBMIT =================

  Future<bool> submitDataPosyandu({
    String? kategori,
    String? bulan,
    String? jmlIbuHamil,
    String? diperiksa,
    String? feTabletDarah,
    String? jmlIbuMenyusui,
    String? kondom,
    String? pil,
    String? implant,
    String? mop,
    String? mow,
    String? iud,
    String? suntikan,
    String? lainLainKb,
    String? jmlBalitaL,
    String? jmlBalitaP,
    String? bukuKiaL,
    String? bukuKiaP,
    String? datangL,
    String? datangP,
    String? naikL,
    String? naikP,
    String? vitAL,
    String? vitAP,
    String? pmtL,
    String? pmtP,
    String? imunisasiTt1,
    String? imunisasiTt2,
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
        '/report/posyandu',
        data: {
          'id_user': safe(idUser),

          'id_role': safe(idRole),

          'id_organization': safe(idOrganization),

          'kategori': safe(kategori).toLowerCase(),

          'bulan': safe(bulan),

          'jml_ibu_hamil': safe(jmlIbuHamil, defaultValue: '0'),

          'diperiksa': safe(diperiksa, defaultValue: '0'),

          'fe_tablet_darah': safe(feTabletDarah, defaultValue: '0'),

          'jml_ibu_menyusui': safe(jmlIbuMenyusui, defaultValue: '0'),

          'kondom': safe(kondom, defaultValue: '0'),

          'pil': safe(pil, defaultValue: '0'),

          'implant': safe(implant, defaultValue: '0'),

          'mop': safe(mop, defaultValue: '0'),

          'mow': safe(mow, defaultValue: '0'),

          'iud': safe(iud, defaultValue: '0'),

          'suntikan': safe(suntikan, defaultValue: '0'),

          /// ======================
          /// FIX DATABASE
          /// ======================
          'lain_lain_kb': safe(lainLainKb, defaultValue: '0'),

          'jml_balita_l': safe(jmlBalitaL, defaultValue: '0'),

          'jml_balita_p': safe(jmlBalitaP, defaultValue: '0'),

          'buku_kia_l': safe(bukuKiaL, defaultValue: '0'),

          'buku_kia_p': safe(bukuKiaP, defaultValue: '0'),

          'datang_l': safe(datangL, defaultValue: '0'),

          'datang_p': safe(datangP, defaultValue: '0'),

          'naik_l': safe(naikL, defaultValue: '0'),

          'naik_p': safe(naikP, defaultValue: '0'),

          'vit_a_l': safe(vitAL, defaultValue: '0'),

          'vit_a_p': safe(vitAP, defaultValue: '0'),

          'pmt_l': safe(pmtL, defaultValue: '0'),

          'pmt_p': safe(pmtP, defaultValue: '0'),

          'imunisasi_tt_1': safe(imunisasiTt1, defaultValue: '0'),

          'imunisasi_tt_2': safe(imunisasiTt2, defaultValue: '0'),

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
          e.response?.data?['message']?.toString() ??
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
