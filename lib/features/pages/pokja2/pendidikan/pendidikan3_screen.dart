import 'package:epkk_nganjuk/common/appbar/custom_appbar.dart';
import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/common/typography.dart';
import 'package:epkk_nganjuk/core/validators/validator_form.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:epkk_nganjuk/features/auth/component/input_form_field.dart';
import 'package:epkk_nganjuk/features/pages/pokja2/pendidikan/pendidikan_ketrampilan_controller.dart';
import 'package:epkk_nganjuk/features/draft/button_secondary_outline.dart';
import 'package:epkk_nganjuk/features/draft/draft_model.dart';
import 'package:epkk_nganjuk/features/draft/draft_service.dart';
import 'package:epkk_nganjuk/features/draft/draft_controller.dart';
import 'package:epkk_nganjuk/routes/app_routes.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class PendidikanKetrampilan3Screen extends StatefulWidget {
  const PendidikanKetrampilan3Screen({super.key});

  @override
  State<PendidikanKetrampilan3Screen> createState() =>
      _Pendidikan3ScreenState();
}

class _Pendidikan3ScreenState extends State<PendidikanKetrampilan3Screen> {
  final PendidikanKeterampilanController controller =
      Get.isRegistered<PendidikanKeterampilanController>()
          ? Get.find<PendidikanKeterampilanController>()
          : Get.put(PendidikanKeterampilanController());

  final klpController = TextEditingController();

  final ibuPesertaController = TextEditingController();

  final apeController = TextEditingController();

  final kelSimulasiController = TextEditingController();

  final tutorKFController = TextEditingController();

  final tutorPaudController = TextEditingController();

  final kaderBKPController = TextEditingController();

  final koperasiController = TextEditingController();

  final ketrampilanController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  DraftModel? _editingDraft;
  bool _isSavingDraft = false;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args is Map && args['draft'] is DraftModel) {
      _editingDraft = args['draft'] as DraftModel;
      controller.restoreDraft(_editingDraft!.dataForm);
      klpController.text = controller.jumlahKlp;
      ibuPesertaController.text = controller.jumlahIbuPeserta;
      apeController.text = controller.jumlahApe;
      kelSimulasiController.text = controller.jumlahKelSimulasi;
      tutorKFController.text = controller.kf;
      tutorPaudController.text = controller.paudTutor;
      kaderBKPController.text = controller.bkb;
      koperasiController.text = controller.koperasi;
      ketrampilanController.text = controller.ketrampilan;
    }
  }

  Future<bool> _saveDraft() async {
    if (_isSavingDraft || controller.isLoading.value) return false;
    controller.setStep3(
      klp: klpController.text,
      ibu: ibuPesertaController.text,
      ape: apeController.text,
      simulasi: kelSimulasiController.text,
      kfVal: tutorKFController.text,
      paudTutorVal: tutorPaudController.text,
      bkbVal: kaderBKPController.text,
      koperasiVal: koperasiController.text,
      ketrampilanVal: ketrampilanController.text,
    );
    if (controller.idUser.isEmpty) return false;
    setState(() => _isSavingDraft = true);
    try {
      final data = controller.draftData(langkah: 3)..['id_user'] = controller.idUser;
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

  @override
  void dispose() {
    klpController.dispose();

    ibuPesertaController.dispose();

    apeController.dispose();

    kelSimulasiController.dispose();

    tutorKFController.dispose();

    tutorPaudController.dispose();

    kaderBKPController.dispose();

    koperasiController.dispose();

    ketrampilanController.dispose();

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

          validator: (v) => ValidatorForm.validateDefault(v),
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

      appBar: AppBarSecondary(
        title: 'Pendidikan & Keterampilan',

        onBack: () => Get.back(),

        currentStep: 3,

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
                          SizedBox(height: 12.h),

                          /// BKP
                          sectionTitle('BKP'),

                          SizedBox(height: 12.h),

                          inputField(
                            controller: klpController,

                            label: 'Jumlah KLP',
                          ),

                          inputField(
                            controller: ibuPesertaController,

                            label: 'Jumlah ibu peserta',
                          ),

                          inputField(
                            controller: apeController,

                            label: 'Jumlah APE (SET)',
                          ),

                          inputField(
                            controller: kelSimulasiController,

                            label: 'Jumlah Kel. Simulasi',
                          ),

                          SizedBox(height: 8.h),

                          /// KADER KHUSUS
                          sectionTitle('Kader Khusus'),

                          SizedBox(height: 12.h),

                          /// TUTOR
                          sectionTitle('Tutor'),

                          SizedBox(height: 12.h),

                          inputField(
                            controller: tutorKFController,

                            label: 'KF',
                          ),

                          inputField(
                            controller: tutorPaudController,

                            label: 'Paud / sejenis',
                          ),

                          inputField(
                            controller: kaderBKPController,

                            label: 'BKP',
                          ),

                          inputField(
                            controller: koperasiController,

                            label: 'Koperasi',
                          ),

                          inputField(
                            controller: ketrampilanController,

                            label: 'Keterampilan',
                          ),

                          SizedBox(height: 10.h),

                          Row(
                            children: [
                              Expanded(
                                child: ButtonSecondaryOutline(
                                  text: _isSavingDraft ? 'Menyimpan...' : 'Simpan Draf',
                                  onPressed: _isSavingDraft || controller.isLoading.value ? null : _saveDraft,
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
                                          /// SIMPAN DATA
                                          controller.setStep3(
                                            klp: klpController.text,

                                            ibu: ibuPesertaController.text,

                                            ape: apeController.text,

                                            simulasi:
                                                kelSimulasiController.text,

                                            kfVal: tutorKFController.text,

                                            paudTutorVal:
                                                tutorPaudController.text,

                                            bkbVal: kaderBKPController.text,

                                            koperasiVal:
                                                koperasiController.text,

                                            ketrampilanVal:
                                                ketrampilanController.text,
                                          );

                                          /// NEXT
                                          Get.toNamed(Routes.PENDIDIKAN4, arguments: {'draft': _editingDraft});
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
    );
  }
}
