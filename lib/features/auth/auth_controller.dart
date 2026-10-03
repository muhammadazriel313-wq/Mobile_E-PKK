import 'dart:math';

import 'package:dio/dio.dart';
import 'package:epkk_nganjuk/features/akun/profile_controller.dart';
import 'package:epkk_nganjuk/features/home/nav_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:epkk_nganjuk/core/api_helper.dart';
import 'package:epkk_nganjuk/features/auth/auth_model.dart';
import 'package:epkk_nganjuk/main_screen.dart';
import 'package:epkk_nganjuk/routes/app_routes.dart';
import 'package:epkk_nganjuk/services/preferences/preferences_service.dart';
import 'package:epkk_nganjuk/welcome/welcome_screen.dart';

class AuthController extends GetxController {
  final ApiHelper apiHelper = ApiHelper();

  /// ================= STATE =================
  var isAuthLogin = false.obs;
  var isAuthRegister = false.obs;
  var isForgotPasswordLoading = false.obs;

  var errorMessage = ''.obs;

  var authResponse = Rxn<LoginResponse>();
  var authResponses = Rxn<RegisterResponse>();

  String generatedOtp = '1000';

  /// ================= SPLASH =================
  Future<void> checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 3));

    try {
      final isExpired = await PreferencesService.isLoginExpired();

      if (isExpired) {
        await PreferencesService.clearUserData();

        Get.offAll(
          WelcomeScreen(),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 700),
        );
      } else {
        final user = await PreferencesService.getUser();

        if (user != null) {
          Get.offAll(
            MainScreen(),
            transition: Transition.fadeIn,
            duration: const Duration(milliseconds: 700),
          );
        } else {
          Get.offAll(
            WelcomeScreen(),
            transition: Transition.fadeIn,
            duration: const Duration(milliseconds: 700),
          );
        }
      }
    } catch (e) {
      Get.offAll(
        WelcomeScreen(),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 700),
      );
    }
  }

  /// ================= LOGIN =================
  Future<void> authLoginController({
    required String phoneNumber,
    required String password,
    required String role,
  }) async {
    isAuthLogin.value = true;

    errorMessage.value = '';

    try {
      print("PHONE: $phoneNumber");
      print("PASSWORD: $password");
      print("ROLE: $role");

      final response = await apiHelper.post(
        '/auth/login',
        data: {'phone_number': phoneNumber, 'password': password, 'role': role},
      );

      print("STATUS: ${response.statusCode}");
      print("RESPONSE: ${response.data}");

      final result = LoginResponse.fromJson(response.data);

      authResponse.value = result;

      if (result.statusCode == 200 && result.data != null) {
        await PreferencesService.saveUser(result.data!, result.token ?? '');
        final profilController = Get.find<ProfilController>();

        await profilController.loadProfil();

        Get.snackbar(
          'Berhasil',
          'Login berhasil! Selamat datang ${result.data!.fullName}',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF3F8FC1),
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
          borderRadius: 12,
          duration: const Duration(seconds: 2),
        );

        final NavController navController = Get.find<NavController>();

        navController.changeTabIndex(0);

        Get.offAllNamed(Routes.MAIN);
      } else {
        errorMessage.value = result.message;

        Get.snackbar(
          'Gagal Login',
          result.message,
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFFEF5350),
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
          borderRadius: 12,
        );
      }
    } catch (e) {
      String errorDesc = 'Terjadi kesalahan saat login';

      if (e is DioException) {
        switch (e.response?.statusCode) {
          case 401:
            errorDesc = 'Password salah!';
            break;

          case 403:
            errorDesc = 'Akses ditolak';
            break;

          case 404:
            errorDesc = 'Nomor tidak terdaftar';
            break;

          case 500:
            errorDesc = 'Server error';
            break;

          default:
            errorDesc = e.response?.data['message'] ?? 'Koneksi bermasalah';
        }
      } else {
        errorDesc = e.toString();
      }

      errorMessage.value = errorDesc;

      Get.snackbar(
        'Error',
        errorDesc,
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFEF5350),
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
      );
    } finally {
      isAuthLogin.value = false;
    }
  }

  /// ================= REGISTER =================
  Future<void> authRegisterController({
    required String full_name,
    required String phone_number,
    required String id_subdistrict,
    required String id_village,
    required String role_id,
    required String id_organization,
    required String kode_otp,
    required String password,
  }) async {
    isAuthRegister.value = true;

    errorMessage.value = '';

    try {
      final response = await apiHelper.post(
        '/auth/register',
        data: {
          'full_name': full_name,
          'phone_number': phone_number,
          'id_subdistrict': id_subdistrict,
          'id_village': id_village,
          'id_role': role_id,
          'id_organization': id_organization,
          'password': password,
          'kode_otp': kode_otp,
        },
      );

      final result = RegisterResponse.fromJson(response.data);

      authResponses.value = result;

      if (result.statusCode == 200 && result.data != null) {
        await PreferencesService.saveUser(result.data!, '');

        // Reload profil agar halaman Akun langsung update
        try {
          final profilController = Get.find<ProfilController>();
          await profilController.loadProfil();
        } catch (_) {}

        Get.snackbar(
          'Berhasil',
          'Registrasi berhasil! Selamat datang',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.offAll(MainScreen());
      } else {
        errorMessage.value = result.message;

        Get.snackbar(
          'Gagal',
          result.message,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } finally {
      isAuthRegister.value = false;
    }
  }

  /// ================= OTP =================
  Future<void> sendOtpViaWhatsApp(String phone, String otp) async {
    await apiHelper.post(
      '/auth/send-otp',
      data: {'phone': _formatPhone(phone), 'otp': otp},
    );
  }

  /// ================= RESEND OTP =================
  Future<void> resendOTP(String phone) async {
    try {
      isForgotPasswordLoading.value = true;

      generateRandomNumber();

      await sendOtpViaWhatsApp(phone, generatedOtp);

      Get.snackbar('Berhasil', 'OTP dikirim ulang');
    } finally {
      isForgotPasswordLoading.value = false;
    }
  }

  /// ================= REGISTER OTP =================
  Future<void> resendOtpForRegister({required String phoneNumber}) async {
    try {
      isForgotPasswordLoading.value = true;

      generateRandomNumber();

      await sendOtpViaWhatsApp(phoneNumber, generatedOtp);

      Get.snackbar(
        'Kode Dikirim',
        'Kode OTP baru telah dikirim ke nomor WhatsApp Anda',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengirim ulang OTP: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isForgotPasswordLoading.value = false;
    }
  }

  /// ================= VERIFY PHONE =================
  Future<void> verifyPhoneForPasswordReset(String phone) async {
    try {
      isForgotPasswordLoading.value = true;

      final response = await apiHelper.get(
        '/auth/check-user',
        queryParameters: {'phone_number': phone},
      );

      if (response.statusCode == 200) {
        Get.toNamed(
          Routes.VERIFICATION_FORGOT_PASSWORD,
          arguments: {'phone': phone},
        );
      } else {
        Get.snackbar('Error', response.data['message']);
      }
    } finally {
      isForgotPasswordLoading.value = false;
    }
  }

  /// ================= RESET PASSWORD =================
  Future<void> resetPassword({
    required String phone,
    required String newPassword,
  }) async {
    try {
      isForgotPasswordLoading.value = true;

      final response = await apiHelper.post(
        '/auth/update-password',
        data: {'phone': phone, 'new_password': newPassword},
      );

      if (response.statusCode == 200) {
        await PreferencesService.clearUserData();

        Get.snackbar(
          'Berhasil',
          'Password berhasil diperbarui',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.offAll(WelcomeScreen());
      } else {
        errorMessage.value = response.data['message'];

        Get.snackbar(
          'Error',
          response.data['message'],
          snackPosition: SnackPosition.TOP,
        );
      }
    } finally {
      isForgotPasswordLoading.value = false;
    }
  }

  /// ================= LOGOUT =================
  Future<void> logout() async {
    await PreferencesService.clearUserData();

    Get.offAll(WelcomeScreen());
  }

  /// ================= UTIL =================
  void generateRandomNumber() {
    final random = Random();

    generatedOtp = "1234"; // BYPASS OTP
  }

  String _formatPhone(String phone) {
    String cleaned = phone.replaceAll(RegExp(r'[^0-9]'), '');

    if (cleaned.startsWith('0')) {
      cleaned = cleaned.replaceFirst('0', '62');
    }

    return cleaned;
  }
}
