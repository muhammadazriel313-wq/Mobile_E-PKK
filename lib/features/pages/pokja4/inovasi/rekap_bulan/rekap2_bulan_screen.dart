/// =======================================================
/// FILE : rekap_desa_2_screen.dart
/// =======================================================

import 'package:epkk_nganjuk/common/appbar/custom_appbar.dart';
import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/common/typography.dart';

import 'package:epkk_nganjuk/core/validators/validator_form.dart';

import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:epkk_nganjuk/features/auth/component/input_form_field.dart';

import 'package:epkk_nganjuk/features/draft/button_secondary_outline.dart';
import 'package:epkk_nganjuk/features/draft/draft_controller.dart';
import 'package:epkk_nganjuk/features/draft/draft_model.dart';
import 'package:epkk_nganjuk/features/draft/draft_service.dart';
import 'package:epkk_nganjuk/services/preferences/preferences_service.dart';

import 'package:epkk_nganjuk/routes/app_routes.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class RekapDesa2Screen extends StatefulWidget {
  const RekapDesa2Screen({super.key});

  @override
  State<RekapDesa2Screen> createState() => _RekapDesa2ScreenState();
}

class _RekapDesa2ScreenState extends State<RekapDesa2Screen> {
  late Map<String, dynamic> args;

  /// ================= CONTROLLER =================

  final bayiLahirLController = TextEditingController();

  final bayiLahirPController = TextEditingController();

  final akteAdaController = TextEditingController();

  final akteTidakController = TextEditingController();

  final bayiMeninggalLController = TextEditingController();

  final bayiMeninggalPController = TextEditingController();

  final balitaMeninggalLController = TextEditingController();

  final balitaMeninggalPController = TextEditingController();

  /// ================= FORM =================

  final _formKey = GlobalKey<FormState>();

  String effectiveKategori = '';

  DraftModel? _editingDraft;

  bool _isSavingDraft = false;

  @override
  void initState() {
    super.initState();

    args = {};

    final rawArgs = Get.arguments;

    if (rawArgs is Map) {
      args = Map<String, dynamic>.from(rawArgs);
    }

    if (args['kategori']?.toString().isNotEmpty ?? false) {
      effectiveKategori = args['kategori'].toString();
    }

    if (args['draft'] is DraftModel) {
      _editingDraft = args['draft'] as DraftModel;

      _populateFromDraft(_editingDraft!);
    }
  }

  void _populateFromDraft(DraftModel draft) {
    final d = draft.dataForm;

    if (d['kategori']?.toString().isNotEmpty ?? false) {
      effectiveKategori = d['kategori'].toString();
    }

    bayiLahirLController.text = d['bayi_lahir_l']?.toString() ?? '';

    bayiLahirPController.text = d['bayi_lahir_p']?.toString() ?? '';

    akteAdaController.text = d['akte_kelahiran_ada']?.toString() ?? '';

    akteTidakController.text = d['akte_kelahiran_tidak']?.toString() ?? '';

    bayiMeninggalLController.text = d['bayi_meninggal_l']?.toString() ?? '';

    bayiMeninggalPController.text = d['bayi_meninggal_p']?.toString() ?? '';

    balitaMeninggalLController.text =
        d['balita_meninggal_l']?.toString() ?? '';

    balitaMeninggalPController.text =
        d['balita_meninggal_p']?.toString() ?? '';
  }

