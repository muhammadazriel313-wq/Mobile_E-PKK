import 'package:epkk_nganjuk/core/validators/validator_form.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';

import 'package:epkk_nganjuk/common/appbar/custom_appbar.dart';

import 'package:epkk_nganjuk/features/auth/component/input_form_field.dart';
import 'package:epkk_nganjuk/features/pages/pokja3/jumlah_kader/kader_pokja3_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class KaderPokja3Screen extends StatefulWidget {
  const KaderPokja3Screen({super.key});

  @override
  State<KaderPokja3Screen> createState() => _KaderPokja3ScreenState();
}

class _KaderPokja3ScreenState extends State<KaderPokja3Screen> {
  final panganController = TextEditingController();

  final sandangController = TextEditingController();

  final tataController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final controller = Get.put(KaderPokja3Controller());

  void clearForm() {
    panganController.clear();

    sandangController.clear();

    tataController.clear();
  }

  @override
  void dispose() {
    panganController.dispose();

    sandangController.dispose();

    tataController.dispose();

    super.dispose();
  }

  Widget inputField({
    required TextEditingController controller,

    required String label,
  }) {
    return Column(
      children: [
        InputFormField(
          controller: controller,

          hintText: 'Masukkan jumlah',

          label: label,

          keyboardType: TextInputType.number,

          validator: ValidatorForm.validateDefault,
        ),

        SizedBox(height: 24.h),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    final isTablet = media.size.width >= 600;

    return Scaffold(
      resizeToAvoidBottomInset: true,

      backgroundColor: Colors.white,

      /// APPBAR
      appBar: AppBarSecondary(
        title: 'Kader Pokja III',

        onBack: () => Get.back(),
      ),

      /// BODY
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
                      maxWidth: isTablet ? 600 : double.infinity,

                      minHeight: constraints.maxHeight,
                    ),

                    child: Form(
                      key: _formKey,

                      child: Column(
                        children: [
                          SizedBox(height: 12.h),

                          /// PANGAN
                          inputField(
                            controller: panganController,

                            label: 'Pangan',
                          ),

                          /// SANDANG
                          inputField(
                            controller: sandangController,

                            label: 'Sandang',
                          ),

                          /// TATA LAKSANA
                          inputField(
                            controller: tataController,

                            label: 'Tata Laksana Rumah Tangga',
                          ),

                          SizedBox(height: 10.h),

                          /// BUTTON
                          ZoomTapAnimation(
                            child: Obx(
                              () => ButtonFill(
                                text: controller.isLoading.value
                                    ? 'Loading'
                                    : 'Kirim',

                                textColor: Colors.white,

                                onPressed: controller.isLoading.value
                                    ? null
                                    : () async {
                                        final isValid = _formKey.currentState!
                                            .validate();

                                        if (!isValid) {
                                          Get.snackbar(
                                            'Error',

                                            'Form tidak valid!',

                                            snackPosition: SnackPosition.TOP,

                                            backgroundColor: Colors.orange,

                                            colorText: Colors.white,
                                          );

                                          return;
                                        }

                                        /// SIMPAN
                                        controller.setField(
                                          pangan: panganController.text,

                                          sandang: sandangController.text,

                                          tataLaksanaRumah: tataController.text,
                                        );

                                        /// SUBMIT
                                        final success = await controller
                                            .submit();

                                        if (success) {
                                          Get.offAllNamed('/main');
                                        }
                                      },
                              ),
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
}
