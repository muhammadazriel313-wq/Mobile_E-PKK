import 'package:epkk_nganjuk/common/appbar/custom_appbar.dart';
import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/common/typography.dart';
import 'package:epkk_nganjuk/core/validators/validator_form.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:epkk_nganjuk/features/auth/component/input_form_field.dart';
import 'package:epkk_nganjuk/features/pages/pokja2/pendidikan/pendidikan_ketrampilan_controller.dart';
import 'package:epkk_nganjuk/routes/app_routes.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class PendidikanKetrampilan2Screen
    extends StatefulWidget {
  const PendidikanKetrampilan2Screen({
    super.key,
  });

  @override
  State<PendidikanKetrampilan2Screen>
  createState() =>
      _Pendidikan2ScreenState();
}

class _Pendidikan2ScreenState
    extends State<
      PendidikanKetrampilan2Screen
    > {
  final PendidikanKeterampilanController
  controller =
      Get.find<
        PendidikanKeterampilanController
      >();

  final paketCKelController =
      TextEditingController();

  final paketCWargaController =
      TextEditingController();

  final paketKFKelController =
      TextEditingController();

  final paketKFWargaController =
      TextEditingController();

  final paudController =
      TextEditingController();

  final tamanBacaanController =
      TextEditingController();

  final _formKey =
      GlobalKey<FormState>();

  @override
  void dispose() {
    paketCKelController.dispose();

    paketCWargaController.dispose();

    paketKFKelController.dispose();

    paketKFWargaController.dispose();

    paudController.dispose();

    tamanBacaanController.dispose();

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

          validator: (value) =>
              ValidatorForm
                  .validateDefault(
                    value,
                  ),
        ),

        SizedBox(height: 20.h),
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
            'Pendidikan & Keterampilan',

        onBack: () => Get.back(),

        currentStep: 2,

        totalSteps: 5,
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

                          /// PAKET C
                          sectionTitle(
                              'Paket C'),

                          SizedBox(
                              height: 12.h),

                          inputField(
                            controller:
                                paketCKelController,

                            label:
                                'Kel. Belajar',
                          ),

                          inputField(
                            controller:
                                paketCWargaController,

                            label:
                                'Warga Belajar',
                          ),

                          SizedBox(
                              height: 8.h),

                          /// PAKET KF
                          sectionTitle(
                              'Paket KF'),

                          SizedBox(
                              height: 12.h),

                          inputField(
                            controller:
                                paketKFKelController,

                            label:
                                'Kel. Belajar',
                          ),

                          inputField(
                            controller:
                                paketKFWargaController,

                            label:
                                'Warga Belajar',
                          ),

                          SizedBox(
                              height: 8.h),

                          /// PAUD
                          inputField(
                            controller:
                                paudController,

                            label:
                                'Paud / sejenis',
                          ),

                          /// TAMAN BACAAN
                          inputField(
                            controller:
                                tamanBacaanController,

                            label:
                                'Jumlah taman bacaan / perpustakaan',
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
                                    controller
                                        .isLoading
                                        .value,

                                onPressed:
                                    controller
                                            .isLoading
                                            .value
                                        ? null
                                        : () {
                                            if (_formKey
                                                .currentState!
                                                .validate()) {
                                              /// SIMPAN DATA
                                              controller
                                                  .setStep2(
                                                    kelC:
                                                        paketCKelController
                                                            .text,

                                                    wargaC:
                                                        paketCWargaController
                                                            .text,

                                                    kelKF:
                                                        paketKFKelController
                                                            .text,

                                                    wargaKF:
                                                        paketKFWargaController
                                                            .text,

                                                    paudVal:
                                                        paudController
                                                            .text,

                                                    taman:
                                                        tamanBacaanController
                                                            .text,
                                                  );

                                              /// NEXT
                                              Get.toNamed(
                                                Routes
                                                    .PENDIDIKAN3,
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