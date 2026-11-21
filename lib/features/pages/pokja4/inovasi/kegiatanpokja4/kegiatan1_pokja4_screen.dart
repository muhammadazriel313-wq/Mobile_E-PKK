/// =======================================================
/// FILE : kegiatan_pokja4_1_screen.dart
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
import 'package:epkk_nganjuk/routes/app_routes.dart';
import 'package:epkk_nganjuk/services/preferences/preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class KegiatanPokja41Screen extends StatefulWidget {
  final String? kategori;

  const KegiatanPokja41Screen({super.key, this.kategori});

  @override
  State<KegiatanPokja41Screen> createState() => _KegiatanPokja41ScreenState();
}

class _KegiatanPokja41ScreenState extends State<KegiatanPokja41Screen> {
  /// ================= CONTROLLER =================

  final kaderKesehatanController = TextEditingController();
  final giziController = TextEditingController();
  final keslingController = TextEditingController();
  final phbsController = TextEditingController();
  final kbController = TextEditingController();
  final posyanduController = TextEditingController();
  final imunisasiController = TextEditingController();
  final pkgController = TextEditingController();
  final tbcController = TextEditingController();

  /// ================= FORM =================

  final _formKey = GlobalKey<FormState>();

  String? idUser;
  String? idRole;
  String? idOrganization;
  String? fullName;
  String? nameRole;
  String? nameOrganization;
  String effectiveKategori = '';

  DraftModel? _editingDraft;
  bool _isSavingDraft = false;
  bool _allowPop = false;

  void clearForm() {
    kaderKesehatanController.clear();
    giziController.clear();
    keslingController.clear();
    phbsController.clear();
    kbController.clear();
    posyanduController.clear();
    imunisasiController.clear();
    pkgController.clear();
    tbcController.clear();
  }

  bool isFormEmpty() {
    return kaderKesehatanController.text.trim().isEmpty &&
        giziController.text.trim().isEmpty &&
        keslingController.text.trim().isEmpty &&
        phbsController.text.trim().isEmpty &&
        kbController.text.trim().isEmpty &&
        posyanduController.text.trim().isEmpty &&
        imunisasiController.text.trim().isEmpty &&
        pkgController.text.trim().isEmpty &&
        tbcController.text.trim().isEmpty;
  }

  @override
  void initState() {
    super.initState();
    effectiveKategori = widget.kategori ?? '';
    final args = Get.arguments;
    if (args is Map) {
      idUser = args['id_user']?.toString();
      fullName = args['full_name']?.toString();
      idRole = args['id_role']?.toString();
      nameRole = args['name_role']?.toString();
      idOrganization = args['id_organization']?.toString();
      nameOrganization = args['name_organization']?.toString();
      if ((args['kategori']?.toString().isNotEmpty ?? false)) {
        effectiveKategori = args['kategori'].toString();
      }
      if (args['draft'] is DraftModel) {
        _editingDraft = args['draft'] as DraftModel;
        _populateFromDraft(_editingDraft!);
      }
    }
  }

  void _populateFromDraft(DraftModel draft) {
    final d = draft.dataForm;
    if (d['kategori']?.toString().isNotEmpty ?? false) {
      effectiveKategori = d['kategori'].toString();
    }
    kaderKesehatanController.text = d['kader_kesehatan']?.toString() ?? '';
    giziController.text = d['gizi']?.toString() ?? '';
    keslingController.text = d['kesling']?.toString() ?? '';
    phbsController.text = d['phbs']?.toString() ?? '';
    kbController.text = d['kb']?.toString() ?? '';
    posyanduController.text = d['posyandu']?.toString() ?? '';
    imunisasiController.text =
        d['imunisasi_vaksinasi_bayi_balita']?.toString() ?? '';
    pkgController.text = d['pkg']?.toString() ?? '';
    tbcController.text = d['tbc']?.toString() ?? '';
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
      'kategori': effectiveKategori,
      'kader_kesehatan': kaderKesehatanController.text.trim(),
      'gizi': giziController.text.trim(),
      'kesling': keslingController.text.trim(),
      'phbs': phbsController.text.trim(),
      'kb': kbController.text.trim(),
      'posyandu': posyanduController.text.trim(),
      'imunisasi_vaksinasi_bayi_balita': imunisasiController.text.trim(),
      'pkg': pkgController.text.trim(),
      'tbc': tbcController.text.trim(),
      'langkah': 1,
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
          jenis: 'inovasi_kegiatan',
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
    kaderKesehatanController.dispose();
    giziController.dispose();
    keslingController.dispose();
    phbsController.dispose();
    kbController.dispose();
    posyanduController.dispose();
    imunisasiController.dispose();
    pkgController.dispose();
    tbcController.dispose();
    super.dispose();
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
          title: 'Kegiatan Pokja 4',
          actionWidget: DraftBadgeIcon(
            scope: DraftScope.laporan,
            arguments: {
              'id_user': idUser,
              'full_name': fullName,
              'id_role': idRole,
              'name_role': nameRole,
              'id_organization': idOrganization,
              'name_organization': nameOrganization,
              'kategori': effectiveKategori,
            },
          ),
          onBack: () async {
            final shouldPop = await _onWillPop();
            if (shouldPop && mounted) {
              _allowPop = true;
              Navigator.of(context).pop();
            }
          },
          currentStep: 1,
          totalSteps: 5,
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
                            /// KESEHATAN MASYARAKAT
                            /// ======================
                            TypographyStyles.bodyCaptionSemiBold(
                              'Kesehatan Masyarakat',
                              color: TextColors.grey900,
                            ),
                            SizedBox(height: 24.h),
                            _inputField(
                              controller: kaderKesehatanController,
                              label: 'Kader Kesehatan',
                            ),
                            _space(),
                            _inputField(
                              controller: giziController,
                              label: 'Gizi',
                            ),
                            _space(),
                            _inputField(
                              controller: keslingController,
                              label: 'Kesling',
                            ),
                            _space(),
                            _inputField(
                              controller: phbsController,
                              label: 'PHBS',
                            ),
                            _space(),
                            _inputField(
                              controller: kbController,
                              label: 'KB',
                            ),
                            _space(),
                            _inputField(
                              controller: posyanduController,
                              label: 'Posyandu',
                            ),
                            _space(),
                            _inputField(
                              controller: imunisasiController,
                              label: 'Imunisasi Vaksinasi Bayi Balita',
                            ),
                            _space(),
                            _inputField(controller: pkgController, label: 'PKG'),
                            _space(),
                            _inputField(controller: tbcController, label: 'TBC'),
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
                                            'id_user': idUser,
                                            'full_name': fullName,
                                            'id_role': idRole,
                                            'name_role': nameRole,
                                            'id_organization': idOrganization,
                                            'name_organization':
                                                nameOrganization,
                                            'kategori': effectiveKategori,
                                            'kader_kesehatan':
                                                kaderKesehatanController.text,
                                            'gizi': giziController.text,
                                            'kesling': keslingController.text,
                                            'phbs': phbsController.text,
                                            'kb': kbController.text,
                                            'posyandu': posyanduController.text,
                                            'imunisasi_vaksinasi_bayi_balita':
                                                imunisasiController.text,
                                            'pkg': pkgController.text,
                                            'tbc': tbcController.text,
                                            if (_editingDraft != null)
                                              'draft': _editingDraft,
                                          };
                                          Get.toNamed(
                                            Routes.KEGIATAN_POKJA4_2,
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
  /// INPUT FIELD
  /// ======================

  Widget _inputField({
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

  /// ======================
  /// SPACE
  /// ======================

  Widget _space() => SizedBox(height: 20.h);
}
