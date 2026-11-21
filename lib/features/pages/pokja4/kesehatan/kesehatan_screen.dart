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

class KesehatanScreen extends StatefulWidget {
  const KesehatanScreen({super.key});

  @override
  State<KesehatanScreen> createState() => _KesehatanScreenState();
}

class _KesehatanScreenState extends State<KesehatanScreen> {
  String? idUser;
  String? idRole;
  String? idOrganization;
  String? fullName;
  String? nameRole;
  String? nameOrganization;

  // Controllers Kolom Kesehatan (Lampiran 4.24, Kolom 3 - 11)
  final kaderKesehatanController = TextEditingController();
  final kaderGiziController = TextEditingController();
  final kaderKeslingController = TextEditingController();
  final kaderPhbsController = TextEditingController();
  final kaderKbController = TextEditingController();
  final posyanduController = TextEditingController();
  final imunisasiController = TextEditingController();
  final pkgController = TextEditingController();
  final tbcController = TextEditingController();
  final catatanController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final KesehatanController uploadReportController = Get.put(
    KesehatanController(),
  );

  @override
  void initState() {
    super.initState();

    final args = Get.arguments;
    if (args != null) {
      idUser = args['id_user']?.toString();
      fullName = args['full_name']?.toString();
      idRole = args['id_role']?.toString();
      nameRole = args['name_role']?.toString();
      idOrganization = args['id_organization']?.toString();
      nameOrganization = args['name_organization']?.toString();
    }
  }

  @override
  void dispose() {
    kaderKesehatanController.dispose();
    kaderGiziController.dispose();
    kaderKeslingController.dispose();
    kaderPhbsController.dispose();
    kaderKbController.dispose();
    posyanduController.dispose();
    imunisasiController.dispose();
    pkgController.dispose();
    tbcController.dispose();
    catatanController.dispose();
    super.dispose();
  }

  void clearForm() {
    kaderKesehatanController.clear();
    kaderGiziController.clear();
    kaderKeslingController.clear();
    kaderPhbsController.clear();
    kaderKbController.clear();
    posyanduController.clear();
    imunisasiController.clear();
    pkgController.clear();
    tbcController.clear();
    catatanController.clear();
  }

  Widget buildInput({
    required TextEditingController controller,
    required String label,
    String hintText = 'Masukkan jumlah',
    TextInputAction action = TextInputAction.next,
    bool isOptional = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: InputFormField(
        controller: controller,
        hintText: hintText,
        label: label,
        keyboardType: isOptional ? TextInputType.text : TextInputType.number,
        textInputAction: action,
        validator: isOptional
            ? null
            : (value) => ValidatorForm.validateDefault(value),
      ),
    );
  }

  Widget buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h, bottom: 12.h),
      child: Row(
        children: [
          Container(
            width: 4.w,
            height: 18.h,
            decoration: BoxDecoration(
              color: BrandColors.brandPrimary500,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(width: 8.w),
          TypographyStyles.bodyCaptionSemiBold(
            title,
            color: TextColors.grey900,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final isTablet = media.size.width >= 600;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBarSecondary(title: 'Kesehatan (Pokja IV)'),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.manual,
                padding: EdgeInsets.only(
                  left: isTablet ? 40.w : 16.w,
                  right: isTablet ? 40.w : 16.w,
                  top: 16.h,
                  bottom: media.viewInsets.bottom + 24.h,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isTablet ? 600 : double.infinity,
                      minHeight: constraints.maxHeight,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// JUMLAH KADER (KOLOM 3-7)
                          buildSectionHeader('Jumlah Kader'),

                          buildInput(
                            controller: kaderKesehatanController,
                            label: 'Kader Kesehatan',
                          ),
                          buildInput(
                            controller: kaderGiziController,
                            label: 'Gizi',
                          ),
                          buildInput(
                            controller: kaderKeslingController,
                            label: 'Kesling',
                          ),
                          buildInput(
                            controller: kaderPhbsController,
                            label: 'PHBS',
                          ),
                          buildInput(
                            controller: kaderKbController,
                            label: 'KB',
                          ),

                          /// POSYANDU & LAYANAN KESEHATAN (KOLOM 8-11)
                          buildSectionHeader(
                            'Posyandu, Imunisasi, PKG dan TBC',
                          ),

                          buildInput(
                            controller: posyanduController,
                            label: 'Posyandu',
                            hintText: 'Jumlah total posyandu',
                          ),
                          buildInput(
                            controller: imunisasiController,
                            label: 'Imunisasi / Vaksinasi Bayi / Balita',
                          ),
                          buildInput(
                            controller: pkgController,
                            label: 'PKG',
                            hintText: 'Pemeriksaan Kesehatan Gratis',
                          ),
                          buildInput(
                            controller: tbcController,
                            label: 'TBC',
                            hintText: 'Jumlah penderita TBC',
                          ),

                          /// CATATAN OPSIONAL
                          buildSectionHeader('Catatan Tambahan (Opsional)'),
                          buildInput(
                            controller: catatanController,
                            label: 'Catatan',
                            hintText: 'Tulis catatan jika ada',
                            action: TextInputAction.done,
                            isOptional: true,
                          ),

                          SizedBox(height: 12.h),

                          /// SUBMIT BUTTON
                          ZoomTapAnimation(
                            child: Obx(
                              () => ButtonFill(
                                text: uploadReportController.isLoading.value
                                    ? 'Mengirim Data...'
                                    : 'Kirim Laporan',
                                textColor: Colors.white,
                                onPressed:
                                    uploadReportController.isLoading.value
                                    ? null
                                    : () async {
                                        final isFormValid = _formKey
                                            .currentState!
                                            .validate();

                                        if (!isFormValid) {
                                          Get.snackbar(
                                            'Peringatan',
                                            'Form belum lengkap! Silakan periksa kolom isian.',
                                            snackPosition: SnackPosition.TOP,
                                            backgroundColor: Colors.orange,
                                            colorText: Colors.white,
                                          );
                                          return;
                                        }

                                        await uploadReportController
                                            .submitKesehatanData(
                                              idUser: idUser ?? '',
                                              kaderKesehatan:
                                                  kaderKesehatanController.text,
                                              kaderGizi:
                                                  kaderGiziController.text,
                                              kaderKesling:
                                                  kaderKeslingController.text,
                                              kaderPhbs:
                                                  kaderPhbsController.text,
                                              kaderKb: kaderKbController.text,
                                              posyandu: posyanduController.text,
                                              imunisasiVaksinasi:
                                                  imunisasiController.text,
                                              pkg: pkgController.text,
                                              tbc: tbcController.text,
                                              idRole: idRole ?? '',
                                              idOrganization:
                                                  idOrganization ?? '',
                                              catatan: catatanController.text,
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
                                          _formKey.currentState?.reset();
                                          clearForm();
                                          Get.offAllNamed('/main');
                                        }
                                      },
                              ),
                            ),
                          ),

                          SizedBox(height: 24.h),
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
