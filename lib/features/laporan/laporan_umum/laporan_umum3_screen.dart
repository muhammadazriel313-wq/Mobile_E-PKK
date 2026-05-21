import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/common/typography.dart';
import 'package:epkk_nganjuk/core/validators/validator_form.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:epkk_nganjuk/features/auth/component/custome_appbar.dart';
import 'package:epkk_nganjuk/features/auth/component/input_form_field.dart';
import 'package:epkk_nganjuk/features/laporan/laporan_umum/laporan_umum_controller.dart';
import 'package:epkk_nganjuk/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class LaporanUmum3Screen extends StatefulWidget {
  const LaporanUmum3Screen({super.key});

  @override
  State<LaporanUmum3Screen> createState() => _LaporanUmum3ScreenState();
}

class _LaporanUmum3ScreenState extends State<LaporanUmum3Screen> {
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

  String jiwa_laki = '';
  String jiwa_perempuan = '';

  String anggota_laki = '';
  String anggota_perempuan = '';

  String umum_laki = '';
  String umum_perempuan = '';

  String khusus_laki = '';
  String khusus_perempuan = '';

  // ================= CONTROLLER =================

  final lakilaki1Controller = TextEditingController();

  final perempuan1Controller = TextEditingController();

  final lakilaki2Controller = TextEditingController();

  final perempuan2Controller = TextEditingController();

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

    jiwa_laki = args['jiwa_laki'] ?? '';

    jiwa_perempuan = args['jiwa_perempuan'] ?? '';

    anggota_laki = args['anggota_laki'] ?? '';

    anggota_perempuan = args['anggota_perempuan'] ?? '';

    umum_laki = args['umum_laki'] ?? '';

    umum_perempuan = args['umum_perempuan'] ?? '';

    khusus_laki = args['khusus_laki'] ?? '';

    khusus_perempuan = args['khusus_perempuan'] ?? '';
  }

  @override
  void dispose() {
    lakilaki1Controller.dispose();

    perempuan1Controller.dispose();

    lakilaki2Controller.dispose();

    perempuan2Controller.dispose();

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

        currentStep: 3,

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
                          // ================= HONORER =================
                          _section('Jumlah Tenaga Sekretariat - Honorer'),

                          _input(lakilaki1Controller, 'Laki-laki'),

                          _input(perempuan1Controller, 'Perempuan'),

                          // ================= BANTUAN =================
                          _section('Bantuan'),

                          _input(lakilaki2Controller, 'Laki-laki'),

                          _input(perempuan2Controller, 'Perempuan'),

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
                                            Routes.LAPORAN_UMUM4,

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
                                              'jiwa_laki': jiwa_laki,

                                              'jiwa_perempuan': jiwa_perempuan,

                                              // ================= ANGGOTA =================
                                              'anggota_laki': anggota_laki,

                                              'anggota_perempuan':
                                                  anggota_perempuan,

                                              // ================= UMUM =================
                                              'umum_laki': umum_laki,

                                              'umum_perempuan': umum_perempuan,

                                              // ================= KHUSUS =================
                                              'khusus_laki': khusus_laki,

                                              'khusus_perempuan':
                                                  khusus_perempuan,

                                              // ================= HONORER =================
                                              'honorer_laki':
                                                  lakilaki1Controller.text,

                                              'honorer_perempuan':
                                                  perempuan1Controller.text,

                                              // ================= BANTUAN =================
                                              'bantuan_laki':
                                                  lakilaki2Controller.text,

                                              'bantuan_perempuan':
                                                  perempuan2Controller.text,
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
