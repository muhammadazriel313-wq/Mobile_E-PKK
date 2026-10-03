import 'package:epkk_nganjuk/common/appbar/custom_appbar.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:epkk_nganjuk/features/auth/component/input_form_field.dart';
import 'package:epkk_nganjuk/features/pages/pokja1/penghayatan/penghayatan_controller.dart';
import 'package:epkk_nganjuk/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class PenghayatanPengamalanScreen extends StatefulWidget {
  const PenghayatanPengamalanScreen({super.key});

  @override
  State<PenghayatanPengamalanScreen> createState() => _PenghayatanPengamalanScreenState();
}

class _PenghayatanPengamalanScreenState extends State<PenghayatanPengamalanScreen> {
  String id_user = '';
  String id_role = '';
  String id_organization = '';
  String full_name = '';
  String name_role = '';
  String name_organization = '';

  final kisahKegiatanController = TextEditingController();
  final kisahVolController = TextEditingController();
  final kisahMetodeController = TextEditingController();
  final kisahSasaranController = TextEditingController();

  final krisanKegiatanController = TextEditingController();
  final krisanVolController = TextEditingController();
  final krisanMetodeController = TextEditingController();
  final krisanSasaranController = TextEditingController();

  final kilasKegiatanController = TextEditingController();
  final kilasVolController = TextEditingController();
  final kilasMetodeController = TextEditingController();
  final kilasSasaranController = TextEditingController();

  final kiatKegiatanController = TextEditingController();
  final kiatVolController = TextEditingController();
  final kiatMetodeController = TextEditingController();
  final kiatSasaranController = TextEditingController();

  final kisakKegiatanController = TextEditingController();
  final kisakVolController = TextEditingController();
  final kisakMetodeController = TextEditingController();
  final kisakSasaranController = TextEditingController();

  final pkbnKegiatanController = TextEditingController();
  final pkbnVolController = TextEditingController();
  final pkbnMetodeController = TextEditingController();
  final pkbnSasaranController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final PenghayatanPengamalanController penghayatanController = Get.put(
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
    kisahKegiatanController.clear(); kisahVolController.clear();
    kisahMetodeController.clear(); kisahSasaranController.clear();
    krisanKegiatanController.clear(); krisanVolController.clear();
    krisanMetodeController.clear(); krisanSasaranController.clear();
    kilasKegiatanController.clear(); kilasVolController.clear();
    kilasMetodeController.clear(); kilasSasaranController.clear();
    kiatKegiatanController.clear(); kiatVolController.clear();
    kiatMetodeController.clear(); kiatSasaranController.clear();
    kisakKegiatanController.clear(); kisakVolController.clear();
    kisakMetodeController.clear(); kisakSasaranController.clear();
    pkbnKegiatanController.clear(); pkbnVolController.clear();
    pkbnMetodeController.clear(); pkbnSasaranController.clear();
  }

  @override
  void dispose() {
    kisahKegiatanController.dispose(); kisahVolController.dispose();
    kisahMetodeController.dispose(); kisahSasaranController.dispose();
    krisanKegiatanController.dispose(); krisanVolController.dispose();
    krisanMetodeController.dispose(); krisanSasaranController.dispose();
    kilasKegiatanController.dispose(); kilasVolController.dispose();
    kilasMetodeController.dispose(); kilasSasaranController.dispose();
    kiatKegiatanController.dispose(); kiatVolController.dispose();
    kiatMetodeController.dispose(); kiatSasaranController.dispose();
    kisakKegiatanController.dispose(); kisakVolController.dispose();
    kisakMetodeController.dispose(); kisakSasaranController.dispose();
    pkbnKegiatanController.dispose(); pkbnVolController.dispose();
    pkbnMetodeController.dispose(); pkbnSasaranController.dispose();
    super.dispose();
  }

