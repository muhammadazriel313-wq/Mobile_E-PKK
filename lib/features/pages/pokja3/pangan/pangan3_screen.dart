import 'package:epkk_nganjuk/common/appbar/custom_appbar.dart';
import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/common/typography.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:epkk_nganjuk/features/draft/button_secondary_outline.dart';
import 'package:epkk_nganjuk/features/draft/draft_controller.dart';
import 'package:epkk_nganjuk/features/draft/draft_model.dart';
import 'package:epkk_nganjuk/features/draft/draft_service.dart';
import 'package:epkk_nganjuk/features/pages/pokja3/pangan/pangan_controller.dart';
import 'package:epkk_nganjuk/routes/app_routes.dart';
import 'package:epkk_nganjuk/services/preferences/preferences_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class Pangan3Screen extends StatefulWidget {
  const Pangan3Screen({super.key});

  @override
  State<Pangan3Screen> createState() => _Pangan3ScreenState();
}

class _Pangan3ScreenState extends State<Pangan3Screen> {
  final PanganController uploadController = Get.find<PanganController>();

  late Map<String, dynamic> data;
  DraftModel? _editingDraft;
  bool _isSavingDraft = false;

  @override
  void initState() {
    super.initState();

    final args = Get.arguments;
    if (args is Map) {
      data = Map<String, dynamic>.from(args);
      if (args['draft'] is DraftModel) {
        _editingDraft = args['draft'] as DraftModel;
      }
    } else {
      data = {};
    }
  }

  Map<String, dynamic> _collectFormData() {
    final existingData = _editingDraft?.dataForm ?? <String, dynamic>{};
    return {
      ...existingData,
      'id_user': data['id_user'] ?? '',
      'id_role': data['id_role'] ?? '',
      'id_organization': data['id_organization'] ?? '',
      'full_name': data['full_name'] ?? '',
      'name_role': data['name_role'] ?? '',
      'name_organization': data['name_organization'] ?? '',
      'beras': data['beras']?.toString() ?? '',
      'non_beras': data['non_beras']?.toString() ?? '',
      'peternakan': data['peternakan']?.toString() ?? '',
      'perikanan': data['perikanan']?.toString() ?? '',
      'warung_hidup': data['warung_hidup']?.toString() ?? '',
      'lumbung_hidup': data['lumbung_hidup']?.toString() ?? '',
      'toga': data['toga']?.toString() ?? '',
      'tanaman_keras': data['tanaman_keras']?.toString() ?? '',
      'tanaman_lainnya': data['tanaman_lainnya']?.toString() ?? '',
      'langkah': 3,
    };
  }

  Future<bool> _simpanDraf({bool showFeedback = true}) async {
    if (_isSavingDraft) return false;
    setState(() => _isSavingDraft = true);
    try {
      final user = await PreferencesService.getUser();
      final idAkun = user?.id?.toString() ?? data['id_user']?.toString() ?? '';
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
          jenis: 'pangan',
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
    Get.until((route) => route.settings.name == Routes.HOME || route.isFirst);
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
        title: 'Pangan',
        currentStep: 3,
        totalSteps: 3,
        onBack: () => Get.back(),
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
                      // ================= WARNING =================
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
                                size: 30.w,
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

                      // ================= DETAIL LAPORAN =================
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
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              'Tahap 3 dari 3',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: TextColors.grey600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 12.h),

                      // ================= CARD CONTAINER =================
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _section('Makanan Pokok', [
                              _row('Beras', data['beras']),
                              _row('Non Beras', data['non_beras']),
                            ]),
                            _section('Pemanfaatan Pekarangan', [
                              _row('Peternakan', data['peternakan']),
                              _row('Perikanan', data['perikanan']),
                              _row('Warung Hidup', data['warung_hidup']),
                              _row('Lumbung Hidup', data['lumbung_hidup']),
                              _row('Toga', data['toga']),
                              _row('Tanaman Keras', data['tanaman_keras']),
                              _row('Tanaman Lainnya', data['tanaman_lainnya']),
                            ]),
                          ],
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // ================= BUTTON =================
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
                                onPressed: _isSavingDraft ||
                                        uploadController.isLoading.value
                                    ? null
                                    : () async => _simpanDrafLaluKembali(),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: ZoomTapAnimation(
                              child: Obx(
                                () => ButtonFill(
                                  text: uploadController.isLoading.value
                                      ? 'Loading...'
                                      : 'Kirim',
                                  textColor: Colors.white,
                                  onPressed: uploadController.isLoading.value ||
                                          _isSavingDraft
                                      ? null
                                      : () async {
                                          final success =
                                              await uploadController
                                                  .submitDataPangan(
                                            beras: data['beras'],
                                            nonBeras: data['non_beras'],
                                            peternakan: data['peternakan'],
                                            perikanan: data['perikanan'],
                                            warungHidup: data['warung_hidup'],
                                            lumbungHidup: data['lumbung_hidup'],
                                            toga: data['toga'],
                                            tanamanKeras: data['tanaman_keras'],
                                            tanamanLainnya:
                                                data['tanaman_lainnya'],
                                            idUser: data['id_user'],
                                            idRole: data['id_role'],
                                            idOrganization:
                                                data['id_organization'],
                                          );

                                          if (success) {
                                            if (_editingDraft != null) {
                                              await DraftService().hapusDraft(
                                                _editingDraft!.id,
                                              );
                                            }
                                            Get.offAllNamed('/main');
                                          } else if (uploadController
                                                  .lastFailureWasNetwork
                                                  .value &&
                                              mounted) {
                                            final saveAsDraft =
                                                await Get.dialog<bool>(
                                              AlertDialog(
                                                title: const Text(
                                                    'Gagal terkirim'),
                                                content: const Text(
                                                  'Simpan sebagai draf agar isian tidak hilang?',
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Get.back(
                                                      result: false,
                                                    ),
                                                    child: const Text('Tutup'),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () => Get.back(
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
    );
  }

  // ================= ROW =================
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

  // ================= SECTION =================
  Widget _section(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12.h),
        TypographyStyles.bodyCaptionSemiBold(title, color: TextColors.grey900),
        SizedBox(height: 8.h),
        ...children,
      ],
    );
  }
}
