/// =======================================================
/// FILE : rekap_desa_tahunan_5_screen.dart
/// =======================================================

import 'package:epkk_nganjuk/common/appbar/custom_appbar.dart';
import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/common/typography.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:epkk_nganjuk/features/draft/button_secondary_outline.dart';
import 'package:epkk_nganjuk/features/draft/draft_controller.dart';
import 'package:epkk_nganjuk/features/draft/draft_model.dart';
import 'package:epkk_nganjuk/features/draft/draft_service.dart';
import 'package:epkk_nganjuk/services/preferences/preferences_service.dart';
import 'package:epkk_nganjuk/features/pages/pokja4/inovasi/rekap_tahun/rekap_tahun_controller.dart';
import 'package:epkk_nganjuk/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class RekapDesaTahunan5Screen extends StatefulWidget {
  const RekapDesaTahunan5Screen({super.key});

  @override
  State<RekapDesaTahunan5Screen> createState() =>
      _RekapDesaTahunan5ScreenState();
}

class _RekapDesaTahunan5ScreenState extends State<RekapDesaTahunan5Screen> {
  /// ================= CONTROLLER =================

  final RekapDesaTahunanController controller = Get.put(
    RekapDesaTahunanController(),
  );

  /// ================= ARGUMENT =================

  late Map<String, dynamic> data;

  DraftModel? _editingDraft;

  bool _isSavingDraft = false;

  @override
  void initState() {
    super.initState();

    data = {};

    final args = Get.arguments;

    if (args is Map) {
      data = Map<String, dynamic>.from(args);

      if (args['draft'] is DraftModel) {
        _editingDraft = args['draft'] as DraftModel;

        data = {..._editingDraft!.dataForm, ...data};
      }
    }

    data.remove('draft');
  }

  Map<String, dynamic> _collectFormData() {
    final existingData = _editingDraft?.dataForm ?? <String, dynamic>{};

    final argsData = Map<String, dynamic>.from(data)..remove('draft');

    return {
      ...existingData,
      ...argsData,
      'langkah': 5,
    };
  }

  Future<bool> _simpanDraf({bool showFeedback = true}) async {
    if (_isSavingDraft) return false;

    setState(() => _isSavingDraft = true);

    try {
      final user = await PreferencesService.getUser();

      final idAkun = user?.id.toString() ?? '';

      if (idAkun.isEmpty) {
        Get.snackbar(
          'Gagal',
          'Sesi pengguna tidak valid.',
          snackPosition: SnackPosition.TOP,
        );

        return false;
      }

      final dataForm = _collectFormData();

      final service = DraftService();

      if (_editingDraft != null) {
        final updated = _editingDraft!.copyWith(
          dataForm: dataForm,
          status: 'draf',
          pesanError: null,
        );

        await service.updateDraft(updated);

        _editingDraft = updated;
      } else {
        final newDraft = await service.simpanDraft(
          idAkun: idAkun,
          jenis: 'inovasi_rekap_tahunan',
          dataForm: dataForm,
          originalPhotoPaths: [],
        );

        _editingDraft = newDraft;
      }

      final draftController = Get.isRegistered<DraftController>()
          ? Get.find<DraftController>()
          : Get.put(DraftController());

      await draftController.refreshAllCount();

      return true;
    } catch (_) {
      Get.snackbar(
        'Gagal',
        'Draf tidak dapat disimpan.',
        snackPosition: SnackPosition.TOP,
      );

      return false;
    } finally {
      if (mounted) setState(() => _isSavingDraft = false);
    }
  }

