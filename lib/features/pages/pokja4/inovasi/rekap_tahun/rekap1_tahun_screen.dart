/// =======================================================
/// FILE : rekap_desa_tahunan_1_screen.dart
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

class RekapDesaTahunan1Screen extends StatefulWidget {
  final String kategori;

  const RekapDesaTahunan1Screen({super.key, required this.kategori});

  @override
  State<RekapDesaTahunan1Screen> createState() =>
      _RekapDesaTahunan1ScreenState();
}

class _RekapDesaTahunan1ScreenState extends State<RekapDesaTahunan1Screen> {
  /// ================= CONTROLLER =================

  final kaderKesehatanController = TextEditingController();

  final giziController = TextEditingController();

  final keslingController = TextEditingController();

  final phbsController = TextEditingController();

  final kbController = TextEditingController();

  final posyanduController = TextEditingController();

  final imunisasiController = TextEditingController();

  final pkgController = TextEditingController();

  final tbcController = TextEditingController();

  /// ================= FORM =================

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    kaderKesehatanController.dispose();
    giziController.dispose();
    keslingController.dispose();
    phbsController.dispose();
    kbController.dispose();
    posyanduController.dispose();
    imunisasiController.dispose();
    pkgController.dispose();
    tbcController.dispose();

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

        currentStep: 1,

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
                          /// KESEHATAN MASYARAKAT
                          /// ======================
                          TypographyStyles.bodyCaptionSemiBold(
                            'Kesehatan Masyarakat',

                            color: TextColors.grey900,
                          ),

                          SizedBox(height: 24.h),

                          _inputField(
                            controller: kaderKesehatanController,

                            label: 'Kader Kesehatan',
                          ),

                          _space(),

                          _inputField(
                            controller: giziController,

                            label: 'Gizi',
                          ),

                          _space(),

                          _inputField(
                            controller: keslingController,

                            label: 'Kesling',
                          ),

                          _space(),

                          _inputField(
                            controller: phbsController,

                            label: 'PHBS',
                          ),

                          _space(),

                          _inputField(controller: kbController, label: 'KB'),

                          _space(),

                          _inputField(
                            controller: posyanduController,

                            label: 'Posyandu',
                          ),

                          _space(),

                          _inputField(
                            controller: imunisasiController,

                            label: 'Imunisasi Vaksinasi Bayi Balita',
                          ),

                          _space(),

                          _inputField(controller: pkgController, label: 'PKG'),

                          _space(),

                          _inputField(controller: tbcController, label: 'TBC'),

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
                                    Routes.REKAP_DESA_TAHUNAN_2,

                                    arguments: {
                                      'kategori': widget.kategori,

                                      'kader_kesehatan':
                                          kaderKesehatanController.text,

                                      'gizi': giziController.text,

                                      'kesling': keslingController.text,

                                      'phbs': phbsController.text,

                                      'kb': kbController.text,

                                      'posyandu': posyanduController.text,

                                      'imunisasi_vaksinasi_bayi_balita':
                                          imunisasiController.text,

                                      'pkg': pkgController.text,

                                      'tbc': tbcController.text,
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
