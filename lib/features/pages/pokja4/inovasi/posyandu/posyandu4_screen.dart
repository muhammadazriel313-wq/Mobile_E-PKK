/// =======================================================
/// FILE : posyandu_4_screen.dart
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

class Posyandu4Screen extends StatefulWidget {
  const Posyandu4Screen({super.key});

  @override
  State<Posyandu4Screen> createState() => _Posyandu4ScreenState();
}

class _Posyandu4ScreenState extends State<Posyandu4Screen> {
  /// ================= ARGUMENT =================

  late Map<String, dynamic> data;

  /// ================= CONTROLLER =================

  final naikLController = TextEditingController();

  final naikPController = TextEditingController();

  final vitALController = TextEditingController();

  final vitAPController = TextEditingController();

  final pmtLController = TextEditingController();

  final pmtPController = TextEditingController();

  final imunisasiTt1Controller = TextEditingController();

  final imunisasiTt2Controller = TextEditingController();

  /// ================= FORM =================

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    data = Get.arguments;
  }

  @override
  void dispose() {
    naikLController.dispose();
    naikPController.dispose();
    vitALController.dispose();
    vitAPController.dispose();
    pmtLController.dispose();
    pmtPController.dispose();
    imunisasiTt1Controller.dispose();
    imunisasiTt2Controller.dispose();

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

        currentStep: 4,

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
                          /// GIZI & IMUNISASI
                          /// ======================
                          TypographyStyles.bodyCaptionSemiBold(
                            'Gizi & Imunisasi',

                            color: TextColors.grey900,
                          ),

                          SizedBox(height: 24.h),

                          _inputNumber(
                            controller: naikLController,

                            label: 'Naik L',
                          ),

                          SizedBox(height: 20.h),

                          _inputNumber(
                            controller: naikPController,

                            label: 'Naik P',
                          ),

                          SizedBox(height: 20.h),

                          _inputNumber(
                            controller: vitALController,

                            label: 'Vit A L',
                          ),

                          SizedBox(height: 20.h),

                          _inputNumber(
                            controller: vitAPController,

                            label: 'Vit A P',
                          ),

                          SizedBox(height: 20.h),

                          _inputNumber(
                            controller: pmtLController,

                            label: 'PMT L',
                          ),

                          SizedBox(height: 20.h),

                          _inputNumber(
                            controller: pmtPController,

                            label: 'PMT P',
                          ),

                          SizedBox(height: 20.h),

                          _inputNumber(
                            controller: imunisasiTt1Controller,

                            label: 'Imunisasi TT 1',
                          ),

                          SizedBox(height: 20.h),

                          _inputNumber(
                            controller: imunisasiTt2Controller,

                            label: 'Imunisasi TT 2',
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
                                    Routes.POSYANDU_5,

                                    arguments: {
                                      ...data,

                                      'naik_l': naikLController.text,

                                      'naik_p': naikPController.text,

                                      'vit_a_l': vitALController.text,

                                      'vit_a_p': vitAPController.text,

                                      'pmt_l': pmtLController.text,

                                      'pmt_p': pmtPController.text,

                                      'imunisasi_tt_1':
                                          imunisasiTt1Controller.text,

                                      'imunisasi_tt_2':
                                          imunisasiTt2Controller.text,
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
