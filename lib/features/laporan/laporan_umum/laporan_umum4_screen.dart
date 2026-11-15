import 'dart:async';

import 'package:epkk_nganjuk/common/appbar/custom_appbar.dart';
import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/common/typography.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:epkk_nganjuk/features/draft/button_secondary_outline.dart';
import 'package:epkk_nganjuk/features/draft/draft_controller.dart';
import 'package:epkk_nganjuk/features/draft/draft_model.dart';
import 'package:epkk_nganjuk/features/draft/draft_service.dart';
import 'package:epkk_nganjuk/features/laporan/laporan_umum/laporan_umum_controller.dart';
import 'package:epkk_nganjuk/routes/app_routes.dart';
import 'package:epkk_nganjuk/services/preferences/preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class LaporanUmum4Screen extends StatefulWidget {
  const LaporanUmum4Screen({super.key});

  @override
  State<LaporanUmum4Screen> createState() => _LaporanUmum4ScreenState();
}

class _LaporanUmum4ScreenState extends State<LaporanUmum4Screen> {
  final LaporanUmumController uploadController =
      Get.find<LaporanUmumController>();

  late Map<String, dynamic> data;
  DraftModel? _editingDraft;
  bool _isSavingDraft = false;

  Map<String, dynamic> _collectFormData() {
    final existingData = _editingDraft?.dataForm ?? {};
    final result = Map<String, dynamic>.from(existingData);
    data.forEach((key, value) {
      if (key != 'draft') {
        result[key] = value;
      }
    });
    result['langkah'] = 4;
    return result;
  }

  Future<bool> _simpanDraf({bool showFeedback = false}) async {
    if (_isSavingDraft || uploadController.isLoading.value) return false;

    setState(() => _isSavingDraft = true);
    try {
      String idUser = data['id_user']?.toString() ?? '';
      if (idUser.isEmpty) {
        final user = await PreferencesService.getUser();
        idUser = user?.id ?? '';
      }
      if (idUser.isEmpty) {
        Get.snackbar(
          'Sesi Tidak Ditemukan',
          'Masuk kembali untuk menyimpan draf.',
          snackPosition: SnackPosition.TOP,
        );
        return false;
      }

      final collectedData = _collectFormData();
      final service = DraftService();
      if (_editingDraft != null) {
        await service.updateDraft(
          _editingDraft!.copyWith(
            dataForm: collectedData,
            status: 'draf',
            pesanError: null,
          ),
        );
      } else {
        await service.simpanDraft(
          idAkun: idUser,
          jenis: 'laporan_umum',
          dataForm: collectedData,
          originalPhotoPaths: [],
        );
      }

      final draftController = Get.isRegistered<DraftController>()
          ? Get.find<DraftController>()
          : Get.put(DraftController());
      await draftController.refreshAllCount();

      if (showFeedback) {
        _showSnackbarDrafDisimpan();
      }
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
    if (!await _simpanDraf()) return false;
    Get.closeAllSnackbars();
    Get.until((route) => route.settings.name == Routes.HOME || route.isFirst);
    Future.delayed(const Duration(milliseconds: 150), _showSnackbarDrafDisimpan);
    return true;
  }

  @override
  void initState() {
    super.initState();

    final args = (Get.arguments ?? {}) as Map;
    data = Map<String, dynamic>.from(args);
    if (args['draft'] is DraftModel) {
      _editingDraft = args['draft'] as DraftModel;
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    final isTablet = media.size.width >= 600;

    return Scaffold(
      resizeToAvoidBottomInset: true,

      backgroundColor: Colors.white,

      appBar: AppBarSecondary(
        title: 'Laporan Umum',

        currentStep: 4,

        totalSteps: 4,
      ),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),

              padding: EdgeInsets.only(
                left: isTablet ? 40.w : 16.w,

                right: isTablet ? 40.w : 16.w,

                top: 20.h,

                bottom: media.padding.bottom + 20.h,
              ),

              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isTablet ? 650 : double.infinity,

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
                                      fontSize: 14.sp,

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
                            // ================= JUMLAH KELOMPOK =================
                            _buildSection('Jumlah Kelompok', [
                              _buildDetailItem(
                                'Dusun/Lingkungan',

                                data['dusun_lingkungan'] ?? '',
                              ),

                              _buildDetailItem('PKK RW', data['PKK_RW'] ?? '0'),

                              _buildDetailItem('PKK RT', data['PKK_RT'] ?? '0'),

                              _buildDetailItem(
                                'Desa Wisma',

                                data['desa_wisma'] ?? '',
                              ),
                            ]),

                            // ================= JUMLAH =================
                            _buildSection('Jumlah', [
                              _buildDetailItem('KRT', data['KRT'] ?? '0'),

                              _buildDetailItem('KK', data['KK'] ?? '0'),
                            ]),

                            // ================= JUMLAH JIWA =================
                            _buildSection('Jumlah Jiwa', [
                              _buildDetailItem(
                                'Laki-laki',

                                data['jiwa_laki'] ?? '0',
                              ),

                              _buildDetailItem(
                                'Perempuan',

                                data['jiwa_perempuan'] ?? '0',
                              ),
                            ]),

                            // ================= JUMLAH KADER =================
                            _buildSection('Jumlah Kader', [
                              _buildSection('Anggota TP PKK', [
                                _buildDetailItem(
                                  'Laki-laki',

                                  data['anggota_laki'] ?? '0',
                                ),

                                _buildDetailItem(
                                  'Perempuan',

                                  data['anggota_perempuan'] ?? '0',
                                ),
                              ]),

                              _buildSection('Umum', [
                                _buildDetailItem(
                                  'Laki-laki',

                                  data['umum_laki'] ?? '0',
                                ),

                                _buildDetailItem(
                                  'Perempuan',

                                  data['umum_perempuan'] ?? '0',
                                ),
                              ]),

                              _buildSection('Khusus', [
                                _buildDetailItem(
                                  'Laki-laki',

                                  data['khusus_laki'] ?? '0',
                                ),

                                _buildDetailItem(
                                  'Perempuan',

                                  data['khusus_perempuan'] ?? '0',
                                ),
                              ]),
                            ]),

                            // ================= SEKRETARIAT =================
                            _buildSection('Jumlah Tenaga Sekretariat', [
                              _buildSection('Honorer', [
                                _buildDetailItem(
                                  'Laki-laki',

                                  data['honorer_laki'] ?? '0',
                                ),

                                _buildDetailItem(
                                  'Perempuan',

                                  data['honorer_perempuan'] ?? '0',
                                ),
                              ]),

                              _buildSection('Bantuan', [
                                _buildDetailItem(
                                  'Laki-laki',

                                  data['bantuan_laki'] ?? '0',
                                ),

                                _buildDetailItem(
                                  'Perempuan',

                                  data['bantuan_perempuan'] ?? '0',
                                ),
                              ]),
                            ]),

                            // ================= KETERANGAN =================
                            _buildSection('Keterangan', [
                              _buildDetailItem(
                                'Keterangan',

                                ((data['keterangan'] ?? '').toString().trim())
                                        .isEmpty
                                    ? '-'
                                    : data['keterangan'].toString(),
                              ),
                            ]),
                          ],
                        ),
                      ),

