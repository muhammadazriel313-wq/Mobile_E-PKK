import 'package:epkk_nganjuk/common/appbar/custom_appbar.dart';
import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/common/typography.dart';
import 'package:epkk_nganjuk/core/validators/validator_form.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:epkk_nganjuk/features/auth/component/input_form_field.dart';
import 'package:epkk_nganjuk/features/laporan/laporan_umum/laporan_umum_controller.dart';
import 'package:epkk_nganjuk/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class LaporanUmum1Screen extends StatefulWidget {
  const LaporanUmum1Screen({super.key});

  @override
  State<LaporanUmum1Screen> createState() =>
      _LaporanUmum1ScreenState();
}

class _LaporanUmum1ScreenState
    extends State<LaporanUmum1Screen> {
  // ================= USER DATA =================

  String? idUser;
  String? idRole;
  String? idOrganization;

  String? fullName;
  String? nameRole;
  String? nameOrganization;

  // ================= FORM CONTROLLER =================

  final dusunController =
      TextEditingController();

  final pkkRwController =
      TextEditingController();

  final pkkRtController =
      TextEditingController();

  final desaWismaController =
      TextEditingController();

  final krtController =
      TextEditingController();

  final kkController =
      TextEditingController();

  // ================= FORM KEY =================

  final _formKey =
      GlobalKey<FormState>();

  // ================= GETX CONTROLLER =================

  final controller = Get.put(
    LaporanUmumController(),
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

    print(
      'id_user=$idUser, id_role=$idRole',
    );
  }

  @override
  void dispose() {
    dusunController.dispose();

    pkkRwController.dispose();

    pkkRtController.dispose();

    desaWismaController.dispose();

    krtController.dispose();

    kkController.dispose();

    super.dispose();
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

      // ================= APPBAR =================

      appBar: AppBarSecondary(
        title: 'Laporan Umum',

        currentStep: 1,

        totalSteps: 4,
      ),

      // ================= BODY =================

      body: SafeArea(
        child: GestureDetector(
          onTap:
              () => FocusScope.of(
                context,
              ).unfocus(),

          child: LayoutBuilder(
            builder: (
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
                      media.viewInsets.bottom +
                      20.h,
                ),

                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth:
                          isTablet
                              ? 650
                              : double.infinity,

                      minHeight:
                          constraints.maxHeight,
                    ),

                    child: Form(
                      key: _formKey,

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [
                          // ================= TITLE =================

                          TypographyStyles
                              .bodyCaptionBold(
                            'Jumlah Kelompok',

                            color:
                                TextColors
                                    .grey700,
                          ),

                          SizedBox(
                            height: 24.h,
                          ),

                          // ================= DUSUN =================

                          _inputField(
                            controller:
                                dusunController,

                            label:
                                'Dusun/Lingkungan',
                          ),

                          _space(),

                          // ================= PKK RW =================

                          _inputField(
                            controller:
                                pkkRwController,

                            label:
                                'PKK RW',
                          ),

                          _space(),

                          // ================= PKK RT =================

                          _inputField(
                            controller:
                                pkkRtController,

                            label:
                                'PKK RT',
                          ),

                          _space(),

                          // ================= DESA WISMA =================

                          _inputField(
                            controller:
                                desaWismaController,

                            label:
                                'Desa Wisma',
                          ),

                          SizedBox(
                            height: 40.h,
                          ),

                          // ================= TITLE =================

                          TypographyStyles
                              .bodyCaptionBold(
                            'Jumlah',

                            color:
                                TextColors
                                    .grey700,
                          ),

                          SizedBox(
                            height: 24.h,
                          ),

                          // ================= KRT =================

                          _inputField(
                            controller:
                                krtController,

                            label: 'KRT',
                          ),

                          _space(),

                          // ================= KK =================

                          _inputField(
                            controller:
                                kkController,

                            label: 'KK',
                          ),

                          SizedBox(
                            height: 30.h,
                          ),

                          // ================= BUTTON =================

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
                                            Get.toNamed(
                                              Routes
                                                  .LAPORAN_UMUM2,

                                              arguments: {
                                                'id_user':
                                                    idUser,

                                                'full_name':
                                                    fullName,

                                                'id_role':
                                                    idRole,

                                                'name_role':
                                                    nameRole,

                                                'id_organization':
                                                    idOrganization,

                                                'name_organization':
                                                    nameOrganization,

                                                'dusun_lingkungan':
                                                    dusunController
                                                        .text,

                                                'PKK_RW':
                                                    pkkRwController
                                                        .text,

                                                'PKK_RT':
                                                    pkkRtController
                                                        .text,

                                                'desa_wisma':
                                                    desaWismaController
                                                        .text,

                                                'KRT':
                                                    krtController
                                                        .text,

                                                'KK':
                                                    kkController
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
                            height: 20.h,
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

  // ================= INPUT FIELD =================

  Widget _inputField({
    required TextEditingController
    controller,

    required String label,
  }) {
    return InputFormField(
      controller: controller,

      hintText: 'Masukkan jumlah',

      label: label,

      keyboardType:
          TextInputType.number,

      textInputAction:
          TextInputAction.next,

      validator: (value) {
        return ValidatorForm
            .validateDefault(value);
      },
    );
  }

  // ================= SPACE =================

  Widget _space() =>
      SizedBox(height: 24.h);
}