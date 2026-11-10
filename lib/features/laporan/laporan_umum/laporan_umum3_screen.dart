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
import 'package:epkk_nganjuk/features/laporan/laporan_umum/laporan_umum_controller.dart';
import 'package:epkk_nganjuk/routes/app_routes.dart';
import 'package:epkk_nganjuk/services/preferences/preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class LaporanUmum3Screen extends StatefulWidget {
  const LaporanUmum3Screen({super.key});

  @override
  State<LaporanUmum3Screen> createState() => _LaporanUmum3ScreenState();
}

class _LaporanUmum3ScreenState extends State<LaporanUmum3Screen> {
  // ================= DATA =================

  String id_user = '';
  String id_role = '';
  String id_organization = '';

  String full_name = '';
  String name_role = '';
  String name_organization = '';

  String dusun_lingkungan = '';

  String PKK_RW = '';
  String PKK_RT = '';

  String desa_wisma = '';

  String KRT = '';
  String KK = '';

  String jiwa_laki = '';
  String jiwa_perempuan = '';

  String anggota_laki = '';
  String anggota_perempuan = '';

  String umum_laki = '';
  String umum_perempuan = '';

  String khusus_laki = '';
  String khusus_perempuan = '';

  // ================= CONTROLLER =================

  final lakilaki1Controller = TextEditingController();

  final perempuan1Controller = TextEditingController();

  final lakilaki2Controller = TextEditingController();

  final perempuan2Controller = TextEditingController();

  // ================= FORM =================

  final _formKey = GlobalKey<FormState>();

  // ================= GETX =================

  final LaporanUmumController uploadController = Get.put(
    LaporanUmumController(),
  );

  // ================= DRAFT STATE =================
  DraftModel? _editingDraft;
  bool _isSavingDraft = false;

  Map<String, dynamic> _collectFormData() {
    final existingData = _editingDraft?.dataForm ?? {};
    final data = Map<String, dynamic>.from(existingData);
    data['id_user'] = id_user.isNotEmpty ? id_user : (_editingDraft?.idAkun ?? '');
    data['id_role'] = id_role;
    data['id_organization'] = id_organization;
    data['full_name'] = full_name;
    data['name_role'] = name_role;
    data['name_organization'] = name_organization;
    data['dusun_lingkungan'] = dusun_lingkungan;
    data['PKK_RW'] = PKK_RW;
    data['PKK_RT'] = PKK_RT;
    data['desa_wisma'] = desa_wisma;
    data['KRT'] = KRT;
    data['KK'] = KK;

    data['jiwa_laki'] = jiwa_laki;
    data['jiwa_perempuan'] = jiwa_perempuan;
    data['anggota_laki'] = anggota_laki;
    data['anggota_perempuan'] = anggota_perempuan;
    data['umum_laki'] = umum_laki;
    data['umum_perempuan'] = umum_perempuan;
    data['khusus_laki'] = khusus_laki;
    data['khusus_perempuan'] = khusus_perempuan;

    data['honorer_laki'] = lakilaki1Controller.text.trim();
    data['honorer_perempuan'] = perempuan1Controller.text.trim();
    data['bantuan_laki'] = lakilaki2Controller.text.trim();
    data['bantuan_perempuan'] = perempuan2Controller.text.trim();
    data['langkah'] = 3;
    return data;
  }

  void _populateFromDraft(DraftModel draft) {
    final data = draft.dataForm;
    lakilaki1Controller.text = data['honorer_laki']?.toString() ?? '';
    perempuan1Controller.text = data['honorer_perempuan']?.toString() ?? '';
    lakilaki2Controller.text = data['bantuan_laki']?.toString() ?? '';
    perempuan2Controller.text = data['bantuan_perempuan']?.toString() ?? '';

    if (id_user.isEmpty) id_user = draft.idAkun;
    if (id_role.isEmpty) id_role = data['id_role']?.toString() ?? '';
    if (id_organization.isEmpty) id_organization = data['id_organization']?.toString() ?? '';
    if (full_name.isEmpty) full_name = data['full_name']?.toString() ?? '';
    if (name_role.isEmpty) name_role = data['name_role']?.toString() ?? '';
    if (name_organization.isEmpty) name_organization = data['name_organization']?.toString() ?? '';

    if (dusun_lingkungan.isEmpty) dusun_lingkungan = data['dusun_lingkungan']?.toString() ?? '';
    if (PKK_RW.isEmpty) PKK_RW = data['PKK_RW']?.toString() ?? '';
    if (PKK_RT.isEmpty) PKK_RT = data['PKK_RT']?.toString() ?? '';
    if (desa_wisma.isEmpty) desa_wisma = data['desa_wisma']?.toString() ?? '';
    if (KRT.isEmpty) KRT = data['KRT']?.toString() ?? '';
    if (KK.isEmpty) KK = data['KK']?.toString() ?? '';

    if (jiwa_laki.isEmpty) jiwa_laki = data['jiwa_laki']?.toString() ?? '';
    if (jiwa_perempuan.isEmpty) jiwa_perempuan = data['jiwa_perempuan']?.toString() ?? '';
    if (anggota_laki.isEmpty) anggota_laki = data['anggota_laki']?.toString() ?? '';
    if (anggota_perempuan.isEmpty) anggota_perempuan = data['anggota_perempuan']?.toString() ?? '';
    if (umum_laki.isEmpty) umum_laki = data['umum_laki']?.toString() ?? '';
    if (umum_perempuan.isEmpty) umum_perempuan = data['umum_perempuan']?.toString() ?? '';
    if (khusus_laki.isEmpty) khusus_laki = data['khusus_laki']?.toString() ?? '';
    if (khusus_perempuan.isEmpty) khusus_perempuan = data['khusus_perempuan']?.toString() ?? '';
  }

