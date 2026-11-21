import 'package:epkk_nganjuk/common/appbar/custom_appbar.dart';
import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:epkk_nganjuk/features/pages/pokja2/pendidikan/pendidikan_ketrampilan_controller.dart';
import 'package:epkk_nganjuk/features/draft/button_secondary_outline.dart';
import 'package:epkk_nganjuk/features/draft/draft_model.dart';
import 'package:epkk_nganjuk/features/draft/draft_service.dart';
import 'package:epkk_nganjuk/features/draft/draft_controller.dart';
import 'package:epkk_nganjuk/routes/app_routes.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class PendidikanKetrampilan5Screen extends StatefulWidget {
  const PendidikanKetrampilan5Screen({super.key});

  @override
  State<PendidikanKetrampilan5Screen> createState() =>
      _PendidikanKetrampilan5ScreenState();
}

class _PendidikanKetrampilan5ScreenState
    extends State<PendidikanKetrampilan5Screen> {
  final controller = Get.isRegistered<PendidikanKeterampilanController>()
      ? Get.find<PendidikanKeterampilanController>()
      : Get.put(PendidikanKeterampilanController());
  DraftModel? _editingDraft;
  bool _isSavingDraft = false;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args is Map && args['draft'] is DraftModel) {
      _editingDraft = args['draft'] as DraftModel;
      controller.restoreDraft(_editingDraft!.dataForm);
    }
  }

  Future<bool> _saveDraft() async {
    if (_isSavingDraft || controller.isLoading.value) return false;
    if (controller.idUser.isEmpty) return false;
    setState(() => _isSavingDraft = true);
    try {
      final data = controller.draftData(langkah: 5)..['id_user'] = controller.idUser;
      final service = DraftService();
      if (_editingDraft != null) {
        await service.updateDraft(_editingDraft!.copyWith(dataForm: data, status: 'draf', pesanError: null));
      } else {
        await service.simpanDraft(idAkun: controller.idUser, jenis: 'pendidikan', dataForm: data, originalPhotoPaths: []);
      }
      final drafts = Get.isRegistered<DraftController>() ? Get.find<DraftController>() : Get.put(DraftController());
      await drafts.refreshAllCount();
      Get.closeAllSnackbars();
      Get.until((route) => route.settings.name == Routes.HOME || route.isFirst);
      Future.delayed(const Duration(milliseconds: 150), () => Get.snackbar('Draf disimpan', '', snackPosition: SnackPosition.TOP));
      return true;
    } catch (_) {
      Get.snackbar('Gagal', 'Draf tidak dapat disimpan.', snackPosition: SnackPosition.TOP);
      return false;
    } finally {
      if (mounted) setState(() => _isSavingDraft = false);
    }
  }

  // ================= HELPER =================

  Widget _row(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Expanded(
            flex: 2,

            child: Text(
              label,

              style: TextStyle(fontSize: 13.sp, color: TextColors.grey600),
            ),
          ),

          SizedBox(width: 12.w),

          Expanded(
            child: Text(
              value,

              textAlign: TextAlign.end,

              style: TextStyle(
                fontSize: 13.sp,

                fontWeight: FontWeight.w600,

                color: TextColors.grey900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(color: Colors.grey.shade300, height: 1);
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h, bottom: 8.h),

      child: Text(
        title,

        style: TextStyle(
          fontWeight: FontWeight.w600,

          fontSize: 14.sp,

          color: TextColors.grey900,
        ),
      ),
    );
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    final isTablet = media.size.width >= 600;

    return Scaffold(
      resizeToAvoidBottomInset: true,

      backgroundColor: Colors.white,

      appBar: AppBarSecondary(
        title: 'Review Laporan',

        onBack: () => Get.back(),

        currentStep: 5,

        totalSteps: 5,
      ),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),

              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

              padding: EdgeInsets.only(
                left: isTablet ? 40.w : 16.w,

                right: isTablet ? 40.w : 16.w,

                top: 20.h,

                bottom: 20.h,
              ),

              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isTablet ? 700 : double.infinity,

                    minHeight: constraints.maxHeight,
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      // ================= INFO BOX =================
                      Container(
                        padding: EdgeInsets.all(16.w),

                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,

                          borderRadius: BorderRadius.circular(12.r),
                        ),

                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Container(
                              padding: EdgeInsets.all(10.w),

                              decoration: BoxDecoration(
                                color: Colors.white,

                                borderRadius: BorderRadius.circular(10.r),
                              ),

                              child: Icon(
                                Icons.search,

                                color: const Color.fromARGB(255, 47, 128, 183),

                                size: 34.w,
                              ),
                            ),

                            SizedBox(width: 12.w),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Text(
                                    'Pastikan data yang Anda masukkan sudah benar !!!',

                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,

                                      fontSize: 15.sp,

                                      color: TextColors.grey900,
                                    ),
                                  ),

                                  SizedBox(height: 4.h),

                                  Text(
                                    'Jika terdapat kesalahan, silakan lakukan perbaikan pada halaman ini.',

                                    style: TextStyle(
                                      fontSize: 13.sp,

                                      color: TextColors.grey600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // ================= HEADER =================
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Expanded(
                            child: Text(
                              'Detail Laporan',

                              style: TextStyle(
                                fontSize: 18.sp,

                                fontWeight: FontWeight.bold,

                                color: TextColors.grey900,
                              ),
                            ),
                          ),

                          GestureDetector(
                            onTap: () => Get.back(),

                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,

                                vertical: 6.h,
                              ),

                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),

                                borderRadius: BorderRadius.circular(8.r),
                              ),

                              child: Row(
                                mainAxisSize: MainAxisSize.min,

                                children: [
                                  Icon(
                                    Icons.edit,

                                    size: 18.sp,

                                    color: const Color.fromARGB(
                                      255,
                                      47,
                                      128,
                                      183,
                                    ),
                                  ),

                                  SizedBox(width: 6.w),

                                  Text(
                                    'Edit',

                                    style: TextStyle(
                                      fontSize: 13.sp,

                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16.h),

                      // ================= CARD =================
                      Container(
                        padding: EdgeInsets.all(16.w),

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius: BorderRadius.circular(12.r),

                          border: Border.all(color: Colors.grey.shade300),
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            _sectionTitle('Jumlah Kelompok Belajar'),

                            _row('Warga yang masih buta', controller.wargaButa),

                            _divider(),

                            _sectionTitle('Paket A'),

                            _row('Kel. Belajar', controller.kelBelajarA),

                            _divider(),

                            _row('Warga Belajar', controller.wargaBelajarA),

                            _divider(),

                            _sectionTitle('Paket B'),

                            _row('Kel. Belajar', controller.kelBelajarB),

                            _divider(),

                            _row('Warga Belajar', controller.wargaBelajarB),

                            _divider(),

                            _sectionTitle('Paket C'),

                            _row('Kel. Belajar', controller.kelBelajarC),

                            _divider(),

                            _row('Warga Belajar', controller.wargaBelajarC),

                            _divider(),

                            _sectionTitle('Paket KF'),

                            _row('Kel. Belajar', controller.kelBelajarKF),

                            _divider(),

                            _row('Warga Belajar', controller.kelBelajarKF),

                            _divider(),

                            _row('Paud', controller.paud),

                            _divider(),

                            _row('Taman Bacaan', controller.tamanBacaan),

                            _divider(),

                            _sectionTitle('BKP'),

                            _row('KLP', controller.jumlahKlp),

                            _divider(),

                            _row('Ibu', controller.jumlahIbuPeserta),

                            _divider(),

                            _row('APE', controller.jumlahApe),

                            _divider(),

                            _row('Simulasi', controller.jumlahKelSimulasi),

                            _divider(),

                            _sectionTitle('Kader Khusus'),

                            _row('KF', controller.kf),

                            _divider(),

                            _row('Paud Tutor', controller.paudTutor),

                            _divider(),

                            _row('BKB', controller.bkb),

                            _divider(),

                            _row('Koperasi', controller.koperasi),

                            _divider(),

                            _row('Ketrampilan', controller.ketrampilan),

                            _divider(),

                            _sectionTitle('Pelatihan'),

                            _row('LP3PKK', controller.lp3pkk),

                            _divider(),

                            _row('TP3PKK', controller.tp3pkk),

                            _divider(),

                            _row('DAMAS', controller.damasPkk),
                          ],
                        ),
                      ),

                      SizedBox(height: 24.h),

                      Row(
                        children: [
                          Expanded(
                            child: ButtonSecondaryOutline(
                              text: _isSavingDraft ? 'Menyimpan...' : 'Simpan Draf',
                              onPressed: _isSavingDraft || controller.isLoading.value ? null : _saveDraft,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: ZoomTapAnimation(
                              child: Obx(
                                () => ButtonFill(
                            text: controller.isLoading.value
                                ? 'Loading...'
                                : 'Kirim',

                            textColor: Colors.white,

                            onPressed: controller.isLoading.value
                                ? null
                                : () async {
                                    final success = await controller.submit();
                                    if (success) {
                                      if (_editingDraft != null) {
                                        await DraftService().hapusDraft(_editingDraft!.id);
                                      }
                                      Get.offAllNamed('/main');
                                    } else if (controller.lastFailureWasNetwork.value && mounted) {
                                      final saveAsDraft = await Get.dialog<bool>(
                                        AlertDialog(
                                          title: const Text('Gagal terkirim'),
                                          content: const Text('Simpan sebagai draf agar isian tidak hilang?'),
                                          actions: [
                                            TextButton(onPressed: () => Get.back(result: false), child: const Text('Tutup')),
                                            ElevatedButton(onPressed: () => Get.back(result: true), child: const Text('Simpan Draf')),
                                          ],
                                        ),
                                        barrierDismissible: false,
                                      );
                                      if (saveAsDraft == true) await _saveDraft();
                                    }
                                  },
                          ),
                                ),
                              ),
                            ),
                        ],
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
}
