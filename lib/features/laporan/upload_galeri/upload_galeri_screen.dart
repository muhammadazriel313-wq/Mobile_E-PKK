import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:epkk_nganjuk/common/appbar/custom_appbar.dart';
import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/common/typography.dart';
import 'package:epkk_nganjuk/core/jabatan_options.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:epkk_nganjuk/features/auth/component/drop_down.dart';
import 'package:epkk_nganjuk/features/auth/component/input_form_field.dart';
import 'package:epkk_nganjuk/features/draft/button_secondary_outline.dart';
import 'package:epkk_nganjuk/features/draft/draft_badge_icon.dart';
import 'package:epkk_nganjuk/features/draft/draft_controller.dart';
import 'package:epkk_nganjuk/features/draft/draft_exit_dialog.dart';
import 'package:epkk_nganjuk/features/draft/draft_model.dart';
import 'package:epkk_nganjuk/features/draft/draft_service.dart';
import 'package:epkk_nganjuk/features/laporan/upload_galeri/upload_galerii_controller.dart';
import 'package:epkk_nganjuk/routes/app_routes.dart';
import 'package:epkk_nganjuk/services/preferences/preferences_service.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class UploadGaleriPage extends StatefulWidget {
  const UploadGaleriPage({Key? key}) : super(key: key);

  @override
  State<UploadGaleriPage> createState() => _UploadGaleriPageState();
}

class _UploadGaleriPageState extends State<UploadGaleriPage> {
  final GaleriController _controller = Get.put(GaleriController());
  final TextEditingController _namaKegiatanController = TextEditingController();
  final TextEditingController _lokasiController = TextEditingController();

  // ================= NAMA PESERTA =================
  final TextEditingController _namaPesertaInputController =
      TextEditingController();
  final List<String> _pesertaList = [];

  double? latitude;
  double? longitude;
  bool isGettingLocation = false;
  final _formKey = GlobalKey<FormState>();

  // Mobile: File, Web (Chrome): bytes
  File? _image;
  Uint8List? _imageBytes;
  String? _imageName;
  bool get _hasImage => kIsWeb ? _imageBytes != null : _image != null;

  final _picker = ImagePicker();
  String? _selectedBidang;

  // ================= JABATAN (khusus Bidang Umum) =================
  String? _selectedJabatan;
  bool get _isBidangUmum => id_organization == kIdOrganisasiBidangUmum;

  List<String> _bidangList = [];
  String? id_user;
  String? id_role;
  String? id_organization;
  String? full_name;
  String? name_role;
  String? name_organization;

  DraftModel? _editingDraft;
  bool _isSavingDraft = false;
  bool _isCompressingPhoto = false;
  bool _allowPop = false;

  void clearForm() {
    _resetForm();
  }

  bool isFormEmpty() {
    return _namaKegiatanController.text.trim().isEmpty &&
        _lokasiController.text.trim().isEmpty &&
        _pesertaList.isEmpty &&
        _selectedBidang == null &&
        _image == null &&
        _imageBytes == null;
  }

  Map<String, dynamic> _collectFormData() {
    String? namaPesertaJson =
        _pesertaList.isNotEmpty ? jsonEncode(_pesertaList) : null;

    return {
      'id_user': id_user ?? _editingDraft?.idAkun ?? '',
      'id_role': id_role ?? '',
      'id_organization': id_organization ?? '',
      'full_name': full_name ?? '',
      'name_role': name_role ?? '',
      'name_organization': name_organization ?? '',
      'deskripsi': _namaKegiatanController.text.trim(),
      'lokasi': _lokasiController.text.trim(),
      'nama_peserta': namaPesertaJson,
      'bidang': _selectedBidang ?? '',
      'pokja': name_organization ?? '',
      'latitude': latitude,
      'longitude': longitude,
      'status': _editingDraft?.dataForm['status'],
      'foto_nama': _imageName ?? _editingDraft?.dataForm['foto_nama'],
      if (_editingDraft?.dataForm['foto_base64'] != null)
        'foto_base64': _editingDraft!.dataForm['foto_base64'],
    };
  }

