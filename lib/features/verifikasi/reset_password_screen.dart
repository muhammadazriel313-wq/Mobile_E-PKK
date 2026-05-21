import 'package:epkk_nganjuk/features/auth/auth_controller.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:epkk_nganjuk/features/auth/component/header_text.dart';
import 'package:epkk_nganjuk/features/auth/component/icon_button_back.dart';
import 'package:epkk_nganjuk/features/auth/component/input_password.dart';
import 'package:epkk_nganjuk/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final AuthController _authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late String _phone;
  late String _otp;
  late String _role;

  @override
  void initState() {
    super.initState();
    _phone = Get.arguments['phone'] ?? '';
    _otp = Get.arguments['otp'] ?? '';
    _role = Get.arguments['role'] ?? 'Tidak diketahui';
    print('Phone: $_phone');
    print('OTP: $_otp');
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Wajib diisi';
    if (value.length < 8) return 'Minimal 8 karakter';
    if (!RegExp(r'[A-Za-z]').hasMatch(value) ||
        !RegExp(r'[0-9]').hasMatch(value)) {
      return 'Harus kombinasi huruf & angka';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButtonBack(onTab: () => Get.back()),
              SizedBox(height: 32.h),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        HeaderText(
                          firstText: 'Atur Password Baru',
                          bodyText:
                              'Buat password baru untuk nomor WhatsApp $_phone',
                        ),
                        SizedBox(height: 40.h),
                        InputPassword(
                          controller: _newPasswordController,
                          hintText: 'Password Baru',
                          svgIconPath: 'assets/icons/ic_lock.svg',
                          validator: _validatePassword,
                        ),
                        SizedBox(height: 20.h),
                        InputPassword(
                          controller: _confirmPasswordController,
                          hintText: 'Konfirmasi Password Baru',
                          svgIconPath: 'assets/icons/ic_lock.svg',
                          validator: (value) {
                            if (value != _newPasswordController.text) {
                              return 'Password tidak cocok';
                            }
                            return _validatePassword(value);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Obx(
          () => ButtonFill(
            text: _authController.isForgotPasswordLoading.value
                ? 'Memproses...'
                : 'Simpan Password',
            textColor: Colors.white,
            onPressed: _authController.isForgotPasswordLoading.value
                ? null
                : () async {
                    await _authController.resetPassword(
                      phone: _phone,
                      newPassword: _newPasswordController.text,
                    );

                    if (_authController.errorMessage.value.isEmpty) {
                      Get.snackbar(
                        'Berhasil',
                        'Password berhasil diperbarui',
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );

                      _newPasswordController.clear();
                      _confirmPasswordController.clear();

                      Get.offAllNamed(Routes.WELCOME);
                    } else {
                      Get.snackbar(
                        'Gagal',
                        _authController.errorMessage.value,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  },
          ),
        ),
      ),
    );
  }
}
