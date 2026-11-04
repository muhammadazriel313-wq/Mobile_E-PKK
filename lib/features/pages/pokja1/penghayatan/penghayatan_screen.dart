import 'package:epkk_nganjuk/common/appbar/custom_appbar.dart';
import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/common/typography.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:epkk_nganjuk/features/auth/component/input_form_field.dart';
import 'package:epkk_nganjuk/features/draft/button_secondary_outline.dart';
import 'package:epkk_nganjuk/features/draft/draft_exit_dialog.dart';
import 'package:epkk_nganjuk/features/draft/draft_model.dart';
import 'package:epkk_nganjuk/features/draft/draft_service.dart';
import 'package:epkk_nganjuk/features/pages/pokja1/penghayatan/penghayatan_controller.dart';
import 'package:epkk_nganjuk/routes/app_routes.dart';
import 'package:epkk_nganjuk/services/preferences/preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class PenghayatanPengamalanScreen extends StatefulWidget {
  const PenghayatanPengamalanScreen({super.key});

  @override
  State<PenghayatanPengamalanScreen> createState() => _PenghayatanPengamalanScreenState();
}

class _PenghayatanPengamalanScreenState extends State<PenghayatanPengamalanScreen> {
  String id_user = '';
  String id_role = '';
  String id_organization = '';
  String full_name = '';
  String name_role = '';
  String name_organization = '';

  // Mode Edit Draf
  DraftModel? _editingDraft;
  bool _isSavingDraft = false;

  final kisahKegiatanController = TextEditingController();
  final kisahVolController = TextEditingController();
  final kisahMetodeController = TextEditingController();
  final kisahSasaranController = TextEditingController();

  final krisanKegiatanController = TextEditingController();
  final krisanVolController = TextEditingController();
  final krisanMetodeController = TextEditingController();
  final krisanSasaranController = TextEditingController();

  final kilasKegiatanController = TextEditingController();
  final kilasVolController = TextEditingController();
  final kilasMetodeController = TextEditingController();
  final kilasSasaranController = TextEditingController();

  final kiatKegiatanController = TextEditingController();
  final kiatVolController = TextEditingController();
  final kiatMetodeController = TextEditingController();
  final kiatSasaranController = TextEditingController();

  final kisakKegiatanController = TextEditingController();
  final kisakVolController = TextEditingController();
  final kisakMetodeController = TextEditingController();
  final kisakSasaranController = TextEditingController();

  final pkbnKegiatanController = TextEditingController();
  final pkbnVolController = TextEditingController();
  final pkbnMetodeController = TextEditingController();
  final pkbnSasaranController = TextEditingController();

  final sumberDanaController = TextEditingController();
  final hasilKegiatanController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final PenghayatanPengamalanController penghayatanController = Get.put(
    PenghayatanPengamalanController(),
  );

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

    // Pastikan id_user selalu valid dari PreferencesService jika tidak terpassing lewat args
    if (id_user.isEmpty) {
      _loadUserIdFromPrefs();
    }

