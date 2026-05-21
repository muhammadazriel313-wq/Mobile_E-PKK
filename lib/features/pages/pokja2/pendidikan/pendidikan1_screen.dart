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

class Pendidikan1Screen extends StatefulWidget {
  const Pendidikan1Screen({super.key});

  @override
  State<Pendidikan1Screen> createState() =>
      _Pendidikan1ScreenState();
}

class _Pendidikan1ScreenState
    extends State<Pendidikan1Screen> {
  final PendidikanKeterampilanController
  controller = Get.put(
    PendidikanKeterampilanController(),
  );

  final jumlahButaController =
      TextEditingController();

  final kelBelajarAController =
      TextEditingController();

  final wargaBelajarAController =
      TextEditingController();

  final kelBelajarBController =
      TextEditingController();

  final wargaBelajarBController =
      TextEditingController();

  final _formKey =
      GlobalKey<FormState>();

  @override
  void dispose() {
    jumlahButaController.dispose();

    kelBelajarAController.dispose();

    wargaBelajarAController.dispose();

    kelBelajarBController.dispose();

    wargaBelajarBController.dispose();

    super.dispose();
  }

  Widget sectionTitle(String title) {
    return Container(
      alignment: Alignment.centerLeft,

      child: TypographyStyles
          .bodyCaptionBold(
        title,
        color: TextColors.grey700,
      ),
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

        SizedBox(height: 24.h),
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
            'Pendidikan & Ketrampilan',

        onBack: () => Get.back(),

        currentStep: 1,

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
                          /// TITLE
                          sectionTitle(
                            'Jumlah Kelompok Belajar',
                          ),

                          SizedBox(
                              height: 12.h),

                          /// INPUT
                          inputField(
                            controller:
                                jumlahButaController,

                            label:
                                'Jumlah warga yang masih buta',
                          ),

                          /// PAKET A
                          sectionTitle(
                              'Paket A'),

                          SizedBox(
                              height: 12.h),

                          inputField(
                            controller:
                                kelBelajarAController,

                            label:
                                'Kel. Belajar',
                          ),

                          inputField(
                            controller:
                                wargaBelajarAController,

                            label:
                                'Warga Belajar',
                          ),

                          /// PAKET B
                          sectionTitle(
                              'Paket B'),

                          SizedBox(
                              height: 12.h),

                          inputField(
                            controller:
                                kelBelajarBController,

                            label:
                                'Kel. Belajar',
                          ),

                          inputField(
                            controller:
                                wargaBelajarBController,

                            label:
                                'Warga Belajar',
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
                                                  .setStep1(
                                                    wargaButaVal:
                                                        jumlahButaController
                                                            .text,

                                                    kelA:
                                                        kelBelajarAController
                                                            .text,

                                                    wargaA:
                                                        wargaBelajarAController
                                                            .text,

                                                    kelB:
                                                        kelBelajarBController
                                                            .text,

                                                    wargaB:
                                                        wargaBelajarBController
                                                            .text,
                                                  );

                                              /// NEXT
                                              Get.toNamed(
                                                Routes
                                                    .PENDIDIKAN2,
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