import 'package:epkk_nganjuk/common/appbar/custom_appbar.dart';
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
import 'package:epkk_nganjuk/features/pages/pokja3/sandang/sandang_controller.dart';
import 'package:epkk_nganjuk/routes/app_routes.dart';
import 'package:epkk_nganjuk/services/preferences/preferences_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class SandangScreen extends StatefulWidget {
  const SandangScreen({super.key});

  @override
  State<SandangScreen> createState() => _SandangScreenState();
}

class _SandangScreenState extends State<SandangScreen> {
  String? id_user;
  String? id_role;
  String? id_organization;
  String? full_name;
  String? name_role;
  String? name_organization;

  final panganController = TextEditingController();
  final sandangController = TextEditingController();
  final jasaController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final SandangController uploadReportController = Get.put(SandangController());

  DraftModel? _editingDraft;
  bool _isSavingDraft = false;
  bool _allowPop = false;

  void clearForm() {
    panganController.clear();
    sandangController.clear();
    jasaController.clear();
  }

  bool isFormEmpty() {
    return panganController.text.trim().isEmpty &&
        sandangController.text.trim().isEmpty &&
        jasaController.text.trim().isEmpty;
  }

  @override
  void initState() {
    super.initState();

    final args = Get.arguments;
    if (args is Map) {
      id_user = args['id_user']?.toString();
      full_name = args['full_name']?.toString();
      id_role = args['id_role']?.toString();
      name_role = args['name_role']?.toString();
      id_organization = args['id_organization']?.toString();
      name_organization = args['name_organization']?.toString();

      if (args['draft'] is DraftModel) {
        _editingDraft = args['draft'] as DraftModel;
        _populateFromDraft(_editingDraft!);
      }
    }
  }

  void _populateFromDraft(DraftModel draft) {
    final d = draft.dataForm;
    panganController.text = d['pangan']?.toString() ?? '';
    sandangController.text = d['sandang']?.toString() ?? '';
    jasaController.text = d['jasa']?.toString() ?? '';
  }

  Map<String, dynamic> _collectFormData() {
    final existingData = _editingDraft?.dataForm ?? <String, dynamic>{};
    return {
      ...existingData,
      'id_user': id_user ?? '',
      'id_role': id_role ?? '',
      'id_organization': id_organization ?? '',
      'full_name': full_name ?? '',
      'name_role': name_role ?? '',
      'name_organization': name_organization ?? '',
      'pangan': panganController.text.trim(),
      'sandang': sandangController.text.trim(),
      'jasa': jasaController.text.trim(),
    };
  }

  Future<bool> _simpanDraf({bool showFeedback = true}) async {
    if (_isSavingDraft) return false;
    setState(() => _isSavingDraft = true);
    try {
      final user = await PreferencesService.getUser();
      final idAkun = user?.id?.toString() ?? id_user ?? '';
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
          jenis: 'sandang',
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
    Get.until((route) => route.settings.name == Routes.HOME || route.isFirst);
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
      clearForm();
      _allowPop = true;
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    panganController.dispose();
    sandangController.dispose();
    jasaController.dispose();
    super.dispose();
  }

  Widget inputField({
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
          textInputAction: action,
          keyboardType: TextInputType.number,
          validator: (value) => ValidatorForm.validateDefault(value),
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
        if (shouldPop && mounted) {
          _allowPop = true;
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBarPrimary(
          title: 'Industri Rumah Tangga',
          actionWidget: DraftBadgeIcon(
            scope: DraftScope.laporan,
            arguments: {
              'id_user': id_user,
              'full_name': full_name,
              'id_role': id_role,
              'name_role': name_role,
              'id_organization': id_organization,
              'name_organization': name_organization,
            },
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
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.only(
                    left: isTablet ? 40.w : 16.w,
                    right: isTablet ? 40.w : 16.w,
                    top: 20.h,
                    bottom: media.viewInsets.bottom + 20.h,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isTablet ? 600 : double.infinity,
                        minHeight: constraints.maxHeight,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20.h),

                            /// PANGAN
                            inputField(
                              controller: panganController,
                              label: 'Pangan',
                            ),

                            /// SANDANG
                            inputField(
                              controller: sandangController,
                              label: 'Sandang',
                            ),

                            /// JASA
                            inputField(
                              controller: jasaController,
                              label: 'Jasa',
                              action: TextInputAction.done,
                            ),

                            SizedBox(height: 10.h),

                            /// BUTTON
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
                                              uploadReportController
                                                  .isLoading.value
                                          ? null
                                          : () async =>
                                              _simpanDrafLaluKembali(),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: ZoomTapAnimation(
                                    child: Obx(
                                      () => ButtonFill(
                                        text: uploadReportController
                                                .isLoading.value
                                            ? 'Loading'
                                            : 'Kirim',
                                        textColor: Colors.white,
                                        onPressed: uploadReportController
                                                .isLoading.value ||
                                                _isSavingDraft
                                            ? null
                                            : () async {
                                                final isFormValid = _formKey
                                                    .currentState!
                                                    .validate();

                                                if (isFormValid) {
                                                  final success =
                                                      await uploadReportController
                                                          .submitDataSandang(
                                                    pangan:
                                                        panganController.text,
                                                    sandang:
                                                        sandangController.text,
                                                    jasa: jasaController.text,
                                                    idRole: id_role ?? '',
                                                    idOrganization:
                                                        id_organization ?? '',
                                                    idUser: id_user ?? '',
                                                  );

                                                  if (success) {
                                                    if (_editingDraft !=
                                                        null) {
                                                      await DraftService()
                                                          .hapusDraft(
                                                        _editingDraft!.id,
                                                      );
                                                    }
                                                    _formKey.currentState
                                                        ?.reset();
                                                    clearForm();
                                                    Get.offAllNamed('/main');
                                                  } else if (uploadReportController
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
                                                            onPressed: () =>
                                                                Get.back(
                                                              result: false,
                                                            ),
                                                            child: const Text(
                                                                'Tutup'),
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
