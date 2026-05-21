import 'package:epkk_nganjuk/common/appbar/custom_appbar.dart';
import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/common/typography.dart';
import 'package:epkk_nganjuk/core/validators/validator_form.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:epkk_nganjuk/features/auth/component/input_form_field.dart';
import 'package:epkk_nganjuk/features/pages/pokja2/pengembangan/pengembangan_kehidupan_controller.dart';
import 'package:epkk_nganjuk/routes/app_routes.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'package:get/get.dart';

class Pengembangan1 extends StatefulWidget {
  const Pengembangan1({super.key});

  @override
  State<Pengembangan1> createState() =>
      _Pengembangan1ScreenState();
}

class _Pengembangan1ScreenState
    extends State<Pengembangan1> {
  final permulaKelompokController =
      TextEditingController();

  final permulaPesertaController =
      TextEditingController();

  final madyaKelompokController =
      TextEditingController();

  final madyaPesertaController =
      TextEditingController();

  final utamaKelompokController =
      TextEditingController();

  final utamaPesertaController =
      TextEditingController();

  final mandiriKelompokController =
      TextEditingController();

  final mandiriPesertaController =
      TextEditingController();

  final _formKey =
      GlobalKey<FormState>();

  final PengembanganKehidupanController
  uploadController = Get.put(
    PengembanganKehidupanController(),
  );

  @override
  void dispose() {
    permulaKelompokController.dispose();

    permulaPesertaController.dispose();

    madyaKelompokController.dispose();

    madyaPesertaController.dispose();

    utamaKelompokController.dispose();

    utamaPesertaController.dispose();

    mandiriKelompokController.dispose();

    mandiriPesertaController.dispose();

    super.dispose();
  }

  Widget sectionTitle(String title) {
    return TypographyStyles
        .bodyCaptionSemiBold(
      title,
      color: TextColors.grey900,
    );
  }

  Widget inputField({
    required TextEditingController
    controller,

    required String label,
  }) {
    return Column(
      children: [
        InputFormField(
          controller: controller,

          hintText: 'Masukkan jumlah',

          label: label,

          keyboardType:
              TextInputType.number,

          validator:
              ValidatorForm
                  .validateDefault,
        ),

        SizedBox(height: 20.h),
      ],
    );
  }

  Widget buildSection(
    String title,

    TextEditingController kelompok,

    TextEditingController peserta,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        sectionTitle(title),

        SizedBox(height: 12.h),

        inputField(
          controller: kelompok,

          label: 'Jumlah Kelompok',
        ),

        inputField(
          controller: peserta,

          label: 'Jumlah Peserta',
        ),

        SizedBox(height: 8.h),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final media =
        MediaQuery.of(context);

    final isTablet =
        media.size.width >= 600;

    return Scaffold(
      resizeToAvoidBottomInset: true,

      backgroundColor: Colors.white,

      appBar: AppBarSecondary(
        title:
            'Pengembangan Kehidupan Berkoperasi',

        onBack: () => Get.back(),

        currentStep: 1,

        totalSteps: 3,
      ),

      body: SafeArea(
        child: GestureDetector(
          onTap: () =>
              FocusScope.of(context)
                  .unfocus(),

          child: LayoutBuilder(
            builder:
                (context, constraints) {
              return SingleChildScrollView(
                physics:
                    const BouncingScrollPhysics(),

                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior
                        .manual,

                padding: EdgeInsets.only(
                  left:
                      isTablet ? 40.w : 16.w,

                  right:
                      isTablet ? 40.w : 16.w,

                  top: 20.h,

                  bottom:
                      media.viewInsets.bottom +
                          20.h,
                ),

                child: Center(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(
                      maxWidth: isTablet
                          ? 600
                          : double.infinity,

                      minHeight:
                          constraints
                              .maxHeight,
                    ),

                    child: Form(
                      key: _formKey,

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [
                          SizedBox(
                              height: 12.h),

                          /// TITLE
                          sectionTitle(
                            'Prakoperasi / Usaha Bersama / UP2K PKK',
                          ),

                          SizedBox(
                              height: 24.h),

                          /// PEMULA
                          buildSection(
                            'Pemula',

                            permulaKelompokController,

                            permulaPesertaController,
                          ),

                          /// MADYA
                          buildSection(
                            'Madya',

                            madyaKelompokController,

                            madyaPesertaController,
                          ),

                          /// UTAMA
                          buildSection(
                            'Utama',

                            utamaKelompokController,

                            utamaPesertaController,
                          ),

                          /// MANDIRI
                          buildSection(
                            'Mandiri',

                            mandiriKelompokController,

                            mandiriPesertaController,
                          ),

                          SizedBox(
                              height: 10.h),

                          /// BUTTON
                          ZoomTapAnimation(
                            child: Obx(
                              () => ButtonFill(
                                text:
                                    'Lanjut',

                                textColor:
                                    Colors
                                        .white,

                                isLoading:
                                    uploadController
                                        .isLoading
                                        .value,

                                onPressed:
                                    uploadController
                                            .isLoading
                                            .value
                                        ? null
                                        : () {
                                            if (_formKey
                                                .currentState!
                                                .validate()) {
                                              /// SIMPAN DATA
                                              uploadController
                                                  .setField(
                                                    jumlahKelompokPemula:
                                                        permulaKelompokController
                                                            .text,

                                                    jumlahPesertaPemula:
                                                        permulaPesertaController
                                                            .text,

                                                    jumlahKelompokMadya:
                                                        madyaKelompokController
                                                            .text,

                                                    jumlahPesertaMadya:
                                                        madyaPesertaController
                                                            .text,

                                                    jumlahKelompokUtama:
                                                        utamaKelompokController
                                                            .text,

                                                    jumlahPesertaUtama:
                                                        utamaPesertaController
                                                            .text,

                                                    jumlahKelompokMandiri:
                                                        mandiriKelompokController
                                                            .text,

                                                    jumlahPesertaMandiri:
                                                        mandiriPesertaController
                                                            .text,
                                                  );

                                              /// NEXT
                                              Get.toNamed(
                                                Routes
                                                    .PENGEMBANGAN2,
                                              );
                                            } else {
                                              Get.snackbar(
                                                'Error',
                                                'Lengkapi Form',

                                                snackPosition:
                                                    SnackPosition
                                                        .TOP,

                                                backgroundColor:
                                                    Colors
                                                        .red,

                                                colorText:
                                                    Colors
                                                        .white,
                                              );
                                            }
                                          },
                              ),
                            ),
                          ),

                          SizedBox(
                              height: 20.h),
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