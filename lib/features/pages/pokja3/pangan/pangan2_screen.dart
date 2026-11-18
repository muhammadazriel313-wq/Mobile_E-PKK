import 'package:epkk_nganjuk/common/appbar/custom_appbar.dart';
import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/common/typography.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:epkk_nganjuk/features/auth/component/input_form_field.dart';
import 'package:epkk_nganjuk/features/draft/button_secondary_outline.dart';
import 'package:epkk_nganjuk/features/draft/draft_controller.dart';
import 'package:epkk_nganjuk/features/draft/draft_model.dart';
import 'package:epkk_nganjuk/features/draft/draft_service.dart';
import 'package:epkk_nganjuk/features/pages/pokja3/pangan/pangan_controller.dart';
import 'package:epkk_nganjuk/routes/app_routes.dart';
import 'package:epkk_nganjuk/services/preferences/preferences_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class Pangan2Screen extends StatefulWidget {
  const Pangan2Screen({super.key});

  @override
  State<Pangan2Screen> createState() => _Pangan1ScreenState();
}

class _Pangan1ScreenState extends State<Pangan2Screen> {
  String? id_user;
  String? id_role;
  String? id_organization;
  String? full_name;
  String? name_role;
  String? name_organization;
  String? beras;
  String? non_beras;

  final peternakanController = TextEditingController();
  final perikananController = TextEditingController();
  final warungHidupController = TextEditingController();
  final lumbungHidupController = TextEditingController();
  final togaController = TextEditingController();
  final tanamanKerasController = TextEditingController();
  final tanamanLainnyaController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final PanganController uploadController = Get.find<PanganController>();

  DraftModel? _editingDraft;
  bool _isSavingDraft = false;

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
      beras = args['beras']?.toString();
      non_beras = args['non_beras']?.toString();

      if (args['draft'] is DraftModel) {
        _editingDraft = args['draft'] as DraftModel;
        _populateFromDraft(_editingDraft!);
      }
    }
  }

  void _populateFromDraft(DraftModel draft) {
    final d = draft.dataForm;
    peternakanController.text = d['peternakan']?.toString() ?? '';
    perikananController.text = d['perikanan']?.toString() ?? '';
    warungHidupController.text = d['warung_hidup']?.toString() ?? '';
    lumbungHidupController.text = d['lumbung_hidup']?.toString() ?? '';
    togaController.text = d['toga']?.toString() ?? '';
    tanamanKerasController.text = d['tanaman_keras']?.toString() ?? '';
    tanamanLainnyaController.text = d['tanaman_lainnya']?.toString() ?? '';
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
      'beras': beras ?? '',
      'non_beras': non_beras ?? '',
      'peternakan': peternakanController.text.trim(),
      'perikanan': perikananController.text.trim(),
      'warung_hidup': warungHidupController.text.trim(),
      'lumbung_hidup': lumbungHidupController.text.trim(),
      'toga': togaController.text.trim(),
      'tanaman_keras': tanamanKerasController.text.trim(),
      'tanaman_lainnya': tanamanLainnyaController.text.trim(),
      'langkah': 2,
    };
  }

  Future<bool> _simpanDraf({bool showFeedback = true}) async {
    if (_isSavingDraft) return false;
    setState(() => _isSavingDraft = true);
    try {
      final user = await PreferencesService.getUser();
      final idAkun = user?.id.toString() ?? id_user ?? '';
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
          jenis: 'pangan',
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
    peternakanController.dispose();
    perikananController.dispose();
    warungHidupController.dispose();
    lumbungHidupController.dispose();
    togaController.dispose();
    tanamanKerasController.dispose();
    tanamanLainnyaController.dispose();
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
        ),
        SizedBox(height: 20.h),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final isTablet = media.size.width >= 600;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,

      /// APPBAR
      appBar: AppBarSecondary(
        title: 'Pangan',
        onBack: () => Get.back(),
        currentStep: 2,
        totalSteps: 3,
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

                          /// TITLE
                          sectionTitle('Pemanfaatan Pekarangan'),

                          SizedBox(height: 24.h),

                          /// PETERNAKAN
                          inputField(
                            controller: peternakanController,
                            label: 'Peternakan',
                          ),

                          /// PERIKANAN
                          inputField(
                            controller: perikananController,
                            label: 'Perikanan',
                          ),

                          /// WARUNG HIDUP
                          inputField(
                            controller: warungHidupController,
                            label: 'Warung Hidup',
                          ),

                          /// LUMBUNG HIDUP
                          inputField(
                            controller: lumbungHidupController,
                            label: 'Lumbung Hidup',
                          ),

                          /// TOGA
                          inputField(
                            controller: togaController,
                            label: 'Toga',
                          ),

                          /// TANAMAN KERAS
                          inputField(
                            controller: tanamanKerasController,
                            label: 'Tanaman Keras',
                          ),

                          /// TANAMAN LAINNYA
                          inputField(
                            controller: tanamanLainnyaController,
                            label: 'Tanaman Lainnya',
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
                                                Get.toNamed(
                                                  Routes.PANGAN3,
                                                  arguments: {
                                                    'id_user': id_user,
                                                    'full_name': full_name,
                                                    'id_role': id_role,
                                                    'name_role': name_role,
                                                    'id_organization':
                                                        id_organization,
                                                    'name_organization':
                                                        name_organization,
                                                    'beras': beras,
                                                    'non_beras': non_beras,
                                                    'peternakan':
                                                        peternakanController
                                                            .text,
                                                    'perikanan':
                                                        perikananController
                                                            .text,
                                                    'warung_hidup':
                                                        warungHidupController
                                                            .text,
                                                    'lumbung_hidup':
                                                        lumbungHidupController
                                                            .text,
                                                    'toga': togaController.text,
                                                    'tanaman_keras':
                                                        tanamanKerasController
                                                            .text,
                                                    'tanaman_lainnya':
                                                        tanamanLainnyaController
                                                            .text,
                                                    if (_editingDraft != null)
                                                      'draft': _editingDraft,
                                                  },
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
    );
  }
}
