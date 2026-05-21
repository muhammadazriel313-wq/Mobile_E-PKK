import 'package:epkk_nganjuk/common/appbar/custom_appbar.dart';
import 'package:epkk_nganjuk/core/validators/validator_form.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:epkk_nganjuk/features/auth/component/input_form_field.dart';
import 'package:epkk_nganjuk/features/pages/pokja4/kader_pokja4/kader_pokja4_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class KaderPokja4Screen
    extends StatefulWidget {
  const KaderPokja4Screen({
    super.key,
  });

  @override
  State<KaderPokja4Screen>
  createState() =>
      _KaderPokja4ScreenState();
}

class _KaderPokja4ScreenState
    extends State<KaderPokja4Screen> {
  String? idUser;
  String? idRole;
  String? idOrganization;
  String? fullName;
  String? nameRole;
  String? nameOrganization;

  final posyanduController =
      TextEditingController();

  final giziController =
      TextEditingController();

  final keslingController =
      TextEditingController();

  final narkobaController =
      TextEditingController();

  final phbsController =
      TextEditingController();

  final kbController =
      TextEditingController();

  final _formKey =
      GlobalKey<FormState>();

  final KaderPokja4Controller
  uploadReportController =
      Get.put(
        KaderPokja4Controller(),
      );

  @override
  void initState() {
    super.initState();

    final args = Get.arguments;

    idUser = args['id_user'];

    fullName = args['full_name'];

    idRole = args['id_role'];

    nameRole = args['name_role'];

    idOrganization =
        args['id_organization'];

    nameOrganization =
        args['name_organization'];

    debugPrint(
      'Diterima dari argument: '
      'id_user=$idUser, '
      'id_role=$idRole, '
      'id_org=$idOrganization',
    );
  }

  @override
  void dispose() {
    posyanduController.dispose();

    giziController.dispose();

    keslingController.dispose();

    narkobaController.dispose();

    phbsController.dispose();

    kbController.dispose();

    super.dispose();
  }

  void clearForm() {
    posyanduController.clear();

    giziController.clear();

    keslingController.clear();

    narkobaController.clear();

    phbsController.clear();

    kbController.clear();
  }

  Widget buildInput({
    required TextEditingController
    controller,

    required String label,

    TextInputAction action =
        TextInputAction.next,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 20.h,
      ),

      child: InputFormField(
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
        title: 'Kader Pokja IV',
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
                              height: 16.h),

                          /// POSYANDU
                          buildInput(
                            controller:
                                posyanduController,

                            label:
                                'Posyandu',
                          ),

                          /// GIZI
                          buildInput(
                            controller:
                                giziController,

                            label:
                                'Gizi',
                          ),

                          /// KESLING
                          buildInput(
                            controller:
                                keslingController,

                            label:
                                'Kesling',
                          ),

                          /// NARKOBA
                          buildInput(
                            controller:
                                narkobaController,

                            label:
                                'Penyuluhan Narkoba',
                          ),

                          /// PHBS
                          buildInput(
                            controller:
                                phbsController,

                            label:
                                'PHBS',
                          ),

                          /// KB
                          buildInput(
                            controller:
                                kbController,

                            label:
                                'KB',

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
                                    ? 'Loading...'
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

                                            if (!isFormValid) {
                                              Get.snackbar(
                                                'Error',

                                                'Form tidak valid',

                                                snackPosition:
                                                    SnackPosition
                                                        .TOP,

                                                backgroundColor:
                                                    Colors
                                                        .orange,

                                                colorText:
                                                    Colors
                                                        .white,
                                              );

                                              return;
                                            }

                                            await uploadReportController
                                                .submitDataKaderPokja4(
                                                  idUser:
                                                      idUser ??
                                                          '',

                                                  posyandu:
                                                      posyanduController
                                                          .text,

                                                  gizi:
                                                      giziController
                                                          .text,

                                                  kesling:
                                                      keslingController
                                                          .text,

                                                  penyuluhanNarkoba:
                                                      narkobaController
                                                          .text,

                                                  phbs:
                                                      phbsController
                                                          .text,

                                                  kb:
                                                      kbController
                                                          .text,

                                                  idRole:
                                                      idRole ??
                                                          '',

                                                  idOrganization:
                                                      idOrganization ??
                                                          '',
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