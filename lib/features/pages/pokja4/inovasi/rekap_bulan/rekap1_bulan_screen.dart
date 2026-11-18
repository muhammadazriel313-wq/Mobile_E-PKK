/// =======================================================
/// FILE : rekap_desa_1_screen.dart
/// =======================================================

import 'package:epkk_nganjuk/common/appbar/custom_appbar.dart';
import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/common/typography.dart';

import 'package:epkk_nganjuk/core/validators/validator_form.dart';

import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:epkk_nganjuk/features/auth/component/input_form_field.dart';

import 'package:epkk_nganjuk/features/draft/button_secondary_outline.dart';
import 'package:epkk_nganjuk/features/draft/draft_badge_icon.dart';
import 'package:epkk_nganjuk/features/draft/draft_controller.dart';
import 'package:epkk_nganjuk/features/draft/draft_exit_dialog.dart';
import 'package:epkk_nganjuk/features/draft/draft_model.dart';
import 'package:epkk_nganjuk/features/draft/draft_service.dart';
import 'package:epkk_nganjuk/services/preferences/preferences_service.dart';

import 'package:epkk_nganjuk/routes/app_routes.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class RekapDesa1Screen extends StatefulWidget {
  final String? kategori;

  const RekapDesa1Screen({super.key, this.kategori});

  @override
  State<RekapDesa1Screen> createState() => _RekapDesa1ScreenState();
}

class _RekapDesa1ScreenState extends State<RekapDesa1Screen> {
  /// ================= CONTROLLER =================

  final rwController = TextEditingController();

  final rtController = TextEditingController();

  final dasaWismaController = TextEditingController();

  final hamilController = TextEditingController();

  final melahirkanController = TextEditingController();

  final nifasController = TextEditingController();

  final meninggalController = TextEditingController();

  /// ================= FORM =================

  final _formKey = GlobalKey<FormState>();

  String effectiveKategori = '';

  DraftModel? _editingDraft;

  bool _isSavingDraft = false;

  bool _allowPop = false;

  @override
  void initState() {
    super.initState();

    effectiveKategori = widget.kategori ?? '';

    final args = Get.arguments;

    if (args is Map) {
      if ((args['kategori']?.toString().isNotEmpty ?? false)) {
        effectiveKategori = args['kategori'].toString();
      }

      if (args['draft'] is DraftModel) {
        _editingDraft = args['draft'] as DraftModel;

        _populateFromDraft(_editingDraft!);
      }
    }
  }

  bool isFormEmpty() {
    return rwController.text.trim().isEmpty &&
        rtController.text.trim().isEmpty &&
        dasaWismaController.text.trim().isEmpty &&
        hamilController.text.trim().isEmpty &&
        melahirkanController.text.trim().isEmpty &&
        nifasController.text.trim().isEmpty &&
        meninggalController.text.trim().isEmpty;
  }

  void _populateFromDraft(DraftModel draft) {
    final d = draft.dataForm;

    if (d['kategori']?.toString().isNotEmpty ?? false) {
      effectiveKategori = d['kategori'].toString();
    }

    rwController.text = d['rw']?.toString() ?? '';

    rtController.text = d['rt']?.toString() ?? '';

    dasaWismaController.text = d['dasa_wisma']?.toString() ?? '';

    hamilController.text = d['hamil']?.toString() ?? '';

    melahirkanController.text = d['melahirkan']?.toString() ?? '';

    nifasController.text = d['nifas']?.toString() ?? '';

    meninggalController.text = d['meninggal']?.toString() ?? '';
  }

  Map<String, dynamic> _collectFormData() {
    final existingData = _editingDraft?.dataForm ?? <String, dynamic>{};

    return {
      ...existingData,
      'kategori': effectiveKategori,
      'rw': rwController.text.trim(),
      'rt': rtController.text.trim(),
      'dasa_wisma': dasaWismaController.text.trim(),
      'hamil': hamilController.text.trim(),
      'melahirkan': melahirkanController.text.trim(),
      'nifas': nifasController.text.trim(),
      'meninggal': meninggalController.text.trim(),
      'langkah': 1,
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

    _allowPop = true;

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

  Future<bool> _onWillPop() async {
    if (_allowPop || isFormEmpty()) return true;

    bool savedViaDialog = false;

    final shouldExit = await DraftExitDialog.show(
      context: context,
      onSaveDraft: () async {
        final saved = await _simpanDrafLaluKembali();

        if (saved) savedViaDialog = true;

        return saved;
      },
    );

    if (savedViaDialog) return false;

    if (shouldExit) {
      _allowPop = true;

      return true;
    }

    return false;
  }

  @override
  void dispose() {
    rwController.dispose();
    rtController.dispose();
    dasaWismaController.dispose();
    hamilController.dispose();
    melahirkanController.dispose();
    nifasController.dispose();
    meninggalController.dispose();

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

    return PopScope(
      canPop: false,

      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final shouldPop = await _onWillPop();

        if (shouldPop && context.mounted) {
          _allowPop = true;

          Navigator.of(context).pop();
        }
      },

      child: Scaffold(
        resizeToAvoidBottomInset: true,

        backgroundColor: Colors.white,

        appBar: AppBarPrimary(
          title: 'Rekap Desa Bulanan',

          actionWidget: DraftBadgeIcon(
            scope: DraftScope.laporan,

            arguments: {'kategori': effectiveKategori},
          ),

          onBack: () async {
            final shouldPop = await _onWillPop();

            if (shouldPop && context.mounted) {
              _allowPop = true;

              Navigator.of(context).pop();
            }
          },

          currentStep: 1,

          totalSteps: 3,
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
                          /// JUMLAH
                          /// ======================
                          sectionTitle('Jumlah'),

                          SizedBox(height: 24.h),

                          buildInput(controller: rwController, label: 'RW'),

                          buildInput(controller: rtController, label: 'RT'),

                          buildInput(
                            controller: dasaWismaController,

                            label: 'Dasa Wisma',
                          ),

                          SizedBox(height: 8.h),

                          /// ======================
                          /// JUMLAH IBU
                          /// ======================
                          sectionTitle('Jumlah Ibu'),

                          SizedBox(height: 24.h),

                          buildInput(
                            controller: hamilController,

                            label: 'Hamil',
                          ),

                          buildInput(
                            controller: melahirkanController,

                            label: 'Melahirkan',
                          ),

                          buildInput(
                            controller: nifasController,

                            label: 'Nifas',
                          ),

                          buildInput(
                            controller: meninggalController,

                            label: 'Ibu Meninggal',

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
                                          Routes.REKAP_DESA_2,

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
      ),
    );
  }
}
