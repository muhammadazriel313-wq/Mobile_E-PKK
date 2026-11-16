import 'dart:async';
import 'dart:io';

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
  var lastFailureWasNetwork = false.obs;

  Future<bool> submitDataSandang({
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
      lastFailureWasNetwork.value = false;

      final response = await apiHelper.post(
        '/report/sandang',
        data: {
          'id_user': idUser,
          'pangan': pangan,
          'sandang': sandang,
          'jasa': jasa,
          'id_role': idRole,
          'id_organization': idOrganization,
          if (catatan != null) 'catatan': catatan,
        },
      );

      if (response.statusCode == 200) {
        reportData.value = ReportSandangModel.fromJson(response.data);

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
        errorMessage.value = 'Gagal upload';

        Get.snackbar(
          'Gagal',
          errorMessage.value,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        return false;
      }
    } catch (e) {
      if (e is SocketException || e is TimeoutException) {
        lastFailureWasNetwork.value = true;
      }
      errorMessage.value = e.toString();

      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.connectionError ||
            e.error is SocketException) {
          lastFailureWasNetwork.value = true;
        }
        errorMessage.value =
            e.response?.data?['message'] ??
            e.response?.data.toString() ??
            'Terjadi kesalahan server';
      }

      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return false;
    } finally {
      isLoading(false);
    }
  }

  void resetForm() {
    reportData(null);
    errorMessage('');
  }

  SandangEntry? get entryData => reportData.value?.data;
}
