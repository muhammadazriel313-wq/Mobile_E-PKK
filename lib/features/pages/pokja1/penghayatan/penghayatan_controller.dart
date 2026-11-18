import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:epkk_nganjuk/core/api_helper.dart';
import 'package:epkk_nganjuk/features/pages/pokja1/penghayatan/penghayatan_model.dart';

class DraftSubmitResult {
  final bool success;
  final bool networkFailure;
  final bool sessionExpired;
  final int? statusCode;
  final String? message;

  const DraftSubmitResult._({
    this.success = false,
    this.networkFailure = false,
    this.sessionExpired = false,
    this.statusCode,
    this.message,
  });
  factory DraftSubmitResult.success() =>
      const DraftSubmitResult._(success: true);
  factory DraftSubmitResult.networkError(String message) =>
      DraftSubmitResult._(networkFailure: true, message: message);
  factory DraftSubmitResult.sessionExpired() =>
      const DraftSubmitResult._(sessionExpired: true, statusCode: 401);
  factory DraftSubmitResult.serverError(String message, int? statusCode) =>
      DraftSubmitResult._(message: message, statusCode: statusCode);
}

class PenghayatanPengamalanController extends GetxController {
  final ApiHelper apiHelper = ApiHelper();
  var reportData = Rxn<ReportPenghayatanPengamalanModel>();
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var lastFailureWasNetwork = false.obs;

