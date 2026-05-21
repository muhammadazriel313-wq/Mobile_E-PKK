import 'dart:async';
import 'package:epkk_nganjuk/core/api_helper.dart';
import 'package:get/get.dart';

class DetailLaporanController extends GetxController {
  final ApiHelper apiHelper = ApiHelper();

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var laporanDetail = <String, dynamic>{}.obs;

  // ================= GET DETAIL =================
  Future<void> loadDetailLaporan({
    required String uuid,
    required int orgId,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await apiHelper.get(
        '/report/detail', //  sesuaikan
        queryParameters: {
          'uuid': uuid,
          'org_id': orgId,
        },
      );

      final data = response.data;

      if (data['statusCode'] == 200) {
        laporanDetail.value = data['data'];
      } else {
        errorMessage.value = data['message'];
      }
    } catch (e) {
      errorMessage.value = 'Gagal memuat detail: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // ================= UPDATE =================
  Future<void> updateLaporan({
    required String uuid,
    required int orgId,
    required Map<String, dynamic> data,
  }) async {
    try {
      isLoading.value = true;

      final response = await apiHelper.post(
        '/report/update', //  sesuaikan
        data: {
          'uuid': uuid,
          'org_id': orgId,
          'data': data,
        },
      );

      if (response.data['statusCode'] != 200) {
        throw Exception(response.data['message']);
      }

      Get.snackbar('Berhasil', 'Laporan berhasil diupdate');
    } catch (e) {
      errorMessage.value = 'Gagal update: $e';
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  // ================= CANCEL =================
  Future<void> cancelLaporan({
    required String uuid,
    required int orgId,
  }) async {
    try {
      final response = await apiHelper.post(
        '/report/cancel', //  sesuaikan
        data: {
          'uuid': uuid,
          'org_id': orgId,
        },
      );

      if (response.data['statusCode'] != 200) {
        throw Exception(response.data['message']);
      }

      Get.snackbar('Berhasil', 'Laporan berhasil dibatalkan');
    } catch (e) {
      throw Exception('Gagal membatalkan laporan: $e');
    }
  }
}