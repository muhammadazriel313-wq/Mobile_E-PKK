import 'dart:async';
import 'dart:io';

import 'package:epkk_nganjuk/core/api_helper.dart';
import 'package:epkk_nganjuk/features/akun/profile_model.dart';
import 'package:epkk_nganjuk/services/preferences/preferences_service.dart';
import 'package:get/get.dart';

import '../auth/auth_controller.dart';

class ProfilController extends GetxController {
  final ApiHelper apiHelper = ApiHelper();
  final AuthController authController = Get.find<AuthController>();

  final profilData = Profil(
    id: '0',
    uuid: '',
    phoneNumber: '',
    fullName: '',
    password: '',
    kodeOtp: '',
    status: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    idSubdistrict: '0',
    idVillage: '0',
    idRole: '0',
    idOrganization: '0',
  ).obs;

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final isUpdating = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfil();
  }

  // ================= LOAD PROFILE =================
  Future<void> loadProfil() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final user = await PreferencesService.getUser();
      if (user == null) throw Exception('User not logged in');

      print('====================');
      print('HIT API PROFILE');
      print('USER ID: ${user.id}');

      final response = await apiHelper.get(
        '/profile',
        queryParameters: {
          'id': user.id.toString(), //  WAJIB ini
        },
      );

      final body = response.data;

      if (body['statusCode'] == 200 && body['data'] != null) {
        profilData.value = Profil.fromJson(body['data']);
      } else {
        throw Exception(body['message'] ?? 'Gagal load profile');
      }
    } on SocketException {
      errorMessage.value = 'Tidak ada koneksi internet';
    } catch (e) {
      print('ERROR LOAD PROFILE: $e');
      errorMessage.value = 'Failed to load profile: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // ================= UPDATE PROFILE =================
  Future<bool> updateProfileInfo({
    required String fullName,
    required String phoneNumber,
  }) async {
    isUpdating.value = true;
    errorMessage.value = '';

    try {
      final response = await apiHelper.post(
        '/profile/update',
        data: {
          'id': profilData.value.id,
          'full_name': fullName,
          'phone_number': phoneNumber,
        },
      );

      if (response.statusCode == 200) {
        profilData.value = Profil(
          id: profilData.value.id,
          uuid: profilData.value.uuid,
          fullName: fullName,
          phoneNumber: phoneNumber,
          password: profilData.value.password,
          kodeOtp: profilData.value.kodeOtp,
          status: profilData.value.status,
          createdAt: profilData.value.createdAt,
          updatedAt: DateTime.now(),
          idSubdistrict: profilData.value.idSubdistrict,
          idVillage: profilData.value.idVillage,
          idRole: profilData.value.idRole,
          idOrganization: profilData.value.idOrganization,
        );

        Get.snackbar('Berhasil', 'Profil diperbarui');
        return true;
      } else {
        errorMessage.value = response.data['message'];
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Gagal update: $e';
      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  // ================= UPDATE PASSWORD =================
  Future<bool> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    isUpdating.value = true;
    errorMessage.value = '';

    try {
      final response = await apiHelper.post(
        '/profile/update',
        data: {
          'id': profilData.value.id,
          'current_password': currentPassword,
          'new_password': newPassword,
        },
      );

      if (response.statusCode == 200) {
        Get.snackbar('Berhasil', 'Password diperbarui');
        return true;
      } else {
        errorMessage.value = response.data['message'];
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Gagal update password: $e';
      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  void resetErrorMessage() => errorMessage.value = '';
}