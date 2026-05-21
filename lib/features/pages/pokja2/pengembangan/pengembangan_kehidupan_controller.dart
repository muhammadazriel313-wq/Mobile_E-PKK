import 'package:dio/dio.dart';
import 'package:epkk_nganjuk/core/api_helper.dart';
import 'package:epkk_nganjuk/features/pages/pokja2/pengembangan/report_pengembangan_kehidupan.dart';
import 'package:epkk_nganjuk/services/preferences/preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PengembanganKehidupanController extends GetxController {
  final ApiHelper apiHelper = ApiHelper();

  // ================= STATE =================
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var reportData = Rxn<ReportPengembanganKehidupanModel>();

  // ================= FORM =================
  PengembanganKehidupanEntry form = PengembanganKehidupanEntryExtension.empty();

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

  // ================= SET FIELD =================
  void setField({
    String? jumlahKelompokPemula,
    String? jumlahPesertaPemula,
    String? jumlahKelompokMadya,
    String? jumlahPesertaMadya,
    String? jumlahKelompokUtama,
    String? jumlahPesertaUtama,
    String? jumlahKelompokMandiri,
    String? jumlahPesertaMandiri,
    String? jumlahKelompokHukum,
    String? jumlahPesertaHukum,
    String? catatan,
  }) {
    form = PengembanganKehidupanEntry(
      idPokja2Bidang2: form.idPokja2Bidang2,
      uuid: form.uuid,
      idUser: form.idUser,
      jumlahKelompokPemula: jumlahKelompokPemula ?? form.jumlahKelompokPemula,
      jumlahPesertaPemula: jumlahPesertaPemula ?? form.jumlahPesertaPemula,
      jumlahKelompokMadya: jumlahKelompokMadya ?? form.jumlahKelompokMadya,
      jumlahPesertaMadya: jumlahPesertaMadya ?? form.jumlahPesertaMadya,
      jumlahKelompokUtama: jumlahKelompokUtama ?? form.jumlahKelompokUtama,
      jumlahPesertaUtama: jumlahPesertaUtama ?? form.jumlahPesertaUtama,
      jumlahKelompokMandiri:
          jumlahKelompokMandiri ?? form.jumlahKelompokMandiri,
      jumlahPesertaMandiri: jumlahPesertaMandiri ?? form.jumlahPesertaMandiri,
      jumlahKelompokHukum: jumlahKelompokHukum ?? form.jumlahKelompokHukum,
      jumlahPesertaHukum: jumlahPesertaHukum ?? form.jumlahPesertaHukum,
      catatan: catatan ?? form.catatan,
      status: form.status,
      createdAt: form.createdAt,
      updatedAt: form.updatedAt,
      role: form.role,
      organization: form.organization,
    );
  }

  // ================= SUBMIT =================
  Future<bool> submit() async {
    if (isLoading.value) return false;

    if (idUser.isEmpty || idRole.isEmpty || idOrganization.isEmpty) {
      Get.snackbar(
        'Error',
        'Session user belum siap',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      return false;
    }

    try {
      isLoading(true);
      errorMessage('');

      final response = await apiHelper.post(
        '/report/pengembangan-kehidupan',
        data: form.toRequest(
          idUser: idUser,
          idRole: idRole,
          idOrganization: idOrganization,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        reportData.value = ReportPengembanganKehidupanModel.fromJson(
          response.data,
        );

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

        // RESET FORM
        form = PengembanganKehidupanEntryExtension.empty();

        return true;
      } else {
        Get.snackbar(
          'Gagal',
          'Upload gagal',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        return false;
      }
    } catch (e) {
      errorMessage(e.toString());

      if (e is DioException) {
        Get.snackbar(
          'Server Error',
          e.response?.data?['message'] ??
              e.response?.data.toString() ??
              'Terjadi kesalahan',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      } else {
        Get.snackbar(
          'Error',
          e.toString(),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }

      return false;
    } finally {
      isLoading(false);
    }
  }
}
