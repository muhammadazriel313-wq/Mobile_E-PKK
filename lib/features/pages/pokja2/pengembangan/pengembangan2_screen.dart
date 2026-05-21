import 'package:epkk_nganjuk/common/appbar/custom_appbar.dart';
import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/common/typography.dart';
import 'package:epkk_nganjuk/core/validators/validator_form.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:epkk_nganjuk/features/auth/component/input_form_field.dart';
import 'package:epkk_nganjuk/features/pages/pokja2/pengembangan/pengembangan_kehidupan_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';

class Pengembangan2 extends StatefulWidget {
  const Pengembangan2({super.key});

  @override
  State<Pengembangan2> createState() =>
      _Pengembangan2ScreenState();
}

class _Pengembangan2ScreenState
    extends State<Pengembangan2> {
  final koperasiKelompokController =
      TextEditingController();

  final koperasiPesertaController =
      TextEditingController();

  final _formKey =
      GlobalKey<FormState>();

  final PengembanganKehidupanController
  uploadController =
      Get.find<
        PengembanganKehidupanController
      >();

  @override
  void dispose() {
    koperasiKelompokController.dispose();

    koperasiPesertaController.dispose();

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

        currentStep: 2,

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
                        .onDrag,

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
                            'Koperasi Berbadan Hukum',
                          ),

                          SizedBox(
                              height: 24.h),

                          /// INPUT
                          inputField(
                            controller:
                                koperasiKelompokController,

                            label:
                                'Jumlah Kelompok',
                          ),

                          inputField(
                            controller:
                                koperasiPesertaController,

                            label:
                                'Jumlah Anggota',
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
                                                    jumlahKelompokHukum:
                                                        koperasiKelompokController
                                                            .text,

                                                    jumlahPesertaHukum:
                                                        koperasiPesertaController
                                                            .text,
                                                  );

                                              /// NEXT
                                              Get.toNamed(
                                                Routes
                                                    .PENGEMBANGAN3,
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