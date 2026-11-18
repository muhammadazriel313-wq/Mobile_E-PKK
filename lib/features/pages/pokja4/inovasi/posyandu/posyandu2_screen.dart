/// =======================================================
/// FILE : posyandu_2_screen.dart
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
import 'package:epkk_nganjuk/routes/app_routes.dart';
import 'package:epkk_nganjuk/services/preferences/preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class Posyandu2Screen extends StatefulWidget {
  const Posyandu2Screen({super.key});

  @override
  State<Posyandu2Screen> createState() => _Posyandu2ScreenState();
}

class _Posyandu2ScreenState extends State<Posyandu2Screen> {
  /// ================= ARGUMENT =================

  late Map<String, dynamic> data;

  /// ================= CONTROLLER =================

  final kondomController = TextEditingController();
  final pilController = TextEditingController();
  final implantController = TextEditingController();
  final mopController = TextEditingController();
  final mowController = TextEditingController();
  final iudController = TextEditingController();
  final suntikanController = TextEditingController();
  final lainController = TextEditingController();

  /// ================= FORM =================

  final _formKey = GlobalKey<FormState>();

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
        _populateFromDraft(_editingDraft!);
      }
    } else {
      data = {};
    }
  }

  void _populateFromDraft(DraftModel draft) {
    final d = draft.dataForm;
    kondomController.text = d['kondom']?.toString() ?? '';
    pilController.text = d['pil']?.toString() ?? '';
    implantController.text = d['implant']?.toString() ?? '';
    mopController.text = d['mop']?.toString() ?? '';
    mowController.text = d['mow']?.toString() ?? '';
    iudController.text = d['iud']?.toString() ?? '';
    suntikanController.text = d['suntikan']?.toString() ?? '';
    lainController.text = d['lain_lain_kb']?.toString() ?? '';
  }

  Map<String, dynamic> _collectFormData() {
    final existingData = _editingDraft?.dataForm ?? <String, dynamic>{};
    return {
      ...existingData,
      ...data,
      'kondom': kondomController.text.trim(),
      'pil': pilController.text.trim(),
      'implant': implantController.text.trim(),
      'mop': mopController.text.trim(),
      'mow': mowController.text.trim(),
      'iud': iudController.text.trim(),
      'suntikan': suntikanController.text.trim(),
      'lain_lain_kb': lainController.text.trim(),
      'langkah': 2,
    };
  }

  Future<bool> _simpanDraf({bool showFeedback = true}) async {
    if (_isSavingDraft) return false;
    setState(() => _isSavingDraft = true);
    try {
      final user = await PreferencesService.getUser();
      final idAkun = user?.id.toString() ?? data['id_user']?.toString() ?? '';
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
          jenis: 'inovasi_posyandu',
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
  void dispose() {
    kondomController.dispose();
    pilController.dispose();
    implantController.dispose();
    mopController.dispose();
    mowController.dispose();
    iudController.dispose();
    suntikanController.dispose();
    lainController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    final isTablet = media.size.width >= 600;

    return Scaffold(
      resizeToAvoidBottomInset: true,

      backgroundColor: Colors.white,

      appBar: AppBarSecondary(
        title: 'Posyandu',

        currentStep: 2,

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
                      maxWidth: isTablet ? 650 : double.infinity,

                      minHeight: constraints.maxHeight,
                    ),

                    child: Form(
                      key: _formKey,

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          /// ======================
                          /// KB
                          /// ======================
                          TypographyStyles.bodyCaptionSemiBold(
                            'KB',

                            color: TextColors.grey900,
                          ),

                          SizedBox(height: 24.h),

                          _inputNumber(
                            controller: kondomController,

                            label: 'Kondom',
                          ),

                          SizedBox(height: 20.h),

                          _inputNumber(controller: pilController, label: 'Pil'),

                          SizedBox(height: 20.h),

                          _inputNumber(
                            controller: implantController,

                            label: 'Implant',
                          ),

                          SizedBox(height: 20.h),

                          _inputNumber(controller: mopController, label: 'MOP'),

                          SizedBox(height: 20.h),

                          _inputNumber(controller: mowController, label: 'MOW'),

                          SizedBox(height: 20.h),

                          _inputNumber(controller: iudController, label: 'IUD'),

                          SizedBox(height: 20.h),

                          _inputNumber(
                            controller: suntikanController,

                            label: 'Suntikan',
                          ),

                          SizedBox(height: 20.h),

                          _inputNumber(
                            controller: lainController,

                            label: 'Lain - lain',
                          ),

                          SizedBox(height: 30.h),

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
                                        : () async =>
                                            _simpanDrafLaluKembali(),
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
                                        final nextArgs = {
                                          ...data,
                                          'kondom': kondomController.text,
                                          'pil': pilController.text,
                                          'implant': implantController.text,
                                          'mop': mopController.text,
                                          'mow': mowController.text,
                                          'iud': iudController.text,
                                          'suntikan': suntikanController.text,
                                          'lain_lain_kb': lainController.text,
                                          if (_editingDraft != null)
                                            'draft': _editingDraft,
                                        };
                                        Get.toNamed(
                                          Routes.POSYANDU_3,
                                          arguments: nextArgs,
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

  /// ======================
  /// INPUT NUMBER
  /// ======================

  Widget _inputNumber({
    required TextEditingController controller,

    required String label,
  }) {
    return InputFormField(
      controller: controller,

      hintText: 'Masukkan jumlah',

      label: label,

      keyboardType: TextInputType.number,

      textInputAction: TextInputAction.next,

      validator: (value) {
        return ValidatorForm.validateNumber(value);
      },
    );
  }
}
