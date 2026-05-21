/// =======================================================
/// FILE : posyandu_3_screen.dart
/// =======================================================

import 'package:epkk_nganjuk/common/appbar/custom_appbar.dart';
import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/common/typography.dart';
import 'package:epkk_nganjuk/core/validators/validator_form.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:epkk_nganjuk/features/auth/component/input_form_field.dart';
import 'package:epkk_nganjuk/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class Posyandu3Screen extends StatefulWidget {
  const Posyandu3Screen({super.key});

  @override
  State<Posyandu3Screen> createState() => _Posyandu3ScreenState();
}

class _Posyandu3ScreenState extends State<Posyandu3Screen> {
  /// ================= ARGUMENT =================

  late Map<String, dynamic> data;

  /// ================= CONTROLLER =================

  final jmlBalitaLController = TextEditingController();

  final jmlBalitaPController = TextEditingController();

  final bukuKiaLController = TextEditingController();

  final bukuKiaPController = TextEditingController();

  final datangLController = TextEditingController();

  final datangPController = TextEditingController();

  /// ================= FORM =================

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    data = Get.arguments;
  }

  @override
  void dispose() {
    jmlBalitaLController.dispose();
    jmlBalitaPController.dispose();
    bukuKiaLController.dispose();
    bukuKiaPController.dispose();
    datangLController.dispose();
    datangPController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    final isTablet = media.size.width >= 600;

    return Scaffold(
      resizeToAvoidBottomInset: true,

      backgroundColor: Colors.white,

      appBar: AppBarSecondary(
        title: 'Posyandu',

        currentStep: 3,

        totalSteps: 5,

        onBack: () => Get.back(),
      ),

      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),

          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),

                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.manual,

                padding: EdgeInsets.only(
                  left: isTablet ? 40.w : 16.w,

                  right: isTablet ? 40.w : 16.w,

                  top: 20.h,

                  bottom: media.viewInsets.bottom + 20.h,
                ),

                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isTablet ? 650 : double.infinity,

                      minHeight: constraints.maxHeight,
                    ),

                    child: Form(
                      key: _formKey,

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          /// ======================
                          /// BALITA
                          /// ======================
                          TypographyStyles.bodyCaptionSemiBold(
                            'Balita',

                            color: TextColors.grey900,
                          ),

                          SizedBox(height: 24.h),

                          _inputNumber(
                            controller: jmlBalitaLController,

                            label: 'Jumlah Balita L',
                          ),

                          SizedBox(height: 20.h),

                          _inputNumber(
                            controller: jmlBalitaPController,

                            label: 'Jumlah Balita P',
                          ),

                          SizedBox(height: 20.h),

                          _inputNumber(
                            controller: bukuKiaLController,

                            label: 'Buku KIA L',
                          ),

                          SizedBox(height: 20.h),

                          _inputNumber(
                            controller: bukuKiaPController,

                            label: 'Buku KIA P',
                          ),

                          SizedBox(height: 20.h),

                          _inputNumber(
                            controller: datangLController,

                            label: 'Datang L',
                          ),

                          SizedBox(height: 20.h),

                          _inputNumber(
                            controller: datangPController,

                            label: 'Datang P',
                          ),

                          SizedBox(height: 30.h),

                          /// ======================
                          /// BUTTON
                          /// ======================
                          ZoomTapAnimation(
                            child: ButtonFill(
                              text: 'Lanjut',

                              textColor: Colors.white,

                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  Get.toNamed(
                                    Routes.POSYANDU_4,

                                    arguments: {
                                      ...data,

                                      'jml_balita_l': jmlBalitaLController.text,

                                      'jml_balita_p': jmlBalitaPController.text,

                                      'buku_kia_l': bukuKiaLController.text,

                                      'buku_kia_p': bukuKiaPController.text,

                                      'datang_l': datangLController.text,

                                      'datang_p': datangPController.text,
                                    },
                                  );
                                } else {
                                  Get.snackbar(
                                    'Error',

                                    'Lengkapi Form',

                                    snackPosition: SnackPosition.TOP,

                                    backgroundColor: Colors.red,

                                    colorText: Colors.white,
                                  );
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

  /// ======================
  /// INPUT NUMBER
  /// ======================

  Widget _inputNumber({
    required TextEditingController controller,

    required String label,
  }) {
    return InputFormField(
      controller: controller,

      hintText: 'Masukkan jumlah',

      label: label,

      keyboardType: TextInputType.number,

      textInputAction: TextInputAction.next,

      validator: (value) {
        return ValidatorForm.validateNumber(value);
      },
    );
  }
}