                      SizedBox(height: 30.h),

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
                                onPressed: _isSavingDraft || uploadController.isLoading.value
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
                                  isLoading: uploadController.isLoading.value,
                                  onPressed: uploadController.isLoading.value || _isSavingDraft
                                      ? null
                                      : () async {
                                    await uploadController.submitUmumData(
                                      idUser: (data['id_user'] ?? '')
                                          .toString(),

                                      dusunLingkungan:
                                          (data['dusun_lingkungan'] ?? '')
                                              .toString(),

                                      pkkRw: (data['PKK_RW'] ?? '0').toString(),

                                      pkkRt: (data['PKK_RT'] ?? '0').toString(),

                                      desaWisma: (data['desa_wisma'] ?? '')
                                          .toString(),

                                      krt: (data['KRT'] ?? '0').toString(),

                                      kk: (data['KK'] ?? '0').toString(),

                                      jiwaLaki: (data['jiwa_laki'] ?? '0')
                                          .toString(),

                                      jiwaPerempuan:
                                          (data['jiwa_perempuan'] ?? '0')
                                              .toString(),

                                      anggotaLaki: (data['anggota_laki'] ?? '0')
                                          .toString(),

                                      anggotaPerempuan:
                                          (data['anggota_perempuan'] ?? '0')
                                              .toString(),

                                      umumLaki: (data['umum_laki'] ?? '0')
                                          .toString(),

                                      umumPerempuan:
                                          (data['umum_perempuan'] ?? '0')
                                              .toString(),

                                      khususLaki: (data['khusus_laki'] ?? '0')
                                          .toString(),

                                      khususPerempuan:
                                          (data['khusus_perempuan'] ?? '0')
                                              .toString(),

                                      honorerLaki: (data['honorer_laki'] ?? '0')
                                          .toString(),

                                      honorerPerempuan:
                                          (data['honorer_perempuan'] ?? '0')
                                              .toString(),

                                      bantuanLaki: (data['bantuan_laki'] ?? '0')
                                          .toString(),

                                      bantuanPerempuan:
                                          (data['bantuan_perempuan'] ?? '0')
                                              .toString(),

                                      idRole: (data['id_role'] ?? '')
                                          .toString(),

                                      idOrganization:
                                          (data['id_organization'] ?? '')
                                              .toString(),

                                      keterangan: (data['keterangan'] ?? '')
                                          .toString(),
                                    );

                                    // SUCCESS
                                    if (uploadController
                                        .errorMessage
                                        .value
                                        .isEmpty) {
                                      if (_editingDraft != null) {
                                        await DraftService().hapusDraft(_editingDraft!.id);
                                      }
                                      await Future.delayed(
                                        const Duration(milliseconds: 1500),
                                      );

                                      Get.offAllNamed('/main');
                                    } else if (uploadController.lastFailureWasNetwork.value && mounted) {
                                      final saveAsDraft = await Get.dialog<bool>(
                                        AlertDialog(
                                          title: const Text('Gagal terkirim'),
                                          content: const Text('Simpan sebagai draf agar isian tidak hilang?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Get.back(result: false),
                                              child: const Text('Tutup'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () => Get.back(result: true),
                                              child: const Text('Simpan Draf'),
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

  // ================= DETAIL ITEM =================

  Widget _buildDetailItem(String label, dynamic value) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Expanded(
                child: Text(
                  label,

                  style: TextStyle(fontSize: 13.sp, color: TextColors.grey600),
                ),
              ),

              SizedBox(width: 16.w),

              Flexible(
                child: Text(
                  value?.toString() ?? '',

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

  Widget _buildSection(String title, List<Widget> children) {
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
