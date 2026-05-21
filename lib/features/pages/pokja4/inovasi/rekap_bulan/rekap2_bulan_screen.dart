/// =======================================================
/// FILE : rekap_desa_2_screen.dart
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

class RekapDesa2Screen extends StatefulWidget {
  const RekapDesa2Screen({super.key});

  @override
  State<RekapDesa2Screen> createState() => _RekapDesa2ScreenState();
}

class _RekapDesa2ScreenState extends State<RekapDesa2Screen> {
  late Map<String, dynamic> args;

  /// ================= CONTROLLER =================

  final bayiLahirLController = TextEditingController();

  final bayiLahirPController = TextEditingController();

  final akteAdaController = TextEditingController();

  final akteTidakController = TextEditingController();

  final bayiMeninggalLController = TextEditingController();

  final bayiMeninggalPController = TextEditingController();

  final balitaMeninggalLController = TextEditingController();

  final balitaMeninggalPController = TextEditingController();

  /// ================= FORM =================

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    args = Get.arguments;
  }

  @override
  void dispose() {
    bayiLahirLController.dispose();
    bayiLahirPController.dispose();
    akteAdaController.dispose();
    akteTidakController.dispose();
    bayiMeninggalLController.dispose();
    bayiMeninggalPController.dispose();
    balitaMeninggalLController.dispose();
    balitaMeninggalPController.dispose();

    super.dispose();
  }

  Widget sectionTitle(String title) {
    return TypographyStyles.bodyCaptionSemiBold(
      title,
      color: TextColors.grey900,
    );
  }

  Widget buildInput({
    required TextEditingController controller,

    required String label,

    TextInputAction action = TextInputAction.next,
  }) {
    return Column(
      children: [
        InputFormField(
          controller: controller,

          hintText: 'Masukkan jumlah',

          label: label,

          keyboardType: TextInputType.number,

          textInputAction: action,

          validator: (value) {
            return ValidatorForm.validateNumber(value);
          },
        ),

        SizedBox(height: 20.h),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    final isTablet = media.size.width >= 600;

    return Scaffold(
      resizeToAvoidBottomInset: true,

      backgroundColor: Colors.white,

      appBar: AppBarSecondary(
        title: 'Rekap Desa Bulanan',

        currentStep: 2,

        totalSteps: 3,

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
                          /// JUMLAH BAYI
                          /// ======================
                          sectionTitle('Jumlah Bayi'),

                          SizedBox(height: 24.h),

                          buildInput(
                            controller: bayiLahirLController,

                            label: 'Bayi Lahir L',
                          ),

                          buildInput(
                            controller: bayiLahirPController,

                            label: 'Bayi Lahir P',
                          ),

                          SizedBox(height: 8.h),

                          /// ======================
                          /// AKTE
                          /// ======================
                          sectionTitle('Akte Kelahiran'),

                          SizedBox(height: 24.h),

                          buildInput(
                            controller: akteAdaController,

                            label: 'Akte Kelahiran Ada',
                          ),

                          buildInput(
                            controller: akteTidakController,

                            label: 'Akte Kelahiran Tidak',
                          ),

                          SizedBox(height: 8.h),

                          /// ======================
                          /// BAYI MENINGGAL
                          /// ======================
                          sectionTitle('Bayi Meninggal'),

                          SizedBox(height: 24.h),

                          buildInput(
                            controller: bayiMeninggalLController,

                            label: 'Bayi Meninggal L',
                          ),

                          buildInput(
                            controller: bayiMeninggalPController,

                            label: 'Bayi Meninggal P',
                          ),

                          SizedBox(height: 8.h),

                          /// ======================
                          /// BALITA MENINGGAL
                          /// ======================
                          sectionTitle('Balita Meninggal'),

                          SizedBox(height: 24.h),

                          buildInput(
                            controller: balitaMeninggalLController,

                            label: 'Balita Meninggal L',
                          ),

                          buildInput(
                            controller: balitaMeninggalPController,

                            label: 'Balita Meninggal P',

                            action: TextInputAction.done,
                          ),

                          SizedBox(height: 10.h),

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
                                    Routes.REKAP_DESA_3,

                                    arguments: {
                                      ...args,

                                      'bayi_lahir_l': bayiLahirLController.text,

                                      'bayi_lahir_p': bayiLahirPController.text,

                                      'akte_kelahiran_ada':
                                          akteAdaController.text,

                                      'akte_kelahiran_tidak':
                                          akteTidakController.text,

                                      'bayi_meninggal_l':
                                          bayiMeninggalLController.text,

                                      'bayi_meninggal_p':
                                          bayiMeninggalPController.text,

                                      'balita_meninggal_l':
                                          balitaMeninggalLController.text,

                                      'balita_meninggal_p':
                                          balitaMeninggalPController.text,
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
}
