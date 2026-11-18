/// =======================================================
/// FILE : kegiatan_pokja4_4_screen.dart
/// =======================================================

import 'package:epkk_nganjuk/common/appbar/custom_appbar.dart';
import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/common/typography.dart';
import 'package:epkk_nganjuk/core/validators/validator_form.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:epkk_nganjuk/features/auth/component/input_form_field.dart';
import 'package:epkk_nganjuk/features/draft/button_secondary_outline.dart';
import 'package:epkk_nganjuk/features/draft/draft_controller.dart';
import 'package:epkk_nganjuk/features/draft/draft_model.dart';
import 'package:epkk_nganjuk/features/draft/draft_service.dart';
import 'package:epkk_nganjuk/routes/app_routes.dart';
import 'package:epkk_nganjuk/services/preferences/preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class KegiatanPokja44Screen extends StatefulWidget {
  const KegiatanPokja44Screen({super.key});

  @override
  State<KegiatanPokja44Screen> createState() => _KegiatanPokja44ScreenState();
}

class _KegiatanPokja44ScreenState extends State<KegiatanPokja44Screen> {
  /// ================= ARGUMENT =================

  late Map<String, dynamic> data;

  /// ================= CONTROLLER =================

  final kkMemilikiTabunganController = TextEditingController();
  final kkMemilikiAsuransiController = TextEditingController();
  final kesehatanController = TextEditingController();
  final kelestarianLingkunganController = TextEditingController();
  final perencanaanSehatController = TextEditingController();

  /// ================= FORM =================

  final _formKey = GlobalKey<FormState>();

  DraftModel? _editingDraft;
  bool _isSavingDraft = false;

  @override
  void initState() {
    super.initState();

    final args = Get.arguments;
    if (args is Map) {
      data = Map<String, dynamic>.from(args);
      if (args['draft'] is DraftModel) {
        _editingDraft = args['draft'] as DraftModel;
        _populateFromDraft(_editingDraft!);
      }
    } else {
      data = {};
    }
  }

  void _populateFromDraft(DraftModel draft) {
    final d = draft.dataForm;
    kkMemilikiTabunganController.text =
        d['kk_memiliki_tabungan']?.toString() ?? '';
    kkMemilikiAsuransiController.text =
        d['kk_memiliki_asuransi']?.toString() ?? '';
    kesehatanController.text = d['kesehatan']?.toString() ?? '';
    kelestarianLingkunganController.text =
        d['kelestarian_lingkungan_hidup']?.toString() ?? '';
    perencanaanSehatController.text =
        d['perencanaan_sehat']?.toString() ?? '';
  }

  Map<String, dynamic> _collectFormData() {
    final existingData = _editingDraft?.dataForm ?? <String, dynamic>{};
    return {
      ...existingData,
      ...data,
      'kk_memiliki_tabungan': kkMemilikiTabunganController.text.trim(),
      'kk_memiliki_asuransi': kkMemilikiAsuransiController.text.trim(),
      'kesehatan': kesehatanController.text.trim(),
      'kelestarian_lingkungan_hidup':
          kelestarianLingkunganController.text.trim(),
      'perencanaan_sehat': perencanaanSehatController.text.trim(),
      'langkah': 4,
    };
  }

  Future<bool> _simpanDraf({bool showFeedback = true}) async {
    if (_isSavingDraft) return false;
    setState(() => _isSavingDraft = true);
    try {
      final user = await PreferencesService.getUser();
      final idAkun = user?.id.toString() ?? data['id_user']?.toString() ?? '';
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
    Get.closeAllSnackbars();
    Get.until((route) => route.settings.name == Routes.HOME || route.isFirst);
    Future.delayed(const Duration(milliseconds: 150), _showSnackbarDrafDisimpan);
    return true;
  }

  @override
  void dispose() {
    kkMemilikiTabunganController.dispose();

    kkMemilikiAsuransiController.dispose();

    kesehatanController.dispose();

    kelestarianLingkunganController.dispose();

    perencanaanSehatController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    final isTablet = media.size.width >= 600;

    return Scaffold(
      resizeToAvoidBottomInset: true,

      backgroundColor: Colors.white,

      appBar: AppBarSecondary(
        title: 'Kegiatan Pokja 4',

        currentStep: 4,

        totalSteps: 5,

        onBack: () => Get.back(),
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
                          /// PROGRAM KELUARGA
                          /// ======================
                          TypographyStyles.bodyCaptionSemiBold(
                            'Program Keluarga',

                            color: TextColors.grey900,
                          ),

                          SizedBox(height: 24.h),

                          _inputField(
                            controller: kkMemilikiTabunganController,

                            label: 'KK Memiliki Tabungan',
                          ),

                          _space(),

                          _inputField(
                            controller: kkMemilikiAsuransiController,

                            label: 'KK Memiliki Asuransi',
                          ),

                          _space(),

                          _inputField(
                            controller: kesehatanController,

                            label: 'Kesehatan',
                          ),

                          _space(),

                          _inputField(
                            controller: kelestarianLingkunganController,

                            label: 'Kelestarian Lingkungan Hidup',
                          ),

                          _space(),

                          _inputField(
                            controller: perencanaanSehatController,

                            label: 'Perencanaan Sehat',
                          ),

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
                                          ...data,
                                          'kk_memiliki_tabungan':
                                              kkMemilikiTabunganController.text,
                                          'kk_memiliki_asuransi':
                                              kkMemilikiAsuransiController.text,
                                          'kesehatan': kesehatanController.text,
                                          'kelestarian_lingkungan_hidup':
                                              kelestarianLingkunganController
                                                  .text,
                                          'perencanaan_sehat':
                                              perencanaanSehatController.text,
                                          if (_editingDraft != null)
                                            'draft': _editingDraft,
                                        };
                                        Get.toNamed(
                                          Routes.KEGIATAN_POKJA4_5,
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
