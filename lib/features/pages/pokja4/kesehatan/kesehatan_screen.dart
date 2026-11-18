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
import 'package:epkk_nganjuk/features/pages/pokja4/kesehatan/kesehatan_controller.dart';
import 'package:epkk_nganjuk/services/preferences/preferences_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class KesehatanScreen extends StatefulWidget {
  const KesehatanScreen({super.key});

  @override
  State<KesehatanScreen> createState() => _KesehatanScreenState();
}

class _KesehatanScreenState extends State<KesehatanScreen> {
  String? idUser;
  String? idRole;
  String? idOrganization;
  String? fullName;
  String? nameRole;
  String? nameOrganization;

  final posyanduJumlahController = TextEditingController();
  final posyanduTintegrasiController = TextEditingController();
  final lansiaKlpController = TextEditingController();
  final lansiaAnggotaController = TextEditingController();
  final lansiaKartuController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final KesehatanController uploadReportController = Get.put(
    KesehatanController(),
  );

  DraftModel? _editingDraft;
  bool _isSavingDraft = false;
  bool _allowPop = false;
  bool _closedBySave = false;

  void clearForm() {
    posyanduJumlahController.clear();
    posyanduTintegrasiController.clear();
    lansiaKlpController.clear();
    lansiaAnggotaController.clear();
    lansiaKartuController.clear();
  }

  bool isFormEmpty() {
    return posyanduJumlahController.text.trim().isEmpty &&
        posyanduTintegrasiController.text.trim().isEmpty &&
        lansiaKlpController.text.trim().isEmpty &&
        lansiaAnggotaController.text.trim().isEmpty &&
        lansiaKartuController.text.trim().isEmpty;
  }

  @override
  void initState() {
    super.initState();

    final args = Get.arguments;
    if (args is Map) {
      idUser = args['id_user']?.toString();
      fullName = args['full_name']?.toString();
      idRole = args['id_role']?.toString();
      nameRole = args['name_role']?.toString();
      idOrganization = args['id_organization']?.toString();
      nameOrganization = args['name_organization']?.toString();

      if (args['draft'] is DraftModel) {
        _editingDraft = args['draft'] as DraftModel;
        _populateFromDraft(_editingDraft!);
      }
    }
  }

  void _populateFromDraft(DraftModel draft) {
    final d = draft.dataForm;
    posyanduJumlahController.text = d['jumlah_posyandu']?.toString() ?? '';
    posyanduTintegrasiController.text =
        d['jumlah_posyandu_iterasi']?.toString() ?? '';
    lansiaKlpController.text = d['jumlah_klp']?.toString() ?? '';
    lansiaAnggotaController.text = d['jumlah_anggota']?.toString() ?? '';
    lansiaKartuController.text = d['jumlah_kartu_gratis']?.toString() ?? '';
  }

  Map<String, dynamic> _collectFormData() {
    final existingData = _editingDraft?.dataForm ?? <String, dynamic>{};
    return {
      ...existingData,
      'id_user': idUser ?? '',
      'id_role': idRole ?? '',
      'id_organization': idOrganization ?? '',
      'full_name': fullName ?? '',
      'name_role': nameRole ?? '',
      'name_organization': nameOrganization ?? '',
      'jumlah_posyandu': posyanduJumlahController.text.trim(),
      'jumlah_posyandu_iterasi': posyanduTintegrasiController.text.trim(),
      'jumlah_klp': lansiaKlpController.text.trim(),
      'jumlah_anggota': lansiaAnggotaController.text.trim(),
      'jumlah_kartu_gratis': lansiaKartuController.text.trim(),
    };
  }

  Future<bool> _simpanDraf({bool showFeedback = true}) async {
    if (_isSavingDraft) return false;
    setState(() => _isSavingDraft = true);
    try {
      final user = await PreferencesService.getUser();
      final idAkun = user?.id.toString() ?? idUser ?? '';
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
          jenis: 'kesehatan',
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
    _closedBySave = true;
    _allowPop = true;
    Get.closeAllSnackbars();
    if (mounted) Navigator.of(context).pop();
    Future.delayed(const Duration(milliseconds: 150), _showSnackbarDrafDisimpan);
    return true;
  }

  Future<bool> _onWillPop() async {
    if (_closedBySave) return false;
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
    posyanduJumlahController.dispose();
    posyanduTintegrasiController.dispose();
    lansiaKlpController.dispose();
    lansiaAnggotaController.dispose();
    lansiaKartuController.dispose();
    super.dispose();
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
        if (didPop || _closedBySave) return;
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
          title: 'Kesehatan',
          actionWidget: DraftBadgeIcon(
            scope: DraftScope.laporan,
            arguments: {
              'id_user': idUser,
              'full_name': fullName,
              'id_role': idRole,
              'name_role': nameRole,
              'id_organization': idOrganization,
              'name_organization': nameOrganization,
            },
          ),
          onBack: () async {
            if (_closedBySave) return;
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
                            SizedBox(height: 6.h),
                            TypographyStyles.bodyCaptionSemiBold(
                              'Posyandu',
                              color: TextColors.grey900,
                            ),
                            SizedBox(height: 24.h),

                            /// POSYANDU JUMLAH
                            buildInput(
                              controller: posyanduJumlahController,
                              label: 'Jumlah Posyandu',
                            ),

                            /// POSYANDU TERINTEGRASI
                            buildInput(
                              controller: posyanduTintegrasiController,
                              label: 'Jumlah Posyandu Terintegrasi',
                            ),

                            SizedBox(height: 10.h),
                            TypographyStyles.bodyCaptionSemiBold(
                              'Kelompok Lansia',
                              color: TextColors.grey900,
                            ),
                            SizedBox(height: 24.h),

                            /// LANSIA KLP
                            buildInput(
                              controller: lansiaKlpController,
                              label: 'Jumlah Kelompok',
                            ),

                            /// LANSIA ANGGOTA
                            buildInput(
                              controller: lansiaAnggotaController,
                              label: 'Jumlah Anggota',
                            ),

                            /// LANSIA KARTU GRATIS
                            buildInput(
                              controller: lansiaKartuController,
                              label:
                                  'Jumlah yang Memiliki Kartu Berobat Gratis',
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
                                            ? 'Loading...'
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

                                                if (!isFormValid) {
                                                  Get.snackbar(
                                                    'Error',
                                                    'Form tidak valid! Mohon periksa kembali input Anda.',
                                                    snackPosition:
                                                        SnackPosition.TOP,
                                                    backgroundColor:
                                                        Colors.orange,
                                                    colorText: Colors.white,
                                                  );
                                                  return;
                                                }

                                                final success =
                                                    await uploadReportController
                                                        .submitKesehatanData(
                                                  idUser: idUser ?? '',
                                                  jumlahPosyandu:
                                                      posyanduJumlahController
                                                          .text,
                                                  jumlahPosyanduIterasi:
                                                      posyanduTintegrasiController
                                                          .text,
                                                  jumlahKip: lansiaKlpController
                                                      .text,
                                                  jumlahAnggota:
                                                      lansiaAnggotaController
                                                          .text,
                                                  jumlahKartuGratis:
                                                      lansiaKartuController
                                                          .text,
                                                  idRole: idRole ?? '',
                                                  idOrganization:
                                                      idOrganization ?? '',
                                                );

                                                if (success) {
                                                  if (_editingDraft != null) {
                                                    await DraftService()
                                                        .hapusDraft(
                                                      _editingDraft!.id,
                                                    );
                                                  }
                                                  _formKey.currentState?.reset();
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
