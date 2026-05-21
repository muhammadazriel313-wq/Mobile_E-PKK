import 'package:epkk_nganjuk/common/appbar/custom_appbar.dart';
import 'package:epkk_nganjuk/core/validators/validator_form.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:epkk_nganjuk/features/auth/component/input_form_field.dart';
import 'package:epkk_nganjuk/features/pages/pokja3/sandang/sandang_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class SandangScreen
    extends StatefulWidget {
  const SandangScreen({
    super.key,
  });

  @override
  State<SandangScreen>
  createState() =>
      _SandangScreenState();
}

class _SandangScreenState
    extends State<SandangScreen> {
  String? id_user;
  String? id_role;
  String? id_organization;
  String? full_name;
  String? name_role;
  String? name_organization;

  final panganController =
      TextEditingController();

  final sandangController =
      TextEditingController();

  final jasaController =
      TextEditingController();

  final _formKey =
      GlobalKey<FormState>();

  final SandangController
  uploadReportController =
      Get.put(
        SandangController(),
      );

  void clearForm() {
    panganController.clear();

    sandangController.clear();

    jasaController.clear();
  }

  @override
  void initState() {
    super.initState();

    final args =
        Get.arguments ?? {};

    id_user = args['id_user'];

    full_name =
        args['full_name'];

    id_role = args['id_role'];

    name_role =
        args['name_role'];

    id_organization =
        args['id_organization'];

    name_organization =
        args['name_organization'];
  }

  @override
  void dispose() {
    panganController.dispose();

    sandangController.dispose();

    jasaController.dispose();

    super.dispose();
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

          validator:
              ValidatorForm
                  .validateDefault,
        ),

        SizedBox(height: 16.h),
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
        title:
            'Jumlah Industri Rumah Tangga',

        onBack: () => Get.back(),
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
                              height: 20.h),

                          /// PANGAN
                          inputField(
                            controller:
                                panganController,

                            label:
                                'Pangan',
                          ),

                          /// SANDANG
                          inputField(
                            controller:
                                sandangController,

                            label:
                                'Sandang',
                          ),

                          /// JASA
                          inputField(
                            controller:
                                jasaController,

                            label:
                                'Jasa',

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
                                text: uploadReportController
                                        .isLoading
                                        .value
                                    ? 'Loading'
                                    : 'Kirim',

                                textColor:
                                    Colors
                                        .white,

                                onPressed:
                                    uploadReportController
                                            .isLoading
                                            .value
                                        ? null
                                        : () async {
                                            final isFormValid =
                                                _formKey
                                                    .currentState!
                                                    .validate();

                                            if (isFormValid) {
                                              await uploadReportController
                                                  .submitDataSandang(
                                                    pangan:
                                                        panganController
                                                            .text,

                                                    sandang:
                                                        sandangController
                                                            .text,

                                                    jasa:
                                                        jasaController
                                                            .text,

                                                    idRole:
                                                        id_role!,

                                                    idOrganization:
                                                        id_organization!,

                                                    idUser:
                                                        id_user!,
                                                  );

                                              if (uploadReportController
                                                          .reportData
                                                          .value !=
                                                      null &&
                                                  uploadReportController
                                                          .reportData
                                                          .value!
                                                          .statusCode ==
                                                      200) {

                                                _formKey
                                                    .currentState
                                                    ?.reset();

                                                clearForm();

                                                Get.offAllNamed(
                                                  '/main',
                                                );
                                              }
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