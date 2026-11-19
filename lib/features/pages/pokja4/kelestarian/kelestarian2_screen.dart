import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/common/typography.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:epkk_nganjuk/features/auth/component/custome_appbar.dart';
import 'package:epkk_nganjuk/features/auth/component/input_form_field.dart';
import 'package:epkk_nganjuk/features/pages/pokja4/kelestarian/kelestarian_controller.dart';
import 'package:epkk_nganjuk/routes/app_routes.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class KelestarianLingkungan2Screen extends StatefulWidget {
  const KelestarianLingkungan2Screen({super.key});

  @override
  State<KelestarianLingkungan2Screen> createState() =>
      _KelestarianLingkungan2ScreenState();
}

class _KelestarianLingkungan2ScreenState
    extends State<KelestarianLingkungan2Screen> {
  String? idUser;
  String? idRole;
  String? idOrganization;
  String? fullName;
  String? nameRole;
  String? nameOrganization;

  String? jamban;
  String? spal;
  String? tps;
  String? mck;

  final pdamController = TextEditingController();

  final sumurController = TextEditingController();

  final lainnyaController = TextEditingController();

  final catatanController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final KelestarianController uploadController = Get.put(
    KelestarianController(),
  );

  @override
  void initState() {
    super.initState();

    final args = Get.arguments;

    idUser = args['id_user'];

    fullName = args['full_name'];

    idRole = args['id_role'];

    nameRole = args['name_role'];

    idOrganization = args['id_organization'];

    nameOrganization = args['name_organization'];

    jamban = args['jamban'];

    spal = args['spal'];

    tps = args['tps'];

    mck = args['mck'];

    debugPrint(
      'Diterima dari argument: '
      'id_user=$idUser, '
      'id_role=$idRole, '
      'id_org=$idOrganization',
    );
  }

  @override
  void dispose() {
    pdamController.dispose();

    sumurController.dispose();

    lainnyaController.dispose();

    catatanController.dispose();

    super.dispose();
  }

  void clearForm() {
    pdamController.clear();

    sumurController.clear();

    lainnyaController.clear();

    catatanController.clear();
  }

  Widget buildInput({
    required TextEditingController controller,

    required String label,

    TextInputAction action = TextInputAction.next,

    String hintText = 'Masukkan jumlah',

    bool isOptional = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),

      child: InputFormField(
        controller: controller,

        hintText: hintText,

        label: label,

        keyboardType: isOptional
            ? TextInputType.multiline
            : TextInputType.number,

        minLines: isOptional ? 3 : 1,

        maxLines: isOptional ? 5 : 1,

        textInputAction: action,
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

      appBar: AppBarSecondary(
        title: 'Kelestarian Lingkungan Hidup',

        currentStep: 2,

        totalSteps: 3,
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
                      maxWidth: isTablet ? 600 : double.infinity,

                      minHeight: constraints.maxHeight,
                    ),

                    child: Form(
                      key: _formKey,

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          SizedBox(height: 32.h),

                          TypographyStyles.bodyCaptionSemiBold(
                            'Jumlah KRT yang Menggunakan Air',

                            color: TextColors.grey900,
                          ),

                          SizedBox(height: 12.h),

                          /// PDAM
                          buildInput(controller: pdamController, label: 'PDAM'),

                          /// SUMUR
                          buildInput(
                            controller: sumurController,

                            label: 'Sumur',
                          ),

                          /// DLL
                          buildInput(
                            controller: lainnyaController,

                            label: 'Lain-lain',
                          ),

                          SizedBox(height: 4.h),

                          TypographyStyles.bodyCaptionSemiBold(
                            'Catatan Tambahan (Opsional)',

                            color: TextColors.grey900,
                          ),

                          SizedBox(height: 12.h),

                          /// CATATAN
                          buildInput(
                            controller: catatanController,

                            label: 'Catatan',

                            hintText: 'Tulis catatan jika ada',

                            isOptional: true,

                            action: TextInputAction.newline,
                          ),

                          SizedBox(height: 10.h),

                          /// BUTTON
                          ZoomTapAnimation(
                            child: Obx(
                              () => ButtonFill(
                                text: 'Lanjut',

                                textColor: Colors.white,

                                isLoading: uploadController.isLoading.value,

                                onPressed: uploadController.isLoading.value
                                    ? null
                                    : () {
                                        if (_formKey.currentState!.validate()) {
                                          Get.toNamed(
                                            Routes.KELESTARIAN3,

                                            arguments: {
                                              'id_user': idUser,

                                              'full_name': fullName,

                                              'id_role': idRole,

                                              'name_role': nameRole,

                                              'id_organization': idOrganization,

                                              'name_organization':
                                                  nameOrganization,

                                              'jamban': jamban,

                                              'spal': spal,

                                              'tps': tps,

                                              'mck': mck,

                                              'pdam': pdamController.text,

                                              'sumur': sumurController.text,

                                              'dll': lainnyaController.text,

                                              'catatan': catatanController.text,
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
