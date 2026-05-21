import 'package:epkk_nganjuk/common/appbar/custom_appbar.dart';
import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/common/typography.dart';
import 'package:epkk_nganjuk/core/validators/validator_form.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:epkk_nganjuk/features/auth/component/input_form_field.dart';
import 'package:epkk_nganjuk/features/pages/pokja4/kesehatan/kesehatan_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class KesehatanScreen
    extends StatefulWidget {
  const KesehatanScreen({
    super.key,
  });

  @override
  State<KesehatanScreen>
  createState() =>
      _KesehatanScreenState();
}

class _KesehatanScreenState
    extends State<KesehatanScreen> {
  String? idUser;
  String? idRole;
  String? idOrganization;
  String? fullName;
  String? nameRole;
  String? nameOrganization;

  final posyanduJumlahController =
      TextEditingController();

  final posyanduTintegrasiController =
      TextEditingController();

  final lansiaKlpController =
      TextEditingController();

  final lansiaAnggotaController =
      TextEditingController();

  final lansiaKartuController =
      TextEditingController();

  final _formKey =
      GlobalKey<FormState>();

  final KesehatanController
  uploadReportController =
      Get.put(
        KesehatanController(),
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
    posyanduJumlahController
        .dispose();

    posyanduTintegrasiController
        .dispose();

    lansiaKlpController.dispose();

    lansiaAnggotaController
        .dispose();

    lansiaKartuController
        .dispose();

    super.dispose();
  }

  void clearForm() {
    posyanduJumlahController
        .clear();

    posyanduTintegrasiController
        .clear();

    lansiaKlpController.clear();

    lansiaAnggotaController
        .clear();

    lansiaKartuController
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
        title: 'Kesehatan',
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
                              height: 16.h),

                          /// POSYANDU
                          TypographyStyles
                              .bodyCaptionSemiBold(
                                'Posyandu',

                                color:
                                    TextColors
                                        .grey900,
                              ),

                          SizedBox(
                              height: 12.h),

                          buildInput(
                            controller:
                                posyanduJumlahController,

                            label:
                                'Jumlah Posyandu',
                          ),

                          buildInput(
                            controller:
                                posyanduTintegrasiController,

                            label:
                                'Posyandu Terintegrasi',
                          ),

                          SizedBox(
                              height: 8.h),

                          /// LANSIA
                          TypographyStyles
                              .bodyCaptionSemiBold(
                                'Lansia',

                                color:
                                    TextColors
                                        .grey900,
                              ),

                          SizedBox(
                              height: 12.h),

                          buildInput(
                            controller:
                                lansiaKlpController,

                            label:
                                'Jumlah KLP',
                          ),

                          buildInput(
                            controller:
                                lansiaAnggotaController,

                            label:
                                'Jumlah Anggota',
                          ),

                          buildInput(
                            controller:
                                lansiaKartuController,

                            label:
                                'Jumlah yang Memiliki Kartu Berobat Gratis',

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
                                                .submitKesehatanData(
                                                  idUser:
                                                      idUser ??
                                                          '',

                                                  jumlahPosyandu:
                                                      posyanduJumlahController
                                                          .text,

                                                  jumlahPosyanduIterasi:
                                                      posyanduTintegrasiController
                                                          .text,

                                                  jumlahKip:
                                                      lansiaKlpController
                                                          .text,

                                                  jumlahAnggota:
                                                      lansiaAnggotaController
                                                          .text,

                                                  jumlahKartuGratis:
                                                      lansiaKartuController
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