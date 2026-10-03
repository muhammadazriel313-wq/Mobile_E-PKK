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
    required String kisahKegiatan, required String kisahVol, required String kisahMetode, required String kisahSasaran,
    required String krisanKegiatan, required String krisanVol, required String krisanMetode, required String krisanSasaran,
    required String kilasKegiatan, required String kilasVol, required String kilasMetode, required String kilasSasaran,
    required String kiatKegiatan, required String kiatVol, required String kiatMetode, required String kiatSasaran,
    required String kisakKegiatan, required String kisakVol, required String kisakMetode, required String kisakSasaran,
    required String pkbnKegiatan, required String pkbnVol, required String pkbnMetode, required String pkbnSasaran,
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
          'kisah_kegiatan': kisahKegiatan, 'kisah_vol': kisahVol, 'kisah_metode': kisahMetode, 'kisah_sasaran': kisahSasaran,
          'krisan_kegiatan': krisanKegiatan, 'krisan_vol': krisanVol, 'krisan_metode': krisanMetode, 'krisan_sasaran': krisanSasaran,
          'kilas_kegiatan': kilasKegiatan, 'kilas_vol': kilasVol, 'kilas_metode': kilasMetode, 'kilas_sasaran': kilasSasaran,
          'kiat_kegiatan': kiatKegiatan, 'kiat_vol': kiatVol, 'kiat_metode': kiatMetode, 'kiat_sasaran': kiatSasaran,
          'kisak_kegiatan': kisakKegiatan, 'kisak_vol': kisakVol, 'kisak_metode': kisakMetode, 'kisak_sasaran': kisakSasaran,
          'pkbn_kegiatan': pkbnKegiatan, 'pkbn_vol': pkbnVol, 'pkbn_metode': pkbnMetode, 'pkbn_sasaran': pkbnSasaran,
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
          Get.snackbar('Berhasil', 'Data berhasil terkirim', backgroundColor: const Color(0xFF3F8FC1), colorText: Colors.white);
        } else {
          errorMessage.value = result.message;
          Get.snackbar('Gagal', errorMessage.value, backgroundColor: const Color(0xFFEF5350), colorText: Colors.white);
        }
      } else {
        errorMessage.value = 'Format response tidak valid';
        Get.snackbar('Error', errorMessage.value, backgroundColor: const Color(0xFFEF5350), colorText: Colors.white);
      }
    } on SocketException {
      errorMessage.value = 'Tidak ada koneksi internet';
      Get.snackbar('Error', errorMessage.value, backgroundColor: const Color(0xFFEF5350), colorText: Colors.white);
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan';
      Get.snackbar('Error', errorMessage.value, backgroundColor: const Color(0xFFEF5350), colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    reportData.value = null;
    errorMessage.value = '';
  }
}
