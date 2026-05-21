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

class PendidikanKetrampilan4Screen
    extends StatefulWidget {
  const PendidikanKetrampilan4Screen({
    super.key,
  });

  @override
  State<PendidikanKetrampilan4Screen>
  createState() =>
      _Pendidikan4ScreenState();
}

class _Pendidikan4ScreenState
    extends State<
      PendidikanKetrampilan4Screen
    > {
  final PendidikanKeterampilanController
  controller =
      Get.find<
        PendidikanKeterampilanController
      >();

  final lp3Controller =
      TextEditingController();

  final tp3Controller =
      TextEditingController();

  final damasController =
      TextEditingController();

  final _formKey =
      GlobalKey<FormState>();

  @override
  void dispose() {
    lp3Controller.dispose();

    tp3Controller.dispose();

    damasController.dispose();

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

          validator: (v) =>
              ValidatorForm
                  .validateDefault(v),
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

        currentStep: 4,

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

                          /// TITLE
                          sectionTitle(
                            'Jumlah Kader yang Sudah Dilatih',
                          ),

                          SizedBox(
                              height: 24.h),

                          /// INPUT
                          inputField(
                            controller:
                                lp3Controller,

                            label:
                                'LP3 PKK',
                          ),

                          inputField(
                            controller:
                                tp3Controller,

                            label:
                                'TP3 PKK',
                          ),

                          inputField(
                            controller:
                                damasController,

                            label:
                                'DAMAS PKK',
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
                                                  .setStep4(
                                                    lp3:
                                                        lp3Controller
                                                            .text,

                                                    tp3:
                                                        tp3Controller
                                                            .text,

                                                    damas:
                                                        damasController
                                                            .text,
                                                  );

                                              /// NEXT
                                              Get.toNamed(
                                                Routes
                                                    .PENDIDIKAN5,
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