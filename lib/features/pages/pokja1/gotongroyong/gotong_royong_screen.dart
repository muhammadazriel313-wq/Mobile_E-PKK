import 'package:epkk_nganjuk/common/appbar/custom_appbar.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:epkk_nganjuk/features/auth/component/input_form_field.dart';
import 'package:epkk_nganjuk/common/typography.dart';
import 'package:epkk_nganjuk/features/draft/button_secondary_outline.dart';
import 'package:epkk_nganjuk/features/draft/draft_controller.dart';
import 'package:epkk_nganjuk/features/draft/draft_exit_dialog.dart';
import 'package:epkk_nganjuk/features/draft/draft_model.dart';
import 'package:epkk_nganjuk/features/draft/draft_service.dart';
import 'package:epkk_nganjuk/services/preferences/preferences_service.dart';
import 'package:epkk_nganjuk/features/pages/pokja1/gotongroyong/gotong_royong_controller.dart';
import 'package:epkk_nganjuk/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class GotongRoyongScreen extends StatefulWidget {
  const GotongRoyongScreen({super.key});

  @override
  State<GotongRoyongScreen> createState() => _GotongRoyongScreenState();
}

class _GotongRoyongScreenState extends State<GotongRoyongScreen> {
  String? id_user;
  String? id_role;
  String? id_organization;

  // 1. KERJA BAKTI
  final kerjaBaktiKegiatanController = TextEditingController();
  final kerjaBaktiVolController = TextEditingController();
  final kerjaBaktiMetodeController = TextEditingController();
  final kerjaBaktiSasaranController = TextEditingController();

  // 2. BANTUAN ANAK YATIM
  final bantuanYatimKegiatanController = TextEditingController();
  final bantuanYatimVolController = TextEditingController();
  final bantuanYatimMetodeController = TextEditingController();
  final bantuanYatimSasaranController = TextEditingController();

  // 3. KEGIATAN SOSIAL
  final kegiatanSosialKegiatanController = TextEditingController();
  final kegiatanSosialVolController = TextEditingController();
  final kegiatanSosialMetodeController = TextEditingController();
  final kegiatanSosialSasaranController = TextEditingController();

  // INFORMASI TAMBAHAN
  final sumberDanaController = TextEditingController();
  final hasilKegiatanController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final GotongRoyongController controller = Get.put(GotongRoyongController());
  DraftModel? _editingDraft;
  bool _isSavingDraft = false;
  bool _allowPop = false;

  void clearForm() {
    kerjaBaktiKegiatanController.clear();
    kerjaBaktiVolController.clear();
    kerjaBaktiMetodeController.clear();
    kerjaBaktiSasaranController.clear();

    bantuanYatimKegiatanController.clear();
    bantuanYatimVolController.clear();
    bantuanYatimMetodeController.clear();
    bantuanYatimSasaranController.clear();

    kegiatanSosialKegiatanController.clear();
    kegiatanSosialVolController.clear();
    kegiatanSosialMetodeController.clear();
    kegiatanSosialSasaranController.clear();

    sumberDanaController.clear();
    hasilKegiatanController.clear();
  }

  bool isFormEmpty() {
    return ![
      kerjaBaktiKegiatanController,
      kerjaBaktiVolController,
      kerjaBaktiMetodeController,
      kerjaBaktiSasaranController,
      bantuanYatimKegiatanController,
      bantuanYatimVolController,
      bantuanYatimMetodeController,
      bantuanYatimSasaranController,
      kegiatanSosialKegiatanController,
      kegiatanSosialVolController,
      kegiatanSosialMetodeController,
      kegiatanSosialSasaranController,
      sumberDanaController,
      hasilKegiatanController,
    ].any((field) => field.text.trim().isNotEmpty);
  }

  Map<String, dynamic> _collectFormData() {
    return {
      'id_user': id_user ?? _editingDraft?.idAkun ?? '',
      'id_role': id_role ?? '',
      'id_organization': id_organization ?? '',
      'kerja_bakti_kegiatan': kerjaBaktiKegiatanController.text.trim(),
      'kerja_bakti_vol': kerjaBaktiVolController.text.trim(),
      'kerja_bakti_metode': kerjaBaktiMetodeController.text.trim(),
      'kerja_bakti_sasaran': kerjaBaktiSasaranController.text.trim(),
      'bantuan_yatim_kegiatan': bantuanYatimKegiatanController.text.trim(),
      'bantuan_yatim_vol': bantuanYatimVolController.text.trim(),
      'bantuan_yatim_metode': bantuanYatimMetodeController.text.trim(),
      'bantuan_yatim_sasaran': bantuanYatimSasaranController.text.trim(),
      'kegiatan_sosial_kegiatan': kegiatanSosialKegiatanController.text.trim(),
      'kegiatan_sosial_vol': kegiatanSosialVolController.text.trim(),
      'kegiatan_sosial_metode': kegiatanSosialMetodeController.text.trim(),
      'kegiatan_sosial_sasaran': kegiatanSosialSasaranController.text.trim(),
      'sumber_dana': sumberDanaController.text.trim(),
      'hasil_kegiatan': hasilKegiatanController.text.trim(),
    };
  }

