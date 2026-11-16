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
import 'package:epkk_nganjuk/features/pages/pokja3/jumlah_kader/kader_pokja3_controller.dart';
import 'package:epkk_nganjuk/routes/app_routes.dart';
import 'package:epkk_nganjuk/services/preferences/preferences_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class KaderPokja3Screen extends StatefulWidget {
  const KaderPokja3Screen({super.key});

  @override
  State<KaderPokja3Screen> createState() => _KaderPokja3ScreenState();
}

class _KaderPokja3ScreenState extends State<KaderPokja3Screen> {
  String? idUser;
  String? idRole;
  String? idOrganization;
  String? fullName;
  String? nameRole;
  String? nameOrganization;

  final panganController = TextEditingController();
  final sandangController = TextEditingController();
  final tataController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final controller = Get.put(KaderPokja3Controller());

  DraftModel? _editingDraft;
  bool _isSavingDraft = false;
  bool _allowPop = false;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args is Map) {
      idUser = args['id_user']?.toString();
      idRole = args['id_role']?.toString();
      idOrganization = args['id_organization']?.toString();
      fullName = args['full_name']?.toString();
      nameRole = args['name_role']?.toString();
      nameOrganization = args['name_organization']?.toString();

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
    tataController.text = d['tata_laksana_rumah']?.toString() ?? '';
  }

  bool isFormEmpty() {
    return panganController.text.trim().isEmpty &&
        sandangController.text.trim().isEmpty &&
        tataController.text.trim().isEmpty;
  }

  void clearForm() {
    panganController.clear();
    sandangController.clear();
    tataController.clear();
  }

  Map<String, dynamic> _collectFormData() {
    return {
      'id_user': idUser ?? '',
      'id_role': idRole ?? '',
      'id_organization': idOrganization ?? '',
      'full_name': fullName ?? '',
      'name_role': nameRole ?? '',
      'name_organization': nameOrganization ?? '',
      'pangan': panganController.text.trim(),
      'sandang': sandangController.text.trim(),
      'tata_laksana_rumah': tataController.text.trim(),
    };
  }

  Future<bool> _simpanDraf({bool showFeedback = true}) async {
    if (_isSavingDraft) return false;
    setState(() => _isSavingDraft = true);
    try {
      final user = await PreferencesService.getUser();
      final idAkun = user?.id?.toString() ?? idUser ?? '';
      if (idAkun.isEmpty) {
        Get.snackbar('Gagal', 'Sesi pengguna tidak valid.', snackPosition: SnackPosition.TOP);
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
          jenis: 'kader_pokja3',
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
      Get.snackbar('Gagal', 'Draf tidak dapat disimpan.', snackPosition: SnackPosition.TOP);
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
    if (mounted) Navigator.of(context).pop();
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
    tataController.dispose();
    super.dispose();
  }

  Widget inputField({
    required TextEditingController controller,

    required String label,
  }) {
    return Column(
      children: [
        InputFormField(
          controller: controller,

          hintText: 'Masukkan jumlah',

          label: label,

          keyboardType: TextInputType.number,

          validator: ValidatorForm.validateDefault,
        ),

        SizedBox(height: 24.h),
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

        /// APPBAR
        appBar: AppBarPrimary(
          title: 'Kader Pokja III',
          actionWidget: DraftBadgeIcon(
            scope: DraftScope.laporan,
            arguments: {
              'id_user': idUser,
              'id_role': idRole,
              'id_organization': idOrganization,
              'full_name': fullName,
              'name_role': nameRole,
              'name_organization': nameOrganization,
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

      /// BODY
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
                      maxWidth: isTablet ? 600 : double.infinity,

                      minHeight: constraints.maxHeight,
                    ),

                    child: Form(
                      key: _formKey,

                      child: Column(
                        children: [
                          SizedBox(height: 12.h),

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

                          /// TATA LAKSANA
                          inputField(
                            controller: tataController,

                            label: 'Tata Laksana Rumah Tangga',
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
                                            controller.isLoading.value
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
                                      text: controller.isLoading.value
                                          ? 'Loading'
                                          : 'Kirim',
                                      textColor: Colors.white,
                                      onPressed: controller.isLoading.value ||
                                              _isSavingDraft
                                          ? null
                                          : () async {
                                              final isValid = _formKey
                                                  .currentState!
                                                  .validate();

                                              if (!isValid) {
                                                Get.snackbar(
                                                  'Error',
                                                  'Form tidak valid!',
                                                  snackPosition:
                                                      SnackPosition.TOP,
                                                  backgroundColor:
                                                      Colors.orange,
                                                  colorText: Colors.white,
                                                );
                                                return;
                                              }

                                              controller.setField(
                                                pangan: panganController.text,
                                                sandang: sandangController.text,
                                                tataLaksanaRumah:
                                                    tataController.text,
                                              );

                                              final success = await controller
                                                  .submit();

                                              if (success) {
                                                if (_editingDraft != null) {
                                                  await DraftService()
                                                      .hapusDraft(
                                                    _editingDraft!.id,
                                                  );
                                                }
                                                Get.offAllNamed('/main');
                                              } else if (controller
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
                                                        child:
                                                            const Text('Tutup'),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () =>
                                                            Get.back(
                                                          result: true,
                                                        ),
                                                        child: const Text(
                                                            'Simpan Draf'),
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
