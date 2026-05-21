import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:epkk_nganjuk/core/api_helper.dart';
import 'package:epkk_nganjuk/features/pages/pokja1/gotongroyong/gotong_royong_model.dart';

class GotongRoyongController extends GetxController {
  final ApiHelper apiHelper = ApiHelper();

  var reportData = Rxn<ReportGotongRoyongModel>();

  var isLoading = false.obs;

  var errorMessage = ''.obs;

  Future<bool> submitGotongRoyong({
    required String idUser,
    required String kerjaBakti,
    required String rukunKematian,
    required String keagamaan,
    required String jimpitan,
    required String arisan,
    required String idRole,
    required String idOrganization,
    String? catatan,
  }) async {
    isLoading.value = true;

    errorMessage.value = '';

    try {
      final response = await apiHelper.post(
        '/report/gotong-royong',
        data: {
          'id_user': idUser,
          'kerja_bakti': kerjaBakti,
          'rukun_kematian': rukunKematian,
          'keagamaan': keagamaan,
          'jimpitan': jimpitan,
          'arisan': arisan,
          'id_role': idRole,
          'id_organization': idOrganization,
          if (catatan != null) 'catatan': catatan,
        },
      );

      if (response.statusCode == 200) {
        reportData.value = ReportGotongRoyongModel.fromJson(response.data);

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
        errorMessage.value = 'Gagal upload data';

        Get.snackbar(
          'Gagal',
          errorMessage.value,
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFFEF5350),
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
          borderRadius: 12,
          duration: const Duration(seconds: 3),
        );

        return false;
      }
    } on SocketException {
      errorMessage.value = 'Tidak ada koneksi internet';

      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFEF5350),
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
        duration: const Duration(seconds: 3),
      );

      return false;
    } on TimeoutException {
      errorMessage.value = 'Server timeout';

      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFEF5350),
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
        duration: const Duration(seconds: 3),
      );

      return false;
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan';

      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFEF5350),
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
        duration: const Duration(seconds: 3),
      );

      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
