import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/common/typography.dart';
import 'package:epkk_nganjuk/core/validators/validator_form.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';

import 'package:epkk_nganjuk/common/appbar/custom_appbar.dart';

import 'package:epkk_nganjuk/features/auth/component/input_form_field.dart';
import 'package:epkk_nganjuk/features/pages/pokja3/pangan/pangan_controller.dart';
import 'package:epkk_nganjuk/routes/app_routes.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class Pangan1Screen extends StatefulWidget {
  const Pangan1Screen({super.key});

  @override
  State<Pangan1Screen> createState() =>
      _Pangan1ScreenState();
}

class _Pangan1ScreenState
    extends State<Pangan1Screen> {
  String? id_user;
  String? id_role;
  String? id_organization;
  String? full_name;
  String? name_role;
  String? name_organization;

  final berasController =
      TextEditingController();

  final nonBerasController =
      TextEditingController();

  final _formKey =
      GlobalKey<FormState>();

  final PanganController
  uploadController = Get.put(
    PanganController(),
  );

  void clearForm() {
    berasController.clear();

    nonBerasController.clear();
  }

  @override
  void initState() {
    super.initState();

    final args = Get.arguments ?? {};

    id_user = args['id_user'];

    full_name = args['full_name'];

    id_role = args['id_role'];

    name_role = args['name_role'];

    id_organization =
        args['id_organization'];

    name_organization =
        args['name_organization'];
  }

  @override
  void dispose() {
    berasController.dispose();

    nonBerasController.dispose();

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

      /// APPBAR
      appBar: AppBarSecondary(
        title: 'Pangan',

        onBack: () => Get.back(),

        currentStep: 1,

        totalSteps: 3,
      ),

      /// BODY
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
                              height: 6.h),

                          /// TITLE
                          sectionTitle(
                            'Makanan Pokok',
                          ),

                          SizedBox(
                              height: 24.h),

                          /// BERAS
                          inputField(
                            controller:
                                berasController,

                            label:
                                'Beras',
                          ),

                          /// NON BERAS
                          inputField(
                            controller:
                                nonBerasController,

                            label:
                                'Non Beras',
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
                                              Get.toNamed(
                                                Routes
                                                    .PANGAN2,

                                                arguments: {
                                                  'id_user':
                                                      id_user,

                                                  'full_name':
                                                      full_name,

                                                  'id_role':
                                                      id_role,

                                                  'name_role':
                                                      name_role,

                                                  'id_organization':
                                                      id_organization,

                                                  'name_organization':
                                                      name_organization,

                                                  'beras':
                                                      berasController
                                                          .text,

                                                  'non_beras':
                                                      nonBerasController
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