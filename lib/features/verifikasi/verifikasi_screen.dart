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

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final AuthController authController = Get.put(AuthController());

  final _codeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final role_id = Get.arguments['role_id'] ?? '';

    final role_name = Get.arguments['role_name'] ?? '';

    final full_name = Get.arguments['full_name'] ?? '';

    final phone_number = Get.arguments['phone_number'] ?? '';

    final password = Get.arguments['password'] ?? '';

    final id_subdistrict = Get.arguments['id_subdistrict'] ?? '';

    final id_village = Get.arguments['id_village'] ?? '';

    final id_organization = Get.arguments['id_organization']?.toString() ?? '';

    final screenHeight = MediaQuery.of(context).size.height;

    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                /// BACK
                IconButtonBack(
                  onTab: () {
                    authController.generateRandomNumber();

                    Get.back();
                  },
                ),

                SizedBox(height: screenHeight * 0.03),

                /// HEADER
                HeaderText(
                  firstText: 'Kode Verifikasi',

                  bodyText: 'Masukkan kode OTP yang dikirim ke WhatsApp Anda.',
                ),

                SizedBox(height: screenHeight * 0.03),

                /// IMAGE
                Center(
                  child: Image.asset(
                    'assets/images/ilustrasi2.png',

                    width: screenWidth * 0.55,

                    height: screenHeight * 0.28,

                    fit: BoxFit.contain,
                  ),
                ),

                SizedBox(height: 30.h),

                /// PIN CODE
                Center(child: PinCodeFields(controller: _codeController)),

                SizedBox(height: 20.h),

                /// RESEND OTP
                Center(
                  child: FooterText(
                    firstText: 'Belum menerima kode?',

                    secondText: 'Kirim ulang',

                    onTab: () {
                      authController.resendOtpForRegister(
                        phoneNumber: phone_number,
                      );
                    },
                  ),
                ),

                SizedBox(height: 40.h),

                /// BUTTON
                Obx(
                  () => ButtonFill(
                    text: authController.isAuthRegister.value
                        ? 'Loading...'
                        : 'Konfirmasi',

                    textColor: Colors.white,

                    onPressed: authController.isAuthRegister.value
                        ? null
                        : () async {
                            final isFormValid =
                                _formKey.currentState?.validate() ?? false;

                            if (!isFormValid) {
                              Get.snackbar('Error', 'Form tidak valid!');

                              return;
                            }

                            /// CEK OTP
                            if (_codeController.text !=
                                authController.generatedOtp) {
                              Get.snackbar(
                                'Error',

                                'Kode OTP tidak sesuai!',

                                snackPosition: SnackPosition.TOP,

                                backgroundColor: Colors.red,

                                colorText: Colors.white,
                              );

                              return;
                            }

                            /// REGISTER
                            await authController.authRegisterController(
                              full_name: full_name,

                              phone_number: phone_number,

                              id_subdistrict: id_subdistrict,

                              id_village: id_village,

                              role_id: role_id,

                              id_organization: id_organization,

                              password: password,

                              kode_otp: authController.generatedOtp,
                            );

                            /// SUCCESS
                            if (authController.authResponses.value?.data !=
                                null) {
                              Get.snackbar(
                                'Berhasil',

                                'Akun berhasil dibuat! Selamat datang, ${authController.authResponses.value!.data!.fullName}',

                                snackPosition: SnackPosition.TOP,

                                backgroundColor: Colors.green,

                                colorText: Colors.white,
                              );

                              Get.offAllNamed(Routes.MAIN);
                            }
                          },
                  ),
                ),

                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