  void _populateFromDraft(DraftModel draft) {
    final data = draft.dataForm;
    kerjaBaktiKegiatanController.text = data['kerja_bakti_kegiatan']?.toString() ?? '';
    kerjaBaktiVolController.text = data['kerja_bakti_vol']?.toString() ?? '';
    kerjaBaktiMetodeController.text = data['kerja_bakti_metode']?.toString() ?? '';
    kerjaBaktiSasaranController.text = data['kerja_bakti_sasaran']?.toString() ?? '';
    bantuanYatimKegiatanController.text = data['bantuan_yatim_kegiatan']?.toString() ?? '';
    bantuanYatimVolController.text = data['bantuan_yatim_vol']?.toString() ?? '';
    bantuanYatimMetodeController.text = data['bantuan_yatim_metode']?.toString() ?? '';
    bantuanYatimSasaranController.text = data['bantuan_yatim_sasaran']?.toString() ?? '';
    kegiatanSosialKegiatanController.text = data['kegiatan_sosial_kegiatan']?.toString() ?? '';
    kegiatanSosialVolController.text = data['kegiatan_sosial_vol']?.toString() ?? '';
    kegiatanSosialMetodeController.text = data['kegiatan_sosial_metode']?.toString() ?? '';
    kegiatanSosialSasaranController.text = data['kegiatan_sosial_sasaran']?.toString() ?? '';
    sumberDanaController.text = data['sumber_dana']?.toString() ?? '';
    hasilKegiatanController.text = data['hasil_kegiatan']?.toString() ?? '';
    id_user = draft.idAkun;
    id_role ??= data['id_role']?.toString();
    id_organization ??= data['id_organization']?.toString();
  }

  Future<bool> _simpanDraf({bool showFeedback = false}) async {
    if (_isSavingDraft || controller.isLoading.value) return false;
    if (isFormEmpty()) {
      Get.snackbar('Form Kosong', 'Isi minimal satu kolom sebelum menyimpan draf.', snackPosition: SnackPosition.TOP);
      return false;
    }
    setState(() => _isSavingDraft = true);
    try {
      if ((id_user ?? '').isEmpty) {
        final user = await PreferencesService.getUser();
        id_user = user?.id;
      }
      if ((id_user ?? '').isEmpty) {
        Get.snackbar('Sesi Tidak Ditemukan', 'Masuk kembali untuk menyimpan draf.', snackPosition: SnackPosition.TOP);
        return false;
      }
      final data = _collectFormData();
      final service = DraftService();
      if (_editingDraft != null) {
        await service.updateDraft(_editingDraft!.copyWith(dataForm: data, status: 'draf', pesanError: null));
      } else {
        await service.simpanDraft(
          idAkun: id_user ?? '',
          jenis: 'gotong_royong',
          dataForm: data,
          originalPhotoPaths: [],
        );
      }
      final draftController = Get.isRegistered<DraftController>()
          ? Get.find<DraftController>()
          : Get.put(DraftController());
      await draftController.refreshAllCount();
      if (showFeedback) Get.snackbar('Berhasil', 'Draf disimpan', snackPosition: SnackPosition.TOP);
      return true;
    } catch (_) {
      Get.snackbar('Gagal', 'Draf tidak dapat disimpan.', snackPosition: SnackPosition.TOP);
      return false;
    } finally {
      if (mounted) setState(() => _isSavingDraft = false);
    }
  }

