import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:epkk_nganjuk/core/api_helper.dart';
import 'package:epkk_nganjuk/features/laporan/upload_galeri/upload_galeri_model.dart';

class GaleriController extends GetxController {
  final ApiHelper apiHelper = ApiHelper();

  /// STATE
  var isLoading = false.obs;

  var errorMessage = ''.obs;

  var galeriData = Rxn<GaleriModel>();

  /// SUBMIT GALERI
  Future<void> submitDataGaleri({
    required String idUser,
    required String deskripsi,
    required String gambar,
    Uint8List? gambarBytes,
    String? namaFile,
    required String pokja,
    required String bidang,
    required String idRole,
    required String idOrganization,

    String? namaPeserta,
    String? lokasi,
    double? latitude,
    double? longitude,
    String? status,
  }) async {
    try {
      isLoading.value = true;

      errorMessage.value = '';

      galeriData.value = null;

      /// FILE MULTIPART
      // [PERUBAHAN 03-10-2026] Mendukung upload di Flutter Web menggunakan fromBytes; kode lama di bawah dinonaktifkan
      // final file = await dio.MultipartFile.fromFile(gambar);
      final dio.MultipartFile file = (kIsWeb && gambarBytes != null)
          ? dio.MultipartFile.fromBytes(gambarBytes, filename: namaFile ?? 'upload.jpg')
          : await dio.MultipartFile.fromFile(gambar);

      final response = await apiHelper.postMultipart(
        '/report/galeri',
        data: {
          'id_user': idUser,
          'deskripsi': deskripsi,
          'gambar': file,
          'pokja': pokja,
          'bidang': bidang,
          'id_role': idRole,
          'id_organization': idOrganization,

          if (namaPeserta != null) 'nama_peserta': namaPeserta,

          if (lokasi != null) 'lokasi': lokasi,

          if (latitude != null) 'latitude': latitude,

          if (longitude != null) 'longitude': longitude,

          if (status != null) 'status': status,
        },
      );

      if (response.statusCode == 200) {
        final body = response.data;

        if (body is Map<String, dynamic>) {
          final result = GaleriModel.fromJson(body);

          galeriData.value = result;

          Get.snackbar(
            'Berhasil',
            'Foto berhasil dikirim',
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color(0xFF3F8FC1),
            colorText: Colors.white,
            margin: const EdgeInsets.all(12),
            borderRadius: 12,
            duration: const Duration(seconds: 3),
          );
        } else {
          errorMessage.value = 'Format respons tidak valid';

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
        errorMessage.value = 'Server bermasalah';

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
        errorMessage.value = 'Terjadi kesalahan (${response.statusCode})';

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
    } on DioException catch (e) {
      errorMessage.value =
          e.response?.data['message'] ?? 'Terjadi kesalahan jaringan';

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
      errorMessage.value = 'Gagal upload galeri';

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
}
