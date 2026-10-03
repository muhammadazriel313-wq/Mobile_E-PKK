import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/common/typography.dart';
import 'package:epkk_nganjuk/features/auth/auth_controller.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:epkk_nganjuk/features/auth/component/drop_down.dart';
import 'package:epkk_nganjuk/features/auth/component/header_text.dart';
import 'package:epkk_nganjuk/features/auth/component/icon_button_back.dart';
import 'package:epkk_nganjuk/features/register/pick_role_controller.dart';
import 'package:epkk_nganjuk/features/register/role/dropdown_model.dart';
import 'package:epkk_nganjuk/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class PickRoleScreen extends StatelessWidget {
  PickRoleScreen({super.key});

  final PickRoleController pickRoleController =
      Get.put(PickRoleController());

  final AuthController authController =
      Get.find<AuthController>();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? {};

    final role_id = args['role_id'] ?? '';
    final role_name = args['role_name'] ?? '';
    final full_name = args['full_name'] ?? '';
    final phone_number = args['phone_number'] ?? '';
    final password = args['password'] ?? '';

    final screenHeight =
        MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 10.h,
          ),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                /// BACK
                IconButtonBack(
                  onTab: () {
                    Get.toNamed(
                      Routes.REGISTER,

                      arguments: {
                        'roleID': role_id,
                        'roleName': role_name,
                      },
                    );
                  },
                ),

                SizedBox(height: screenHeight * 0.03),

                /// HEADER
                HeaderText(
                  firstText:
                      'Pilih Wilayah & Posisi',

                  bodyText:
                      'Anda dapat memasukkan nama kecamatan, nama desa dan role bidang sesuai dengan posisi Anda sekarang.',
                ),

                SizedBox(height: 30.h),

                /// KECAMATAN
                TypographyStyles.bodyCaptionMedium(
                  'Kecamatan',
                  color: TextColors.grey700,
                ),

                SizedBox(height: 14.h),

                DropdownComponent(
                  randomlabel: 'Pilih Kecamatan',

                  errorKosong:
                      'Harap pilih kecamatan anda',

                  listItem: kecamatanList
                      .map((k) => k.name)
                      .toList(),

                  hintText: 'Pilih kecamatan',

                  svgIconPath:
                      'assets/icons/ic_location.svg',

                  onChanged: (selectedKecamatan) {
                    pickRoleController
                        .updateKecamatan(
                          selectedKecamatan,
                        );
                  },
                ),

                SizedBox(height: 20.h),

                /// DESA
                TypographyStyles.bodyCaptionMedium(
                  'Desa',
                  color: TextColors.grey700,
                ),

                SizedBox(height: 14.h),

                Obx(
                  () => DropdownComponent(
                    randomlabel: 'Pilih Desa',

                    errorKosong:
                        'Harap pilih desa anda',

                    listItem:
                        pickRoleController.desaList,

                    hintText: 'Pilih desa',

                    svgIconPath:
                        'assets/icons/ic_location.svg',

                    selectedValue:
                        pickRoleController.desaList
                                .contains(
                                  pickRoleController
                                      .selectedDesa
                                      .value,
                                )
                            ? pickRoleController
                                  .selectedDesa
                                  .value
                            : null,

                    onChanged: (selectedDesa) {
                      pickRoleController
                          .updateDesa(
                            selectedDesa,
                          );
                    },
                  ),
                ),

                SizedBox(height: 20.h),

                /// ROLE BIDANG
                TypographyStyles.bodyCaptionMedium(
                  'Role bidang',
                  color: TextColors.grey700,
                ),

                SizedBox(height: 14.h),

                DropdownComponent(
                  maxHeight: 200.h,

                  randomlabel: 'Pilih Role',

                  errorKosong:
                      'Harap pilih role anda',

                  listItem:
                      pickRoleController.roleBidang,

                  hintText: 'Pilih role bidang',

                  svgIconPath:
                      'assets/icons/ic_user_tag.svg',

                  onChanged: (selectedRole) {
                    pickRoleController
                        .updateSelectedRole(
                          selectedRole,
                        );
                  },
                ),

                SizedBox(height: 40.h),

                /// BUTTON
                ZoomTapAnimation(
                  child: ButtonFill(
                    text: 'Lanjut',
                    textColor: Colors.white,

                    onPressed: () async {
                      if (_formKey.currentState!
                          .validate()) {
                        try {
                          authController
                        // Bypass OTP: generate kode dulu
                              .generateRandomNumber();
                        // Coba kirim OTP, tapi tidak blokir flow jika gagal (mode bypass)
                        try {
                          await authController
                              .sendOtpViaWhatsApp(
                                phone_number,
                                authController.generatedOtp,
                              );
                        } catch (_) {
                          // Abaikan error pengiriman OTP (mode bypass aktif)
                          // Kode OTP bypass = 1234, masukkan di halaman verifikasi
                        }

                          Get.toNamed(
                            Routes.VERIFICATION,

                            arguments: {
                              'role_id': role_id,

                              'role_name':
                                  role_name,

                              'full_name':
                                  full_name,

                              'phone_number':
                                  phone_number,

                              'password':
                                  password,

                              'id_subdistrict':
                                  pickRoleController
                                      .kecamatanSelected
                                      .value,

                              'id_village':
                                  pickRoleController
                                      .selectedDesa
                                      .value,

                              'organization_name':
                                  pickRoleController
                                      .selectedRoleBidang
                                      .value,

                              'id_organization':
                                  pickRoleController
                                      .selectedRoleBidangID
                                      .value,

                              'kode_otp':
                                  authController
                                      .generatedOtp,
                            },
                          );
                        } catch (e) {
                          Get.snackbar(
                            'Error',

                            'Kode OTP bypass = 1234',

                            snackPosition:
                                SnackPosition.TOP,

                            backgroundColor:
                                Colors.red.shade50,

                            colorText:
                                Colors.red.shade800,
                          );
                        }
                      }
                    },
                  ),
                ),

                SizedBox(height: 25.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}