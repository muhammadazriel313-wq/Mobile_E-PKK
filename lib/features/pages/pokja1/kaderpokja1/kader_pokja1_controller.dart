import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:epkk_nganjuk/core/api_helper.dart';
import 'package:epkk_nganjuk/features/pages/pokja1/kaderpokja1/kader1_model.dart';

class UploadReportController extends GetxController {
  final ApiHelper apiHelper = ApiHelper();

  var reportKaderPokja1Model = Rxn<ReportKaderPokja1Model>();

  var isCreateKaderPokja1 = false.obs;

  var errorMessage = ''.obs;

  Future<void> createKaderPokja1Controller({
    required String id_user,
    required String kader_umum,
    required String kader_khusus,
    required String id_role,
    required String id_organization,
  }) async {
    isCreateKaderPokja1.value = true;

    errorMessage.value = '';

    try {
      final response = await apiHelper.post(
        '/report/kader-pokja1',
        data: {
          'id_user': id_user,
          'kader_umum': kader_umum,
          'kader_khusus': kader_khusus,
          'id_role': id_role,
          'id_organization': id_organization,
        },
      );

      print("STATUS : ${response.statusCode}");

      print("BODY : ${response.data}");

      /// STATUS HTTP
      if (response.statusCode == 200) {
        final body = response.data;

        /// FORMAT DATA
        if (body is Map<String, dynamic>) {
          final result = ReportKaderPokja1Model.fromJson(body);

          if (result.statusCode == 200) {
            reportKaderPokja1Model.value = result;

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
      } else if (response.statusCode == 500) {
        errorMessage.value = 'Server bermasalah, coba lagi nanti';

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
      } else {
        errorMessage.value = 'Terjadi kesalahan (code: ${response.statusCode})';

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
    } finally {
      isCreateKaderPokja1.value = false;
    }
  }
}
