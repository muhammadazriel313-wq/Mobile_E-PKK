import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:epkk_nganjuk/core/api_helper.dart';
import 'package:epkk_nganjuk/services/preferences/preferences_service.dart';
import 'package:epkk_nganjuk/features/pages/pokja2/pendidikan/report_pendidikan_ketrampilan_model.dart';

class PendidikanKeterampilanController extends GetxController {
  final ApiHelper apiHelper = ApiHelper();

  // ================= USER =================
  String idUser = '';
  String idRole = '';
  String idOrganization = '';

  // ================= STATE =================
  var isLoading = false.obs;
  var reportData = Rxn<ReportPendidikanKeterampilanModel>();

  // ================= INIT =================
  @override
  void onInit() {
    super.onInit();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await PreferencesService.getUser();

    if (user != null) {
      idUser = user.id?.toString() ?? '';
      idRole = user.role?.id?.toString() ?? '';
      idOrganization = user.organization?.id?.toString() ?? '';

      print("LOGIN USER -> $idUser | $idRole | $idOrganization");
    } else {
      print("USER NULL ❌");
    }
  }

  // ================= STEP 1 =================
  String wargaButa = '';
  String kelBelajarA = '';
  String wargaBelajarA = '';
  String kelBelajarB = '';
  String wargaBelajarB = '';

  void setStep1({
    required String wargaButaVal,
    required String kelA,
    required String wargaA,
    required String kelB,
    required String wargaB,
  }) {
    wargaButa = wargaButaVal;
    kelBelajarA = kelA;
    wargaBelajarA = wargaA;
    kelBelajarB = kelB;
    wargaBelajarB = wargaB;
  }

  // ================= STEP 2 =================
  String kelBelajarC = '';
  String wargaBelajarC = '';
  String kelBelajarKF = '';
  String wargaBelajarKF = '';
  String paud = '';
  String tamanBacaan = '';

  void setStep2({
    required String kelC,
    required String wargaC,
    required String kelKF,
    required String wargaKF,
    required String paudVal,
    required String taman,
  }) {
    kelBelajarC = kelC;
    wargaBelajarC = wargaC;
    kelBelajarKF = kelKF;
    wargaBelajarKF = wargaKF;
    paud = paudVal;
    tamanBacaan = taman;
  }

  // ================= STEP 3 =================
  String jumlahKlp = '';
  String jumlahIbuPeserta = '';
  String jumlahApe = '';
  String jumlahKelSimulasi = '';
  String kf = '';
  String paudTutor = '';
  String bkb = '';
  String koperasi = '';
  String ketrampilan = '';

  void setStep3({
    required String klp,
    required String ibu,
    required String ape,
    required String simulasi,
    required String kfVal,
    required String paudTutorVal,
    required String bkbVal,
    required String koperasiVal,
    required String ketrampilanVal,
  }) {
    jumlahKlp = klp;
    jumlahIbuPeserta = ibu;
    jumlahApe = ape;
    jumlahKelSimulasi = simulasi;
    kf = kfVal;
    paudTutor = paudTutorVal;
    bkb = bkbVal;
    koperasi = koperasiVal;
    ketrampilan = ketrampilanVal;
  }

  // ================= STEP 4 =================
  String lp3pkk = '';
  String tp3pkk = '';
  String damasPkk = '';

  void setStep4({
    required String lp3,
    required String tp3,
    required String damas,
  }) {
    lp3pkk = lp3;
    tp3pkk = tp3;
    damasPkk = damas;
  }

  void clearForm() {
    wargaButa = '';
    kelBelajarA = '';
    wargaBelajarA = '';
    kelBelajarB = '';
    wargaBelajarB = '';
    kelBelajarC = '';
    wargaBelajarC = '';
    kelBelajarKF = '';
    wargaBelajarKF = '';
    paud = '';
    tamanBacaan = '';
    jumlahKlp = '';
    jumlahIbuPeserta = '';
    jumlahApe = '';
    jumlahKelSimulasi = '';
    kf = '';
    paudTutor = '';
    bkb = '';
    koperasi = '';
    ketrampilan = '';
    lp3pkk = '';
    tp3pkk = '';
    damasPkk = '';
  }

  // ================= SUBMIT =================
  Future<bool> submit() async {
    if (isLoading.value) return false;

    if (idUser.isEmpty || idRole.isEmpty || idOrganization.isEmpty) {
      Get.snackbar(
        'Error',
        'Session user belum siap, coba ulangi',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      return false;
    }

    try {
      isLoading.value = true;

      final response = await apiHelper.post(
        '/report/pendidikan-keterampilan',
        data: {
          'id_user': idUser,
          'warga_buta': wargaButa,
          'kel_belajarA': kelBelajarA,
          'warga_belajarA': wargaBelajarA,
          'kel_belajarB': kelBelajarB,
          'warga_belajarB': wargaBelajarB,
          'kel_belajarC': kelBelajarC,
          'warga_belajarC': wargaBelajarC,
          'kel_belajarKF': kelBelajarKF,
          'warga_belajarKF': wargaBelajarKF,
          'paud': paud,
          'taman_bacaan': tamanBacaan,
          'jumlah_klp': jumlahKlp,
          'jumlah_ibu_peserta': jumlahIbuPeserta,
          'jumlah_ape': jumlahApe,
          'jumlah_kel_simulasi': jumlahKelSimulasi,
          'KF': kf,
          'paud_tutor': paudTutor,
          'BKB': bkb,
          'koperasi': koperasi,
          'ketrampilan': ketrampilan,
          'LP3PKK': lp3pkk,
          'TP3PKK': tp3pkk,
          'damas_pkk': damasPkk,
          'id_role': idRole,
          'id_organization': idOrganization,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        reportData.value = ReportPendidikanKeterampilanModel.fromJson(
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
      if (e is DioException) {
        Get.snackbar(
          'Server Error',
          e.response?.data?['message'] ??
              e.response?.data.toString() ??
              'Terjadi kesalahan pada server',
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
      isLoading.value = false;
    }
  }
}
