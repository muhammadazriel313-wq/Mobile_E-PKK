import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:epkk_nganjuk/core/api_helper.dart';
import 'package:epkk_nganjuk/features/pages/pokja1/gotongroyong/gotong_royong_model.dart';

class GotongRoyongController extends GetxController {
  final ApiHelper apiHelper = ApiHelper();

  var reportData = Rxn<ReportGotongRoyongModel>();
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<bool> submitGotongRoyong({
    required String idUser,
    required String idRole,
    required String idOrganization,

    // KERJA BAKTI
    String? kerjaBaktiKegiatan,
    String? kerjaBaktiVol,
    String? kerjaBaktiMetode,
    String? kerjaBaktiSasaran,

    // BANTUAN ANAK YATIM
    String? bantuanYatimKegiatan,
    String? bantuanYatimVol,
    String? bantuanYatimMetode,
    String? bantuanYatimSasaran,

    // KEGIATAN SOSIAL
    String? kegiatanSosialKegiatan,
    String? kegiatanSosialVol,
    String? kegiatanSosialMetode,
    String? kegiatanSosialSasaran,

    // TAMBAHAN
    String? sumberDana,
    String? hasilKegiatan,
    String? catatan,

    // LEGACY (optional fallback)
    String kerjaBakti = '0',
    String rukunKematian = '0',
    String keagamaan = '0',
    String jimpitan = '0',
    String arisan = '0',
    String? jenisKegiatan,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await apiHelper.post(
        '/report/gotong-royong',
        data: {
          'id_user': idUser,
          'id_role': idRole,
          'id_organization': idOrganization,

          // Sub-kolom KERJA BAKTI
          if (kerjaBaktiKegiatan != null) 'kerja_bakti_kegiatan': kerjaBaktiKegiatan,
          if (kerjaBaktiVol != null) 'kerja_bakti_vol': kerjaBaktiVol,
          if (kerjaBaktiMetode != null) 'kerja_bakti_metode': kerjaBaktiMetode,
          if (kerjaBaktiSasaran != null) 'kerja_bakti_sasaran': kerjaBaktiSasaran,

          // Sub-kolom BANTUAN ANAK YATIM
          if (bantuanYatimKegiatan != null) 'bantuan_yatim_kegiatan': bantuanYatimKegiatan,
          if (bantuanYatimVol != null) 'bantuan_yatim_vol': bantuanYatimVol,
          if (bantuanYatimMetode != null) 'bantuan_yatim_metode': bantuanYatimMetode,
          if (bantuanYatimSasaran != null) 'bantuan_yatim_sasaran': bantuanYatimSasaran,

          // Sub-kolom KEGIATAN SOSIAL
          if (kegiatanSosialKegiatan != null) 'kegiatan_sosial_kegiatan': kegiatanSosialKegiatan,
          if (kegiatanSosialVol != null) 'kegiatan_sosial_vol': kegiatanSosialVol,
          if (kegiatanSosialMetode != null) 'kegiatan_sosial_metode': kegiatanSosialMetode,
          if (kegiatanSosialSasaran != null) 'kegiatan_sosial_sasaran': kegiatanSosialSasaran,

          // LEGACY & FALLBACK
          'kerja_bakti': kerjaBaktiVol ?? kerjaBakti,
          'rukun_kematian': bantuanYatimVol ?? rukunKematian,
          'keagamaan': kegiatanSosialVol ?? keagamaan,
          'jimpitan': jimpitan,
          'arisan': arisan,
          if (jenisKegiatan != null) 'jenis_kegiatan': jenisKegiatan,

          // TAMBAHAN
          if (sumberDana != null) 'sumber_dana': sumberDana,
          if (hasilKegiatan != null) 'hasil_kegiatan': hasilKegiatan,
          if (catatan != null) 'catatan': catatan,
        },
      );

      if (response.statusCode == 200) {
        reportData.value = ReportGotongRoyongModel.fromJson(response.data);

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
        errorMessage.value = 'Gagal upload data';

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

        return false;
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

      return false;
    } on TimeoutException {
      errorMessage.value = 'Server timeout';

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

      return false;
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

      return false;
    } finally {
      isLoading.value = false;
    }
  }
}