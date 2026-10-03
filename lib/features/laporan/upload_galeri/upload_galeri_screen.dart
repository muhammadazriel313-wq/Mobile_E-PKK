import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:epkk_nganjuk/common/appbar/custom_appbar.dart';
import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:epkk_nganjuk/features/auth/component/drop_down.dart';
import 'package:epkk_nganjuk/features/auth/component/input_form_field.dart';
import 'package:epkk_nganjuk/features/laporan/upload_galeri/upload_galerii_controller.dart';

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

  final TextEditingController _namaPesertaInputController = TextEditingController();

  final List<String> _pesertaList = [];

  double? latitude;
  double? longitude;

  bool isGettingLocation = false;

  final _formKey = GlobalKey<FormState>();

  File? _image;
  Uint8List? _imageBytes;
  String? _imageName;

  final _picker = ImagePicker();

  String? _selectedBidang;

  List<String> _bidangList = [];

  String? id_user;
  String? id_role;
  String? id_organization;
  String? full_name;
  String? name_role;
  String? name_organization;

  @override
  void initState() {
    super.initState();

    final args = Get.arguments;

    id_user = args['id_user'];
    full_name = args['full_name'];
    id_role = args['id_role'];
    name_role = args['name_role'];
    id_organization = args['id_organization'];
    name_organization = args['name_organization'];

    _initializeBidangList();
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
          _image = File(pickedFile.path);
          _imageBytes = bytes;
          _imageName = pickedFile.name;
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

    if (_image == null) {
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
        'Lokasi wajib diisi',

        snackPosition: SnackPosition.TOP,

        backgroundColor: const Color(0xFFEF5350),

        colorText: Colors.white,

        margin: const EdgeInsets.all(12),

        borderRadius: 12,
      );

      return;
    }

    String? namaPesertaJson =
        _pesertaList.isNotEmpty ? jsonEncode(_pesertaList) : null;

    await _controller.submitDataGaleri(
      idUser: id_user!,
      deskripsi: _namaKegiatanController.text,
      namaPeserta: namaPesertaJson,
      lokasi: _lokasiController.text,

      latitude: latitude,
      longitude: longitude,

      gambar: _image!.path,
      gambarBytes: _imageBytes,
      namaFile: _imageName,

      pokja: name_organization!,

      bidang: _selectedBidang!,

      idRole: id_role!,

      idOrganization: id_organization!,
    );

    if (_controller.galeriData.value != null) {
      _resetForm();
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,

      backgroundColor: Colors.white,

      appBar: AppBarPrimary(
        title: 'Upload Kegiatan',

        onBack: () {
          if (_namaKegiatanController.text.isEmpty &&
              _image == null &&
              _selectedBidang == null) {
            Get.back();
          } else {
            Get.defaultDialog(
              title: "Batal Upload?",

              middleText: "Data yang sudah diisi akan hilang",

              textConfirm: "Ya",

              textCancel: "Tidak",

              confirmTextColor: Colors.white,

              onConfirm: () {
                _resetForm();

                Get.back();
              },
            );
          }
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

                          child: _image != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12.r),

                                  // [PERUBAHAN 03-10-2026] Mendukung preview gambar di Flutter Web (Chrome); kode lama di bawah dinonaktifkan
                                  // child: Image.file(_image!, fit: BoxFit.cover),
                                  child: kIsWeb
                                      ? Image.network(_image!.path, fit: BoxFit.cover)
                                      : Image.file(_image!, fit: BoxFit.cover),
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

                        label: 'Nama Kegiatan',

                        hintText: 'Masukkan nama kegiatan',

                        validator: (value) =>
                            value!.isEmpty ? 'Harap isi nama kegiatan' : null,
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
                                  hintText: 'Ketik nama peserta lalu klik Tambah',
                                  textInputAction: TextInputAction.done,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              ElevatedButton(
                                onPressed: _tambahPeserta,
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  backgroundColor: const Color(0xFF3F8FC1),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.add, color: Colors.white, size: 18.sp),
                                    SizedBox(width: 4.w),
                                    Text('Tambah', style: TextStyle(color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.w600)),
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
                              children: List.generate(_pesertaList.length, (index) {
                                return Chip(
                                  backgroundColor: Colors.blue.shade50,
                                  side: BorderSide(color: Colors.blue.shade200),
                                  label: Text(
                                    '${index + 1}. ${_pesertaList[index]}',
                                    style: TextStyle(fontSize: 12.sp, color: Colors.blue.shade900, fontWeight: FontWeight.w500),
                                  ),
                                  deleteIcon: Icon(Icons.close, size: 16.sp, color: Colors.red.shade400),
                                  onDeleted: () => _hapusPeserta(index),
                                );
                              }),
                            ),
                          ],
                        ],
                      ),

                      SizedBox(height: 20.h),

                      /// LOKASI
                      InputFormField(
                        controller: _lokasiController,

                        label: 'Lokasi Kegiatan',

                        hintText: 'Masukkan lokasi atau klik icon GPS',

                        keyboardType: TextInputType.streetAddress,

                        textInputAction: TextInputAction.done,

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lokasi wajib diisi';
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
                      ZoomTapAnimation(
                        child: Obx(
                          () => ButtonFill(
                            text: _controller.isLoading.value
                                ? 'Mengunggah...'
                                : 'Kirim',

                            textColor: Colors.white,

                            onPressed: _controller.isLoading.value
                                ? null
                                : _submitData,
                          ),
                        ),
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