  void _populateFromDraft(DraftModel draft) {
    final data = draft.dataForm;
    _namaKegiatanController.text = data['deskripsi']?.toString() ?? '';
    _lokasiController.text = data['lokasi']?.toString() ?? '';

    if (data['latitude'] != null) {
      latitude = double.tryParse(data['latitude'].toString());
    }
    if (data['longitude'] != null) {
      longitude = double.tryParse(data['longitude'].toString());
    }

    final pesertaRaw = data['nama_peserta'];
    _pesertaList.clear();
    if (pesertaRaw != null) {
      try {
        final decoded = jsonDecode(pesertaRaw.toString());
        if (decoded is List) {
          _pesertaList.addAll(decoded.map((e) => e.toString()));
        }
      } catch (_) {}
    }

    _selectedBidang = data['bidang']?.toString();

    id_user = draft.idAkun;
    id_role ??= data['id_role']?.toString();
    id_organization ??= data['id_organization']?.toString();
    full_name ??= data['full_name']?.toString();
    name_role ??= data['name_role']?.toString();
    name_organization ??= data['name_organization']?.toString() ?? data['pokja']?.toString();

    _imageName = data['foto_nama']?.toString();

    if (kIsWeb) {
      final base64Str = data['foto_base64']?.toString();
      if (base64Str != null && base64Str.isNotEmpty) {
        try {
          _imageBytes = base64Decode(base64Str);
        } catch (_) {}
      }
    } else {
      if (draft.daftarFoto.isNotEmpty) {
        final path = draft.daftarFoto.first;
        final file = File(path);
        if (file.existsSync()) {
          _image = file;
        }
      }
    }
  }

