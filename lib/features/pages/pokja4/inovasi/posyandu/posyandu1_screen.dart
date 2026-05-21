/// =======================================================
/// FILE : posyandu_1_screen.dart
/// =======================================================

import 'package:epkk_nganjuk/common/appbar/custom_appbar.dart';
import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/common/typography.dart';
import 'package:epkk_nganjuk/core/validators/validator_form.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:epkk_nganjuk/features/auth/component/input_form_field.dart';
import 'package:epkk_nganjuk/features/pages/pokja4/inovasi/component/dropdown_bulan.dart';
import 'package:epkk_nganjuk/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class Posyandu1Screen extends StatefulWidget {
  final String kategori;

  const Posyandu1Screen({super.key, required this.kategori});

  @override
  State<Posyandu1Screen> createState() => _Posyandu1ScreenState();
}

class _Posyandu1ScreenState extends State<Posyandu1Screen> {
  /// ======================
  /// BULAN
  /// ======================

  String? selectedBulan;

  /// ======================
  /// CONTROLLER
  /// ======================

  final jmlIbuHamilController = TextEditingController();

  final diperiksaController = TextEditingController();

  final feTabletDarahController = TextEditingController();

  final jmlIbuMenyusuiController = TextEditingController();

  /// ======================
  /// FORM
  /// ======================

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    jmlIbuHamilController.dispose();
    diperiksaController.dispose();
    feTabletDarahController.dispose();
    jmlIbuMenyusuiController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    final isTablet = media.size.width >= 600;

    return Scaffold(
      resizeToAvoidBottomInset: true,

      backgroundColor: Colors.white,

      appBar: AppBarSecondary(
        title: 'Posyandu',

        currentStep: 1,

        totalSteps: 5,

        onBack: () => Get.back(),
      ),

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

                  top: 20.h,

                  bottom: media.viewInsets.bottom + 20.h,
                ),

                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isTablet ? 650 : double.infinity,

                      minHeight: constraints.maxHeight,
                    ),

                    child: Form(
                      key: _formKey,

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          /// ======================
                          /// IBU HAMIL
                          /// ======================
                          TypographyStyles.bodyCaptionSemiBold(
                            'Ibu Hamil',

                            color: TextColors.grey900,
                          ),

                          SizedBox(height: 24.h),

                          /// ======================
                          /// DROPDOWN BULAN
                          /// ======================
                          DropdownBulan(
                            value: selectedBulan,

                            onChanged: (value) {
                              setState(() {
                                selectedBulan = value;
                              });
                            },
                          ),

                          /// ======================
                          /// VALIDASI BULAN
                          /// ======================
                          if (selectedBulan == null)
                            Padding(
                              padding: EdgeInsets.only(top: 8.h, left: 4.w),

                              child: Text(
                                'Bulan wajib dipilih',

                                style: TextStyle(
                                  fontSize: 12.sp,

                                  color: Colors.red,
                                ),
                              ),
                            ),

                          SizedBox(height: 20.h),

                          /// ======================
                          /// JUMLAH IBU HAMIL
                          /// ======================
                          _inputNumber(
                            controller: jmlIbuHamilController,

                            label: 'Jumlah Ibu Hamil',
                          ),

                          SizedBox(height: 20.h),

                          /// ======================
                          /// DIPERIKSA
                          /// ======================
                          _inputNumber(
                            controller: diperiksaController,

                            label: 'Diperiksa',
                          ),

                          SizedBox(height: 20.h),

                          /// ======================
                          /// FE TABLET DARAH
                          /// ======================
                          _inputNumber(
                            controller: feTabletDarahController,

                            label: 'FE Tablet Darah',
                          ),

                          SizedBox(height: 20.h),

                          /// ======================
                          /// IBU MENYUSUI
                          /// ======================
                          _inputNumber(
                            controller: jmlIbuMenyusuiController,

                            label: 'Jumlah Ibu Menyusui',
                          ),

                          SizedBox(height: 30.h),

                          /// ======================
                          /// BUTTON
                          /// ======================
                          ZoomTapAnimation(
                            child: ButtonFill(
                              text: 'Lanjut',

                              textColor: Colors.white,

                              onPressed: () {
                                /// ======================
                                /// VALIDASI BULAN
                                /// ======================

                                if (selectedBulan == null) {
                                  setState(() {});

                                  Get.snackbar(
                                    'Error',

                                    'Bulan wajib dipilih',

                                    snackPosition: SnackPosition.TOP,

                                    backgroundColor: Colors.red,

                                    colorText: Colors.white,
                                  );

                                  return;
                                }

                                /// ======================
                                /// VALIDASI FORM
                                /// ======================

                                if (_formKey.currentState!.validate()) {
                                  Get.toNamed(
                                    Routes.POSYANDU_2,

                                    arguments: {
                                      'kategori': widget.kategori,

                                      'bulan': selectedBulan,

                                      'jml_ibu_hamil':
                                          jmlIbuHamilController.text,

                                      'diperiksa': diperiksaController.text,

                                      'fe_tablet_darah':
                                          feTabletDarahController.text,

                                      'jml_ibu_menyusui':
                                          jmlIbuMenyusuiController.text,
                                    },
                                  );
                                } else {
                                  Get.snackbar(
                                    'Error',

                                    'Lengkapi Form',

                                    snackPosition: SnackPosition.TOP,

                                    backgroundColor: Colors.red,

                                    colorText: Colors.white,
                                  );
                                }
                              },
                            ),
                          ),

                          SizedBox(height: 20.h),
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

  /// ======================
  /// INPUT NUMBER
  /// ======================

  Widget _inputNumber({
    required TextEditingController controller,

    required String label,
  }) {
    return InputFormField(
      controller: controller,

      hintText: 'Masukkan jumlah',

      label: label,

      keyboardType: TextInputType.number,

      textInputAction: TextInputAction.next,

      validator: (value) {
        return ValidatorForm.validateNumber(value);
      },
    );
  }
}
