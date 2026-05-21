import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/common/typography.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:epkk_nganjuk/features/auth/component/custome_appbar.dart';
import 'package:epkk_nganjuk/features/auth/component/input_form_field.dart';
import 'package:epkk_nganjuk/features/pages/pokja3/pangan/pangan_controller.dart';
import 'package:epkk_nganjuk/routes/app_routes.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class Pangan2Screen extends StatefulWidget {
  const Pangan2Screen({super.key});

  @override
  State<Pangan2Screen> createState() =>
      _Pangan1ScreenState();
}

class _Pangan1ScreenState
    extends State<Pangan2Screen> {
  String? id_user;
  String? id_role;
  String? id_organization;
  String? full_name;
  String? name_role;
  String? name_organization;
  String? beras;
  String? non_beras;

  final peternakanController =
      TextEditingController();

  final perikananController =
      TextEditingController();

  final warungHidupController =
      TextEditingController();

  final lumbungHidupController =
      TextEditingController();

  final togaController =
      TextEditingController();

  final tanamanKerasController =
      TextEditingController();

  final tanamanLainnyaController =
      TextEditingController();

  final _formKey =
      GlobalKey<FormState>();

  final PanganController
  uploadController =
      Get.find<PanganController>();

  @override
  void initState() {
    super.initState();

    final args = Get.arguments;

    id_user = args['id_user'];

    full_name = args['full_name'];

    id_role = args['id_role'];

    name_role = args['name_role'];

    id_organization =
        args['id_organization'];

    name_organization =
        args['name_organization'];

    beras = args['beras'];

    non_beras = args['non_beras'];
  }

  @override
  void dispose() {
    peternakanController.dispose();

    perikananController.dispose();

    warungHidupController.dispose();

    lumbungHidupController.dispose();

    togaController.dispose();

    tanamanKerasController.dispose();

    tanamanLainnyaController.dispose();

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

    TextInputAction action =
        TextInputAction.next,
  }) {
    return Column(
      children: [
        InputFormField(
          controller: controller,

          hintText: 'Masukkan jumlah',

          label: label,

          keyboardType:
              TextInputType.number,

          textInputAction: action,
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
        title: 'Pangan',

        centerTitle: false,

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
                              height: 6.h),

                          /// TITLE
                          sectionTitle(
                            'Pemanfaatan Pekarangan / Hatinya PKK',
                          ),

                          SizedBox(
                              height: 24.h),

                          /// PETERNAKAN
                          inputField(
                            controller:
                                peternakanController,

                            label:
                                'Peternakan',
                          ),

                          /// PERIKANAN
                          inputField(
                            controller:
                                perikananController,

                            label:
                                'Perikanan',
                          ),

                          /// WARUNG HIDUP
                          inputField(
                            controller:
                                warungHidupController,

                            label:
                                'Warung Hidup',
                          ),

                          /// LUMBUNG HIDUP
                          inputField(
                            controller:
                                lumbungHidupController,

                            label:
                                'Lumbung Hidup',
                          ),

                          /// TOGA
                          inputField(
                            controller:
                                togaController,

                            label:
                                'TOGA',
                          ),

                          /// TANAMAN KERAS
                          inputField(
                            controller:
                                tanamanKerasController,

                            label:
                                'Tanaman Keras',
                          ),

                          /// TANAMAN LAINNYA
                          inputField(
                            controller:
                                tanamanLainnyaController,

                            label:
                                'Tanaman Lainnya',

                            action:
                                TextInputAction
                                    .done,
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
                                                    .PANGAN3,

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
                                                      beras,

                                                  'non_beras':
                                                      non_beras,

                                                  'peternakan':
                                                      peternakanController
                                                          .text,

                                                  'perikanan':
                                                      perikananController
                                                          .text,

                                                  'warung_hidup':
                                                      warungHidupController
                                                          .text,

                                                  'lumbung_hidup':
                                                      lumbungHidupController
                                                          .text,

                                                  'toga':
                                                      togaController
                                                          .text,

                                                  'tanaman_keras':
                                                      tanamanKerasController
                                                          .text,

                                                  'tanaman_lainnya':
                                                      tanamanLainnyaController
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