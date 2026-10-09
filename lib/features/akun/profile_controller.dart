import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:epkk_nganjuk/core/api_helper.dart';
import 'package:epkk_nganjuk/features/akun/profile_model.dart';
import 'package:epkk_nganjuk/services/preferences/preferences_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
  // [PERUBAHAN 08-10-2026] Observable status unggah foto profil
  final isUploadingPhoto = false.obs;

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
          // [PERUBAHAN 08-10-2026] Mempertahankan nilai foto yang sudah ada
          foto: profilData.value.foto,
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

  // ================= UPLOAD FOTO PROFIL =================
  // [PERUBAHAN 08-10-2026] Fungsi mengunggah dan mengganti foto profil
  Future<bool> uploadProfilePhoto({
    required String filePath,
    Uint8List? fileBytes,
    String? fileName,
    bool showSuccessSnackbar = true,
  }) async {
    isUploadingPhoto.value = true;
    errorMessage.value = '';

    try {
      final dio.MultipartFile file;
      if (fileBytes != null) {
        file = dio.MultipartFile.fromBytes(
          fileBytes,
          filename: fileName ?? 'profile.jpg',
        );
      } else {
        file = await dio.MultipartFile.fromFile(
          filePath,
          filename: fileName,
        );
      }

      final user = await PreferencesService.getUser();
      final userId = (profilData.value.id.isNotEmpty && profilData.value.id != '0')
          ? profilData.value.id
          : (user?.id ?? '0');

      if (userId == '0' || userId.isEmpty) {
        throw Exception('ID pengguna tidak valid');
      }

      final response = await apiHelper.postMultipart(
        '/profile/photo',
        data: {
          'id_user': userId,
          'foto': file,
        },
      );

      if (response.statusCode == 200) {
        final body = response.data;
        String? newPhotoUrl;
        if (body['data'] != null && body['data']['foto'] != null) {
          newPhotoUrl = body['data']['foto'].toString();
        }

        if (newPhotoUrl != null && newPhotoUrl.isNotEmpty) {
          // Parameter versi untuk mencegah cache gambar
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          final separator = newPhotoUrl.contains('?') ? '&' : '?';
          final versionedUrl = '$newPhotoUrl${separator}v=$timestamp';

          profilData.value = profilData.value.copyWith(foto: versionedUrl);
        } else {
          await loadProfil();
        }

        if (showSuccessSnackbar) {
          Get.snackbar(
            'Berhasil',
            'Foto profil berhasil diperbarui',
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color(0xFF3F8FC1),
            colorText: Colors.white,
            margin: const EdgeInsets.all(12),
            borderRadius: 12,
            duration: const Duration(seconds: 3),
          );
        }
        return true;
      } else {
        final msg = response.data['message'] ?? 'Gagal memperbarui foto profil';
        errorMessage.value = msg;
        Get.snackbar('Gagal', msg, snackPosition: SnackPosition.TOP);
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Gagal memperbarui foto profil: $e';
      Get.snackbar('Gagal', 'Gagal memperbarui foto profil', snackPosition: SnackPosition.TOP);
      return false;
    } finally {
      isUploadingPhoto.value = false;
    }
  }

  // ================= DELETE FOTO PROFIL =================
  // [PERUBAHAN 08-10-2026] Fungsi menghapus foto profil pengguna
  Future<bool> deleteProfilePhoto() async {
    isUploadingPhoto.value = true;
    errorMessage.value = '';

    try {
      final user = await PreferencesService.getUser();
      final userId = (profilData.value.id.isNotEmpty && profilData.value.id != '0')
          ? profilData.value.id
          : (user?.id ?? '0');

      if (userId == '0' || userId.isEmpty) {
        throw Exception('ID pengguna tidak valid');
      }

      final response = await apiHelper.post(
        '/profile/photo/delete',
        data: {'id_user': userId},
      );

      if (response.statusCode == 200) {
        // Update profilData lokal
        profilData.value = Profil(
          id: profilData.value.id,
          uuid: profilData.value.uuid,
          fullName: profilData.value.fullName,
          phoneNumber: profilData.value.phoneNumber,
          password: profilData.value.password,
          kodeOtp: profilData.value.kodeOtp,
          status: profilData.value.status,
          createdAt: profilData.value.createdAt,
          updatedAt: DateTime.now(),
          idSubdistrict: profilData.value.idSubdistrict,
          idVillage: profilData.value.idVillage,
          idRole: profilData.value.idRole,
          idOrganization: profilData.value.idOrganization,
          foto: null,
        );

        Get.snackbar(
          'Berhasil',
          'Foto profil berhasil dihapus',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF3F8FC1),
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
          borderRadius: 12,
          duration: const Duration(seconds: 3),
        );
        return true;
      } else {
        final msg = response.data['message'] ?? 'Gagal menghapus foto profil';
        errorMessage.value = msg;
        Get.snackbar('Gagal', msg, snackPosition: SnackPosition.TOP);
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Gagal menghapus foto profil: $e';
      Get.snackbar('Gagal', 'Gagal menghapus foto profil', snackPosition: SnackPosition.TOP);
      return false;
    } finally {
      isUploadingPhoto.value = false;
    }
  }

  final isDeleting = false.obs;

  // ================= DELETE ACCOUNT =================
  Future<bool> deleteAccount() async {
    isDeleting.value = true;
    errorMessage.value = '';

    try {
      final user = await PreferencesService.getUser();
      final userId = user?.id ?? profilData.value.id;

      if (userId == '0' || userId.isEmpty) {
        throw Exception('User ID tidak valid');
      }

      print('====================');
      print('HIT API DELETE ACCOUNT');
      print('USER ID: $userId');

      final response = await apiHelper.post(
        '/profile/delete',
        data: {'id': userId},
      );

      final body = response.data;
      if (response.statusCode == 200 &&
          (body['statusCode'] == 200 || body['statusCode'] == null)) {
        // Hapus session pengguna lokal
        await PreferencesService.clearUserData();

        // Reset data profil lokal
        profilData.value = Profil(
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
        );

        return true;
      } else {
        final msg = body['message'] ??
            body['error']?['message'] ??
            'Gagal menghapus akun';
        errorMessage.value = msg;
        return false;
      }
    } catch (e) {
      print('ERROR DELETE ACCOUNT: $e');
      errorMessage.value = 'Gagal menghapus akun: $e';
      return false;
    } finally {
      isDeleting.value = false;
    }
  }

  void resetErrorMessage() => errorMessage.value = '';
}