  // Judul divisi: hanya teks bold, sesuai permintaan
  Widget _buildDivisiTitle(String title) {
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
      appBar: AppBarSecondary(
        title: 'Penghayatan & Pengamalan Pancasila',
        onBack: () {
          final ada = [
            kisahKegiatanController, kisahVolController,
            kisahMetodeController, kisahSasaranController,
          ].any((c) => c.text.isNotEmpty);

          if (!ada) {
            Get.back();
          } else {
            Get.defaultDialog(
              title: 'Batal Upload?',
              middleText: 'Data yang sudah diisi akan hilang',
              textConfirm: 'Ya',
              textCancel: 'Tidak',
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
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // ============ KISAH ============
                        _buildDivisiTitle('KISAH'),
                        InputFormField(controller: kisahKegiatanController, hintText: 'Masukkan Kegiatan', label: 'Kegiatan'),
                        SizedBox(height: 16.h),
                        InputFormField(controller: kisahVolController, hintText: 'Masukkan Volume', label: 'Volume', keyboardType: TextInputType.number),
                        SizedBox(height: 16.h),
                        InputFormField(controller: kisahMetodeController, hintText: 'Masukkan Metode', label: 'Metode'),
                        SizedBox(height: 16.h),
                        InputFormField(controller: kisahSasaranController, hintText: 'Masukkan Sasaran', label: 'Sasaran'),

                        // ============ KRISAN ============
                        _buildDivisiTitle('KRISAN'),
                        InputFormField(controller: krisanKegiatanController, hintText: 'Masukkan Kegiatan', label: 'Kegiatan'),
                        SizedBox(height: 16.h),
                        InputFormField(controller: krisanVolController, hintText: 'Masukkan Volume', label: 'Volume', keyboardType: TextInputType.number),
                        SizedBox(height: 16.h),
                        InputFormField(controller: krisanMetodeController, hintText: 'Masukkan Metode', label: 'Metode'),
                        SizedBox(height: 16.h),
                        InputFormField(controller: krisanSasaranController, hintText: 'Masukkan Sasaran', label: 'Sasaran'),

                        // ============ KILAS ============
                        _buildDivisiTitle('KILAS'),
                        InputFormField(controller: kilasKegiatanController, hintText: 'Masukkan Kegiatan', label: 'Kegiatan'),
                        SizedBox(height: 16.h),
                        InputFormField(controller: kilasVolController, hintText: 'Masukkan Volume', label: 'Volume', keyboardType: TextInputType.number),
                        SizedBox(height: 16.h),
                        InputFormField(controller: kilasMetodeController, hintText: 'Masukkan Metode', label: 'Metode'),
                        SizedBox(height: 16.h),
                        InputFormField(controller: kilasSasaranController, hintText: 'Masukkan Sasaran', label: 'Sasaran'),

                        // ============ KIAT ============
                        _buildDivisiTitle('KIAT'),
                        InputFormField(controller: kiatKegiatanController, hintText: 'Masukkan Kegiatan', label: 'Kegiatan'),
                        SizedBox(height: 16.h),
                        InputFormField(controller: kiatVolController, hintText: 'Masukkan Volume', label: 'Volume', keyboardType: TextInputType.number),
                        SizedBox(height: 16.h),
                        InputFormField(controller: kiatMetodeController, hintText: 'Masukkan Metode', label: 'Metode'),
                        SizedBox(height: 16.h),
                        InputFormField(controller: kiatSasaranController, hintText: 'Masukkan Sasaran', label: 'Sasaran'),

                        // ============ KISAK ============
                        _buildDivisiTitle('KISAK'),
                        InputFormField(controller: kisakKegiatanController, hintText: 'Masukkan Kegiatan', label: 'Kegiatan'),
                        SizedBox(height: 16.h),
                        InputFormField(controller: kisakVolController, hintText: 'Masukkan Volume', label: 'Volume', keyboardType: TextInputType.number),
                        SizedBox(height: 16.h),
                        InputFormField(controller: kisakMetodeController, hintText: 'Masukkan Metode', label: 'Metode'),
                        SizedBox(height: 16.h),
                        InputFormField(controller: kisakSasaranController, hintText: 'Masukkan Sasaran', label: 'Sasaran'),

                        // ============ PKBN ============
                        _buildDivisiTitle('PKBN'),
                        InputFormField(controller: pkbnKegiatanController, hintText: 'Masukkan Kegiatan', label: 'Kegiatan'),
                        SizedBox(height: 16.h),
                        InputFormField(controller: pkbnVolController, hintText: 'Masukkan Volume', label: 'Volume', keyboardType: TextInputType.number),
                        SizedBox(height: 16.h),
                        InputFormField(controller: pkbnMetodeController, hintText: 'Masukkan Metode', label: 'Metode'),
                        SizedBox(height: 16.h),
                        InputFormField(controller: pkbnSasaranController, hintText: 'Masukkan Sasaran', label: 'Sasaran'),

                        SizedBox(height: 40.h),

                        // ============ TOMBOL KIRIM ============
                        SizedBox(
                          width: double.infinity,
                          child: ZoomTapAnimation(
                            child: Obx(
                              () => ButtonFill(
                                text: penghayatanController.isLoading.value ? 'Loading' : 'Kirim',
                                textColor: Colors.white,
                                onPressed: penghayatanController.isLoading.value
                                    ? null
                                    : () async {
                                        await penghayatanController.submitPenghayatanPengamalan(
                                          idRole: id_role,
                                          idOrganization: id_organization,
                                          idUser: id_user,
                                          kisahKegiatan: kisahKegiatanController.text,
                                          kisahVol: kisahVolController.text,
                                          kisahMetode: kisahMetodeController.text,
                                          kisahSasaran: kisahSasaranController.text,
                                          krisanKegiatan: krisanKegiatanController.text,
                                          krisanVol: krisanVolController.text,
                                          krisanMetode: krisanMetodeController.text,
                                          krisanSasaran: krisanSasaranController.text,
                                          kilasKegiatan: kilasKegiatanController.text,
                                          kilasVol: kilasVolController.text,
                                          kilasMetode: kilasMetodeController.text,
                                          kilasSasaran: kilasSasaranController.text,
                                          kiatKegiatan: kiatKegiatanController.text,
                                          kiatVol: kiatVolController.text,
                                          kiatMetode: kiatMetodeController.text,
                                          kiatSasaran: kiatSasaranController.text,
                                          kisakKegiatan: kisakKegiatanController.text,
                                          kisakVol: kisakVolController.text,
                                          kisakMetode: kisakMetodeController.text,
                                          kisakSasaran: kisakSasaranController.text,
                                          pkbnKegiatan: pkbnKegiatanController.text,
                                          pkbnVol: pkbnVolController.text,
                                          pkbnMetode: pkbnMetodeController.text,
                                          pkbnSasaran: pkbnSasaranController.text,
                                        );

                                        final res = penghayatanController.reportData.value;
                                        if (res != null && res.statusCode == 200) {
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