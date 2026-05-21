import 'package:epkk_nganjuk/common/appbar/custom_appbar.dart';
import 'package:epkk_nganjuk/core/validators/validator_form.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:epkk_nganjuk/features/auth/component/input_form_field.dart';
import 'package:epkk_nganjuk/features/pages/pokja4/jumlah_rumah/perencanaan_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class PerencanaanSehatScreen
    extends StatefulWidget {
  const PerencanaanSehatScreen({
    super.key,
  });

  @override
  State<PerencanaanSehatScreen>
  createState() =>
      _PerencanaanSehatScreenState();
}

class _PerencanaanSehatScreenState
    extends State<PerencanaanSehatScreen> {
  String? idUser;
  String? idRole;
  String? idOrganization;
  String? fullName;
  String? nameRole;
  String? nameOrganization;

  final pusController =
      TextEditingController();

  final wusController =
      TextEditingController();

  final kbPriaController =
      TextEditingController();

  final kbWanitaController =
      TextEditingController();

  final tabunganKeluargaController =
      TextEditingController();

  final _formKey =
      GlobalKey<FormState>();

  final PerencanaanController
  uploadReportController =
      Get.put(
        PerencanaanController(),
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
    pusController.dispose();

    wusController.dispose();

    kbPriaController.dispose();

    kbWanitaController.dispose();

    tabunganKeluargaController
        .dispose();

    super.dispose();
  }

  void clearForm() {
    pusController.clear();

    wusController.clear();

    kbPriaController.clear();

    kbWanitaController.clear();

    tabunganKeluargaController
        .clear();
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

      appBar: AppBarSecondary(
        title:
            'Perencanaan Sehat',
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
                              height: 24.h),

                          /// PUS
                          buildInput(
                            controller:
                                pusController,

                            label:
                                'Pria Usia Subur (PUS)',
                          ),

                          /// WUS
                          buildInput(
                            controller:
                                wusController,

                            label:
                                'Wanita Usia Subur (WUS)',
                          ),

                          /// KB PRIA
                          buildInput(
                            controller:
                                kbPriaController,

                            label:
                                'Anggota KB Pria',
                          ),

                          /// KB WANITA
                          buildInput(
                            controller:
                                kbWanitaController,

                            label:
                                'Anggota KB Wanita',
                          ),

                          /// TABUNGAN
                          buildInput(
                            controller:
                                tabunganKeluargaController,

                            label:
                                'KK yang Memiliki Tabungan Keluarga',

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

                                                'Form tidak valid! Mohon periksa kembali input Anda.',

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
                                                .submitPerencanaanData(
                                                  idUser:
                                                      idUser ??
                                                          '',

                                                  jumlahPriaSubur:
                                                      pusController
                                                          .text,

                                                  jumlahWanitaSubur:
                                                      wusController
                                                          .text,

                                                  kbPria:
                                                      kbPriaController
                                                          .text,

                                                  kbWanita:
                                                      kbWanitaController
                                                          .text,

                                                  kkTabungan:
                                                      tabunganKeluargaController
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