import 'package:epkk_nganjuk/common/appbar/custom_appbar.dart';
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

  // 1. KERJA BAKTI
  final kerjaBaktiKegiatanController = TextEditingController();
  final kerjaBaktiVolController = TextEditingController();
  final kerjaBaktiMetodeController = TextEditingController();
  final kerjaBaktiSasaranController = TextEditingController();

  // 2. BANTUAN ANAK YATIM
  final bantuanYatimKegiatanController = TextEditingController();
  final bantuanYatimVolController = TextEditingController();
  final bantuanYatimMetodeController = TextEditingController();
  final bantuanYatimSasaranController = TextEditingController();

  // 3. KEGIATAN SOSIAL
  final kegiatanSosialKegiatanController = TextEditingController();
  final kegiatanSosialVolController = TextEditingController();
  final kegiatanSosialMetodeController = TextEditingController();
  final kegiatanSosialSasaranController = TextEditingController();

  // INFORMASI TAMBAHAN
  final sumberDanaController = TextEditingController();
  final hasilKegiatanController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final GotongRoyongController controller = Get.put(GotongRoyongController());

  void clearForm() {
    kerjaBaktiKegiatanController.clear();
    kerjaBaktiVolController.clear();
    kerjaBaktiMetodeController.clear();
    kerjaBaktiSasaranController.clear();

    bantuanYatimKegiatanController.clear();
    bantuanYatimVolController.clear();
    bantuanYatimMetodeController.clear();
    bantuanYatimSasaranController.clear();

    kegiatanSosialKegiatanController.clear();
    kegiatanSosialVolController.clear();
    kegiatanSosialMetodeController.clear();
    kegiatanSosialSasaranController.clear();

    sumberDanaController.clear();
    hasilKegiatanController.clear();
  }

  bool isFormEmpty() {
    return kerjaBaktiKegiatanController.text.isEmpty &&
        kerjaBaktiVolController.text.isEmpty &&
        kerjaBaktiMetodeController.text.isEmpty &&
        kerjaBaktiSasaranController.text.isEmpty &&
        bantuanYatimKegiatanController.text.isEmpty &&
        bantuanYatimVolController.text.isEmpty &&
        bantuanYatimMetodeController.text.isEmpty &&
        bantuanYatimSasaranController.text.isEmpty &&
        kegiatanSosialKegiatanController.text.isEmpty &&
        kegiatanSosialVolController.text.isEmpty &&
        kegiatanSosialMetodeController.text.isEmpty &&
        kegiatanSosialSasaranController.text.isEmpty &&
        sumberDanaController.text.isEmpty &&
        hasilKegiatanController.text.isEmpty;
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
    kerjaBaktiKegiatanController.dispose();
    kerjaBaktiVolController.dispose();
    kerjaBaktiMetodeController.dispose();
    kerjaBaktiSasaranController.dispose();

    bantuanYatimKegiatanController.dispose();
    bantuanYatimVolController.dispose();
    bantuanYatimMetodeController.dispose();
    bantuanYatimSasaranController.dispose();

    kegiatanSosialKegiatanController.dispose();
    kegiatanSosialVolController.dispose();
    kegiatanSosialMetodeController.dispose();
    kegiatanSosialSasaranController.dispose();

    sumberDanaController.dispose();
    hasilKegiatanController.dispose();

    super.dispose();
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 24.h, bottom: 12.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1F2937),
        ),
      ),
    );
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
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
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
                        // ============ 1. KERJA BAKTI ============
                        _buildSectionTitle('KERJA BAKTI'),
                        InputFormField(
                          controller: kerjaBaktiKegiatanController,
                          hintText: 'Masukkan Kegiatan',
                          label: 'Kegiatan',
                        ),
                        SizedBox(height: 16.h),
                        InputFormField(
                          controller: kerjaBaktiVolController,
                          hintText: 'Masukkan Volume',
                          label: 'Volume',
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 16.h),
                        InputFormField(
                          controller: kerjaBaktiMetodeController,
                          hintText: 'Masukkan Metode',
                          label: 'Metode',
                        ),
                        SizedBox(height: 16.h),
                        InputFormField(
                          controller: kerjaBaktiSasaranController,
                          hintText: 'Masukkan Sasaran',
                          label: 'Sasaran',
                        ),

                        // ============ 2. BANTUAN ANAK YATIM ============
                        _buildSectionTitle('BANTUAN ANAK YATIM'),
                        InputFormField(
                          controller: bantuanYatimKegiatanController,
                          hintText: 'Masukkan Kegiatan',
                          label: 'Kegiatan',
                        ),
                        SizedBox(height: 16.h),
                        InputFormField(
                          controller: bantuanYatimVolController,
                          hintText: 'Masukkan Volume',
                          label: 'Volume',
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 16.h),
                        InputFormField(
                          controller: bantuanYatimMetodeController,
                          hintText: 'Masukkan Metode',
                          label: 'Metode',
                        ),
                        SizedBox(height: 16.h),
                        InputFormField(
                          controller: bantuanYatimSasaranController,
                          hintText: 'Masukkan Sasaran',
                          label: 'Sasaran',
                        ),

                        // ============ 3. KEGIATAN SOSIAL ============
                        _buildSectionTitle('KEGIATAN SOSIAL'),
                        InputFormField(
                          controller: kegiatanSosialKegiatanController,
                          hintText: 'Masukkan Kegiatan',
                          label: 'Kegiatan',
                        ),
                        SizedBox(height: 16.h),
                        InputFormField(
                          controller: kegiatanSosialVolController,
                          hintText: 'Masukkan Volume',
                          label: 'Volume',
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 16.h),
                        InputFormField(
                          controller: kegiatanSosialMetodeController,
                          hintText: 'Masukkan Metode',
                          label: 'Metode',
                        ),
                        SizedBox(height: 16.h),
                        InputFormField(
                          controller: kegiatanSosialSasaranController,
                          hintText: 'Masukkan Sasaran',
                          label: 'Sasaran',
                        ),

                        // ============ INFORMASI TAMBAHAN ============
                        _buildSectionTitle('INFORMASI TAMBAHAN'),
                        InputFormField(
                          controller: sumberDanaController,
                          hintText: 'Masukkan Sumber Dana (cth: APBD, Swadaya)',
                          label: 'Sumber Dana',
                        ),
                        SizedBox(height: 16.h),
                        InputFormField(
                          controller: hasilKegiatanController,
                          hintText: 'Masukkan Hasil Kegiatan',
                          label: 'Hasil Kegiatan',
                          minLines: 3,
                          maxLines: 5,
                        ),

                        SizedBox(height: 40.h),

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
                                      bool success = await controller.submitGotongRoyong(
                                        idUser: id_user ?? '',
                                        idRole: id_role ?? '',
                                        idOrganization: id_organization ?? '',

                                        // KERJA BAKTI
                                        kerjaBaktiKegiatan: kerjaBaktiKegiatanController.text.isNotEmpty ? kerjaBaktiKegiatanController.text : null,
                                        kerjaBaktiVol: kerjaBaktiVolController.text.isNotEmpty ? kerjaBaktiVolController.text : null,
                                        kerjaBaktiMetode: kerjaBaktiMetodeController.text.isNotEmpty ? kerjaBaktiMetodeController.text : null,
                                        kerjaBaktiSasaran: kerjaBaktiSasaranController.text.isNotEmpty ? kerjaBaktiSasaranController.text : null,

                                        // BANTUAN ANAK YATIM
                                        bantuanYatimKegiatan: bantuanYatimKegiatanController.text.isNotEmpty ? bantuanYatimKegiatanController.text : null,
                                        bantuanYatimVol: bantuanYatimVolController.text.isNotEmpty ? bantuanYatimVolController.text : null,
                                        bantuanYatimMetode: bantuanYatimMetodeController.text.isNotEmpty ? bantuanYatimMetodeController.text : null,
                                        bantuanYatimSasaran: bantuanYatimSasaranController.text.isNotEmpty ? bantuanYatimSasaranController.text : null,

                                        // KEGIATAN SOSIAL
                                        kegiatanSosialKegiatan: kegiatanSosialKegiatanController.text.isNotEmpty ? kegiatanSosialKegiatanController.text : null,
                                        kegiatanSosialVol: kegiatanSosialVolController.text.isNotEmpty ? kegiatanSosialVolController.text : null,
                                        kegiatanSosialMetode: kegiatanSosialMetodeController.text.isNotEmpty ? kegiatanSosialMetodeController.text : null,
                                        kegiatanSosialSasaran: kegiatanSosialSasaranController.text.isNotEmpty ? kegiatanSosialSasaranController.text : null,

                                        // TAMBAHAN
                                        sumberDana: sumberDanaController.text.trim().isNotEmpty
                                            ? sumberDanaController.text.trim()
                                            : null,
                                        hasilKegiatan: hasilKegiatanController.text.trim().isNotEmpty
                                            ? hasilKegiatanController.text.trim()
                                            : null,
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
      ),
    );
  }
}