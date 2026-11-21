import 'package:epkk_nganjuk/common/appbar/custom_appbar.dart';
import 'package:epkk_nganjuk/core/validators/validator_form.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:epkk_nganjuk/features/draft/button_secondary_outline.dart';
import 'package:epkk_nganjuk/features/auth/component/input_form_field.dart';
import 'package:epkk_nganjuk/features/draft/draft_controller.dart';
import 'package:epkk_nganjuk/features/draft/draft_exit_dialog.dart';
import 'package:epkk_nganjuk/features/draft/draft_model.dart';
import 'package:epkk_nganjuk/features/draft/draft_service.dart';
import 'package:epkk_nganjuk/services/preferences/preferences_service.dart';
import 'package:epkk_nganjuk/features/pages/pokja1/kaderpokja1/kader_pokja1_controller.dart';
import 'package:epkk_nganjuk/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class KaderPokja1Screen extends StatefulWidget {
  const KaderPokja1Screen({super.key});

  @override
  State<KaderPokja1Screen> createState() => _KaderPokja1ScreenState();
}

class _KaderPokja1ScreenState extends State<KaderPokja1Screen> {
  String id_user = '';
  String id_role = '';
  String id_organization = '';
  String full_name = '';
  String name_role = '';
  String name_organization = '';

  final kaderUmumController = TextEditingController();
  final kaderKhususController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final UploadReportController uploadReportController = Get.put(
    UploadReportController(),
  );

  DraftModel? _editingDraft;
  bool _isSavingDraft = false;
  bool _allowPop = false;

  Map<String, dynamic> _collectFormData() {
    return {
      'id_user': id_user,
      'full_name': full_name,
      'id_role': id_role,
      'name_role': name_role,
      'id_organization': id_organization,
      'name_organization': name_organization,
      'kader_umum': kaderUmumController.text.trim(),
      'kader_khusus': kaderKhususController.text.trim(),
    };
  }

  void _populateFromDraft(DraftModel draft) {
    final data = draft.dataForm;
    if (data['kader_umum'] != null) {
      kaderUmumController.text = data['kader_umum'].toString();
    }
    if (data['kader_khusus'] != null) {
      kaderKhususController.text = data['kader_khusus'].toString();
    }
    if (data['id_user'] != null && id_user.isEmpty) {
      id_user = data['id_user'].toString();
    }
    if (data['id_role'] != null && id_role.isEmpty) {
      id_role = data['id_role'].toString();
    }
    if (data['id_organization'] != null && id_organization.isEmpty) {
      id_organization = data['id_organization'].toString();
    }
    if (data['full_name'] != null && full_name.isEmpty) {
      full_name = data['full_name'].toString();
    }
    if (data['name_role'] != null && name_role.isEmpty) {
      name_role = data['name_role'].toString();
    }
    if (data['name_organization'] != null && name_organization.isEmpty) {
      name_organization = data['name_organization'].toString();
    }
  }

  bool _isFormEmpty() {
    return kaderUmumController.text.trim().isEmpty &&
        kaderKhususController.text.trim().isEmpty;
  }

