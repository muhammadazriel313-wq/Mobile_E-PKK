import 'package:epkk_nganjuk/common/appbar/custom_appbar.dart';
import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/common/typography.dart';
import 'package:epkk_nganjuk/core/validators/validator_form.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:epkk_nganjuk/features/auth/component/input_form_field.dart';
import 'package:epkk_nganjuk/features/pages/pokja1/penghayatan/penghayatan_controller.dart';
import 'package:epkk_nganjuk/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PenghayatanPengamalanScreen extends StatefulWidget {
  const PenghayatanPengamalanScreen({super.key});

  @override
  State<PenghayatanPengamalanScreen> createState() =>
      _PenghayatanPengamalanScreenState();
}

class _PenghayatanPengamalanScreenState
    extends State<PenghayatanPengamalanScreen> {
  String id_user = '';
  String id_role = '';
  String id_organization = '';
  String full_name = '';
  String name_role = '';
  String name_organization = '';

  final jumlahkel1Controller = TextEditingController();

  final jumlahanggota1Controller = TextEditingController();

  final jumlahkel2Controller = TextEditingController();

  final jumlahanggota2Controller = TextEditingController();

  final jumlahkel3Controller = TextEditingController();

  final jumlahanggota3Controller = TextEditingController();

  final jumlahkel4Controller = TextEditingController();

  final jumlahanggota4Controller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final PenghayatanPengamalanController controller = Get.put(
    PenghayatanPengamalanController(),
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
    jumlahkel1Controller.clear();
    jumlahanggota1Controller.clear();

    jumlahkel2Controller.clear();
    jumlahanggota2Controller.clear();

    jumlahkel3Controller.clear();
    jumlahanggota3Controller.clear();

    jumlahkel4Controller.clear();
    jumlahanggota4Controller.clear();
  }

  @override
  void dispose() {
    jumlahkel1Controller.dispose();
    jumlahanggota1Controller.dispose();

    jumlahkel2Controller.dispose();
    jumlahanggota2Controller.dispose();

    jumlahkel3Controller.dispose();
    jumlahanggota3Controller.dispose();

    jumlahkel4Controller.dispose();
    jumlahanggota4Controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,

      appBar: AppBarSecondary(
        title: 'Penghayatan & Pengamalan Pancasila',

        onBack: () {
          if (jumlahkel1Controller.text.isEmpty &&
              jumlahanggota1Controller.text.isEmpty &&
              jumlahkel2Controller.text.isEmpty &&
              jumlahanggota2Controller.text.isEmpty &&
              jumlahkel3Controller.text.isEmpty &&
              jumlahanggota3Controller.text.isEmpty &&
              jumlahkel4Controller.text.isEmpty &&
              jumlahanggota4Controller.text.isEmpty) {
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
                      /// SECTION 1
                      _section('Sosialisasi Pendidikan PKBN'),

                      _input(jumlahkel1Controller, 'Jumlah Kel. Simulasi'),

                      _input(jumlahanggota1Controller, 'Jumlah Anggota'),

                      /// SECTION 2
                      _section('PKDRT'),

                      _input(jumlahkel2Controller, 'Jumlah Kel. Simulasi'),

                      _input(jumlahanggota2Controller, 'Jumlah Anggota'),

                      /// SECTION 3
                      _section('Pola Asuh'),

                      _input(jumlahkel3Controller, 'Jumlah Kel. Simulasi'),

                      _input(jumlahanggota3Controller, 'Jumlah Anggota'),

                      /// SECTION 4
                      _section('Lansia'),

                      _input(jumlahkel4Controller, 'Jumlah Kel. Simulasi'),

                      _input(jumlahanggota4Controller, 'Jumlah Anggota'),

                      SizedBox(height: 24.h),

                      /// BUTTON
                      Obx(
                        () => ButtonFill(
                          text: controller.isLoading.value
                              ? 'Loading'
                              : 'Kirim',

                          textColor: Colors.white,

                          onPressed: controller.isLoading.value
                              ? null
                              : () async {
                                  if (!_formKey.currentState!.validate()) {
                                    return;
                                  }

                                  await controller.submitPenghayatanPengamalan(
                                    idUser: id_user,

                                    jumlahKelSimulasi1:
                                        jumlahkel1Controller.text,

                                    jumlahAnggota1:
                                        jumlahanggota1Controller.text,

                                    jumlahKelSimulasi2:
                                        jumlahkel2Controller.text,

                                    jumlahAnggota2:
                                        jumlahanggota2Controller.text,

                                    jumlahKelSimulasi3:
                                        jumlahkel3Controller.text,

                                    jumlahAnggota3:
                                        jumlahanggota3Controller.text,

                                    jumlahKelSimulasi4:
                                        jumlahkel4Controller.text,

                                    jumlahAnggota4:
                                        jumlahanggota4Controller.text,

                                    idRole: id_role,

                                    idOrganization: id_organization,
                                  );

                                  final res = controller.reportData.value;

                                  if (res != null && res.statusCode == 200) {
                                    clearForm();

                                    Get.offAllNamed(Routes.MAIN);
                                  }
                                },
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

  /// SECTION
  Widget _section(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        TypographyStyles.bodyCaptionMedium(title, color: TextColors.grey700),

        SizedBox(height: 12.h),
      ],
    );
  }

  /// INPUT
  Widget _input(TextEditingController controller, String label) {
    return Column(
      children: [
        InputFormField(
          controller: controller,

          keyboardType: TextInputType.number,

          hintText: 'Masukkan jumlah',

          label: label,

          validator: (value) => ValidatorForm.validateDefault(value),
        ),

        SizedBox(height: 24.h),
      ],
    );
  }
}
