import 'package:epkk_nganjuk/common/appbar/custom_appbar.dart';
import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/common/typography.dart';
import 'package:epkk_nganjuk/core/validators/validator_form.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:epkk_nganjuk/features/auth/component/input_form_field.dart';
import 'package:epkk_nganjuk/features/pages/pokja3/perumahan/perumahan_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class PerumahanScreen
    extends StatefulWidget {
  const PerumahanScreen({
    super.key,
  });

  @override
  State<PerumahanScreen>
  createState() =>
      _PerumahanScreenState();
}

class _PerumahanScreenState
    extends State<PerumahanScreen> {
  String? id_user;
  String? id_role;
  String? id_organization;
  String? full_name;
  String? name_role;
  String? name_organization;

  final sehatLayakController =
      TextEditingController();

  final tidakSehatController =
      TextEditingController();

  final _formKey =
      GlobalKey<FormState>();

  final PerumahanController
  uploadReportController =
      Get.put(
        PerumahanController(),
      );

  void clearForm() {
    sehatLayakController.clear();

    tidakSehatController.clear();
  }

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

    debugPrint(
      'Diterima dari argument: id_user=$id_user, id_role=$id_role, id_org=$id_organization',
    );
  }

  @override
  void dispose() {
    sehatLayakController.dispose();

    tidakSehatController.dispose();

    super.dispose();
  }

  Widget sectionTitle(
    String title,
  ) {
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
        title:
            'Perumahan & Tata Laksana Rumah',
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
                              height: 8.h),

                          /// TITLE
                          sectionTitle(
                            'Jumlah Rumah',
                          ),

                          SizedBox(
                              height: 24.h),

                          /// INPUT 1
                          inputField(
                            controller:
                                sehatLayakController,

                            label:
                                'Sehat dan Layak Dihuni',
                          ),

                          /// INPUT 2
                          inputField(
                            controller:
                                tidakSehatController,

                            label:
                                'Tidak Sehat dan Tidak Layak Dihuni',

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
                                                  .submitDataPerumahan(
                                                    layakHuni:
                                                        sehatLayakController
                                                            .text,

                                                    tidakLayak:
                                                        tidakSehatController
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