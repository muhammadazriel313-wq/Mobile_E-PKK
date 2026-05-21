import 'dart:async';
import 'dart:io';

import 'package:epkk_nganjuk/core/api_helper.dart';
import 'package:epkk_nganjuk/features/pages/pokja4/jumlah_rumah/report_perencanaan_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PerencanaanController extends GetxController {
  final ApiHelper apiHelper = ApiHelper();

  // ================= STATE =================
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var reportData = Rxn<ReportPerencanaanModel>();

  // ================= SUBMIT DATA =================
  Future<void> submitPerencanaanData({
    required String idUser,
    required String jumlahPriaSubur,
    required String jumlahWanitaSubur,
    required String kbPria,
    required String kbWanita,
    required String kkTabungan,
    required String idRole,
    required String idOrganization,
    String? catatan,
  }) async {
    try {
      isLoading(true);
      errorMessage('');
      reportData(null);

      final response = await apiHelper.post(
        '/report/perencanaan-sehat',
        data: {
          'id_user': idUser,
          'J_Psubur': jumlahPriaSubur,
          'J_Wsubur': jumlahWanitaSubur,
          'Kb_p': kbPria,
          'Kb_w': kbWanita,
          'Kk_tbg': kkTabungan,
          'id_role': idRole,
          'id_organization': idOrganization,
          if (catatan != null &&
              catatan.isNotEmpty)
            'catatan': catatan,
        },
      );

      if (response.statusCode == 200) {
        final result =
            ReportPerencanaanModel.fromJson(
          response.data,
        );

        reportData(result);

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
      } else {
        errorMessage(
          'Gagal mengirim data',
        );

        Get.snackbar(
          'Gagal',
          'Gagal mengirim data',
          snackPosition:
              SnackPosition.TOP,
          backgroundColor:
              Colors.red,
          colorText: Colors.white,
          duration:
              const Duration(seconds: 3),
        );
      }
    } on SocketException {
      errorMessage(
        'Tidak ada koneksi internet',
      );

      Get.snackbar(
        'Error',
        'Tidak ada koneksi internet',
        snackPosition:
            SnackPosition.TOP,
        backgroundColor:
            Colors.red,
        colorText: Colors.white,
        duration:
            const Duration(seconds: 3),
      );
    } on TimeoutException {
      errorMessage('Server timeout');

      Get.snackbar(
        'Error',
        'Server tidak merespons',
        snackPosition:
            SnackPosition.TOP,
        backgroundColor:
            Colors.red,
        colorText: Colors.white,
        duration:
            const Duration(seconds: 3),
      );
    } catch (e) {
      errorMessage(e.toString());

      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition:
            SnackPosition.TOP,
        backgroundColor:
            Colors.red,
        colorText: Colors.white,
        duration:
            const Duration(seconds: 3),
      );
    } finally {
      isLoading(false);
    }
  }

  // ================= RESET =================
  void resetForm() {
    reportData(null);
    errorMessage('');
  }
}