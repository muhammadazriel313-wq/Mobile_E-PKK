import 'package:epkk_nganjuk/features/auth/auth_controller.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:epkk_nganjuk/features/auth/component/footer_text.dart';
import 'package:epkk_nganjuk/features/auth/component/header_text.dart';
import 'package:epkk_nganjuk/features/auth/component/icon_button_back.dart';
import 'package:epkk_nganjuk/features/auth/component/pin_code_fields.dart';
import 'package:epkk_nganjuk/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';



class VerificationForgotPasswordScreen extends StatefulWidget {
  const VerificationForgotPasswordScreen({super.key});

  @override
  State<VerificationForgotPasswordScreen> createState() =>
      _VerificationForgotPasswordScreenState();
}

class _VerificationForgotPasswordScreenState
    extends State<VerificationForgotPasswordScreen> {
  final AuthController authController = Get.find<AuthController>();
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late String phoneNumber;
  late String role;
  late String kodeOtp;

  @override
  void initState() {
    super.initState();
    phoneNumber = Get.arguments['phone_number'] ?? '';
    role = Get.arguments['role'] ?? 'Tidak diketahui';
    kodeOtp = Get.arguments['kode_otp'] ?? '';
    print('Phone: $phoneNumber');
    print('Role: $role');
    print('Kode OTP: $kodeOtp');
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
              IconButtonBack(
                onTab: () {
                  Get.back();
                },
              ),
              SizedBox(height: 32.h),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        HeaderText(
                          firstText: 'Verifikasi OTP',
                          bodyText:
                              'Masukkan kode OTP yang telah dikirim ke nomor WhatsApp $phoneNumber',
                        ),
                        SizedBox(height: 20.h),
                        Center(
                          child: Image.asset(
                            'assets/images/ilustrasi2.png',
                            width: 150.w,
                            height: 260.h,
                          ),
                        ),
                        SizedBox(height: 32.h),
                        PinCodeFields(
                          controller: _codeController,
                        ),
                        SizedBox(height: 20.h),
                        FooterText(
                          firstText: 'Tidak menerima kode?',
                          secondText: 'Kirim ulang',
                          onTab: () {
                            authController.resendOTP(phoneNumber);
                          },
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Obx(
          () => ButtonFill(
            text: authController.isForgotPasswordLoading.value
                ? 'Memproses...'
                : 'Verifikasi',
            textColor: Colors.white,
            onPressed: authController.isForgotPasswordLoading.value
                ? null
                : () async {
                    if (_formKey.currentState!.validate()) {
                      if (_codeController.text == kodeOtp) {
                        Get.snackbar(
                          'Sukses',
                          'Kode OTP valid. Silakan atur ulang kata sandi Anda.',
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );

                        Get.toNamed(Routes.RESET_PASSWORD_BARU, arguments: {
                          'phone': phoneNumber,
                          'otp': _codeController.text,
                          'role': role
                        });
                      } else {
                        Get.snackbar(
                          'Error',
                          'Kode OTP tidak sesuai!',
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    }
                  },
          ),
        ),
      ),
    );
  }
}
