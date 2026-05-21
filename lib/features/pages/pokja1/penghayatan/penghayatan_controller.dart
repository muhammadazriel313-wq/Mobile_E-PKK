import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:epkk_nganjuk/core/api_helper.dart';
import 'package:epkk_nganjuk/features/pages/pokja1/penghayatan/penghayatan_model.dart';

class PenghayatanPengamalanController extends GetxController {
  final ApiHelper apiHelper = ApiHelper();

  var reportData = Rxn<ReportPenghayatanPengamalanModel>();

  var isLoading = false.obs;

  var errorMessage = ''.obs;

  Future<void> submitPenghayatanPengamalan({
    required String idUser,
    required String jumlahKelSimulasi1,
    required String jumlahAnggota1,
    required String jumlahKelSimulasi2,
    required String jumlahAnggota2,
    required String jumlahKelSimulasi3,
    required String jumlahAnggota3,
    required String jumlahKelSimulasi4,
    required String jumlahAnggota4,
    required String idRole,
    required String idOrganization,
    String? catatan,
  }) async {
    isLoading.value = true;

    errorMessage.value = '';

    reportData.value = null;

    try {
      final response = await apiHelper.post(
        '/report/penghayatan',
        data: {
          'id_user': idUser,
          'jumlah_kel_simulasi1': jumlahKelSimulasi1,
          'jumlah_anggota1': jumlahAnggota1,
          'jumlah_kel_simulasi2': jumlahKelSimulasi2,
          'jumlah_anggota2': jumlahAnggota2,
          'jumlah_kel_simulasi3': jumlahKelSimulasi3,
          'jumlah_anggota3': jumlahAnggota3,
          'jumlah_kel_simulasi4': jumlahKelSimulasi4,
          'jumlah_anggota4': jumlahAnggota4,
          'id_role': idRole,
          'id_organization': idOrganization,
          if (catatan != null) 'catatan': catatan,
        },
      );

      final body = response.data;

      if (body is Map<String, dynamic>) {
        final result = ReportPenghayatanPengamalanModel.fromJson(body);

        if (result.statusCode == 200) {
          reportData.value = result;

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
          errorMessage.value = result.message;

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
        }
      } else {
        errorMessage.value = 'Format response tidak valid';

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
    } on TimeoutException {
      errorMessage.value = 'Server tidak merespons';

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
    } catch (e, stackTrace) {
      print('ERROR: $e');

      print('STACKTRACE: $stackTrace');

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
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    reportData.value = null;

    errorMessage.value = '';
  }
}
