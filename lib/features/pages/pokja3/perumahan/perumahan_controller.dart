import 'package:dio/dio.dart';
import 'package:epkk_nganjuk/core/api_helper.dart';
import 'package:epkk_nganjuk/features/pages/pokja3/perumahan/report_perumahan_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PerumahanController extends GetxController {
  final ApiHelper apiHelper = ApiHelper();

  // ================= STATE =================
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var reportData = Rxn<ReportPerumahanModel>();

  // ================= SUBMIT =================
  Future<void> submitDataPerumahan({
    required String idUser,
    required String layakHuni,
    required String tidakLayak,
    required String idRole,
    required String idOrganization,
    String? catatan,
  }) async {
    try {
      isLoading(true);
      errorMessage('');
      reportData(null);

      final data = {
        'id_user': idUser,
        'layak_huni':
            int.tryParse(layakHuni) ?? 0,
        'tidak_layak':
            int.tryParse(tidakLayak) ?? 0,
        'id_role': idRole,
        'id_organization':
            idOrganization,
        if (catatan != null)
          'catatan': catatan,
      };

      final response = await apiHelper.post(
        '/report/perumahan',
        data: data,
      );

      if (response.statusCode == 200) {
        reportData.value =
            ReportPerumahanModel.fromJson(
          response.data,
        );

        // SUCCESS
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
          'Upload gagal',
        );

        // GAGAL
        Get.snackbar(
          'Gagal',
          'Upload gagal',
          snackPosition:
              SnackPosition.TOP,
          backgroundColor:
              Colors.red,
          colorText: Colors.white,
          duration:
              const Duration(seconds: 3),
        );
      }
    } catch (e) {
      errorMessage(e.toString());

      // ERROR
      if (e is DioException) {
        Get.snackbar(
          'Server Error',
          e.response?.data?['message'] ??
              e.response?.data
                  .toString() ??
              'Terjadi kesalahan',
          snackPosition:
              SnackPosition.TOP,
          backgroundColor:
              Colors.red,
          colorText: Colors.white,
          duration:
              const Duration(seconds: 3),
        );
      } else {
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
      }
    } finally {
      isLoading(false);
    }
  }

  // ================= RESET =================
  void resetForm() {
    reportData(null);
    errorMessage('');
  }

  // ================= GETTER =================
  PerumahanEntry? get entryData =>
      reportData.value?.data;
}