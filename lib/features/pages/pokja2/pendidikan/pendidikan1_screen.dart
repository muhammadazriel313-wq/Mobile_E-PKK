import 'package:epkk_nganjuk/common/appbar/custom_appbar.dart';
import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/common/typography.dart';
import 'package:epkk_nganjuk/core/validators/validator_form.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:epkk_nganjuk/features/auth/component/input_form_field.dart';
import 'package:epkk_nganjuk/features/pages/pokja2/pendidikan/pendidikan_ketrampilan_controller.dart';
import 'package:epkk_nganjuk/features/draft/button_secondary_outline.dart';
import 'package:epkk_nganjuk/features/draft/draft_badge_icon.dart';
import 'package:epkk_nganjuk/features/draft/draft_controller.dart';
import 'package:epkk_nganjuk/features/draft/draft_exit_dialog.dart';
import 'package:epkk_nganjuk/features/draft/draft_model.dart';
import 'package:epkk_nganjuk/features/draft/draft_service.dart';
import 'package:epkk_nganjuk/routes/app_routes.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class Pendidikan1Screen extends StatefulWidget {
  const Pendidikan1Screen({super.key});

  @override
  State<Pendidikan1Screen> createState() => _Pendidikan1ScreenState();
}

class _Pendidikan1ScreenState extends State<Pendidikan1Screen> {
  final PendidikanKeterampilanController controller = Get.put(
    PendidikanKeterampilanController(),
  );

  final jumlahButaController = TextEditingController();

  final kelBelajarAController = TextEditingController();

  final wargaBelajarAController = TextEditingController();

  final kelBelajarBController = TextEditingController();

  final wargaBelajarBController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  DraftModel? _editingDraft;
  bool _isSavingDraft = false;
  bool _allowPop = false;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args is Map && args['draft'] is DraftModel) {
      _editingDraft = args['draft'] as DraftModel;
      controller.restoreDraft(_editingDraft!.dataForm);
      jumlahButaController.text = controller.wargaButa;
      kelBelajarAController.text = controller.kelBelajarA;
      wargaBelajarAController.text = controller.wargaBelajarA;
      kelBelajarBController.text = controller.kelBelajarB;
      wargaBelajarBController.text = controller.wargaBelajarB;
    }
  }

  Map<String, dynamic> _collectFormData() {
    controller.setStep1(
      wargaButaVal: jumlahButaController.text,
      kelA: kelBelajarAController.text,
      wargaA: wargaBelajarAController.text,
      kelB: kelBelajarBController.text,
      wargaB: wargaBelajarBController.text,
    );
    final data = controller.draftData(langkah: 1);
    data['id_user'] = controller.idUser;
    return data;
  }

  Future<bool> _saveDraftAndExit() async {
    if (_isSavingDraft || controller.isLoading.value) return false;
    if (controller.idUser.isEmpty) return false;
    setState(() => _isSavingDraft = true);
    try {
      final data = _collectFormData();
      final service = DraftService();
      if (_editingDraft != null) {
        await service.updateDraft(_editingDraft!.copyWith(dataForm: data, status: 'draf', pesanError: null));
      } else {
        await service.simpanDraft(idAkun: controller.idUser, jenis: 'pendidikan', dataForm: data, originalPhotoPaths: []);
      }
      final drafts = Get.isRegistered<DraftController>() ? Get.find<DraftController>() : Get.put(DraftController());
      await drafts.refreshAllCount();
      Get.closeAllSnackbars();
      Get.until((route) => route.settings.name == Routes.HOME || route.isFirst);
      Future.delayed(const Duration(milliseconds: 150), () => Get.snackbar('Draf disimpan', '', snackPosition: SnackPosition.TOP));
      return true;
    } catch (_) {
      Get.snackbar('Gagal', 'Draf tidak dapat disimpan.', snackPosition: SnackPosition.TOP);
      return false;
    } finally {
      if (mounted) setState(() => _isSavingDraft = false);
    }
  }

  Future<bool> _onWillPop() async {
    if (_allowPop || !controller.hasDraftInput) return true;
    bool savedViaDialog = false;
    final exit = await DraftExitDialog.show(
      context: context,
      onSaveDraft: () async {
        final saved = await _saveDraftAndExit();
        if (saved) savedViaDialog = true;
        return saved;
      },
    );
    if (savedViaDialog) return false;
    if (exit) {
      controller.clearForm();
      _allowPop = true;
    }
    return exit;
  }

  @override
  void dispose() {
    jumlahButaController.dispose();

    kelBelajarAController.dispose();

    wargaBelajarAController.dispose();

    kelBelajarBController.dispose();

    wargaBelajarBController.dispose();

    super.dispose();
  }

  Widget sectionTitle(String title) {
    return Container(
      alignment: Alignment.centerLeft,

      child: TypographyStyles.bodyCaptionBold(title, color: TextColors.grey700),
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

          validator: (value) => ValidatorForm.validateDefault(value),
        ),

        SizedBox(height: 24.h),
      ],
    );
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
        if (await _onWillPop() && mounted) Get.back();
      },
      child: Scaffold(
      resizeToAvoidBottomInset: true,

      backgroundColor: Colors.white,

      appBar: AppBarPrimary(
        title: 'Pendidikan & Ketrampilan',

        onBack: () async {
          if (await _onWillPop() && mounted) Get.back();
        },
        actionWidget: DraftBadgeIcon(
          scope: DraftScope.laporan,
          arguments: args is Map ? Map<String, dynamic>.from(args) : null,
        ),
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
                      maxWidth: isTablet ? 600 : double.infinity,

                      minHeight: constraints.maxHeight,
                    ),

                    child: Form(
                      key: _formKey,

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          /// TITLE
                          sectionTitle('Jumlah Kelompok Belajar'),

                          SizedBox(height: 12.h),

                          /// INPUT
                          inputField(
                            controller: jumlahButaController,

                            label: 'Jumlah warga yang masih buta',
                          ),

                          /// PAKET A
                          sectionTitle('Paket A'),

                          SizedBox(height: 12.h),

                          inputField(
                            controller: kelBelajarAController,

                            label: 'Kel. Belajar',
                          ),

                          inputField(
                            controller: wargaBelajarAController,

                            label: 'Warga Belajar',
                          ),

                          /// PAKET B
                          sectionTitle('Paket B'),

                          SizedBox(height: 12.h),

                          inputField(
                            controller: kelBelajarBController,

                            label: 'Kel. Belajar',
                          ),

                          inputField(
                            controller: wargaBelajarBController,

                            label: 'Warga Belajar',
                          ),

                          SizedBox(height: 10.h),

                          Row(
                            children: [
                              Expanded(
                                child: ButtonSecondaryOutline(
                                  text: _isSavingDraft ? 'Menyimpan...' : 'Simpan Draf',
                                  onPressed: _isSavingDraft || controller.isLoading.value ? null : _saveDraftAndExit,
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
                                      onPressed: controller.isLoading.value
                                          ? null
                                          : () {
                                              if (_formKey.currentState!.validate()) {
                                                controller.setStep1(
                                                  wargaButaVal: jumlahButaController.text,
                                                  kelA: kelBelajarAController.text,
                                                  wargaA: wargaBelajarAController.text,
                                                  kelB: kelBelajarBController.text,
                                                  wargaB: wargaBelajarBController.text,
                                                );
                                                Get.toNamed(Routes.PENDIDIKAN2, arguments: {'draft': _editingDraft});
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
}
