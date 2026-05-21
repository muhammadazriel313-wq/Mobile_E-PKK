import 'package:dio/dio.dart';
import 'package:epkk_nganjuk/core/api_helper.dart';
import 'package:epkk_nganjuk/features/pages/pokja3/sandang/report_sandang_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SandangController extends GetxController {
  final ApiHelper apiHelper = ApiHelper();

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var reportData = Rxn<ReportSandangModel>();

  Future<void> submitDataSandang({
    required String idUser,
    required String pangan,
    required String sandang,
    required String jasa,
    required String idRole,
    required String idOrganization,
    String? catatan,
  }) async {
    try {
      isLoading(true);
      errorMessage('');
      reportData(null);

      final response = await apiHelper.post(
        '/report/sandang',
        data: {
          'id_user': idUser,
          'pangan': pangan,
          'sandang': sandang,
          'jasa': jasa,
          'id_role': idRole,
          'id_organization':
              idOrganization,
          if (catatan != null)
            'catatan': catatan,
        },
      );

      if (response.statusCode == 200) {
        reportData.value =
            ReportSandangModel.fromJson(
          response.data,
        );

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
        errorMessage.value =
            'Gagal upload';

        Get.snackbar(
          'Gagal',
          errorMessage.value,
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
      errorMessage.value = e.toString();

      if (e is DioException) {
        errorMessage.value =
            e.response?.data?['message'] ??
                e.response?.data
                    .toString() ??
                'Terjadi kesalahan server';
      }

      Get.snackbar(
        'Error',
        errorMessage.value,
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

  void resetForm() {
    reportData(null);
    errorMessage('');
  }

  SandangEntry? get entryData =>
      reportData.value?.data;
}