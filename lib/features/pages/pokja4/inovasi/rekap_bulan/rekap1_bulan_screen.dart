/// =======================================================
/// FILE : rekap_desa_1_screen.dart
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

class RekapDesa1Screen extends StatefulWidget {
  final String kategori;

  const RekapDesa1Screen({super.key, required this.kategori});

  @override
  State<RekapDesa1Screen> createState() => _RekapDesa1ScreenState();
}

class _RekapDesa1ScreenState extends State<RekapDesa1Screen> {
  /// ================= CONTROLLER =================

  final rwController = TextEditingController();

  final rtController = TextEditingController();

  final dasaWismaController = TextEditingController();

  final hamilController = TextEditingController();

  final melahirkanController = TextEditingController();

  final nifasController = TextEditingController();

  final meninggalController = TextEditingController();

  /// ================= FORM =================

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    rwController.dispose();
    rtController.dispose();
    dasaWismaController.dispose();
    hamilController.dispose();
    melahirkanController.dispose();
    nifasController.dispose();
    meninggalController.dispose();

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

        currentStep: 1,

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
                          /// JUMLAH
                          /// ======================
                          sectionTitle('Jumlah'),

                          SizedBox(height: 24.h),

                          buildInput(controller: rwController, label: 'RW'),

                          buildInput(controller: rtController, label: 'RT'),

                          buildInput(
                            controller: dasaWismaController,

                            label: 'Dasa Wisma',
                          ),

                          SizedBox(height: 8.h),

                          /// ======================
                          /// JUMLAH IBU
                          /// ======================
                          sectionTitle('Jumlah Ibu'),

                          SizedBox(height: 24.h),

                          buildInput(
                            controller: hamilController,

                            label: 'Hamil',
                          ),

                          buildInput(
                            controller: melahirkanController,

                            label: 'Melahirkan',
                          ),

                          buildInput(
                            controller: nifasController,

                            label: 'Nifas',
                          ),

                          buildInput(
                            controller: meninggalController,

                            label: 'Ibu Meninggal',

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
                                    Routes.REKAP_DESA_2,

                                    arguments: {
                                      'kategori': widget.kategori,

                                      'rw': rwController.text,

                                      'rt': rtController.text,

                                      'dasa_wisma': dasaWismaController.text,

                                      'hamil': hamilController.text,

                                      'melahirkan': melahirkanController.text,

                                      'nifas': nifasController.text,

                                      'meninggal': meninggalController.text,
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
