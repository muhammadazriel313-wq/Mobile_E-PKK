/// =======================================================
/// FILE : posyandu_2_screen.dart
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

class Posyandu2Screen extends StatefulWidget {
  const Posyandu2Screen({super.key});

  @override
  State<Posyandu2Screen> createState() =>
      _Posyandu2ScreenState();
}

class _Posyandu2ScreenState
    extends State<Posyandu2Screen> {
  /// ================= ARGUMENT =================

  late Map<String, dynamic> data;

  /// ================= CONTROLLER =================

  final kondomController =
      TextEditingController();

  final pilController =
      TextEditingController();

  final implantController =
      TextEditingController();

  final mopController =
      TextEditingController();

  final mowController =
      TextEditingController();

  final iudController =
      TextEditingController();

  final suntikanController =
      TextEditingController();

  final lainController =
      TextEditingController();

  /// ================= FORM =================

  final _formKey =
      GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    data = Get.arguments;
  }

  @override
  void dispose() {
    kondomController.dispose();
    pilController.dispose();
    implantController.dispose();
    mopController.dispose();
    mowController.dispose();
    iudController.dispose();
    suntikanController.dispose();
    lainController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media =
        MediaQuery.of(context);

    final isTablet =
        media.size.width >= 600;

    return Scaffold(
      resizeToAvoidBottomInset:
          true,

      backgroundColor:
          Colors.white,

      appBar: AppBarSecondary(
        title: 'Posyandu',

        currentStep: 2,

        totalSteps: 5,

        onBack:
            () => Get.back(),
      ),

      body: SafeArea(
        child: GestureDetector(
          onTap:
              () => FocusScope.of(
                context,
              ).unfocus(),

          child: LayoutBuilder(
            builder:
                (
                  context,
                  constraints,
                ) {
                  return SingleChildScrollView(
                    physics:
                        const BouncingScrollPhysics(),

                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior
                            .manual,

                    padding: EdgeInsets.only(
                      left:
                          isTablet
                              ? 40.w
                              : 16.w,

                      right:
                          isTablet
                              ? 40.w
                              : 16.w,

                      top: 20.h,

                      bottom:
                          media
                              .viewInsets
                              .bottom +
                          20.h,
                    ),

                    child: Center(
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(
                              maxWidth:
                                  isTablet
                                      ? 650
                                      : double
                                          .infinity,

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
                              /// ======================
                              /// KB
                              /// ======================

                              TypographyStyles
                                  .bodyCaptionSemiBold(
                                'KB',

                                color:
                                    TextColors
                                        .grey900,
                              ),

                              SizedBox(
                                height:
                                    24.h,
                              ),

                              _inputNumber(
                                controller:
                                    kondomController,

                                label:
                                    'Kondom',
                              ),

                              SizedBox(
                                height:
                                    20.h,
                              ),

                              _inputNumber(
                                controller:
                                    pilController,

                                label:
                                    'Pil',
                              ),

                              SizedBox(
                                height:
                                    20.h,
                              ),

                              _inputNumber(
                                controller:
                                    implantController,

                                label:
                                    'Implant',
                              ),

                              SizedBox(
                                height:
                                    20.h,
                              ),

                              _inputNumber(
                                controller:
                                    mopController,

                                label:
                                    'MOP',
                              ),

                              SizedBox(
                                height:
                                    20.h,
                              ),

                              _inputNumber(
                                controller:
                                    mowController,

                                label:
                                    'MOW',
                              ),

                              SizedBox(
                                height:
                                    20.h,
                              ),

                              _inputNumber(
                                controller:
                                    iudController,

                                label:
                                    'IUD',
                              ),

                              SizedBox(
                                height:
                                    20.h,
                              ),

                              _inputNumber(
                                controller:
                                    suntikanController,

                                label:
                                    'Suntikan',
                              ),

                              SizedBox(
                                height:
                                    20.h,
                              ),

                              _inputNumber(
                                controller:
                                    lainController,

                                label:
                                    'Lain - lain',
                              ),

                              SizedBox(
                                height:
                                    30.h,
                              ),

                              /// ======================
                              /// BUTTON
                              /// ======================

                              ZoomTapAnimation(
                                child: ButtonFill(
                                  text:
                                      'Lanjut',

                                  textColor:
                                      Colors
                                          .white,

                                  onPressed:
                                      () {
                                        if (_formKey
                                            .currentState!
                                            .validate()) {
                                          Get.toNamed(
                                            Routes
                                                .POSYANDU_3,

                                            arguments: {
                                              ...data,

                                              'kondom':
                                                  kondomController
                                                      .text,

                                              'pil':
                                                  pilController
                                                      .text,

                                              'implant':
                                                  implantController
                                                      .text,

                                              'mop':
                                                  mopController
                                                      .text,

                                              'mow':
                                                  mowController
                                                      .text,

                                              'iud':
                                                  iudController
                                                      .text,

                                              'suntikan':
                                                  suntikanController
                                                      .text,

                                              'lain_lain_kb':
                                                  lainController
                                                      .text,
                                            },
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

                              SizedBox(
                                height:
                                    20.h,
                              ),
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
    required TextEditingController
    controller,

    required String label,
  }) {
    return InputFormField(
      controller: controller,

      hintText:
          'Masukkan jumlah',

      label: label,

      keyboardType:
          TextInputType.number,

      textInputAction:
          TextInputAction.next,

      validator: (value) {
        return ValidatorForm
            .validateNumber(
              value,
            );
      },
    );
  }
}