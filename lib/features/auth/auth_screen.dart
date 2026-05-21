import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/common/typography.dart';
import 'package:epkk_nganjuk/core/validators/validator_auth.dart';
import 'package:epkk_nganjuk/features/auth/auth_controller.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:epkk_nganjuk/features/auth/component/footer_text.dart';
import 'package:epkk_nganjuk/features/auth/component/forget_password_text.dart';
import 'package:epkk_nganjuk/features/auth/component/header_text.dart';
import 'package:epkk_nganjuk/features/auth/component/icon_button_back.dart';
import 'package:epkk_nganjuk/features/auth/component/input_form.dart';
import 'package:epkk_nganjuk/features/auth/component/input_password.dart';
import 'package:epkk_nganjuk/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nomorController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthController authController = Get.put(AuthController());

  late String roleId;
  late String roleName;

  @override
  void initState() {
    super.initState();

    roleId = Get.arguments['roleID'] ?? 'ID not found';
    roleName = Get.arguments['roleName'] ?? 'Tidak diketahui';
  }

  @override
  void dispose() {
    _nomorController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),

          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top,
              ),

              child: IntrinsicHeight(
                child: Form(
                  key: _formKey,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      /// BUTTON BACK
                      IconButtonBack(
                        onTab: () {
                          Get.offNamed(Routes.WELCOME);
                        },
                      ),

                      SizedBox(height: 32.h),

                      /// HEADER
                      HeaderText(
                        firstText: 'Masuk sebagai $roleName',

                        bodyText:
                            'Masuk sebagai $roleName merupakan pengguna Anggota PKK yang berasal dari Desa. Silahkan masuk menggunakan akun yang sudah di daftarkan',
                      ),

                      SizedBox(height: 40.h),

                      /// LABEL NOMOR
                      TypographyStyles.bodyCaptionMedium(
                        'Nomor WhatsApp',
                        color: TextColors.grey700,
                      ),

                      SizedBox(height: 16.h),

                      /// INPUT NOMOR
                      InputForm(
                        controller: _nomorController,
                        hintText: '0821xxxx',
                        svgIconPath: 'assets/icons/ic_call.svg',
                        keyboardType: TextInputType.phone,

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Masukkan nomor whatsapp anda';
                          }

                          return null;
                        },
                      ),

                      SizedBox(height: 20.h),

                      /// LABEL PASSWORD
                      TypographyStyles.bodyCaptionMedium(
                        'Password',
                        color: TextColors.grey700,
                      ),

                      SizedBox(height: 16.h),

                      /// INPUT PASSWORD
                      InputPassword(
                        controller: _passwordController,
                        hintText: '••••••••••',
                        svgIconPath: 'assets/icons/ic_lock.svg',
                        validator: ValidatorAuth.validatePassword,
                      ),

                      SizedBox(height: 20.h),

                      /// LUPA PASSWORD
                      ForgetPasswordText(
                        onTab: () {
                          Get.toNamed(
                            Routes.RESET_PASSWORD,

                            arguments: {'roleID': roleId, 'roleName': roleName},
                          );
                        },
                      ),

                      SizedBox(height: 32.h),

                      /// BUTTON LOGIN
                      ZoomTapAnimation(
                        child: Obx(
                          () => ButtonFill(
                            text: "Masuk",
                            textColor: Colors.white,
                            isLoading: authController.isAuthLogin.value,

                            onPressed: authController.isAuthLogin.value
                                ? null
                                : () async {
                                    if (_formKey.currentState!.validate()) {
                                      await authController.authLoginController(
                                        phoneNumber: _nomorController.text
                                            .trim(),

                                        password: _passwordController.text
                                            .trim(),

                                        role: roleId,
                                      );
                                    }
                                  },
                          ),
                        ),
                      ),

                      SizedBox(height: 30.h),

                      /// FOOTER DAFTAR
                      Center(
                        child: FooterText(
                          firstText: 'Belum punya akun?',
                          secondText: 'Daftar',

                          onTab: () {
                            Get.toNamed(
                              Routes.REGISTER,
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
          ),
        ),
      ),
    );
  }
}
