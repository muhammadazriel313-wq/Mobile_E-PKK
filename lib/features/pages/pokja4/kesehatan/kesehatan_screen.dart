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

  // Kolom 3-11 Lampiran 4.24
  final kaderKesehatanController = TextEditingController();
  final kaderGiziController = TextEditingController();
  final kaderKeslingController = TextEditingController();
  final kaderPhbsController = TextEditingController();
  final kaderKbController = TextEditingController();
  final posyanduController = TextEditingController();
  final imunisasiController = TextEditingController();
  final pkgController = TextEditingController();
  final tbcController = TextEditingController();
  final catatanController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final KesehatanController uploadReportController = Get.put(
    KesehatanController(),
  );

  DraftModel? _editingDraft;
  bool _isSavingDraft = false;
  bool _allowPop = false;
  bool _closedBySave = false;

  void clearForm() {
    kaderKesehatanController.clear();
    kaderGiziController.clear();
    kaderKeslingController.clear();
    kaderPhbsController.clear();
    kaderKbController.clear();
    posyanduController.clear();
    imunisasiController.clear();
    pkgController.clear();
    tbcController.clear();
    catatanController.clear();
  }

  bool isFormEmpty() {
    return kaderKesehatanController.text.trim().isEmpty &&
        kaderGiziController.text.trim().isEmpty &&
        kaderKeslingController.text.trim().isEmpty &&
        kaderPhbsController.text.trim().isEmpty &&
        kaderKbController.text.trim().isEmpty &&
        posyanduController.text.trim().isEmpty &&
        imunisasiController.text.trim().isEmpty &&
        pkgController.text.trim().isEmpty &&
        tbcController.text.trim().isEmpty &&
        catatanController.text.trim().isEmpty;
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
    kaderKesehatanController.text = d['kader_kesehatan']?.toString() ?? '';
    kaderGiziController.text = d['kader_gizi']?.toString() ?? '';
    kaderKeslingController.text = d['kader_kesling']?.toString() ?? '';
    kaderPhbsController.text = d['kader_phbs']?.toString() ?? '';
    kaderKbController.text = d['kader_kb']?.toString() ?? '';
    // Draf lama menyimpan posyandu di kunci jumlah_posyandu.
    posyanduController.text =
        (d['posyandu'] ?? d['jumlah_posyandu'])?.toString() ?? '';
    imunisasiController.text = d['imunisasi_vaksinasi']?.toString() ?? '';
    pkgController.text = d['pkg']?.toString() ?? '';
    tbcController.text = d['tbc']?.toString() ?? '';
    catatanController.text = d['catatan']?.toString() ?? '';
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
      'kader_kesehatan': kaderKesehatanController.text.trim(),
      'kader_gizi': kaderGiziController.text.trim(),
      'kader_kesling': kaderKeslingController.text.trim(),
      'kader_phbs': kaderPhbsController.text.trim(),
      'kader_kb': kaderKbController.text.trim(),
      'posyandu': posyanduController.text.trim(),
      'imunisasi_vaksinasi': imunisasiController.text.trim(),
      'pkg': pkgController.text.trim(),
      'tbc': tbcController.text.trim(),
      'catatan': catatanController.text.trim(),
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
    kaderKesehatanController.dispose();
    kaderGiziController.dispose();
    kaderKeslingController.dispose();
    kaderPhbsController.dispose();
    kaderKbController.dispose();
    posyanduController.dispose();
    imunisasiController.dispose();
    pkgController.dispose();
    tbcController.dispose();
    catatanController.dispose();
    super.dispose();
  }

  Widget buildInput({
    required TextEditingController controller,
    required String label,
    String hintText = 'Masukkan jumlah',
    TextInputAction action = TextInputAction.next,
    bool isOptional = false,
  }) {
    return Column(
      children: [
        InputFormField(
          controller: controller,
          hintText: hintText,
          label: label,
          textInputAction: action,
          keyboardType: isOptional ? TextInputType.text : TextInputType.number,
          validator: isOptional
              ? null
              : (value) => ValidatorForm.validateDefault(value),
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
                              'Jumlah Kader',
                              color: TextColors.grey900,
                            ),
                            SizedBox(height: 24.h),

                            /// KADER KESEHATAN
                            buildInput(
                              controller: kaderKesehatanController,
                              label: 'Kader Kesehatan',
                            ),

                            /// KADER GIZI
                            buildInput(
                              controller: kaderGiziController,
                              label: 'Gizi',
                            ),

                            /// KADER KESLING
                            buildInput(
                              controller: kaderKeslingController,
                              label: 'Kesling',
                            ),

                            /// KADER PHBS
                            buildInput(
                              controller: kaderPhbsController,
                              label: 'PHBS',
                            ),

                            /// KADER KB
                            buildInput(
                              controller: kaderKbController,
                              label: 'KB',
                            ),

                            SizedBox(height: 10.h),
                            TypographyStyles.bodyCaptionSemiBold(
                              'Posyandu, Imunisasi, PKG dan TBC',
                              color: TextColors.grey900,
                            ),
                            SizedBox(height: 24.h),

                            /// POSYANDU
                            buildInput(
                              controller: posyanduController,
                              label: 'Posyandu',
                              hintText: 'Jumlah total posyandu',
                            ),

                            /// IMUNISASI / VAKSINASI
                            buildInput(
                              controller: imunisasiController,
                              label: 'Imunisasi / Vaksinasi Bayi / Balita',
                            ),

                            /// PKG
                            buildInput(
                              controller: pkgController,
                              label: 'PKG',
                              hintText: 'Pemeriksaan Kesehatan Gratis',
                            ),

                            /// TBC
                            buildInput(
                              controller: tbcController,
                              label: 'TBC',
                              hintText: 'Jumlah penderita TBC',
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
                                                  kaderKesehatan:
                                                      kaderKesehatanController
                                                          .text,
                                                  kaderGizi:
                                                      kaderGiziController.text,
                                                  kaderKesling:
                                                      kaderKeslingController
                                                          .text,
                                                  kaderPhbs:
                                                      kaderPhbsController.text,
                                                  kaderKb:
                                                      kaderKbController.text,
                                                  posyandu:
                                                      posyanduController.text,
                                                  imunisasiVaksinasi:
                                                      imunisasiController.text,
                                                  pkg: pkgController.text,
                                                  tbc: tbcController.text,
                                                  catatan:
                                                      catatanController.text,
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