  void _showSnackbarDrafDisimpan() {
    double horizontalMargin = 20.w;

    final ctx = Get.context;

    if (ctx != null) {
      final screenWidth = MediaQuery.of(ctx).size.width;

      if (screenWidth > 220) {
        horizontalMargin = (screenWidth - 220) / 2;
      }
    }

    Get.snackbar(
      '',
      '',
      titleText: Center(
        child: Text(
          'Draf disimpan',
          style: TextStyle(
            fontFamily: TypographyStyles.fontFamily,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      messageText: const SizedBox.shrink(),
      maxWidth: 220,
      margin: EdgeInsets.only(
        top: 12.h,
        left: horizontalMargin,
        right: horizontalMargin,
      ),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      borderRadius: 24.r,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
      backgroundColor: const Color(0xFF3F8FC1),
      colorText: Colors.white,
    );
  }

  Future<bool> _simpanDrafLaluKembali() async {
    if (!await _simpanDraf(showFeedback: false)) return false;

    Get.closeAllSnackbars();

    Get.until(
      (route) =>
          route.settings.name == Routes.UPLOAD_LAPORAN ||
          route.settings.name == Routes.DRAFT_LIST ||
          route.settings.name == Routes.INOVASI ||
          route.settings.name == Routes.HOME ||
          route.isFirst,
    );

    Future.delayed(const Duration(milliseconds: 150), _showSnackbarDrafDisimpan);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    final isTablet = media.size.width >= 600;

    return Scaffold(
      resizeToAvoidBottomInset: true,

      backgroundColor: Colors.white,

      appBar: AppBarSecondary(
        title: 'Rekap Desa Tahunan',

        currentStep: 5,

        totalSteps: 5,

        onBack: () => Get.back(),
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
                      maxWidth: isTablet ? 700 : double.infinity,

                      minHeight: constraints.maxHeight,
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        /// ================= WARNING =================
                        Container(
                          padding: EdgeInsets.all(16.w),

                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,

                            borderRadius: BorderRadius.circular(12.r),
                          ),

                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10.w),

                                decoration: BoxDecoration(
                                  color: Colors.white,

                                  borderRadius: BorderRadius.circular(10.r),
                                ),

                                child: Icon(
                                  Icons.search,

                                  color: const Color(0xFF2F80B7),

                                  size: 28.w,
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
                                        fontSize: 15.sp,

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

                        /// ================= HEADER =================
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Text(
                              'Detail Laporan',

                              style: TextStyle(
                                fontSize: 18.sp,

                                fontWeight: FontWeight.bold,

                                color: TextColors.grey900,
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
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),

                                  borderRadius: BorderRadius.circular(8.r),
                                ),

                                child: Row(
                                  mainAxisSize: MainAxisSize.min,

                                  children: [
                                    Icon(
                                      Icons.edit,

                                      size: 18.w,

                                      color: const Color(0xFF2F80B7),
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

                        /// ================= CARD =================
                        Container(
                          padding: EdgeInsets.all(16.w),

                          decoration: BoxDecoration(
                            color: Colors.white,

                            borderRadius: BorderRadius.circular(12.r),

                            border: Border.all(color: Colors.grey.shade300),
                          ),

                          child: Column(
                            children: data.entries.map((entry) {
                              return _row(
                                entry.key.replaceAll('_', ' '),

                                entry.value.toString(),
                              );
                            }).toList(),
                          ),
                        ),

                        SizedBox(height: 30.h),

                        /// ================= BUTTON =================
                        Row(
                          children: [
                            Expanded(
                              child: ZoomTapAnimation(
                                child: ButtonSecondaryOutline(
                                  text: _isSavingDraft
                                      ? 'Menyimpan...'
                                      : (_editingDraft != null
                                          ? 'Simpan Perubahan'
                                          : 'Simpan Draf'),

                                  onPressed: _isSavingDraft
                                      ? null
                                      : () async => _simpanDrafLaluKembali(),
                                ),
                              ),
                            ),

                            SizedBox(width: 12.w),

                            Expanded(
                              child: Obx(
                                () => ZoomTapAnimation(
                                  child: ButtonFill(
                                    text: controller.isLoading.value
                                        ? 'Loading...'
                                        : 'Kirim',

                                    textColor: Colors.white,

                                    isLoading: controller.isLoading.value,

                                    onPressed: controller.isLoading.value
                                        ? null
                                        : () async {
                                            final success = await controller
                                                .submitDataRekapDesaTahunan(
                                                  kategori: data['kategori'],

                                                  kaderKesehatan:
                                                      data['kader_kesehatan'],

                                                  gizi: data['gizi'],

                                                  kesling: data['kesling'],

                                                  phbs: data['phbs'],

                                                  kb: data['kb'],

                                                  posyandu: data['posyandu'],

                                                  imunisasiVaksinasiBayiBalita:
                                                      data['imunisasi_vaksinasi_bayi_balita'],

                                                  pkg: data['pkg'],

                                                  tbc: data['tbc'],

                                                  jambanWc: data['jamban_wc'],

                                                  spal: data['spal'],

                                                  tps: data['tps'],

                                                  jumlahMck: data['jumlah_mck'],

                                                  pdam: data['pdam'],

                                                  sumur: data['sumur'],

                                                  lainLain: data['lain_lain'],

                                                  jmlPus: data['jml_pus'],

                                                  jmlWus: data['jml_wus'],

                                                  akseptorKbL:
                                                      data['akseptor_kb_l'],

                                                  akseptorKbP:
                                                      data['akseptor_kb_p'],

                                                  jmlKkTabungan:
                                                      data['jml_kk_tabungan'],

                                                  jmlKkAsuransi:
                                                      data['jml_kk_asuransi'],

                                                  kesehatanProgram:
                                                      data['kesehatan_program'],

                                                  kelestarianLingkunganHidup:
                                                      data['kelestarian_lingkungan_hidup'],

                                                  perencanaanSehatProgram:
                                                      data['perencanaan_sehat_program'],
                                                );

                                            /// ================= SUCCESS =================

                                            if (success) {
                                              if (_editingDraft != null) {
                                                await DraftService()
                                                    .hapusDraft(
                                                      _editingDraft!.id,
                                                    );

                                                final draftController =
                                                    Get.isRegistered<
                                                            DraftController>()
                                                        ? Get.find<
                                                            DraftController>()
                                                        : Get.put(
                                                            DraftController(),
                                                          );

                                                await draftController
                                                    .refreshAllCount();
                                              }

                                              data.clear();

                                              Get.offAllNamed('/main');
                                            } else if (controller
                                                    .lastFailureWasNetwork
                                                    .value &&
                                                mounted) {
                                              final saveAsDraft =
                                                  await Get.dialog<bool>(
                                                    AlertDialog(
                                                      title: const Text(
                                                        'Gagal terkirim',
                                                      ),

                                                      content: const Text(
                                                        'Simpan sebagai draf agar isian tidak hilang?',
                                                      ),

                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Get.back(
                                                                result: false,
                                                              ),

                                                          child: const Text(
                                                            'Tutup',
                                                          ),
                                                        ),

                                                        ElevatedButton(
                                                          onPressed: () =>
                                                              Get.back(
                                                                result: true,
                                                              ),

                                                          child: const Text(
                                                            'Simpan Draf',
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                    barrierDismissible: false,
                                                  );

                                              if (saveAsDraft == true) {
                                                await _simpanDrafLaluKembali();
                                              }
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
      ),
    );
  }

  /// ================= ROW =================

  Widget _row(String label, String? value) {
    return Column(
      children: [
        Padding(
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
                  value ?? '0',

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
        ),

        Divider(color: Colors.grey.shade300, height: 1),
      ],
    );
  }
}