    // Jika dibuka dalam rangka Edit Draf
    if (args['draft'] != null && args['draft'] is DraftModel) {
      _editingDraft = args['draft'] as DraftModel;
      _populateFromDraft(_editingDraft!);
    }
  }

  Future<void> _loadUserIdFromPrefs() async {
    final user = await PreferencesService.getUser();
    if (user != null && mounted) {
      setState(() {
        id_user = user.id;
      });
    }
  }

  void _populateFromDraft(DraftModel draft) {
    final data = draft.dataForm;
    kisahKegiatanController.text = data['kisah_kegiatan']?.toString() ?? '';
    kisahVolController.text = data['kisah_vol']?.toString() ?? '';
    kisahMetodeController.text = data['kisah_metode']?.toString() ?? '';
    kisahSasaranController.text = data['kisah_sasaran']?.toString() ?? '';

    krisanKegiatanController.text = data['krisan_kegiatan']?.toString() ?? '';
    krisanVolController.text = data['krisan_vol']?.toString() ?? '';
    krisanMetodeController.text = data['krisan_metode']?.toString() ?? '';
    krisanSasaranController.text = data['krisan_sasaran']?.toString() ?? '';

    kilasKegiatanController.text = data['kilas_kegiatan']?.toString() ?? '';
    kilasVolController.text = data['kilas_vol']?.toString() ?? '';
    kilasMetodeController.text = data['kilas_metode']?.toString() ?? '';
    kilasSasaranController.text = data['kilas_sasaran']?.toString() ?? '';

    kiatKegiatanController.text = data['kiat_kegiatan']?.toString() ?? '';
    kiatVolController.text = data['kiat_vol']?.toString() ?? '';
    kiatMetodeController.text = data['kiat_metode']?.toString() ?? '';
    kiatSasaranController.text = data['kiat_sasaran']?.toString() ?? '';

    kisakKegiatanController.text = data['kisak_kegiatan']?.toString() ?? '';
    kisakVolController.text = data['kisak_vol']?.toString() ?? '';
    kisakMetodeController.text = data['kisak_metode']?.toString() ?? '';
    kisakSasaranController.text = data['kisak_sasaran']?.toString() ?? '';

    pkbnKegiatanController.text = data['pkbn_kegiatan']?.toString() ?? '';
    pkbnVolController.text = data['pkbn_vol']?.toString() ?? '';
    pkbnMetodeController.text = data['pkbn_metode']?.toString() ?? '';
    pkbnSasaranController.text = data['pkbn_sasaran']?.toString() ?? '';

    sumberDanaController.text = data['sumber_dana']?.toString() ?? '';
    hasilKegiatanController.text = data['hasil_kegiatan']?.toString() ?? '';

    if (id_role.isEmpty) id_role = data['id_role']?.toString() ?? '';
    if (id_organization.isEmpty) id_organization = data['id_organization']?.toString() ?? '';
  }

  void clearForm() {
    kisahKegiatanController.clear(); kisahVolController.clear();
    kisahMetodeController.clear(); kisahSasaranController.clear();
    krisanKegiatanController.clear(); krisanVolController.clear();
    krisanMetodeController.clear(); krisanSasaranController.clear();
    kilasKegiatanController.clear(); kilasVolController.clear();
    kilasMetodeController.clear(); kilasSasaranController.clear();
    kiatKegiatanController.clear(); kiatVolController.clear();
    kiatMetodeController.clear(); kiatSasaranController.clear();
    kisakKegiatanController.clear(); kisakVolController.clear();
    kisakMetodeController.clear(); kisakSasaranController.clear();
    pkbnKegiatanController.clear(); pkbnVolController.clear();
    pkbnMetodeController.clear(); pkbnSasaranController.clear();
    sumberDanaController.clear();
    hasilKegiatanController.clear();
  }

  @override
  void dispose() {
    kisahKegiatanController.dispose(); kisahVolController.dispose();
    kisahMetodeController.dispose(); kisahSasaranController.dispose();
    krisanKegiatanController.dispose(); krisanVolController.dispose();
    krisanMetodeController.dispose(); krisanSasaranController.dispose();
    kilasKegiatanController.dispose(); kilasVolController.dispose();
    kilasMetodeController.dispose(); kilasSasaranController.dispose();
    kiatKegiatanController.dispose(); kiatVolController.dispose();
    kiatMetodeController.dispose(); kiatSasaranController.dispose();
    kisakKegiatanController.dispose(); kisakVolController.dispose();
    kisakMetodeController.dispose(); kisakSasaranController.dispose();
    pkbnKegiatanController.dispose(); pkbnVolController.dispose();
    pkbnMetodeController.dispose(); pkbnSasaranController.dispose();
    sumberDanaController.dispose();
    hasilKegiatanController.dispose();
    super.dispose();
  }

  Widget _buildDivisiTitle(String title) {
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

  bool _isAnyFieldFilled() {
    return kisahKegiatanController.text.trim().isNotEmpty || kisahVolController.text.trim().isNotEmpty ||
           kisahMetodeController.text.trim().isNotEmpty || kisahSasaranController.text.trim().isNotEmpty ||
           krisanKegiatanController.text.trim().isNotEmpty || krisanVolController.text.trim().isNotEmpty ||
           krisanMetodeController.text.trim().isNotEmpty || krisanSasaranController.text.trim().isNotEmpty ||
           kilasKegiatanController.text.trim().isNotEmpty || kilasVolController.text.trim().isNotEmpty ||
           kilasMetodeController.text.trim().isNotEmpty || kilasSasaranController.text.trim().isNotEmpty ||
           kiatKegiatanController.text.trim().isNotEmpty || kiatVolController.text.trim().isNotEmpty ||
           kiatMetodeController.text.trim().isNotEmpty || kiatSasaranController.text.trim().isNotEmpty ||
           kisakKegiatanController.text.trim().isNotEmpty || kisakVolController.text.trim().isNotEmpty ||
           kisakMetodeController.text.trim().isNotEmpty || kisakSasaranController.text.trim().isNotEmpty ||
           pkbnKegiatanController.text.trim().isNotEmpty || pkbnVolController.text.trim().isNotEmpty ||
           pkbnMetodeController.text.trim().isNotEmpty || pkbnSasaranController.text.trim().isNotEmpty ||
           sumberDanaController.text.trim().isNotEmpty || hasilKegiatanController.text.trim().isNotEmpty;
  }

  Map<String, dynamic> _collectFormData() {
    return {
      'id_user': id_user,
      'id_role': id_role,
      'id_organization': id_organization,
      'kisah_kegiatan': kisahKegiatanController.text.trim(),
      'kisah_vol': kisahVolController.text.trim(),
      'kisah_metode': kisahMetodeController.text.trim(),
      'kisah_sasaran': kisahSasaranController.text.trim(),
      'krisan_kegiatan': krisanKegiatanController.text.trim(),
      'krisan_vol': krisanVolController.text.trim(),
      'krisan_metode': krisanMetodeController.text.trim(),
      'krisan_sasaran': krisanSasaranController.text.trim(),
      'kilas_kegiatan': kilasKegiatanController.text.trim(),
      'kilas_vol': kilasVolController.text.trim(),
      'kilas_metode': kilasMetodeController.text.trim(),
      'kilas_sasaran': kilasSasaranController.text.trim(),
      'kiat_kegiatan': kiatKegiatanController.text.trim(),
      'kiat_vol': kiatVolController.text.trim(),
      'kiat_metode': kiatMetodeController.text.trim(),
      'kiat_sasaran': kiatSasaranController.text.trim(),
      'kisak_kegiatan': kisakKegiatanController.text.trim(),
      'kisak_vol': kisakVolController.text.trim(),
      'kisak_metode': kisakMetodeController.text.trim(),
      'kisak_sasaran': kisakSasaranController.text.trim(),
      'pkbn_kegiatan': pkbnKegiatanController.text.trim(),
      'pkbn_vol': pkbnVolController.text.trim(),
      'pkbn_metode': pkbnMetodeController.text.trim(),
      'pkbn_sasaran': pkbnSasaranController.text.trim(),
      'sumber_dana': sumberDanaController.text.trim(),
      'hasil_kegiatan': hasilKegiatanController.text.trim(),
    };
  }

  Future<void> _handleSaveDraft({bool showFeedback = true}) async {
    if (_isSavingDraft) return;
    setState(() => _isSavingDraft = true);

    try {
      String effectiveIdAkun = id_user;
      if (effectiveIdAkun.isEmpty) {
        final user = await PreferencesService.getUser();
        effectiveIdAkun = user?.id ?? '';
      }

      if (effectiveIdAkun.isEmpty) {
        Get.snackbar('Perhatian', 'Sesi login tidak ditemukan', backgroundColor: const Color(0xFFEF5350), colorText: Colors.white);
        return;
      }

      final draftService = DraftService();
      final formData = _collectFormData();

      if (_editingDraft != null) {
        // Update draft yang sedang diedit
        final updatedDraft = _editingDraft!.copyWith(
          dataForm: formData,
          status: 'draf',
          pesanError: null,
        );
        await draftService.updateDraft(updatedDraft);
      } else {
        // Simpan sebagai draf baru
        await draftService.simpanDraft(
          idAkun: effectiveIdAkun,
          jenis: 'pancasila',
          dataForm: formData,
          originalPhotoPaths: [],
        );
      }

      if (showFeedback) {
        Get.snackbar(
          'Draf Tersimpan',
          'Laporan berhasil disimpan sebagai draf di HP',
          backgroundColor: const Color(0xFF3F8FC1),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      if (showFeedback) {
        Get.snackbar(
          'Gagal Menyimpan Draf',
          'Terjadi kesalahan saat menyimpan draf',
          backgroundColor: const Color(0xFFEF5350),
          colorText: Colors.white,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSavingDraft = false);
      }
    }
  }

  Future<bool> _onWillPop() async {
    if (!_isAnyFieldFilled()) {
      return true;
    }
    return await DraftExitDialog.show(
      context: context,
      onSaveDraft: () async {
        await _handleSaveDraft(showFeedback: true);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop) {
          Get.back();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBarSecondary(
          title: 'Penghayatan Dan Pengamalan Pancasila',
          onBack: () async {
            final shouldPop = await _onWillPop();
            if (shouldPop) {
              Get.back();
            }
          },
        ),
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_editingDraft != null) ...[
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE3F2FD),
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(color: const Color(0xFF90CAF9)),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.info_outline, size: 18.sp, color: BrandColors.brandPrimary25),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: TypographyStyles.bodyCaptionReguler(
                                      'Tanggal laporan: mengikuti tanggal draf dibuat',
                                      color: BrandColors.brandPrimary25,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 12.h),
                          ],

                          // ============ KISAH ============
                          _buildDivisiTitle('KISAH'),
                          InputFormField(controller: kisahKegiatanController, hintText: 'Masukkan Kegiatan', label: 'Kegiatan'),
                          SizedBox(height: 16.h),
                          InputFormField(controller: kisahVolController, hintText: 'Masukkan Volume', label: 'Volume', keyboardType: TextInputType.number),
                          SizedBox(height: 16.h),
                          InputFormField(controller: kisahMetodeController, hintText: 'Masukkan Metode', label: 'Metode'),
                          SizedBox(height: 16.h),
                          InputFormField(controller: kisahSasaranController, hintText: 'Masukkan Sasaran', label: 'Sasaran'),

                          // ============ KRISAN ============
                          _buildDivisiTitle('KRISAN'),
                          InputFormField(controller: krisanKegiatanController, hintText: 'Masukkan Kegiatan', label: 'Kegiatan'),
                          SizedBox(height: 16.h),
                          InputFormField(controller: krisanVolController, hintText: 'Masukkan Volume', label: 'Volume', keyboardType: TextInputType.number),
                          SizedBox(height: 16.h),
                          InputFormField(controller: krisanMetodeController, hintText: 'Masukkan Metode', label: 'Metode'),
                          SizedBox(height: 16.h),
                          InputFormField(controller: krisanSasaranController, hintText: 'Masukkan Sasaran', label: 'Sasaran'),

                          // ============ KILAS ============
                          _buildDivisiTitle('KILAS'),
                          InputFormField(controller: kilasKegiatanController, hintText: 'Masukkan Kegiatan', label: 'Kegiatan'),
                          SizedBox(height: 16.h),
                          InputFormField(controller: kilasVolController, hintText: 'Masukkan Volume', label: 'Volume', keyboardType: TextInputType.number),
                          SizedBox(height: 16.h),
                          InputFormField(controller: kilasMetodeController, hintText: 'Masukkan Metode', label: 'Metode'),
                          SizedBox(height: 16.h),
                          InputFormField(controller: kilasSasaranController, hintText: 'Masukkan Sasaran', label: 'Sasaran'),

                          // ============ KIAT ============
                          _buildDivisiTitle('KIAT'),
                          InputFormField(controller: kiatKegiatanController, hintText: 'Masukkan Kegiatan', label: 'Kegiatan'),
                          SizedBox(height: 16.h),
                          InputFormField(controller: kiatVolController, hintText: 'Masukkan Volume', label: 'Volume', keyboardType: TextInputType.number),
                          SizedBox(height: 16.h),
                          InputFormField(controller: kiatMetodeController, hintText: 'Masukkan Metode', label: 'Metode'),
                          SizedBox(height: 16.h),
                          InputFormField(controller: kiatSasaranController, hintText: 'Masukkan Sasaran', label: 'Sasaran'),

                          // ============ KISAK ============
                          _buildDivisiTitle('KISAK'),
                          InputFormField(controller: kisakKegiatanController, hintText: 'Masukkan Kegiatan', label: 'Kegiatan'),
                          SizedBox(height: 16.h),
                          InputFormField(controller: kisakVolController, hintText: 'Masukkan Volume', label: 'Volume', keyboardType: TextInputType.number),
                          SizedBox(height: 16.h),
                          InputFormField(controller: kisakMetodeController, hintText: 'Masukkan Metode', label: 'Metode'),
                          SizedBox(height: 16.h),
                          InputFormField(controller: kisakSasaranController, hintText: 'Masukkan Sasaran', label: 'Sasaran'),

                          // ============ PKBN ============
                          _buildDivisiTitle('PKBN'),
                          InputFormField(controller: pkbnKegiatanController, hintText: 'Masukkan Kegiatan', label: 'Kegiatan'),
                          SizedBox(height: 16.h),
                          InputFormField(controller: pkbnVolController, hintText: 'Masukkan Volume', label: 'Volume', keyboardType: TextInputType.number),
                          SizedBox(height: 16.h),
                          InputFormField(controller: pkbnMetodeController, hintText: 'Masukkan Metode', label: 'Metode'),
                          SizedBox(height: 16.h),
                          InputFormField(controller: pkbnSasaranController, hintText: 'Masukkan Sasaran', label: 'Sasaran'),

                          // ============ INFORMASI TAMBAHAN ============
                          _buildDivisiTitle('INFORMASI TAMBAHAN'),
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

                          SizedBox(height: 36.h),

                          // ============ TOMBOL AKSI (DRAF & KIRIM) ============
                          Row(
                            children: [
                              // Tombol Simpan Draf / Simpan Perubahan (Outline, Sekunder)
                              Expanded(
                                child: ZoomTapAnimation(
                                  child: ButtonSecondaryOutline(
                                    text: _isSavingDraft
                                        ? 'Menyimpan...'
                                        : (_editingDraft != null ? 'Simpan Perubahan' : 'Simpan Draf'),
                                    onPressed: _isSavingDraft || penghayatanController.isLoading.value
                                        ? null
                                        : () async {
                                            await _handleSaveDraft(showFeedback: true);
                                            if (mounted) {
                                              Get.back();
                                            }
                                          },
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              // Tombol Kirim (Fill, Utama)
                              Expanded(
                                child: ZoomTapAnimation(
                                  child: Obx(
                                    () => ButtonFill(
                                      text: penghayatanController.isLoading.value ? 'Loading' : 'Kirim',
                                      textColor: Colors.white,
                                      onPressed: penghayatanController.isLoading.value || _isSavingDraft
                                          ? null
                                          : () async {
                                              await penghayatanController.submitPenghayatanPengamalan(
                                                idRole: id_role,
                                                idOrganization: id_organization,
                                                idUser: id_user,
                                                kisahKegiatan: kisahKegiatanController.text,
                                                kisahVol: kisahVolController.text,
                                                kisahMetode: kisahMetodeController.text,
                                                kisahSasaran: kisahSasaranController.text,
                                                krisanKegiatan: krisanKegiatanController.text,
                                                krisanVol: krisanVolController.text,
                                                krisanMetode: krisanMetodeController.text,
                                                krisanSasaran: krisanSasaranController.text,
                                                kilasKegiatan: kilasKegiatanController.text,
                                                kilasVol: kilasVolController.text,
                                                kilasMetode: kilasMetodeController.text,
                                                kilasSasaran: kilasSasaranController.text,
                                                kiatKegiatan: kiatKegiatanController.text,
                                                kiatVol: kiatVolController.text,
                                                kiatMetode: kiatMetodeController.text,
                                                kiatSasaran: kiatSasaranController.text,
                                                kisakKegiatan: kisakKegiatanController.text,
                                                kisakVol: kisakVolController.text,
                                                kisakMetode: kisakMetodeController.text,
                                                kisakSasaran: kisakSasaranController.text,
                                                pkbnKegiatan: pkbnKegiatanController.text,
                                                pkbnVol: pkbnVolController.text,
                                                pkbnMetode: pkbnMetodeController.text,
                                                pkbnSasaran: pkbnSasaranController.text,
                                                sumberDana: sumberDanaController.text.isNotEmpty ? sumberDanaController.text : null,
                                                hasilKegiatan: hasilKegiatanController.text.isNotEmpty ? hasilKegiatanController.text : null,
                                              );

                                              final res = penghayatanController.reportData.value;
                                              if (res != null && res.statusCode == 200) {
                                                if (_editingDraft != null) {
                                                  // Jika yang dikirim adalah draf yang sedang diedit, hapus dari DB
                                                  await DraftService().hapusDraft(_editingDraft!.id);
                                                }
                                                _formKey.currentState?.reset();
                                                clearForm();
                                                Get.offAllNamed(Routes.MAIN);
                                              }
                                            },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 24.h),
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
