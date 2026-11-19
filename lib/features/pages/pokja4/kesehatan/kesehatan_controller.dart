import 'dart:async';
import 'dart:io';

import 'package:epkk_nganjuk/core/api_helper.dart';
import 'package:epkk_nganjuk/features/pages/pokja4/kesehatan/report_kesehatan_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KesehatanController extends GetxController {
  final ApiHelper apiHelper = ApiHelper();

  // ================= STATE =================
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var reportData = Rxn<ReportKesehatanModel>();

  // ================= SUBMIT DATA =================
  Future<void> submitKesehatanData({
    required String idUser,
    required String kaderKesehatan,
    required String kaderGizi,
    required String kaderKesling,
    required String kaderPhbs,
    required String kaderKb,
    required String posyandu,
    required String imunisasiVaksinasi,
    required String pkg,
    required String tbc,
    required String idRole,
    required String idOrganization,
    String? catatan,
    // Optional legacy params jika dipanggil dari tempat lama
    String? jumlahPosyandu,
    String? jumlahPosyanduIterasi,
    String? jumlahKip,
    String? jumlahAnggota,
    String? jumlahKartuGratis,
  }) async {
    try {
      isLoading(true);
      errorMessage('');
      reportData(null);

      final response = await apiHelper.post(
        '/report/kesehatan',
        data: {
          'id_user': idUser,
          'kader_kesehatan': kaderKesehatan,
          'kader_gizi': kaderGizi,
          'kader_kesling': kaderKesling,
          'kader_phbs': kaderPhbs,
          'kader_kb': kaderKb,
          'posyandu': posyandu,
          'imunisasi_vaksinasi': imunisasiVaksinasi,
          'pkg': pkg,
          'tbc': tbc,
          'id_role': idRole,
          'id_organization': idOrganization,
          // Support kolom legacy
          'jumlah_posyandu': jumlahPosyandu ?? posyandu,
          'jumlah_posyandu_iterasi': jumlahPosyanduIterasi ?? kaderGizi,
          'jumlah_klp': jumlahKip ?? kaderKesling,
          'jumlah_anggota': jumlahAnggota ?? kaderPhbs,
          'jumlah_kartu_gratis': jumlahKartuGratis ?? kaderKb,
          if (catatan != null && catatan.isNotEmpty) 'catatan': catatan,
        },
      );

      if (response.statusCode == 200) {
        final result = ReportKesehatanModel.fromJson(response.data);

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
        errorMessage('Gagal mengirim data');

        Get.snackbar(
          'Gagal',
          'Gagal mengirim data',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } on SocketException {
      errorMessage('Tidak ada koneksi internet');

      Get.snackbar(
        'Error',
        'Tidak ada koneksi internet',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } on TimeoutException {
      errorMessage('Server timeout');

      Get.snackbar(
        'Error',
        'Server tidak merespons',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      errorMessage(e.toString());

      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
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
