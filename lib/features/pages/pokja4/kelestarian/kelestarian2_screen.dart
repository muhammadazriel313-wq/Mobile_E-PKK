import 'package:epkk_nganjuk/common/appbar/custom_appbar.dart';
import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/common/typography.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:epkk_nganjuk/features/auth/component/input_form_field.dart';
import 'package:epkk_nganjuk/features/draft/button_secondary_outline.dart';
import 'package:epkk_nganjuk/features/draft/draft_controller.dart';
import 'package:epkk_nganjuk/features/draft/draft_model.dart';
import 'package:epkk_nganjuk/features/draft/draft_service.dart';
import 'package:epkk_nganjuk/features/pages/pokja4/kelestarian/kelestarian_controller.dart';
import 'package:epkk_nganjuk/routes/app_routes.dart';
import 'package:epkk_nganjuk/services/preferences/preferences_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class KelestarianLingkungan2Screen extends StatefulWidget {
  const KelestarianLingkungan2Screen({super.key});

  @override
  State<KelestarianLingkungan2Screen> createState() =>
      _KelestarianLingkungan2ScreenState();
}

class _KelestarianLingkungan2ScreenState
    extends State<KelestarianLingkungan2Screen> {
  String? idUser;
  String? idRole;
  String? idOrganization;
  String? fullName;
  String? nameRole;
  String? nameOrganization;

  String? jamban;
  String? spal;
  String? tps;
  String? mck;

  final pdamController = TextEditingController();
  final sumurController = TextEditingController();
  final lainnyaController = TextEditingController();
  final catatanController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final KelestarianController uploadController = Get.put(
    KelestarianController(),
  );

  DraftModel? _editingDraft;
  bool _isSavingDraft = false;

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

      jamban = args['jamban']?.toString();
      spal = args['spal']?.toString();
      tps = args['tps']?.toString();
      mck = args['mck']?.toString();

      if (args['draft'] is DraftModel) {
        _editingDraft = args['draft'] as DraftModel;
        _populateFromDraft(_editingDraft!);
      }
    }
  }

  void _populateFromDraft(DraftModel draft) {
    final d = draft.dataForm;
    pdamController.text = d['pdam']?.toString() ?? '';
    sumurController.text = d['sumur']?.toString() ?? '';
    lainnyaController.text = d['dll']?.toString() ?? '';
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
      'jamban': jamban ?? '',
      'spal': spal ?? '',
      'tps': tps ?? '',
      'mck': mck ?? '',
      'pdam': pdamController.text.trim(),
      'sumur': sumurController.text.trim(),
      'dll': lainnyaController.text.trim(),
      'catatan': catatanController.text.trim(),
      'langkah': 2,
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
          jenis: 'kelestarian',
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
    Get.until(
      (route) =>
          route.settings.name == Routes.UPLOAD_LAPORAN ||
          route.settings.name == Routes.DRAFT_LIST ||
          route.settings.name == Routes.HOME ||
          route.isFirst,
    );
    Future.delayed(const Duration(milliseconds: 150), _showSnackbarDrafDisimpan);
    return true;
  }

  @override
  void dispose() {
    pdamController.dispose();
    sumurController.dispose();
    lainnyaController.dispose();
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
        title: 'Kelestarian Lingkungan',
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
                          TypographyStyles.bodyCaptionSemiBold(
                            'Jumlah KART Yang Menggunakan Air',
                            color: TextColors.grey900,
                          ),
                          SizedBox(height: 24.h),

                          /// PDAM
                          buildInput(controller: pdamController, label: 'PDAM'),

                          /// SUMUR
                          buildInput(
                            controller: sumurController,
                            label: 'Sumur',
                          ),

                          /// DLL
                          buildInput(
                            controller: lainnyaController,
                            label: 'Lain - lainnya',
                          ),

                          SizedBox(height: 10.h),
                          TypographyStyles.bodyCaptionSemiBold(
                            'Catatan Tambahan (Opsional)',
                            color: TextColors.grey900,
                          ),
                          SizedBox(height: 24.h),

                          /// CATATAN
                          buildInput(
                            controller: catatanController,
                            label: 'Catatan',
                            hintText: 'Tulis catatan jika ada',
                            action: TextInputAction.done,
                            isOptional: true,
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
                                      text: 'Lanjut',
                                      textColor: Colors.white,
                                      isLoading:
                                          uploadController.isLoading.value,
                                      onPressed: uploadController
                                              .isLoading.value
                                          ? null
                                          : () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                Get.toNamed(
                                                  Routes.KELESTARIAN3,
                                                  arguments: {
                                                    'id_user': idUser,
                                                    'full_name': fullName,
                                                    'id_role': idRole,
                                                    'name_role': nameRole,
                                                    'id_organization':
                                                        idOrganization,
                                                    'name_organization':
                                                        nameOrganization,
                                                    'jamban': jamban,
                                                    'spal': spal,
                                                    'tps': tps,
                                                    'mck': mck,
                                                    'pdam':
                                                        pdamController.text,
                                                    'sumur':
                                                        sumurController.text,
                                                    'dll':
                                                        lainnyaController.text,
                                                    'catatan':
                                                        catatanController.text,
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