  void _showSnackbarDrafDisimpan() {
    Get.snackbar(
      '',
      '',
      titleText: Center(
        child: Text(
          'Draf disimpan',
          style: TextStyle(fontFamily: TypographyStyles.fontFamily, fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      messageText: const SizedBox.shrink(),
      maxWidth: 220,
      margin: EdgeInsets.only(top: 12.h, left: 20.w, right: 20.w),
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
  void initState() {
    super.initState();
    final args = Get.arguments ?? {};
    id_user = args['id_user'];
    id_role = args['id_role'];
    id_organization = args['id_organization'];
    if (args['draft'] is DraftModel) {
      _editingDraft = args['draft'] as DraftModel;
      _populateFromDraft(_editingDraft!);
    }
  }

  @override
  void dispose() {
    kerjaBaktiKegiatanController.dispose();
    kerjaBaktiVolController.dispose();
    kerjaBaktiMetodeController.dispose();
    kerjaBaktiSasaranController.dispose();

    bantuanYatimKegiatanController.dispose();
    bantuanYatimVolController.dispose();
    bantuanYatimMetodeController.dispose();
    bantuanYatimSasaranController.dispose();

    kegiatanSosialKegiatanController.dispose();
    kegiatanSosialVolController.dispose();
    kegiatanSosialMetodeController.dispose();
    kegiatanSosialSasaranController.dispose();

    sumberDanaController.dispose();
    hasilKegiatanController.dispose();

    super.dispose();
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 24.h, bottom: 12.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1F2937),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        appBar: AppBarSecondary(
          title: 'Gotong Royong',
          onBack: () async {
            final shouldPop = await _onWillPop();
            if (shouldPop && mounted) Get.back();
          },
        ),
        body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.manual,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ============ 1. KERJA BAKTI ============
                        _buildSectionTitle('KERJA BAKTI'),
                        InputFormField(
                          controller: kerjaBaktiKegiatanController,
                          hintText: 'Masukkan Kegiatan',
                          label: 'Kegiatan',
                        ),
                        SizedBox(height: 16.h),
                        InputFormField(
                          controller: kerjaBaktiVolController,
                          hintText: 'Masukkan Volume',
                          label: 'Volume',
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 16.h),
                        InputFormField(
                          controller: kerjaBaktiMetodeController,
                          hintText: 'Masukkan Metode',
                          label: 'Metode',
                        ),
                        SizedBox(height: 16.h),
                        InputFormField(
                          controller: kerjaBaktiSasaranController,
                          hintText: 'Masukkan Sasaran',
                          label: 'Sasaran',
                        ),

                        // ============ 2. BANTUAN ANAK YATIM ============
                        _buildSectionTitle('BANTUAN ANAK YATIM'),
                        InputFormField(
                          controller: bantuanYatimKegiatanController,
                          hintText: 'Masukkan Kegiatan',
                          label: 'Kegiatan',
                        ),
                        SizedBox(height: 16.h),
                        InputFormField(
                          controller: bantuanYatimVolController,
                          hintText: 'Masukkan Volume',
                          label: 'Volume',
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 16.h),
                        InputFormField(
                          controller: bantuanYatimMetodeController,
                          hintText: 'Masukkan Metode',
                          label: 'Metode',
                        ),
                        SizedBox(height: 16.h),
                        InputFormField(
                          controller: bantuanYatimSasaranController,
                          hintText: 'Masukkan Sasaran',
                          label: 'Sasaran',
                        ),

                        // ============ 3. KEGIATAN SOSIAL ============
                        _buildSectionTitle('KEGIATAN SOSIAL'),
                        InputFormField(
                          controller: kegiatanSosialKegiatanController,
                          hintText: 'Masukkan Kegiatan',
                          label: 'Kegiatan',
                        ),
                        SizedBox(height: 16.h),
                        InputFormField(
                          controller: kegiatanSosialVolController,
                          hintText: 'Masukkan Volume',
                          label: 'Volume',
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 16.h),
                        InputFormField(
                          controller: kegiatanSosialMetodeController,
                          hintText: 'Masukkan Metode',
                          label: 'Metode',
                        ),
                        SizedBox(height: 16.h),
                        InputFormField(
                          controller: kegiatanSosialSasaranController,
                          hintText: 'Masukkan Sasaran',
                          label: 'Sasaran',
                        ),

                        // ============ INFORMASI TAMBAHAN ============
                        _buildSectionTitle('INFORMASI TAMBAHAN'),
                        InputFormField(
                          controller: sumberDanaController,
                          hintText: 'Masukkan Sumber Dana (cth: APBD, Swadaya)',
                          label: 'Sumber Dana',
                        ),
                        SizedBox(height: 16.h),
                        InputFormField(
                          controller: hasilKegiatanController,
                          hintText: 'Masukkan Hasil Kegiatan',
                          label: 'Hasil Kegiatan',
                          minLines: 3,
                          maxLines: 5,
                        ),

                        SizedBox(height: 40.h),

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
                                    text: controller.isLoading.value
                                        ? 'Loading...'
                                        : 'Kirim',
                                    textColor: Colors.white,
                                    onPressed: controller.isLoading.value || _isSavingDraft
                                        ? null
                                        : () async {
                                      bool success = await controller
                                          .submitGotongRoyong(
                                            idUser: id_user ?? '',
                                            idRole: id_role ?? '',
                                            idOrganization:
                                                id_organization ?? '',

                                            // KERJA BAKTI
                                            kerjaBaktiKegiatan:
                                                kerjaBaktiKegiatanController
                                                    .text
                                                    .isNotEmpty
                                                ? kerjaBaktiKegiatanController
                                                      .text
                                                : null,
                                            kerjaBaktiVol:
                                                kerjaBaktiVolController
                                                    .text
                                                    .isNotEmpty
                                                ? kerjaBaktiVolController.text
                                                : null,
                                            kerjaBaktiMetode:
                                                kerjaBaktiMetodeController
                                                    .text
                                                    .isNotEmpty
                                                ? kerjaBaktiMetodeController
                                                      .text
                                                : null,
                                            kerjaBaktiSasaran:
                                                kerjaBaktiSasaranController
                                                    .text
                                                    .isNotEmpty
                                                ? kerjaBaktiSasaranController
                                                      .text
                                                : null,

                                            // BANTUAN ANAK YATIM
                                            bantuanYatimKegiatan:
                                                bantuanYatimKegiatanController
                                                    .text
                                                    .isNotEmpty
                                                ? bantuanYatimKegiatanController
                                                      .text
                                                : null,
                                            bantuanYatimVol:
                                                bantuanYatimVolController
                                                    .text
                                                    .isNotEmpty
                                                ? bantuanYatimVolController.text
                                                : null,
                                            bantuanYatimMetode:
                                                bantuanYatimMetodeController
                                                    .text
                                                    .isNotEmpty
                                                ? bantuanYatimMetodeController
                                                      .text
                                                : null,
                                            bantuanYatimSasaran:
                                                bantuanYatimSasaranController
                                                    .text
                                                    .isNotEmpty
                                                ? bantuanYatimSasaranController
                                                      .text
                                                : null,

                                            // KEGIATAN SOSIAL
                                            kegiatanSosialKegiatan:
                                                kegiatanSosialKegiatanController
                                                    .text
                                                    .isNotEmpty
                                                ? kegiatanSosialKegiatanController
                                                      .text
                                                : null,
                                            kegiatanSosialVol:
                                                kegiatanSosialVolController
                                                    .text
                                                    .isNotEmpty
                                                ? kegiatanSosialVolController
                                                      .text
                                                : null,
                                            kegiatanSosialMetode:
                                                kegiatanSosialMetodeController
                                                    .text
                                                    .isNotEmpty
                                                ? kegiatanSosialMetodeController
                                                      .text
                                                : null,
                                            kegiatanSosialSasaran:
                                                kegiatanSosialSasaranController
                                                    .text
                                                    .isNotEmpty
                                                ? kegiatanSosialSasaranController
                                                      .text
                                                : null,

                                            // TAMBAHAN
                                            sumberDana:
                                                sumberDanaController.text
                                                    .trim()
                                                    .isNotEmpty
                                                ? sumberDanaController.text
                                                      .trim()
                                                : null,
                                            hasilKegiatan:
                                                hasilKegiatanController.text
                                                    .trim()
                                                    .isNotEmpty
                                                ? hasilKegiatanController.text
                                                      .trim()
                                                : null,
                                          );

                                      if (success) {
                                        if (_editingDraft != null) {
                                          await DraftService().hapusDraft(_editingDraft!.id);
                                        }
                                        _formKey.currentState?.reset();
                                        clearForm();
                                        Get.offAllNamed(Routes.MAIN);
                                      } else if (controller.lastFailureWasNetwork.value && mounted) {
                                        final saveAsDraft = await Get.dialog<bool>(
                                          AlertDialog(
                                            title: const Text('Gagal terkirim'),
                                            content: const Text('Simpan sebagai draf agar isian tidak hilang?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Get.back(result: false),
                                                child: const Text('Tutup'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () => Get.back(result: true),
                                                child: const Text('Simpan Draf'),
                                              ),
                                            ],
                                          ),
                                          barrierDismissible: false,
                                        );
                                        if (saveAsDraft == true) await _simpanDrafLaluKembali();
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
              );
            },
          ),
        ),
      ),
      ),
    );
  }
}