  void _showSnackbarDrafDisimpan() {
    final width = MediaQuery.of(Get.context!).size.width;
    final horizontalMargin = (width - 220) / 2;
    Get.snackbar(
      '',
      '',
      titleText: const Center(
        child: Text(
          'Draf disimpan',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
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

  Future<bool> _simpanDraf() async {
    if (_isSavingDraft || uploadReportController.isCreateKaderPokja1.value) {
      return false;
    }
    if (_isFormEmpty()) {
      Get.snackbar(
        'Form Kosong',
        'Isi minimal satu kolom sebelum menyimpan draf.',
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }
    setState(() => _isSavingDraft = true);
    try {
      if (id_user.isEmpty) {
        final user = await PreferencesService.getUser();
        id_user = user?.id ?? '';
      }
      if (id_user.isEmpty) {
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
          idAkun: id_user,
          jenis: 'kader_pokja1',
          dataForm: data,
          originalPhotoPaths: [],
        );
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

  Future<bool> _simpanDrafLaluKembali() async {
    if (!await _simpanDraf()) return false;
    _allowPop = true;
    Get.closeAllSnackbars();
    Get.back();
    Future.delayed(const Duration(milliseconds: 150), _showSnackbarDrafDisimpan);
    return true;
  }

  Future<bool> _onWillPop() async {
    if (_allowPop || _isFormEmpty()) return true;
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

    id_user = args['id_user'] ?? '';
    full_name = args['full_name'] ?? '';
    id_role = args['id_role'] ?? '';
    name_role = args['name_role'] ?? '';
    id_organization = args['id_organization'] ?? '';
    name_organization = args['name_organization'] ?? '';

    if (args['draft'] is DraftModel) {
      _editingDraft = args['draft'] as DraftModel;
      _populateFromDraft(_editingDraft!);
    }
  }

  void clearForm() {
    kaderUmumController.clear();
    kaderKhususController.clear();
  }

  @override
  void dispose() {
    kaderUmumController.dispose();
    kaderKhususController.dispose();
    super.dispose();
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
          title: 'Kader Pokja I',
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
                        SizedBox(height: 12.h),

                        /// PKBN
                        InputFormField(
                          controller: kaderUmumController,

                          keyboardType: TextInputType.number,

                          hintText: 'Masukkan jumlah',

                          label: 'Kader Umum',

                          validator: (value) =>
                              ValidatorForm.validateNumber(value),
                        ),

                        SizedBox(height: 24.h),

                        /// PKDRT
                        InputFormField(
                          controller: kaderKhususController,

                          keyboardType: TextInputType.number,

                          hintText: 'Masukkan jumlah',

                          label: 'Kader Khusus',

                          validator: (value) =>
                              ValidatorForm.validateNumber(value),
                        ),

                        SizedBox(height: 24.h),

                        SizedBox(height: 40.h),

                        /// BUTTONS
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
                                          uploadReportController
                                              .isCreateKaderPokja1.value
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
                                    text: uploadReportController
                                            .isCreateKaderPokja1.value
                                        ? 'Loading'
                                        : 'Kirim',
                                    textColor: Colors.white,
                                    onPressed: uploadReportController
                                                .isCreateKaderPokja1.value ||
                                            _isSavingDraft
                                        ? null
                                        : () async {
                                            if (!_formKey.currentState!
                                                .validate()) {
                                              return;
                                            }

                                            await uploadReportController
                                                .createKaderPokja1Controller(
                                                  kader_umum:
                                                      kaderUmumController.text,
                                                  kader_khusus:
                                                      kaderKhususController.text,
                                                  id_role: id_role,
                                                  id_organization:
                                                      id_organization,
                                                  id_user: id_user,
                                                );

                                            final res = uploadReportController
                                                .reportKaderPokja1Model
                                                .value;

                                            if (res != null &&
                                                res.statusCode == 200) {
                                              if (_editingDraft != null) {
                                                await DraftService()
                                                    .hapusDraft(_editingDraft!.id);
                                                final draftController = Get.isRegistered<DraftController>()
                                                    ? Get.find<DraftController>()
                                                    : Get.put(DraftController());
                                                await draftController.refreshAllCount();
                                              }

                                              _formKey.currentState?.reset();
                                              clearForm();
                                              Get.offAllNamed(Routes.MAIN);
                                            } else if (uploadReportController
                                                .lastFailureWasNetwork.value) {
                                              Get.dialog(
                                                AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(16.r),
                                                  ),
                                                  title: const Text(
                                                    'Gagal Terkirim',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  content: const Text(
                                                    'Koneksi gagal. Simpan sebagai draf agar data tidak hilang?',
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () => Get.back(),
                                                      child: const Text('Batal'),
                                                    ),
                                                    ElevatedButton(
                                                      style:
                                                          ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            const Color(0xFF3F8FC1),
                                                        foregroundColor:
                                                            Colors.white,
                                                      ),
                                                      onPressed: () async {
                                                        Get.back();
                                                        await _simpanDrafLaluKembali();
                                                      },
                                                      child: const Text(
                                                        'Simpan Draf',
                                                      ),
                                                    ),
                                                  ],
                                                ),
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
              );
            },
          ),
        ),
      ),
      ),
    );
  }
}
