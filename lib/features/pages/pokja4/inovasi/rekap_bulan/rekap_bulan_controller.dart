/// =======================================================
/// FILE : rekap_bulan_controller.dart
/// =======================================================

import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

import 'package:epkk_nganjuk/core/api_helper.dart';

import 'package:epkk_nganjuk/services/preferences/preferences_service.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

class RekapDesaBulananController extends GetxController {
  final ApiHelper apiHelper = ApiHelper();

  /// ================= STATE =================

  var isLoading = false.obs;

  var errorMessage = ''.obs;

  var lastFailureWasNetwork = false.obs;

  Map<String, dynamic> toSnapshot(
    Map<String, dynamic> values, {
    required int step,
  }) => {...values, 'langkah': step};

  void applySnapshot(Map<String, dynamic> snapshot) {
    // Form values are owned by the step screens and restored there.
  }

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

    idUser = user?.id.toString() ?? '';

    idRole = user?.role?.id.toString() ?? '';

    idOrganization = user?.organization?.id.toString() ?? '';
  }

  /// ================= SUBMIT =================

  Future<bool> submitDataRekapDesa({
    required String kategori,

    required String rw,

    required String rt,

    required String dasaWisma,

    required String hamil,

    required String melahirkan,

    required String nifas,

    required String meninggal,

    required String bayiLahirL,

    required String bayiLahirP,

    required String akteKelahiranAda,

    required String akteKelahiranTidak,

    required String bayiMeninggalL,

    required String bayiMeninggalP,

    required String balitaMeninggalL,

    required String balitaMeninggalP,
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

      lastFailureWasNetwork.value = false;

      final response = await apiHelper.post(
        '/report/rekap-desa-bulanan',

        data: {
          'id_user': idUser,

          'id_role': idRole,

          'id_organization': idOrganization,

          'kategori': kategori.toLowerCase(),

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
      if (e is SocketException || e is TimeoutException) {
        lastFailureWasNetwork.value = true;
      }

      errorMessage(ApiHelper.pesanGalat(e));

      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.connectionError ||
            e.error is SocketException) {
          lastFailureWasNetwork.value = true;
        }

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

          ApiHelper.pesanGalat(e),

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
