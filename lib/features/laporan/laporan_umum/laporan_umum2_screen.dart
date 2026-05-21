import 'package:epkk_nganjuk/common/appbar/custom_appbar.dart';
import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/common/typography.dart';
import 'package:epkk_nganjuk/core/validators/validator_form.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:epkk_nganjuk/features/auth/component/input_form_field.dart';
import 'package:epkk_nganjuk/features/laporan/laporan_umum/laporan_umum_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../../routes/app_routes.dart';

class LaporanUmum2Screen extends StatefulWidget {
  const LaporanUmum2Screen({super.key});

  @override
  State<LaporanUmum2Screen> createState() => _LaporanUmum2ScreenState();
}

class _LaporanUmum2ScreenState extends State<LaporanUmum2Screen> {
  // ================= DATA =================

  String id_user = '';
  String id_role = '';
  String id_organization = '';

  String full_name = '';
  String name_role = '';
  String name_organization = '';

  String dusun_lingkungan = '';

  String PKK_RW = '';
  String PKK_RT = '';

  String desa_wisma = '';

  String KRT = '';
  String KK = '';

  // ================= CONTROLLER =================

  final lakilaki1Controller = TextEditingController();

  final perempuan1Controller = TextEditingController();

  final lakilaki2Controller = TextEditingController();

  final perempuan2Controller = TextEditingController();

  final lakilaki3Controller = TextEditingController();

  final perempuan3Controller = TextEditingController();

  final lakilaki4Controller = TextEditingController();

  final perempuan4Controller = TextEditingController();

  // ================= FORM =================

  final _formKey = GlobalKey<FormState>();

  // ================= GETX =================

  final LaporanUmumController uploadController = Get.put(
    LaporanUmumController(),
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

    dusun_lingkungan = args['dusun_lingkungan'] ?? '';

    PKK_RW = args['PKK_RW'] ?? '';

    PKK_RT = args['PKK_RT'] ?? '';

    desa_wisma = args['desa_wisma'] ?? '';

    KRT = args['KRT'] ?? '';

    KK = args['KK'] ?? '';
  }

  @override
  void dispose() {
    lakilaki1Controller.dispose();

    perempuan1Controller.dispose();

    lakilaki2Controller.dispose();

    perempuan2Controller.dispose();

    lakilaki3Controller.dispose();

    perempuan3Controller.dispose();

    lakilaki4Controller.dispose();

    perempuan4Controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    final isTablet = media.size.width >= 600;

    return Scaffold(
      resizeToAvoidBottomInset: true,

      backgroundColor: Colors.white,

      // ================= APPBAR =================
      appBar: AppBarSecondary(
        title: 'Laporan Umum',

        currentStep: 2,

        totalSteps: 4,
      ),

      // ================= BODY =================
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
                          // ================= JUMLAH JIWA =================
                          _section('Jumlah Jiwa'),

                          _input(lakilaki1Controller, 'Laki-laki'),

                          _input(perempuan1Controller, 'Perempuan'),

                          // ================= KADER =================
                          _section('Jumlah Kader - Anggota TP PKK'),

                          _input(lakilaki2Controller, 'Laki-laki'),

                          _input(perempuan2Controller, 'Perempuan'),

                          // ================= UMUM =================
                          _section('Umum'),

                          _input(lakilaki3Controller, 'Laki-laki'),

                          _input(perempuan3Controller, 'Perempuan'),

                          // ================= KHUSUS =================
                          _section('Khusus'),

                          _input(lakilaki4Controller, 'Laki-laki'),

                          _input(perempuan4Controller, 'Perempuan'),

                          SizedBox(height: 30.h),

                          // ================= BUTTON =================
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
                                            Routes.LAPORAN_UMUM3,

                                            arguments: {
                                              // ================= USER =================
                                              'id_user': id_user,

                                              'full_name': full_name,

                                              'id_role': id_role,

                                              'name_role': name_role,

                                              'id_organization':
                                                  id_organization,

                                              'name_organization':
                                                  name_organization,

                                              // ================= DATA =================
                                              'dusun_lingkungan':
                                                  dusun_lingkungan,

                                              'PKK_RW': PKK_RW,

                                              'PKK_RT': PKK_RT,

                                              'desa_wisma': desa_wisma,

                                              'KRT': KRT,

                                              'KK': KK,

                                              // ================= JIWA =================
                                              'jiwa_laki':
                                                  lakilaki1Controller.text,

                                              'jiwa_perempuan':
                                                  perempuan1Controller.text,

                                              // ================= ANGGOTA =================
                                              'anggota_laki':
                                                  lakilaki2Controller.text,

                                              'anggota_perempuan':
                                                  perempuan2Controller.text,

                                              // ================= UMUM =================
                                              'umum_laki':
                                                  lakilaki3Controller.text,

                                              'umum_perempuan':
                                                  perempuan3Controller.text,

                                              // ================= KHUSUS =================
                                              'khusus_laki':
                                                  lakilaki4Controller.text,

                                              'khusus_perempuan':
                                                  perempuan4Controller.text,
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

  // ================= SECTION =================

  Widget _section(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        TypographyStyles.bodyCaptionBold(title, color: TextColors.grey700),

        SizedBox(height: 24.h),
      ],
    );
  }

  // ================= INPUT =================

  Widget _input(TextEditingController controller, String label) {
    return Column(
      children: [
        InputFormField(
          controller: controller,

          hintText: 'Masukkan jumlah',

          label: label,

          keyboardType: TextInputType.number,

          textInputAction: TextInputAction.next,

          validator: (value) => ValidatorForm.validateDefault(value),
        ),

        SizedBox(height: 24.h),
      ],
    );
  }
}
