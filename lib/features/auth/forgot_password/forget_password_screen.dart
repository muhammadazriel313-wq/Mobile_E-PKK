import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/common/typography.dart';
import 'package:epkk_nganjuk/features/auth/auth_controller.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';
import '../component/header_text.dart';
import '../component/icon_button_back.dart';
import '../component/input_form.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nomorController = TextEditingController();

  final authController = Get.put(AuthController());

  late String roleId;
  late String roleName;

  @override
  void initState() {
    super.initState();

    final args = Get.arguments ?? {};

    roleId = args['roleID'] ?? 'ID not found';

    roleName = args['roleName'] ?? 'Tidak diketahui';
  }

  @override
  void dispose() {
    _nomorController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    final isTablet = media.size.width >= 600;

    return Scaffold(
      resizeToAvoidBottomInset: true,

      backgroundColor: Colors.white,

      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),

          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),

                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,

                padding: EdgeInsets.only(
                  left: isTablet ? 40.w : 16.w,

                  right: isTablet ? 40.w : 16.w,

                  top: 16.h,

                  bottom: media.viewInsets.bottom + 30.h,
                ),

                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isTablet ? 500 : double.infinity,
                    ),

                    child: Form(
                      key: _formKey,

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          /// BACK
                          IconButtonBack(
                            onTab: () {
                              Get.toNamed(
                                Routes.AUTH_LOGIN,

                                arguments: {
                                  'roleID': roleId,

                                  'roleName': roleName,
                                },
                              );
                            },
                          ),

                          SizedBox(height: 28.h),

                          /// HEADER
                          HeaderText(
                            firstText: 'Atur Ulang Kata Sandi',

                            bodyText:
                                'Mohon masukkan nomor whatsapp anda yang sudah didaftarkan diaplikasi ini.',
                          ),

                          SizedBox(height: 28.h),

                          /// IMAGE
                          Center(
                            child: Image.asset(
                              'assets/images/ilustrasi3.png',

                              width: isTablet ? 260.w : 0.60.sw,

                              fit: BoxFit.contain,
                            ),
                          ),

                          SizedBox(height: 32.h),

                          /// LABEL
                          TypographyStyles.bodyCaptionMedium(
                            'Nomor WhatsApp',

                            color: TextColors.grey700,
                          ),

                          SizedBox(height: 14.h),

                          /// INPUT
                          InputForm(
                            controller: _nomorController,

                            hintText: '0821xxxx',

                            svgIconPath: 'assets/icons/ic_call.svg',

                            keyboardType: TextInputType.number,

                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Masukkan nomor whatsapp anda';
                              }

                              if (value.length < 10) {
                                return 'Nomor tidak valid';
                              }

                              return null;
                            },
                          ),

                          SizedBox(height: 32.h),

                          /// BUTTON
                          Obx(
                            () => ButtonFill(
                              text: authController.isForgotPasswordLoading.value
                                  ? 'Mengirim...'
                                  : 'Lanjut',

                              textColor: Colors.white,

                              onPressed:
                                  authController.isForgotPasswordLoading.value
                                  ? null
                                  : () async {
                                      if (_formKey.currentState!.validate()) {
                                        final phoneNumber =
                                            _nomorController.text;

                                        try {
                                          authController
                                                  .isForgotPasswordLoading
                                                  .value =
                                              true;

                                          authController.generateRandomNumber();

                                          final kodeOtp =
                                              authController.generatedOtp;

                                          await authController
                                              .sendOtpViaWhatsApp(
                                                phoneNumber,
                                                kodeOtp,
                                              );

                                          Get.toNamed(
                                            Routes.VERIFICATION_FORGOT_PASSWORD,

                                            arguments: {
                                              'phone_number': phoneNumber,

                                              'kode_otp': kodeOtp,

                                              'roleID': roleId,

                                              'roleName': roleName,
                                            },
                                          );
                                        } catch (e) {
                                          Get.snackbar(
                                            'Error',
                                            'Gagal mengirim OTP',

                                            backgroundColor: Colors.red,

                                            colorText: Colors.white,
                                          );
                                        } finally {
                                          authController
                                                  .isForgotPasswordLoading
                                                  .value =
                                              false;
                                        }
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
            },
          ),
        ),
      ),
    );
  }
}
