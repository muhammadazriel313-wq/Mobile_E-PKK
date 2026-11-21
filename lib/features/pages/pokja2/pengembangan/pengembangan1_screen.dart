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
import 'package:epkk_nganjuk/features/pages/pokja2/pengembangan/pengembangan_kehidupan_controller.dart';
import 'package:epkk_nganjuk/routes/app_routes.dart';
import 'package:epkk_nganjuk/services/preferences/preferences_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'package:get/get.dart';

class Pengembangan1 extends StatefulWidget {
  const Pengembangan1({super.key});

  @override
  State<Pengembangan1> createState() => _Pengembangan1ScreenState();
}

class _Pengembangan1ScreenState extends State<Pengembangan1> {
  String? idUser;
  String? idRole;
  String? idOrganization;
  String? fullName;
  String? nameRole;
  String? nameOrganization;

  final permulaKelompokController = TextEditingController();
  final permulaPesertaController = TextEditingController();
  final madyaKelompokController = TextEditingController();
  final madyaPesertaController = TextEditingController();
  final utamaKelompokController = TextEditingController();
  final utamaPesertaController = TextEditingController();
  final mandiriKelompokController = TextEditingController();
  final mandiriPesertaController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final PengembanganKehidupanController uploadController = Get.put(
    PengembanganKehidupanController(),
  );

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
    permulaKelompokController.text = d['jumlah_kelompok_pemula']?.toString() ?? '';
    permulaPesertaController.text = d['jumlah_peserta_pemula']?.toString() ?? '';
    madyaKelompokController.text = d['jumlah_kelompok_madya']?.toString() ?? '';
    madyaPesertaController.text = d['jumlah_peserta_madya']?.toString() ?? '';
    utamaKelompokController.text = d['jumlah_kelompok_utama']?.toString() ?? '';
    utamaPesertaController.text = d['jumlah_peserta_utama']?.toString() ?? '';
    mandiriKelompokController.text = d['jumlah_kelompok_mandiri']?.toString() ?? '';
    mandiriPesertaController.text = d['jumlah_peserta_mandiri']?.toString() ?? '';
  }

  bool isFormEmpty() {
    return permulaKelompokController.text.trim().isEmpty &&
        permulaPesertaController.text.trim().isEmpty &&
        madyaKelompokController.text.trim().isEmpty &&
        madyaPesertaController.text.trim().isEmpty &&
        utamaKelompokController.text.trim().isEmpty &&
        utamaPesertaController.text.trim().isEmpty &&
        mandiriKelompokController.text.trim().isEmpty &&
        mandiriPesertaController.text.trim().isEmpty;
  }

  void clearForm() {
    permulaKelompokController.clear();
    permulaPesertaController.clear();
    madyaKelompokController.clear();
    madyaPesertaController.clear();
    utamaKelompokController.clear();
    utamaPesertaController.clear();
    mandiriKelompokController.clear();
    mandiriPesertaController.clear();
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
      'jumlah_kelompok_pemula': permulaKelompokController.text.trim(),
      'jumlah_peserta_pemula': permulaPesertaController.text.trim(),
      'jumlah_kelompok_madya': madyaKelompokController.text.trim(),
      'jumlah_peserta_madya': madyaPesertaController.text.trim(),
      'jumlah_kelompok_utama': utamaKelompokController.text.trim(),
      'jumlah_peserta_utama': utamaPesertaController.text.trim(),
      'jumlah_kelompok_mandiri': mandiriKelompokController.text.trim(),
      'jumlah_peserta_mandiri': mandiriPesertaController.text.trim(),
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
          jenis: 'pengembangan',
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
    permulaKelompokController.dispose();

    permulaPesertaController.dispose();

    madyaKelompokController.dispose();

    madyaPesertaController.dispose();

    utamaKelompokController.dispose();

    utamaPesertaController.dispose();

    mandiriKelompokController.dispose();

    mandiriPesertaController.dispose();

    super.dispose();
  }

  Widget sectionTitle(String title) {
    return TypographyStyles.bodyCaptionSemiBold(
      title,
      color: TextColors.grey900,
    );
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

        SizedBox(height: 20.h),
      ],
    );
  }

  Widget buildSection(
    String title,

    TextEditingController kelompok,

    TextEditingController peserta,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        sectionTitle(title),

        SizedBox(height: 12.h),

        inputField(controller: kelompok, label: 'Jumlah Kelompok'),

        inputField(controller: peserta, label: 'Jumlah Peserta'),

        SizedBox(height: 8.h),
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
          title: 'Pengembangan Kehidupan Berkoperasi',
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
                      maxWidth: isTablet ? 600 : double.infinity,

                      minHeight: constraints.maxHeight,
                    ),

                    child: Form(
                      key: _formKey,

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          SizedBox(height: 12.h),

                          /// TITLE
                          sectionTitle(
                            'Prakoperasi / Usaha Bersama / UP2K PKK',
                          ),

                          SizedBox(height: 24.h),

                          /// PEMULA
                          buildSection(
                            'Pemula',

                            permulaKelompokController,

                            permulaPesertaController,
                          ),

                          /// MADYA
                          buildSection(
                            'Madya',

                            madyaKelompokController,

                            madyaPesertaController,
                          ),

                          /// UTAMA
                          buildSection(
                            'Utama',

                            utamaKelompokController,

                            utamaPesertaController,
                          ),

                          /// MANDIRI
                          buildSection(
                            'Mandiri',

                            mandiriKelompokController,

                            mandiriPesertaController,
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
                                            uploadController.isLoading.value
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
                                      text: 'Lanjut',
                                      textColor: Colors.white,
                                      isLoading:
                                          uploadController.isLoading.value,
                                      onPressed: uploadController.isLoading.value
                                          ? null
                                          : () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                uploadController.setField(
                                                  jumlahKelompokPemula:
                                                      permulaKelompokController
                                                          .text,
                                                  jumlahPesertaPemula:
                                                      permulaPesertaController
                                                          .text,
                                                  jumlahKelompokMadya:
                                                      madyaKelompokController
                                                          .text,
                                                  jumlahPesertaMadya:
                                                      madyaPesertaController
                                                          .text,
                                                  jumlahKelompokUtama:
                                                      utamaKelompokController
                                                          .text,
                                                  jumlahPesertaUtama:
                                                      utamaPesertaController
                                                          .text,
                                                  jumlahKelompokMandiri:
                                                      mandiriKelompokController
                                                          .text,
                                                  jumlahPesertaMandiri:
                                                      mandiriPesertaController
                                                          .text,
                                                );

                                                final nextArgs = {
                                                  'id_user': idUser,
                                                  'id_role': idRole,
                                                  'id_organization':
                                                      idOrganization,
                                                  'full_name': fullName,
                                                  'name_role': nameRole,
                                                  'name_organization':
                                                      nameOrganization,
                                                  if (_editingDraft != null)
                                                    'draft': _editingDraft,
                                                };

                                                Get.toNamed(
                                                  Routes.PENGEMBANGAN2,
                                                  arguments: nextArgs,
                                                );
                                              } else {
                                                Get.snackbar(
                                                  'Error',
                                                  'Lengkapi Form',
                                                  snackPosition:
                                                      SnackPosition.TOP,
                                                  backgroundColor: Colors.red,
                                                  colorText: Colors.white,
                                                );
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