  Future<void> submitPenghayatanPengamalan({
    required String idUser,
    required String kisahKegiatan,
    required String kisahVol,
    required String kisahMetode,
    required String kisahSasaran,
    required String krisanKegiatan,
    required String krisanVol,
    required String krisanMetode,
    required String krisanSasaran,
    required String kilasKegiatan,
    required String kilasVol,
    required String kilasMetode,
    required String kilasSasaran,
    required String kiatKegiatan,
    required String kiatVol,
    required String kiatMetode,
    required String kiatSasaran,
    required String kisakKegiatan,
    required String kisakVol,
    required String kisakMetode,
    required String kisakSasaran,
    required String pkbnKegiatan,
    required String pkbnVol,
    required String pkbnMetode,
    required String pkbnSasaran,
    String? sumberDana,
    String? hasilKegiatan,
    required String idRole,
    required String idOrganization,
    String? catatan,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';
    lastFailureWasNetwork.value = false;
    reportData.value = null;

    try {
      final response = await apiHelper.post(
        '/report/penghayatan',
        data: {
          'id_user': idUser,
          'kisah_kegiatan': kisahKegiatan,
          'kisah_vol': kisahVol,
          'kisah_metode': kisahMetode,
          'kisah_sasaran': kisahSasaran,
          'krisan_kegiatan': krisanKegiatan,
          'krisan_vol': krisanVol,
          'krisan_metode': krisanMetode,
          'krisan_sasaran': krisanSasaran,
          'kilas_kegiatan': kilasKegiatan,
          'kilas_vol': kilasVol,
          'kilas_metode': kilasMetode,
          'kilas_sasaran': kilasSasaran,
          'kiat_kegiatan': kiatKegiatan,
          'kiat_vol': kiatVol,
          'kiat_metode': kiatMetode,
          'kiat_sasaran': kiatSasaran,
          'kisak_kegiatan': kisakKegiatan,
          'kisak_vol': kisakVol,
          'kisak_metode': kisakMetode,
          'kisak_sasaran': kisakSasaran,
          'pkbn_kegiatan': pkbnKegiatan,
          'pkbn_vol': pkbnVol,
          'pkbn_metode': pkbnMetode,
          'pkbn_sasaran': pkbnSasaran,
          if (sumberDana != null) 'sumber_dana': sumberDana,
          if (hasilKegiatan != null) 'hasil_kegiatan': hasilKegiatan,
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
            backgroundColor: const Color(0xFF3F8FC1),
            colorText: Colors.white,
          );
        } else {
          errorMessage.value = result.message;
          Get.snackbar(
            'Gagal',
            errorMessage.value,
            backgroundColor: const Color(0xFFEF5350),
            colorText: Colors.white,
          );
        }
      } else {
        errorMessage.value = 'Format response tidak valid';
        Get.snackbar(
          'Error',
          errorMessage.value,
          backgroundColor: const Color(0xFFEF5350),
          colorText: Colors.white,
        );
      }
    } on DioException catch (e) {
      final networkFailure =
          e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout;
      lastFailureWasNetwork.value = networkFailure;
      errorMessage.value = e.response?.statusCode == 422
          ? ((e.response?.data is Map
                    ? e.response?.data['message']?.toString()
                    : null) ??
                'Data tidak dapat diterima')
          : (e.response?.statusCode == 401
                ? 'Sesi login habis'
                : (networkFailure
                      ? 'Tidak ada koneksi internet atau waktu tunggu habis'
                      : 'Terjadi kesalahan'));
      Get.snackbar(
        'Error',
        errorMessage.value,
        backgroundColor: const Color(0xFFEF5350),
        colorText: Colors.white,
      );
    } on SocketException {
      lastFailureWasNetwork.value = true;
      errorMessage.value = 'Tidak ada koneksi internet';
      Get.snackbar(
        'Error',
        errorMessage.value,
        backgroundColor: const Color(0xFFEF5350),
        colorText: Colors.white,
      );
    } on TimeoutException {
      lastFailureWasNetwork.value = true;
      errorMessage.value = 'Waktu tunggu koneksi habis';
      Get.snackbar(
        'Error',
        errorMessage.value,
        backgroundColor: const Color(0xFFEF5350),
        colorText: Colors.white,
      );
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan';
      Get.snackbar(
        'Error',
        errorMessage.value,
        backgroundColor: const Color(0xFFEF5350),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<DraftSubmitResult> submitDraftData(Map<String, dynamic> data) async {
    return _submitData(data);
  }

  Future<DraftSubmitResult> _submitData(Map<String, dynamic> data) async {
    isLoading.value = true;
    errorMessage.value = '';
    reportData.value = null;
    try {
      // TODO Tahap 6: kirim UUID draf sebagai kunci idempotensi setelah backend mendukungnya.
      final response = await apiHelper
          .post(
            '/report/penghayatan',
            data: {...data, 'tanggal_laporan': data['tanggal_dibuat']},
          )
          .timeout(const Duration(seconds: 45));
      final body = response.data;
      if (body is Map<String, dynamic>) {
        final result = ReportPenghayatanPengamalanModel.fromJson(body);
        if (result.statusCode == 200) {
          reportData.value = result;
          return DraftSubmitResult.success();
        }
        errorMessage.value = result.message;
        return DraftSubmitResult.serverError(result.message, result.statusCode);
      }
      errorMessage.value = 'Format response tidak valid';
      return DraftSubmitResult.serverError(
        errorMessage.value,
        response.statusCode,
      );
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 401) return DraftSubmitResult.sessionExpired();
      if (status == 422) {
        final data = e.response?.data;
        final message = data is Map
            ? (data['message']?.toString() ?? data.toString())
            : data?.toString();
        errorMessage.value = message ?? 'Data tidak dapat diterima';
        return DraftSubmitResult.serverError(errorMessage.value, status);
      }
      final network =
          e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout;
      errorMessage.value = network
          ? 'Tidak ada koneksi internet atau waktu tunggu habis'
          : 'Terjadi kesalahan';
      return network
          ? DraftSubmitResult.networkError(errorMessage.value)
          : DraftSubmitResult.serverError(errorMessage.value, status);
    } on SocketException {
      errorMessage.value = 'Tidak ada koneksi internet';
      return DraftSubmitResult.networkError(errorMessage.value);
    } on TimeoutException {
      lastFailureWasNetwork.value = true;
      errorMessage.value = 'Waktu tunggu koneksi habis';
      return DraftSubmitResult.networkError(errorMessage.value);
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan';
      return DraftSubmitResult.serverError(errorMessage.value, null);
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    reportData.value = null;
    errorMessage.value = '';
  }
}