  Map<String, dynamic> _collectFormData() {
    final existingData = _editingDraft?.dataForm ?? <String, dynamic>{};

    return {
      ...existingData,
      'kategori': effectiveKategori,
      'rw': args['rw']?.toString() ?? existingData['rw']?.toString() ?? '',
      'rt': args['rt']?.toString() ?? existingData['rt']?.toString() ?? '',
      'dasa_wisma':
          args['dasa_wisma']?.toString() ??
          existingData['dasa_wisma']?.toString() ??
          '',
      'hamil': args['hamil']?.toString() ?? existingData['hamil']?.toString() ?? '',
      'melahirkan':
          args['melahirkan']?.toString() ??
          existingData['melahirkan']?.toString() ??
          '',
      'nifas': args['nifas']?.toString() ?? existingData['nifas']?.toString() ?? '',
      'meninggal':
          args['meninggal']?.toString() ??
          existingData['meninggal']?.toString() ??
          '',
      'bayi_lahir_l': bayiLahirLController.text.trim(),
      'bayi_lahir_p': bayiLahirPController.text.trim(),
      'akte_kelahiran_ada': akteAdaController.text.trim(),
      'akte_kelahiran_tidak': akteTidakController.text.trim(),
      'bayi_meninggal_l': bayiMeninggalLController.text.trim(),
      'bayi_meninggal_p': bayiMeninggalPController.text.trim(),
      'balita_meninggal_l': balitaMeninggalLController.text.trim(),
      'balita_meninggal_p': balitaMeninggalPController.text.trim(),
      'langkah': 2,
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
          jenis: 'inovasi_rekap_bulanan',
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
  void dispose() {
    bayiLahirLController.dispose();
    bayiLahirPController.dispose();
    akteAdaController.dispose();
    akteTidakController.dispose();
    bayiMeninggalLController.dispose();
    bayiMeninggalPController.dispose();
    balitaMeninggalLController.dispose();
    balitaMeninggalPController.dispose();

    super.dispose();
  }

  Widget sectionTitle(String title) {
    return TypographyStyles.bodyCaptionSemiBold(
      title,
      color: TextColors.grey900,
    );
  }

  Widget buildInput({
    required TextEditingController controller,

    required String label,

    TextInputAction action = TextInputAction.next,
  }) {
    return Column(
      children: [
        InputFormField(
          controller: controller,

          hintText: 'Masukkan jumlah',

          label: label,

          keyboardType: TextInputType.number,

          textInputAction: action,

          validator: (value) {
            return ValidatorForm.validateNumber(value);
          },
        ),

        SizedBox(height: 20.h),
      ],
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
        title: 'Rekap Desa Bulanan',

        currentStep: 2,

        totalSteps: 3,

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
                      maxWidth: isTablet ? 650 : double.infinity,

                      minHeight: constraints.maxHeight,
                    ),

                    child: Form(
                      key: _formKey,

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          /// ======================
                          /// JUMLAH BAYI
                          /// ======================
                          sectionTitle('Jumlah Bayi'),

                          SizedBox(height: 24.h),

                          buildInput(
                            controller: bayiLahirLController,

                            label: 'Bayi Lahir L',
                          ),

                          buildInput(
                            controller: bayiLahirPController,

                            label: 'Bayi Lahir P',
                          ),

                          SizedBox(height: 8.h),

                          /// ======================
                          /// AKTE
                          /// ======================
                          sectionTitle('Akte Kelahiran'),

                          SizedBox(height: 24.h),

                          buildInput(
                            controller: akteAdaController,

                            label: 'Akte Kelahiran Ada',
                          ),

                          buildInput(
                            controller: akteTidakController,

                            label: 'Akte Kelahiran Tidak',
                          ),

                          SizedBox(height: 8.h),

                          /// ======================
                          /// BAYI MENINGGAL
                          /// ======================
                          sectionTitle('Bayi Meninggal'),

                          SizedBox(height: 24.h),

                          buildInput(
                            controller: bayiMeninggalLController,

                            label: 'Bayi Meninggal L',
                          ),

                          buildInput(
                            controller: bayiMeninggalPController,

                            label: 'Bayi Meninggal P',
                          ),

                          SizedBox(height: 8.h),

                          /// ======================
                          /// BALITA MENINGGAL
                          /// ======================
                          sectionTitle('Balita Meninggal'),

                          SizedBox(height: 24.h),

                          buildInput(
                            controller: balitaMeninggalLController,

                            label: 'Balita Meninggal L',
                          ),

                          buildInput(
                            controller: balitaMeninggalPController,

                            label: 'Balita Meninggal P',

                            action: TextInputAction.done,
                          ),

                          SizedBox(height: 10.h),

                          /// ======================
                          /// BUTTON
                          /// ======================
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
                                child: ZoomTapAnimation(
                                  child: ButtonFill(
                                    text: 'Lanjut',

                                    textColor: Colors.white,

                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        Get.toNamed(
                                          Routes.REKAP_DESA_3,

                                          arguments: {
                                            ..._collectFormData(),

                                            if (_editingDraft != null)
                                              'draft': _editingDraft,
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
                            ],
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
