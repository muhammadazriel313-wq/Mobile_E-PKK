/// =======================================================
/// FILE : rekap_desa_tahunan_2_screen.dart
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

class RekapDesaTahunan2Screen extends StatefulWidget {
  const RekapDesaTahunan2Screen({super.key});

  @override
  State<RekapDesaTahunan2Screen> createState() =>
      _RekapDesaTahunan2ScreenState();
}

class _RekapDesaTahunan2ScreenState extends State<RekapDesaTahunan2Screen> {
  /// ================= ARGUMENT =================

  late Map<String, dynamic> data;

  /// ================= CONTROLLER =================

  final jambanWcController = TextEditingController();

  final spalController = TextEditingController();

  final tpsController = TextEditingController();

  final jumlahMckController = TextEditingController();

  final pdamController = TextEditingController();

  final sumurController = TextEditingController();

  final lainLainController = TextEditingController();

  /// ================= FORM =================

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    data = Get.arguments;
  }

  @override
  void dispose() {
    jambanWcController.dispose();
    spalController.dispose();
    tpsController.dispose();
    jumlahMckController.dispose();
    pdamController.dispose();
    sumurController.dispose();
    lainLainController.dispose();

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
        title: 'Rekap Desa Tahunan',

        currentStep: 2,

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
                          /// LINGKUNGAN
                          /// ======================
                          TypographyStyles.bodyCaptionSemiBold(
                            'Lingkungan',

                            color: TextColors.grey900,
                          ),

                          SizedBox(height: 24.h),

                          _inputField(
                            controller: jambanWcController,

                            label: 'Jamban WC',
                          ),

                          _space(),

                          _inputField(
                            controller: spalController,

                            label: 'SPAL',
                          ),

                          _space(),

                          _inputField(controller: tpsController, label: 'TPS'),

                          _space(),

                          _inputField(
                            controller: jumlahMckController,

                            label: 'Jumlah MCK',
                          ),

                          _space(),

                          _inputField(
                            controller: pdamController,

                            label: 'PDAM',
                          ),

                          _space(),

                          _inputField(
                            controller: sumurController,

                            label: 'Sumur',
                          ),

                          _space(),

                          _inputField(
                            controller: lainLainController,

                            label: 'Lain-lain',
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
                                    Routes.REKAP_DESA_TAHUNAN_3,

                                    arguments: {
                                      ...data,

                                      'jamban_wc': jambanWcController.text,

                                      'spal': spalController.text,

                                      'tps': tpsController.text,

                                      'jumlah_mck': jumlahMckController.text,

                                      'pdam': pdamController.text,

                                      'sumur': sumurController.text,

                                      'lain_lain': lainLainController.text,
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
  /// INPUT FIELD
  /// ======================

  Widget _inputField({
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

  /// ======================
  /// SPACE
  /// ======================

  Widget _space() => SizedBox(height: 20.h);
}
