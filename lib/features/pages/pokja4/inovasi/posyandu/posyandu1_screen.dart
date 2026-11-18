/// =======================================================
/// FILE : posyandu_1_screen.dart
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
import 'package:epkk_nganjuk/features/pages/pokja4/inovasi/component/dropdown_bulan.dart';
import 'package:epkk_nganjuk/routes/app_routes.dart';
import 'package:epkk_nganjuk/services/preferences/preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class Posyandu1Screen extends StatefulWidget {
  final String kategori;

  const Posyandu1Screen({super.key, required this.kategori});

  @override
  State<Posyandu1Screen> createState() => _Posyandu1ScreenState();
}

class _Posyandu1ScreenState extends State<Posyandu1Screen> {
  /// ======================
  /// BULAN
  /// ======================

  String? selectedBulan;

  /// ======================
  /// CONTROLLER
  /// ======================

  final jmlIbuHamilController = TextEditingController();
  final diperiksaController = TextEditingController();
  final feTabletDarahController = TextEditingController();
  final jmlIbuMenyusuiController = TextEditingController();

  /// ======================
  /// FORM
  /// ======================

  final _formKey = GlobalKey<FormState>();

  DraftModel? _editingDraft;
  bool _isSavingDraft = false;

  @override
  void initState() {
    super.initState();

    final args = Get.arguments;
    if (args is Map && args['draft'] is DraftModel) {
      _editingDraft = args['draft'] as DraftModel;
      _populateFromDraft(_editingDraft!);
    }
  }

  void _populateFromDraft(DraftModel draft) {
    final d = draft.dataForm;
    selectedBulan = d['bulan']?.toString();
    jmlIbuHamilController.text = d['jml_ibu_hamil']?.toString() ?? '';
    diperiksaController.text = d['diperiksa']?.toString() ?? '';
    feTabletDarahController.text = d['fe_tablet_darah']?.toString() ?? '';
    jmlIbuMenyusuiController.text = d['jml_ibu_menyusui']?.toString() ?? '';
  }

  bool _isFormDirty() {
    return (selectedBulan != null && selectedBulan!.isNotEmpty) ||
        jmlIbuHamilController.text.trim().isNotEmpty ||
        diperiksaController.text.trim().isNotEmpty ||
        feTabletDarahController.text.trim().isNotEmpty ||
        jmlIbuMenyusuiController.text.trim().isNotEmpty;
  }

  Map<String, dynamic> _collectFormData() {
    final existingData = _editingDraft?.dataForm ?? <String, dynamic>{};
    return {
      ...existingData,
      'kategori': widget.kategori.isNotEmpty
          ? widget.kategori
          : (existingData['kategori'] ?? ''),
      'bulan': selectedBulan ?? '',
      'jml_ibu_hamil': jmlIbuHamilController.text.trim(),
      'diperiksa': diperiksaController.text.trim(),
      'fe_tablet_darah': feTabletDarahController.text.trim(),
      'jml_ibu_menyusui': jmlIbuMenyusuiController.text.trim(),
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

  bool _allowPop = false;

  Future<bool> _simpanDrafLaluKembali() async {
    if (!await _simpanDraf(showFeedback: false)) return false;
    _allowPop = true;
    Get.closeAllSnackbars();
    Get.until((route) => route.settings.name == Routes.HOME || route.isFirst);
    Future.delayed(const Duration(milliseconds: 150), _showSnackbarDrafDisimpan);
    return true;
  }

  Future<bool> _onWillPop() async {
    if (_allowPop || !_isFormDirty()) return true;
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
    jmlIbuHamilController.dispose();
    diperiksaController.dispose();
    feTabletDarahController.dispose();
    jmlIbuMenyusuiController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    final isTablet = media.size.width >= 600;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, dynamic result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && mounted) {
          _allowPop = true;
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,

        backgroundColor: Colors.white,

        appBar: AppBarPrimary(
          title: 'Posyandu',

          currentStep: 1,

          totalSteps: 5,

          actionWidget: const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: DraftBadgeIcon(scope: DraftScope.laporan),
          ),

          onBack: () async {
            final shouldPop = await _onWillPop();
            if (shouldPop && mounted) {
              _allowPop = true;
              Navigator.of(context).pop();
            }
          },
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
                            /// IBU HAMIL
                            /// ======================
                            TypographyStyles.bodyCaptionSemiBold(
                              'Ibu Hamil',

                              color: TextColors.grey900,
                            ),

                            SizedBox(height: 24.h),

                            /// ======================
                            /// DROPDOWN BULAN
                            /// ======================
                            DropdownBulan(
                              value: selectedBulan,

                              onChanged: (value) {
                                setState(() {
                                  selectedBulan = value;
                                });
                              },
                            ),

                            /// ======================
                            /// VALIDASI BULAN
                            /// ======================
                            if (selectedBulan == null)
                              Padding(
                                padding: EdgeInsets.only(top: 8.h, left: 4.w),

                                child: Text(
                                  'Bulan wajib dipilih',

                                  style: TextStyle(
                                    fontSize: 12.sp,

                                    color: Colors.red,
                                  ),
                                ),
                              ),

                            SizedBox(height: 20.h),

                            /// ======================
                            /// JUMLAH IBU HAMIL
                            /// ======================
                            _inputNumber(
                              controller: jmlIbuHamilController,

                              label: 'Jumlah Ibu Hamil',
                            ),

                            SizedBox(height: 20.h),

                            /// ======================
                            /// DIPERIKSA
                            /// ======================
                            _inputNumber(
                              controller: diperiksaController,

                              label: 'Diperiksa',
                            ),

                            SizedBox(height: 20.h),

                            /// ======================
                            /// FE TABLET DARAH
                            /// ======================
                            _inputNumber(
                              controller: feTabletDarahController,

                              label: 'FE Tablet Darah',
                            ),

                            SizedBox(height: 20.h),

                            /// ======================
                            /// IBU MENYUSUI
                            /// ======================
                            _inputNumber(
                              controller: jmlIbuMenyusuiController,

                              label: 'Jumlah Ibu Menyusui',
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
                                        /// ======================
                                        /// VALIDASI BULAN
                                        /// ======================
                                        if (selectedBulan == null) {
                                          setState(() {});
                                          Get.snackbar(
                                            'Error',
                                            'Bulan wajib dipilih',
                                            snackPosition: SnackPosition.TOP,
                                            backgroundColor: Colors.red,
                                            colorText: Colors.white,
                                          );
                                          return;
                                        }

                                        /// ======================
                                        /// VALIDASI FORM
                                        /// ======================
                                        if (_formKey.currentState!.validate()) {
                                          final nextArgs = {
                                            'kategori': widget.kategori,
                                            'bulan': selectedBulan,
                                            'jml_ibu_hamil':
                                                jmlIbuHamilController.text,
                                            'diperiksa':
                                                diperiksaController.text,
                                            'fe_tablet_darah':
                                                feTabletDarahController.text,
                                            'jml_ibu_menyusui':
                                                jmlIbuMenyusuiController.text,
                                            if (_editingDraft != null)
                                              'draft': _editingDraft,
                                          };
                                          Get.toNamed(
                                            Routes.POSYANDU_2,
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
