import 'package:epkk_nganjuk/common/appbar/custom_appbar.dart';
import 'package:epkk_nganjuk/core/validators/validator_form.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:epkk_nganjuk/features/auth/component/input_form_field.dart';
import 'package:epkk_nganjuk/features/pages/pokja1/kaderpokja1/kader_pokja1_controller.dart';
import 'package:epkk_nganjuk/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class KaderPokja1Screen extends StatefulWidget {
  const KaderPokja1Screen({super.key});

  @override
  State<KaderPokja1Screen> createState() => _KaderPokja1ScreenState();
}

class _KaderPokja1ScreenState extends State<KaderPokja1Screen> {
  String id_user = '';
  String id_role = '';
  String id_organization = '';
  String full_name = '';
  String name_role = '';
  String name_organization = '';

  final pkbnController = TextEditingController();
  final pkdrtController = TextEditingController();
  final polaController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final UploadReportController uploadReportController = Get.put(
    UploadReportController(),
  );

  @override
  void initState() {
    super.initState();

    final args = Get.arguments ?? {};

    id_user = args['id_user'] ?? '';
    full_name = args['full_name'] ?? '';
    id_role = args['id_role'] ?? '';
    name_role = args['name_role'] ?? '';
    id_organization = args['id_organization'] ?? '';
    name_organization = args['name_organization'] ?? '';
  }

  void clearForm() {
    pkbnController.clear();
    pkdrtController.clear();
    polaController.clear();
  }

  @override
  void dispose() {
    pkbnController.dispose();
    pkdrtController.dispose();
    polaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,

      appBar: AppBarSecondary(
        title: 'Kader Pokja I',

        onBack: () {
          if (pkbnController.text.isEmpty &&
              pkdrtController.text.isEmpty &&
              polaController.text.isEmpty) {
            Get.back();
          } else {
            Get.defaultDialog(
              title: "Batal Upload?",
              middleText: "Data yang sudah diisi akan hilang",
              textConfirm: "Ya",
              textCancel: "Tidak",

              onConfirm: () {
                clearForm();

                Get.back();
                Get.back();
              },
            );
          }
        },
      ),

      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),

          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.manual,

                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),

                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),

                  child: Form(
                    key: _formKey,

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        SizedBox(height: 12.h),

                        /// PKBN
                        InputFormField(
                          controller: pkbnController,

                          keyboardType: TextInputType.number,

                          hintText: 'Masukkan jumlah',

                          label: 'PKBN',

                          validator: (value) =>
                              ValidatorForm.validateNumber(value),
                        ),

                        SizedBox(height: 24.h),

                        /// PKDRT
                        InputFormField(
                          controller: pkdrtController,

                          keyboardType: TextInputType.number,

                          hintText: 'Masukkan jumlah',

                          label: 'PKDRT',

                          validator: (value) =>
                              ValidatorForm.validateNumber(value),
                        ),

                        SizedBox(height: 24.h),

                        /// POLA ASUH
                        InputFormField(
                          controller: polaController,

                          keyboardType: TextInputType.number,

                          hintText: 'Masukkan jumlah',

                          label: 'Pola Asuh',

                          validator: (value) =>
                              ValidatorForm.validateNumber(value),
                        ),

                        SizedBox(height: 40.h),

                        /// BUTTON
                        SizedBox(
                          width: double.infinity,

                          child: ZoomTapAnimation(
                            child: Obx(
                              () => ButtonFill(
                                text:
                                    uploadReportController
                                        .isCreateKaderPokja1
                                        .value
                                    ? 'Loading'
                                    : 'Kirim',

                                textColor: Colors.white,

                                onPressed:
                                    uploadReportController
                                        .isCreateKaderPokja1
                                        .value
                                    ? null
                                    : () async {
                                        if (!_formKey.currentState!
                                            .validate()) {
                                          return;
                                        }

                                        await uploadReportController
                                            .createKaderPokja1Controller(
                                              PKBN: pkbnController.text,
                                              PKDRT: pkdrtController.text,
                                              pola_asuh: polaController.text,
                                              id_role: id_role,
                                              id_organization: id_organization,
                                              id_user: id_user,
                                            );

                                        final res = uploadReportController
                                            .reportKaderPokja1Model
                                            .value;

                                        if (res != null &&
                                            res.statusCode == 200) {
                                          _formKey.currentState?.reset();

                                          clearForm();

                                          Get.offAllNamed(Routes.MAIN);
                                        }
                                      },
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 20.h),
                      ],
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
