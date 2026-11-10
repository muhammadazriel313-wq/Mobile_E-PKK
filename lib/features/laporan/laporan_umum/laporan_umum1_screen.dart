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
import 'package:epkk_nganjuk/features/laporan/laporan_umum/laporan_umum_controller.dart';
import 'package:epkk_nganjuk/routes/app_routes.dart';
import 'package:epkk_nganjuk/services/preferences/preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class LaporanUmum1Screen extends StatefulWidget {
  const LaporanUmum1Screen({super.key});

  @override
  State<LaporanUmum1Screen> createState() => _LaporanUmum1ScreenState();
}

class _LaporanUmum1ScreenState extends State<LaporanUmum1Screen> {
  // ================= USER DATA =================

  String? idUser;
  String? idRole;
  String? idOrganization;

  String? fullName;
  String? nameRole;
  String? nameOrganization;

  // ================= FORM CONTROLLER =================

  final dusunController = TextEditingController();

  final pkkRwController = TextEditingController();

  final pkkRtController = TextEditingController();

  final desaWismaController = TextEditingController();

  final krtController = TextEditingController();

  final kkController = TextEditingController();

  // ================= FORM KEY =================

  final _formKey = GlobalKey<FormState>();

  // ================= GETX CONTROLLER =================

  final controller = Get.put(LaporanUmumController());

  // ================= DRAFT STATE =================
  DraftModel? _editingDraft;
  bool _isSavingDraft = false;
  bool _allowPop = false;

  void clearForm() {
    dusunController.clear();
    pkkRwController.clear();
    pkkRtController.clear();
    desaWismaController.clear();
    krtController.clear();
    kkController.clear();
  }

  bool isFormEmpty() {
    return ![
      dusunController,
      pkkRwController,
      pkkRtController,
      desaWismaController,
      krtController,
      kkController,
    ].any((c) => c.text.trim().isNotEmpty);
  }

  Map<String, dynamic> _collectFormData() {
    final existingData = _editingDraft?.dataForm ?? {};
    final data = Map<String, dynamic>.from(existingData);
    data['id_user'] = idUser ?? _editingDraft?.idAkun ?? '';
    data['id_role'] = idRole ?? '';
    data['id_organization'] = idOrganization ?? '';
    data['full_name'] = fullName ?? '';
    data['name_role'] = nameRole ?? '';
    data['name_organization'] = nameOrganization ?? '';
    data['dusun_lingkungan'] = dusunController.text.trim();
    data['PKK_RW'] = pkkRwController.text.trim();
    data['PKK_RT'] = pkkRtController.text.trim();
    data['desa_wisma'] = desaWismaController.text.trim();
    data['KRT'] = krtController.text.trim();
    data['KK'] = kkController.text.trim();
    data['langkah'] = 1;
    return data;
  }

  void _populateFromDraft(DraftModel draft) {
    final data = draft.dataForm;
    dusunController.text = data['dusun_lingkungan']?.toString() ?? '';
    pkkRwController.text = data['PKK_RW']?.toString() ?? '';
    pkkRtController.text = data['PKK_RT']?.toString() ?? '';
    desaWismaController.text = data['desa_wisma']?.toString() ?? '';
    krtController.text = data['KRT']?.toString() ?? '';
    kkController.text = data['KK']?.toString() ?? '';

    idUser = draft.idAkun;
    idRole ??= data['id_role']?.toString();
    idOrganization ??= data['id_organization']?.toString();
    fullName ??= data['full_name']?.toString();
    nameRole ??= data['name_role']?.toString();
    nameOrganization ??= data['name_organization']?.toString();
  }

