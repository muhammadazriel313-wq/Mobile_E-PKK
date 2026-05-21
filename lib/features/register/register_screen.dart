import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/common/typography.dart';
import 'package:epkk_nganjuk/features/auth/auth_controller.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:epkk_nganjuk/features/auth/component/footer_text.dart';
import 'package:epkk_nganjuk/features/auth/component/header_text.dart';
import 'package:epkk_nganjuk/features/auth/component/icon_button_back.dart';
import 'package:epkk_nganjuk/features/auth/component/input_form.dart';
import 'package:epkk_nganjuk/features/auth/component/input_password.dart';
import 'package:epkk_nganjuk/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _nomorController = TextEditingController();
  final _passController = TextEditingController();
  final _konfirmPassController =
      TextEditingController();

  final AuthController authController =
      Get.find<AuthController>();

  late String roleId;
  late String roleName;

  @override
  void initState() {
    super.initState();

    final args = Get.arguments ?? {};

    roleId = args['roleID'] ?? '';
    roleName = args['roleName'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight =
        MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 10.h,
          ),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

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

                SizedBox(height: screenHeight * 0.03),

                /// HEADER
                HeaderText(
                  firstText:
                      'Daftar sebagai $roleName',

                  bodyText:
                      'Daftar sebagai $roleName merupakan pengguna Anggota PKK yang berasal dari Desa. Silahkan isikan form yang sudah disediakan untuk mendaftarkan akun anda',
                ),

                SizedBox(height: screenHeight * 0.04),

                /// NAMA
                TypographyStyles.bodyCaptionMedium(
                  'Nama',
                  color: TextColors.grey700,
                ),

                SizedBox(height: 14.h),

                InputForm(
                  controller: _nameController,
                  hintText: 'Ahmad ...',
                  svgIconPath:
                      'assets/icons/ic_profile.svg',

                  inputFormatters: [],

                  validator: (value) {
                    if (value == null ||
                        value.isEmpty) {
                      return 'Masukkan nama anda';
                    }

                    return null;
                  },
                ),

                SizedBox(height: 20.h),

                /// NOMOR
                TypographyStyles.bodyCaptionMedium(
                  'Nomor WhatsApp',
                  color: TextColors.grey700,
                ),

                SizedBox(height: 14.h),

                InputForm(
                  controller: _nomorController,
                  hintText: '0821xxxx',
                  svgIconPath:
                      'assets/icons/ic_call.svg',

                  keyboardType:
                      TextInputType.phone,

                  validator: (value) {
                    if (value == null ||
                        value.isEmpty) {
                      return 'Masukkan nomor whatsapp anda';
                    }

                    return null;
                  },
                ),

                SizedBox(height: 20.h),

                /// PASSWORD
                TypographyStyles.bodyCaptionMedium(
                  'Password',
                  color: TextColors.grey700,
                ),

                SizedBox(height: 14.h),

                InputPassword(
                  controller: _passController,
                  hintText: '••••••••••',
                  svgIconPath:
                      'assets/icons/ic_lock.svg',

                  validator: (value) {
                    if (value == null ||
                        value.isEmpty) {
                      return 'Masukkan password anda';
                    }

                    return null;
                  },
                ),

                SizedBox(height: 20.h),

                /// KONFIRM PASSWORD
                TypographyStyles.bodyCaptionMedium(
                  'Konfirmasi password',
                  color: TextColors.grey700,
                ),

                SizedBox(height: 14.h),

                InputPassword(
                  controller:
                      _konfirmPassController,

                  hintText: '••••••••••',

                  svgIconPath:
                      'assets/icons/ic_lock.svg',

                  validator: (value) {
                    if (value == null ||
                        value.isEmpty) {
                      return 'Masukkan konfirmasi password anda';
                    }

                    return null;
                  },
                ),

                SizedBox(height: 35.h),

                /// BUTTON
                ZoomTapAnimation(
                  child: Obx(
                    () => ButtonFill(
                      text: "Lanjut",
                      textColor: Colors.white,

                      isLoading:
                          authController
                              .isAuthLogin
                              .value,

                      onPressed:
                          authController
                                  .isAuthLogin
                                  .value
                              ? null
                              : () {
                                  if (_formKey
                                      .currentState!
                                      .validate()) {
                                    if (_passController
                                            .text !=
                                        _konfirmPassController
                                            .text) {
                                      Get.snackbar(
                                        'Error',

                                        'Password dan konfirmasi password tidak cocok',

                                        snackPosition:
                                            SnackPosition
                                                .TOP,

                                        backgroundColor:
                                            Colors.red,

                                        colorText:
                                            Colors
                                                .white,
                                      );

                                      return;
                                    }

                                    Get.toNamed(
                                      Routes.PICK_ROLE,

                                      arguments: {
                                        'role_id':
                                            roleId,

                                        'role_name':
                                            roleName,

                                        'full_name':
                                            _nameController
                                                .text,

                                        'phone_number':
                                            _nomorController
                                                .text,

                                        'password':
                                            _passController
                                                .text,
                                      },
                                    );
                                  }
                                },
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                /// FOOTER
                Center(
                  child: FooterText(
                    firstText:
                        'Sudah punya akun?',

                    secondText: 'Masuk',

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