  Future<bool> _simpanDraf({bool showFeedback = false}) async {
    if (_isSavingDraft || uploadController.isLoading.value) return false;

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
    Get.closeAllSnackbars();
    Get.until((route) => route.settings.name == Routes.HOME || route.isFirst);
    Future.delayed(const Duration(milliseconds: 150), _showSnackbarDrafDisimpan);
    return true;
  }

  @override
  void initState() {
    super.initState();

    final args = (Get.arguments ?? {}) as Map;

    id_user = args['id_user']?.toString() ?? '';

    full_name = args['full_name']?.toString() ?? '';

    id_role = args['id_role']?.toString() ?? '';

    name_role = args['name_role']?.toString() ?? '';

    id_organization = args['id_organization']?.toString() ?? '';

    name_organization = args['name_organization']?.toString() ?? '';

    dusun_lingkungan = args['dusun_lingkungan']?.toString() ?? '';

    PKK_RW = args['PKK_RW']?.toString() ?? '';

    PKK_RT = args['PKK_RT']?.toString() ?? '';

    desa_wisma = args['desa_wisma']?.toString() ?? '';

    KRT = args['KRT']?.toString() ?? '';

    KK = args['KK']?.toString() ?? '';

    jiwa_laki = args['jiwa_laki']?.toString() ?? '';

    jiwa_perempuan = args['jiwa_perempuan']?.toString() ?? '';

    anggota_laki = args['anggota_laki']?.toString() ?? '';

    anggota_perempuan = args['anggota_perempuan']?.toString() ?? '';

    umum_laki = args['umum_laki']?.toString() ?? '';

    umum_perempuan = args['umum_perempuan']?.toString() ?? '';

    khusus_laki = args['khusus_laki']?.toString() ?? '';

    khusus_perempuan = args['khusus_perempuan']?.toString() ?? '';

    if (args['draft'] is DraftModel) {
      _editingDraft = args['draft'] as DraftModel;
      _populateFromDraft(_editingDraft!);
    }
  }

  @override
  void dispose() {
    lakilaki1Controller.dispose();

    perempuan1Controller.dispose();

    lakilaki2Controller.dispose();

    perempuan2Controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    final isTablet = media.size.width >= 600;

    return Scaffold(
      resizeToAvoidBottomInset: true,

      backgroundColor: Colors.white,

      // ================= APPBAR =================
      appBar: AppBarSecondary(
        title: 'Laporan Umum',

        currentStep: 3,

        totalSteps: 4,
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
                          // ================= HONORER =================
                          _section('Jumlah Tenaga Sekretariat - Honorer'),

                          _input(lakilaki1Controller, 'Laki-laki'),

                          _input(perempuan1Controller, 'Perempuan'),

                          // ================= BANTUAN =================
                          _section('Bantuan'),

                          _input(lakilaki2Controller, 'Laki-laki'),

                          _input(perempuan2Controller, 'Perempuan'),

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
                                    onPressed: _isSavingDraft || uploadController.isLoading.value
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
                                      isLoading: uploadController.isLoading.value,
                                      onPressed: uploadController.isLoading.value || _isSavingDraft
                                          ? null
                                          : () {
                                              if (_formKey.currentState!.validate()) {
                                                final nextArgs = _collectFormData();
                                                nextArgs['draft'] = _editingDraft;
                                                Get.toNamed(
                                                  Routes.LAPORAN_UMUM4,
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
    );
  }

  // ================= SECTION =================

  Widget _section(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        TypographyStyles.bodyCaptionBold(title, color: TextColors.grey700),

        SizedBox(height: 24.h),
      ],
    );
  }

  // ================= INPUT =================

  Widget _input(TextEditingController controller, String label) {
    return Column(
      children: [
        InputFormField(
          controller: controller,

          hintText: 'Masukkan jumlah',

          label: label,

          keyboardType: TextInputType.number,

          textInputAction: TextInputAction.next,

          validator: (value) => ValidatorForm.validateDefault(value),
        ),

        SizedBox(height: 24.h),
      ],
    );
  }
}