  Future<bool> _simpanDraf({bool showFeedback = false}) async {
    if (_isSavingDraft || controller.isLoading.value) return false;
    if (isFormEmpty()) {
      Get.snackbar(
        'Form Kosong',
        'Isi minimal satu kolom sebelum menyimpan draf.',
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }

    setState(() => _isSavingDraft = true);
    try {
      if ((idUser ?? '').isEmpty) {
        final user = await PreferencesService.getUser();
        idUser = user?.id;
      }
      if ((idUser ?? '').isEmpty) {
        Get.snackbar(
          'Sesi Tidak Ditemukan',
          'Masuk kembali untuk menyimpan draf.',
          snackPosition: SnackPosition.TOP,
        );
        return false;
      }

      final data = _collectFormData();
      final service = DraftService();
      if (_editingDraft != null) {
        await service.updateDraft(
          _editingDraft!.copyWith(
            dataForm: data,
            status: 'draf',
            pesanError: null,
          ),
        );
      } else {
        await service.simpanDraft(
          idAkun: idUser ?? '',
          jenis: 'laporan_umum',
          dataForm: data,
          originalPhotoPaths: [],
        );
      }

      final draftController = Get.isRegistered<DraftController>()
          ? Get.find<DraftController>()
          : Get.put(DraftController());
      await draftController.refreshAllCount();

      if (showFeedback) {
        _showSnackbarDrafDisimpan();
      }
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
    if (!await _simpanDraf()) return false;
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
  void initState() {
    super.initState();

    final args = (Get.arguments ?? {}) as Map;

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

  @override
  void dispose() {
    dusunController.dispose();

    pkkRwController.dispose();

    pkkRtController.dispose();

    desaWismaController.dispose();

    krtController.dispose();

    kkController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    final isTablet = media.size.width >= 600;

    final args = Get.arguments;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && mounted) Get.back();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,

        backgroundColor: Colors.white,

        // ================= APPBAR =================
        appBar: AppBarPrimary(
          title: 'Laporan Umum',
          currentStep: 1,
          totalSteps: 4,
          actionWidget: DraftBadgeIcon(
            scope: DraftScope.laporan,
            arguments: args is Map<String, dynamic>
                ? args
                : (args is Map ? Map<String, dynamic>.from(args) : null),
          ),
          onBack: () async {
            final shouldPop = await _onWillPop();
            if (shouldPop && mounted) Get.back();
          },
        ),

      // ================= BODY =================
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
                          // ================= TITLE =================
                          TypographyStyles.bodyCaptionBold(
                            'Jumlah Kelompok',

                            color: TextColors.grey700,
                          ),

                          SizedBox(height: 24.h),

                          // ================= DUSUN =================
                          _inputField(
                            controller: dusunController,

                            label: 'Dusun/Lingkungan',
                          ),

                          _space(),

                          // ================= PKK RW =================
                          _inputField(
                            controller: pkkRwController,

                            label: 'PKK RW',
                          ),

                          _space(),

                          // ================= PKK RT =================
                          _inputField(
                            controller: pkkRtController,

                            label: 'PKK RT',
                          ),

                          _space(),

                          // ================= DESA WISMA =================
                          _inputField(
                            controller: desaWismaController,

                            label: 'Desa Wisma',
                          ),

                          SizedBox(height: 40.h),

                          // ================= TITLE =================
                          TypographyStyles.bodyCaptionBold(
                            'Jumlah',

                            color: TextColors.grey700,
                          ),

                          SizedBox(height: 24.h),

                          // ================= KRT =================
                          _inputField(controller: krtController, label: 'KRT'),

                          _space(),

                          // ================= KK =================
                          _inputField(controller: kkController, label: 'KK'),

                          SizedBox(height: 30.h),

                          // ================= BUTTON =================
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
                                    onPressed: _isSavingDraft || controller.isLoading.value
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
                                      isLoading: controller.isLoading.value,
                                      onPressed: controller.isLoading.value || _isSavingDraft
                                          ? null
                                          : () {
                                              if (_formKey.currentState!.validate()) {
                                                final nextArgs = _collectFormData();
                                                nextArgs['draft'] = _editingDraft;
                                                Get.toNamed(
                                                  Routes.LAPORAN_UMUM2,
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

  // ================= INPUT FIELD =================

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
        return ValidatorForm.validateDefault(value);
      },
    );
  }

  // ================= SPACE =================

  Widget _space() => SizedBox(height: 24.h);
}
