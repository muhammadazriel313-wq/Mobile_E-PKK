import 'package:dio/dio.dart';
import 'package:epkk_nganjuk/core/api_helper.dart';
import 'package:epkk_nganjuk/features/pages/pokja3/pangan/report_pangan_model.dart';
import 'package:epkk_nganjuk/services/preferences/preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PanganController extends GetxController {
  final ApiHelper apiHelper = ApiHelper();

  var isLoading = false.obs;
  var reportData = Rxn<ReportPanganModel>();
  var errorMessage = ''.obs;

  // ================= FORM =================
  var beras = ''.obs;
  var nonBeras = ''.obs;
  var peternakan = ''.obs;
  var perikanan = ''.obs;
  var warungHidup = ''.obs;
  var lumbungHidup = ''.obs;
  var toga = ''.obs;
  var tanamanKeras = ''.obs;
  var tanamanLainnya = ''.obs;

  // ================= USER =================
  String idUser = '';
  String idRole = '';
  String idOrganization = '';

  @override
  void onInit() {
    super.onInit();
    loadUser();
  }

  Future<void> loadUser() async {
    final user = await PreferencesService.getUser();

    idUser = user?.id?.toString() ?? '';
    idRole = user?.role?.id?.toString() ?? '';
    idOrganization = user?.organization?.id?.toString() ?? '';
  }

  // ================= METHOD BARU =================
  Future<void> submitDataPangan({
    required String idUser,
    required String beras,
    required String nonBeras,
    required String peternakan,
    required String perikanan,
    required String warungHidup,
    required String lumbungHidup,
    required String toga,
    required String tanamanKeras,
    required String tanamanLainnya,
    required String idRole,
    required String idOrganization,
    String? catatan,
  }) async {
    try {
      isLoading(true);
      errorMessage('');

      final response = await apiHelper.post(
        '/report/pangan',
        data: {
          'id_user': idUser,
          'beras': beras,
          'non_beras': nonBeras,
          'peternakan': peternakan,
          'perikanan': perikanan,
          'warung_hidup': warungHidup,
          'lumbung_hidup': lumbungHidup,
          'toga': toga,
          'tanaman_keras': tanamanKeras,
          'tanaman_lainnya': tanamanLainnya,
          'id_role': idRole,
          'id_organization': idOrganization,
          if (catatan != null) 'catatan': catatan,
        },
      );

      if (response.statusCode == 200) {
        reportData.value = ReportPanganModel.fromJson(response.data);

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
        errorMessage.value = 'Gagal upload data';

        Get.snackbar(
          'Gagal',
          'Gagal upload data',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      errorMessage.value = e.toString();

      if (e is DioException) {
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
    } finally {
      isLoading(false);
    }
  }

  // ================= METHOD LAMA =================
  Future<bool> submit() async {
    try {
      isLoading(true);

      final response = await apiHelper.post(
        '/report/pangan',
        data: {
          'id_user': idUser,
          'beras': beras.value,
          'non_beras': nonBeras.value,
          'peternakan': peternakan.value,
          'perikanan': perikanan.value,
          'warung_hidup': warungHidup.value,
          'lumbung_hidup': lumbungHidup.value,
          'toga': toga.value,
          'tanaman_keras': tanamanKeras.value,
          'tanaman_lainnya': tanamanLainnya.value,
          'id_role': idRole,
          'id_organization': idOrganization,
        },
      );

      if (response.statusCode == 200) {
        reportData.value = ReportPanganModel.fromJson(response.data);

        Get.snackbar(
          'Berhasil',
          'Data berhasil disimpan',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        return true;
      }

      Get.snackbar(
        'Gagal',
        'Upload gagal',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      return false;
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
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
}