  Future<bool> _simpanDraf({bool showFeedback = false}) async {
    if (_isSavingDraft || _isCompressingPhoto || _controller.isLoading.value) {
      return false;
    }
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
      if ((id_user ?? '').isEmpty) {
        final user = await PreferencesService.getUser();
        id_user = user?.id;
      }
      if ((id_user ?? '').isEmpty) {
        Get.snackbar(
          'Sesi Tidak Ditemukan',
          'Masuk kembali untuk menyimpan draf.',
          snackPosition: SnackPosition.TOP,
        );
        return false;
      }

      final data = _collectFormData();
      final service = DraftService();

      if (kIsWeb) {
        // Logika simpan foto untuk Web
        if (_imageBytes != null && (data['foto_base64'] == null || _image != null)) {
          setState(() => _isCompressingPhoto = true);
          try {
            Uint8List compressed = _imageBytes!;
            try {
              final result = await FlutterImageCompress.compressWithList(
                _imageBytes!,
                minWidth: 1024,
                minHeight: 1024,
                quality: 70,
              );
              if (result.isNotEmpty) {
                compressed = result;
              }
            } catch (e) {
              debugPrint('Kompresi web gagal, fallback ke original bytes: $e');
            }

            try {
              data['foto_base64'] = base64Encode(compressed);
            } catch (e) {
              debugPrint('Gagal base64 encode foto web: $e');
              data.remove('foto_base64');
              Get.snackbar(
                'Catatan Foto',
                'Foto perlu dipilih ulang saat mengirim',
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.orange.shade700,
                colorText: Colors.white,
                duration: const Duration(seconds: 3),
              );
            }
          } finally {
            if (mounted) setState(() => _isCompressingPhoto = false);
          }
        }

        try {
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
              idAkun: id_user ?? '',
              jenis: 'galeri',
              dataForm: data,
              originalPhotoPaths: [],
            );
          }
        } catch (e) {
          final errStr = e.toString().toLowerCase();
          if (errStr.contains('quota') || errStr.contains('full')) {
            Get.snackbar(
              'Penyimpanan Penuh',
              'Penyimpanan penuh, hapus draf lama',
              snackPosition: SnackPosition.TOP,
              backgroundColor: const Color(0xFFEF5350),
              colorText: Colors.white,
              duration: const Duration(seconds: 3),
            );
            return false;
          }
          rethrow;
        }
      } else {
        // Logika simpan foto untuk Android/iOS
        List<String> originalPaths = [];
        if (_image != null && _image!.existsSync()) {
          originalPaths.add(_image!.path);
        } else if (_editingDraft != null && _editingDraft!.daftarFoto.isNotEmpty) {
          originalPaths.addAll(_editingDraft!.daftarFoto);
        }

        if (_editingDraft != null) {
          List<String> savedPhotoPaths = [];
          for (final pth in originalPaths) {
            if (pth.contains('draft_photos')) {
              savedPhotoPaths.add(pth);
            } else {
              final processed = await service.processAndSavePhoto(pth);
              if (processed != null) {
                savedPhotoPaths.add(processed);
              }
            }
          }
          await service.updateDraft(
            _editingDraft!.copyWith(
              dataForm: data,
              daftarFoto: savedPhotoPaths,
              status: 'draf',
              pesanError: null,
            ),
          );
        } else {
          await service.simpanDraft(
            idAkun: id_user ?? '',
            jenis: 'galeri',
            dataForm: data,
            originalPhotoPaths: originalPaths,
          );
        }
      }

      final draftController = Get.isRegistered<DraftController>()
          ? Get.find<DraftController>()
          : Get.put(DraftController());
      await draftController.refreshAllCount();

      if (showFeedback) {
        _showSnackbarDrafDisimpan();
      }
      return true;
    } catch (e) {
      debugPrint('Error simpan draf galeri: $e');
      final errStr = e.toString().toLowerCase();
      if (errStr.contains('quota') || errStr.contains('full')) {
        Get.snackbar(
          'Penyimpanan Penuh',
          'Penyimpanan penuh, hapus draf lama',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFFEF5350),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      } else {
        Get.snackbar(
          'Gagal',
          'Draf tidak dapat disimpan.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFFEF5350),
          colorText: Colors.white,
        );
      }
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
    if (mounted) {
      Navigator.of(context).pop();
    } else {
      Get.back();
    }
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

    id_user = args['id_user']?.toString();
    full_name = args['full_name']?.toString();
    id_role = args['id_role']?.toString();
    name_role = args['name_role']?.toString();
    id_organization = args['id_organization']?.toString();
    name_organization = args['name_organization']?.toString();
    _initializeBidangList();

    if (args['draft'] is DraftModel) {
      _editingDraft = args['draft'] as DraftModel;
      _populateFromDraft(_editingDraft!);
    }
  }

  void _initializeBidangList() {
    if (id_organization == '1') {
      _bidangList = [
        'Kader Pokja I',
        'Penghayatan & Pengamalan Pancasila',
        'Gotong Royong',
      ];
    } else if (id_organization == '2') {
      _bidangList = [
        'Pendidikan & Ketrampilan',
        'Pengembangan Kehidupan Berkoperasi',
      ];
    } else if (id_organization == '3') {
      _bidangList = [
        'Kader Pokja III',
        'Program Pangan',
        'Program Sandang',
        'Program Perumahan & Tata Laksana Rumah Tangga',
      ];
    } else if (id_organization == '4') {
      _bidangList = [
        'Kader Pokja IV',
        'Kesehatan',
        'Kelestarian Lingkungan Hidup',
        'Perencanaan Sehat',
        'Inovasi Prioritas',
        'Inovasi Unggulan',
      ];
    } else if (id_organization == '5') {
      _bidangList = ['Laporan Umum'];
    } else {
      _bidangList = ['Bidang Tidak Ditemukan'];
    }
  }

  void _tambahPeserta() {
    final nama = _namaPesertaInputController.text.trim();
    if (nama.isEmpty) {
      Get.snackbar(
        'Peringatan',
        'Nama peserta tidak boleh kosong',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange.shade600,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
        duration: const Duration(seconds: 2),
      );
      return;
    }
    if (_pesertaList.any((p) => p.toLowerCase() == nama.toLowerCase())) {
      Get.snackbar(
        'Peringatan',
        'Nama peserta "$nama" sudah ada dalam daftar',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange.shade600,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
        duration: const Duration(seconds: 2),
      );
      return;
    }
    setState(() {
      _pesertaList.add(nama);
      _namaPesertaInputController.clear();
    });
  }

  void _hapusPeserta(int index) {
    setState(() {
      _pesertaList.removeAt(index);
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _imageBytes = bytes;
          _imageName = pickedFile.name;
          _image = kIsWeb ? null : File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _showImageSourceDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Pilih Sumber Gambar',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: TextColors.grey700,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.blue),
              title: Text(
                'Kamera',
                style: TextStyle(fontSize: 14.sp, color: TextColors.grey700),
              ),
              onTap: () {
                Get.back();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.blue),
              title: Text(
                'Galeri',
                style: TextStyle(fontSize: 14.sp, color: TextColors.grey700),
              ),
              onTap: () {
                Get.back();
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    try {
      setState(() {
        isGettingLocation = true;
      });
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar(
          'Lokasi Mati',
          'Aktifkan GPS terlebih dahulu',
          snackPosition: SnackPosition.TOP,
        );
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          'Izin Ditolak',
          'Izin lokasi ditolak permanen',
          snackPosition: SnackPosition.TOP,
        );
        return;
      }
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      latitude = position.latitude;
      longitude = position.longitude;
      final placemarks = await placemarkFromCoordinates(latitude!, longitude!);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        String lokasi = '${place.subLocality ?? ''}, ${place.locality ?? ''}';
        _lokasiController.text = lokasi;
      }
    } finally {
      setState(() {
        isGettingLocation = false;
      });
    }
  }

  Future<void> _submitData() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_image == null && _imageBytes == null) {
      Get.snackbar(
        'Error',
        'Pilih gambar terlebih dahulu',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFEF5350),
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
      );
      return;
    }
    if (_lokasiController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Tempat kegiatan wajib diisi',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFEF5350),
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
      );
      return;
    }

    await _controller.submitDataGaleri(
      idUser: id_user!,
      deskripsi: _namaKegiatanController.text,
      lokasi: _lokasiController.text,
      latitude: latitude,
      longitude: longitude,

      gambar: _image != null ? _image!.path : (_imageName ?? 'upload.jpg'),
      gambarBytes: _imageBytes,
      namaFile: _imageName,
      namaPeserta: List<String>.from(_pesertaList),
      jabatan: _isBidangUmum ? _selectedJabatan : null,
      pokja: name_organization!,
      bidang: _selectedBidang!,
      idRole: id_role!,
      idOrganization: id_organization!,
    );
    if (_controller.galeriData.value != null) {
      if (_editingDraft != null) {
        await DraftService().hapusDraft(_editingDraft!.id);
      }
      _resetForm();
      Get.offAllNamed(Routes.MAIN);
    } else if (_controller.lastFailureWasNetwork.value && mounted) {
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
      if (saveAsDraft == true) {
        await _simpanDrafLaluKembali();
      }
    }
  }

  void _resetForm() {
    _namaKegiatanController.clear();
    _namaPesertaInputController.clear();
    _pesertaList.clear();
    _lokasiController.clear();
    latitude = null;
    longitude = null;
    setState(() {
      _image = null;
      _imageBytes = null;
      _imageName = null;
      _selectedBidang = null;
      _selectedJabatan = null;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        appBar: AppBarPrimary(
          title: 'Upload Kegiatan',
          actionWidget: DraftBadgeIcon(
            scope: DraftScope.galeri,
            arguments: args is Map<String, dynamic>
                ? args
                : (args is Map ? Map<String, dynamic>.from(args) : null),
          ),
          onBack: () async {
            final shouldPop = await _onWillPop();
            if (shouldPop && mounted) Get.back();
          },
        ),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// IMAGE
                      ZoomTapAnimation(
                        onTap: _showImageSourceDialog,
                        child: Container(
                          height: 220.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: Colors.grey.shade300),
                          ),

                          child: (_imageBytes != null || _image != null)
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12.r),
                                  child: _imageBytes != null
                                      ? Image.memory(
                                          _imageBytes!,
                                          fit: BoxFit.cover,
                                        )
                                      : (kIsWeb
                                          ? Image.network(
                                              _image!.path,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.file(
                                              _image!,
                                              fit: BoxFit.cover,
                                            )),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_a_photo,
                                      size: 50.sp,
                                      color: Colors.grey.shade500,
                                    ),
                                    SizedBox(height: 10.h),
                                    Text(
                                      'Tambahkan Foto',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      SizedBox(height: 24.h),

                      /// NAMA KEGIATAN
                      InputFormField(
                        controller: _namaKegiatanController,
                        label: 'Uraian Kegiatan',
                        hintText: 'Masukkan uraian kegiatan',
                        validator: (value) =>
                            value!.isEmpty ? 'Harap isi uraian kegiatan' : null,
                      ),
                      SizedBox(height: 20.h),

                      /// NAMA PESERTA
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: InputFormField(
                                  controller: _namaPesertaInputController,
                                  label: 'Nama Peserta',
                                  hintText:
                                      'Ketik nama peserta lalu klik Tambah',
                                  textInputAction: TextInputAction.done,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              ElevatedButton(
                                onPressed: _tambahPeserta,
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 14.w,
                                    vertical: 14.h,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  backgroundColor: const Color(0xFF3F8FC1),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 18.sp,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      'Tambah',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (_pesertaList.isNotEmpty) ...[
                            SizedBox(height: 10.h),
                            Wrap(
                              spacing: 8.w,
                              runSpacing: 6.h,
                              children: List.generate(_pesertaList.length, (
                                index,
                              ) {
                                return Chip(
                                  backgroundColor: Colors.blue.shade50,
                                  side: BorderSide(color: Colors.blue.shade200),
                                  label: Text(
                                    '${index + 1}. ${_pesertaList[index]}',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.blue.shade900,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  deleteIcon: Icon(
                                    Icons.close,
                                    size: 16.sp,
                                    color: Colors.red.shade400,
                                  ),
                                  onDeleted: () => _hapusPeserta(index),
                                );
                              }),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 20.h),

                      /// JABATAN (khusus akun Bidang Umum)
                      if (_isBidangUmum) ...[
                        DropdownComponent(
                          hintText: 'Pilih Jabatan',
                          randomlabel: 'Jabatan',
                          errorKosong: 'Pilih jabatan',
                          svgIconPath: 'assets/icons/ic_user_tag.svg',
                          listItem: kJabatanOptions,
                          onChanged: (value) {
                            setState(() {
                              _selectedJabatan = value;
                            });
                          },
                          selectedValue: _selectedJabatan,
                        ),
                        SizedBox(height: 20.h),
                      ],

                      /// LOKASI
                      InputFormField(
                        controller: _lokasiController,
                        label: 'Tempat Kegiatan',
                        hintText: 'Masukkan tempat atau klik icon GPS',
                        keyboardType: TextInputType.streetAddress,
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Tempat kegiatan wajib diisi';
                          }
                          return null;
                        },
                        suffixIcon: isGettingLocation
                            ? Padding(
                                padding: EdgeInsets.all(12.w),
                                child: SizedBox(
                                  height: 18.h,
                                  width: 18.w,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : IconButton(
                                icon: Icon(
                                  Icons.location_on,
                                  color: Colors.blue,
                                  size: 24.sp,
                                ),
                                onPressed: _getCurrentLocation,
                              ),
                      ),
                      SizedBox(height: 20.h),

                      /// DROPDOWN
                      DropdownComponent(
                        hintText: 'Pilih Bidang',
                        randomlabel: 'Bidang',
                        errorKosong: 'Pilih bidang',
                        svgIconPath: 'assets/icons/ic_user_tag.svg',
                        listItem: _bidangList,
                        onChanged: (value) {
                          setState(() {
                            _selectedBidang = value;
                          });
                        },
                        selectedValue: _selectedBidang,
                      ),
                      SizedBox(height: 30.h),

                      /// BUTTON
                      Row(
                        children: [
                          Expanded(
                            child: ZoomTapAnimation(
                              child: ButtonSecondaryOutline(
                                text: _isCompressingPhoto
                                    ? 'Memproses Foto...'
                                    : (_isSavingDraft
                                        ? 'Menyimpan...'
                                        : (_editingDraft != null
                                            ? 'Simpan Perubahan'
                                            : 'Simpan Draf')),
                                onPressed: _isSavingDraft ||
                                        _isCompressingPhoto ||
                                        _controller.isLoading.value
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
                                  text: _controller.isLoading.value
                                      ? 'Mengunggah...'
                                      : 'Kirim',
                                  textColor: Colors.white,
                                  onPressed: _controller.isLoading.value ||
                                          _isSavingDraft ||
                                          _isCompressingPhoto
                                      ? null
                                      : _submitData,
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
    );
  }

  @override
  void dispose() {
    _namaKegiatanController.dispose();
    _namaPesertaInputController.dispose();
    _lokasiController.dispose();
    super.dispose();
  }
}
