/// =======================================================
/// FILE : rekap_desa_tahunan_4_screen.dart
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

class RekapDesaTahunan4Screen extends StatefulWidget {
  const RekapDesaTahunan4Screen({super.key});

  @override
  State<RekapDesaTahunan4Screen> createState() =>
      _RekapDesaTahunan4ScreenState();
}

class _RekapDesaTahunan4ScreenState extends State<RekapDesaTahunan4Screen> {
  /// ================= ARGUMENT =================

  late Map<String, dynamic> data;

  /// ================= CONTROLLER =================

  final jmlKkTabunganController = TextEditingController();

  final jmlKkAsuransiController = TextEditingController();

  final kesehatanProgramController = TextEditingController();

  final kelestarianLingkunganController = TextEditingController();

  final perencanaanSehatController = TextEditingController();

  /// ================= FORM =================

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    data = Get.arguments;
  }

  @override
  void dispose() {
    jmlKkTabunganController.dispose();
    jmlKkAsuransiController.dispose();
    kesehatanProgramController.dispose();
    kelestarianLingkunganController.dispose();
    perencanaanSehatController.dispose();

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
                          /// PROGRAM & TABUNGAN
                          /// ======================
                          TypographyStyles.bodyCaptionSemiBold(
                            'Program & Tabungan',

                            color: TextColors.grey900,
                          ),

                          SizedBox(height: 24.h),

                          _inputField(
                            controller: jmlKkTabunganController,

                            label: 'Jumlah KK Tabungan',
                          ),

                          _space(),

                          _inputField(
                            controller: jmlKkAsuransiController,

                            label: 'Jumlah KK Asuransi',
                          ),

                          _space(),

                          _inputField(
                            controller: kesehatanProgramController,

                            label: 'Kesehatan Program',
                          ),

                          _space(),

                          _inputField(
                            controller: kelestarianLingkunganController,

                            label: 'Kelestarian Lingkungan Hidup',
                          ),

                          _space(),

                          _inputField(
                            controller: perencanaanSehatController,

                            label: 'Perencanaan Sehat Program',
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
                                    Routes.REKAP_DESA_TAHUNAN_5,

                                    arguments: {
                                      ...data,

                                      'jml_kk_tabungan':
                                          jmlKkTabunganController.text,

                                      'jml_kk_asuransi':
                                          jmlKkAsuransiController.text,

                                      'kesehatan_program':
                                          kesehatanProgramController.text,

                                      'kelestarian_lingkungan_hidup':
                                          kelestarianLingkunganController.text,

                                      'perencanaan_sehat_program':
                                          perencanaanSehatController.text,
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
