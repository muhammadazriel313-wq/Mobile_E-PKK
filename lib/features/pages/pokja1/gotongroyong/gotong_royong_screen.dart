import 'package:epkk_nganjuk/common/appbar/custom_appbar.dart';
import 'package:epkk_nganjuk/core/validators/validator_form.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:epkk_nganjuk/features/auth/component/input_form_field.dart';
import 'package:epkk_nganjuk/features/pages/pokja1/gotongroyong/gotong_royong_controller.dart';
import 'package:epkk_nganjuk/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class GotongRoyongScreen extends StatefulWidget {
  const GotongRoyongScreen({super.key});

  @override
  State<GotongRoyongScreen> createState() => _GotongRoyongScreenState();
}

class _GotongRoyongScreenState extends State<GotongRoyongScreen> {
  String? id_user;
  String? id_role;
  String? id_organization;

  final kerjabaktiController = TextEditingController();

  final rukunkematianController = TextEditingController();

  final keagamaanController = TextEditingController();

  final jimpitanController = TextEditingController();

  final arisanController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final GotongRoyongController controller = Get.put(GotongRoyongController());

  void clearForm() {
    kerjabaktiController.clear();
    rukunkematianController.clear();
    keagamaanController.clear();
    jimpitanController.clear();
    arisanController.clear();
  }

  bool isFormEmpty() {
    return kerjabaktiController.text.isEmpty &&
        rukunkematianController.text.isEmpty &&
        keagamaanController.text.isEmpty &&
        jimpitanController.text.isEmpty &&
        arisanController.text.isEmpty;
  }

  @override
  void initState() {
    super.initState();

    final args = Get.arguments ?? {};

    id_user = args['id_user'];

    id_role = args['id_role'];

    id_organization = args['id_organization'];
  }

  @override
  void dispose() {
    kerjabaktiController.dispose();
    rukunkematianController.dispose();
    keagamaanController.dispose();
    jimpitanController.dispose();
    arisanController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,

      /// APPBAR
      appBar: AppBarSecondary(
        title: 'Gotong Royong',

        onBack: () {
          if (isFormEmpty()) {
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

      /// BODY
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,

              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),

              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),

                child: Form(
                  key: _formKey,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      /// INPUT
                      _input(kerjabaktiController, 'Kerja Bakti'),

                      _input(rukunkematianController, 'Rukun Kematian'),

                      _input(keagamaanController, 'Keagamaan'),

                      _input(jimpitanController, 'Jimpitan'),

                      _input(arisanController, 'Arisan'),

                      SizedBox(height: 24.h),

                      /// BUTTON
                      ZoomTapAnimation(
                        child: Obx(
                          () => ButtonFill(
                            text: controller.isLoading.value
                                ? 'Loading...'
                                : 'Kirim',

                            textColor: Colors.white,

                            onPressed: controller.isLoading.value
                                ? null
                                : () async {
                                    if (!_formKey.currentState!.validate()) {
                                      return;
                                    }

                                    bool success = await controller
                                        .submitGotongRoyong(
                                          idUser: id_user!,

                                          kerjaBakti: kerjabaktiController.text,

                                          rukunKematian:
                                              rukunkematianController.text,

                                          keagamaan: keagamaanController.text,

                                          jimpitan: jimpitanController.text,

                                          arisan: arisanController.text,

                                          idRole: id_role!,

                                          idOrganization: id_organization!,
                                        );

                                    if (success) {
                                      _formKey.currentState?.reset();

                                      clearForm();

                                      Get.offAllNamed(Routes.MAIN);
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
            );
          },
        ),
      ),
    );
  }

  /// REUSABLE INPUT
  Widget _input(TextEditingController controller, String label) {
    return Column(
      children: [
        InputFormField(
          controller: controller,

          hintText: 'Masukkan jumlah',

          label: label,

          keyboardType: TextInputType.number,

          validator: (value) => ValidatorForm.validateNumber(value),
        ),

        SizedBox(height: 24.h),
      ],
    );
  }
}
