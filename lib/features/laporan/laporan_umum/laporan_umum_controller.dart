import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:epkk_nganjuk/core/api_helper.dart';
import 'package:epkk_nganjuk/features/laporan/laporan_umum/laporan_umum_model.dart';

class LaporanUmumController extends GetxController {
  final ApiHelper apiHelper = ApiHelper();

  var isLoading = false.obs;

  var errorMessage = ''.obs;

  var reportData = Rxn<ReportUmumModel>();

  Future<void> submitUmumData({
    required String idUser,
    required String dusunLingkungan,
    required String pkkRw,
    required String pkkRt,
    required String desaWisma,
    required String krt,
    required String kk,
    required String jiwaLaki,
    required String jiwaPerempuan,
    required String anggotaLaki,
    required String anggotaPerempuan,
    required String umumLaki,
    required String umumPerempuan,
    required String khususLaki,
    required String khususPerempuan,
    required String honorerLaki,
    required String honorerPerempuan,
    required String bantuanLaki,
    required String bantuanPerempuan,
    required String idRole,
    required String idOrganization,
    String? catatan,
  }) async {
    try {
      isLoading(true);

      errorMessage('');

      reportData(null);

      final response = await apiHelper.post(
        '/report/laporan-umum',
        data: {
          'id_user': idUser,
          'dusun_lingkungan': dusunLingkungan,
          'PKK_RW': pkkRw,
          'PKK_RT': pkkRt,
          'desa_wisma': desaWisma,
          'KRT': krt,
          'KK': kk,
          'jiwa_laki': jiwaLaki,
          'jiwa_perempuan': jiwaPerempuan,
          'anggota_laki': anggotaLaki,
          'anggota_perempuan': anggotaPerempuan,
          'umum_laki': umumLaki,
          'umum_perempuan': umumPerempuan,
          'khusus_laki': khususLaki,
          'khusus_perempuan': khususPerempuan,
          'honorer_laki': honorerLaki,
          'honorer_perempuan': honorerPerempuan,
          'bantuan_laki': bantuanLaki,
          'bantuan_perempuan': bantuanPerempuan,
          'id_role': idRole,
          'id_organization': idOrganization,
          if (catatan != null) 'catatan': catatan,
        },
      );

      print(response.data);

      if (response.statusCode == 200) {
        final data = ReportUmumModel.fromJson(response.data);

        reportData(data);

        Get.snackbar(
          'Berhasil',
          'Data Umum berhasil disimpan',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      } else {
        errorMessage('Gagal: ${response.statusCode}');

        Get.snackbar(
          'Gagal',
          errorMessage.value,
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
        errorMessage.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } on TimeoutException {
      errorMessage('Server tidak merespons');

      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      errorMessage(e.toString());

      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading(false);
    }
  }
}
