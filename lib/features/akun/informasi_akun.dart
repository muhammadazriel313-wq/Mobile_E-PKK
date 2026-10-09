import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/features/akun/profile_controller.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:epkk_nganjuk/features/auth/component/input_form_field.dart';
import 'package:epkk_nganjuk/welcome/welcome_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class InfoAkunScreen extends StatefulWidget {
  const InfoAkunScreen({super.key});

  @override
  State<InfoAkunScreen> createState() => _InfoAkunScreenState();
}
class _InfoAkunScreenState extends State<InfoAkunScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();

  final _phoneController = TextEditingController();

  final ProfilController controller = Get.find<ProfilController>();

  final Color primaryColor = const Color(0xFF3F8FC1);

  // [PERUBAHAN 08-10-2026] Instance ImagePicker untuk ganti foto profil
  final ImagePicker _picker = ImagePicker();

  // [PERUBAHAN 08-10-2026] State berkas dan byte foto yang dipilih secara lokal untuk pratinjau langsung
  XFile? _selectedImageFile;
  Uint8List? _selectedImageBytes;

  late Worker _profileWorker;

  // [PERUBAHAN 08-10-2026] Dialog pemilihan sumber foto profil
  void _pilihSumberFoto() {
    final hasPhoto = _selectedImageBytes != null ||
        (controller.profilData.value.foto != null &&
            controller.profilData.value.foto!.isNotEmpty);

    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.r),
        ),
        title: Text(
          'Ganti Foto Profil',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt_rounded, color: primaryColor),
              title: Text(
                'Kamera',
                style: TextStyle(fontSize: 14.sp, color: Colors.black87),
              ),
              onTap: () {
                Get.back();
                _ambilFoto(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library_rounded, color: primaryColor),
              title: Text(
                'Galeri',
                style: TextStyle(fontSize: 14.sp, color: Colors.black87),
              ),
              onTap: () {
                Get.back();
                _ambilFoto(ImageSource.gallery);
              },
            ),
            // [PERUBAHAN 08-10-2026] Opsi Hapus Foto profil seperti WhatsApp di paling bawah
            if (hasPhoto) ...[
              Divider(height: 1, color: Colors.grey.shade200),
              ListTile(
                leading: const Icon(
                  Icons.delete_outline_rounded,
                  color: Color(0xFFDC2626),
                ),
                title: Text(
                  'Hapus Foto',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFFDC2626),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  Get.back();
                  _konfirmasiHapusFoto();
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  // [PERUBAHAN 08-10-2026] Dialog konfirmasi hapus foto profil seperti WhatsApp
  void _konfirmasiHapusFoto() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.r),
        ),
        title: Text(
          'Hapus Foto Profil',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus foto profil?',
          style: TextStyle(
            fontSize: 13.sp,
            color: Colors.grey.shade700,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Batal',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            onPressed: () async {
              Get.back();
              // Reset pratinjau lokal jika ada
              if (_selectedImageFile != null || _selectedImageBytes != null) {
                if (mounted) {
                  setState(() {
                    _selectedImageFile = null;
                    _selectedImageBytes = null;
                  });
                }
              }

              // Jika di server tersimpan foto, panggil fungsi hapus
              final serverPhoto = controller.profilData.value.foto;
              if (serverPhoto != null && serverPhoto.isNotEmpty) {
                await controller.deleteProfilePhoto();
              }
            },
            child: const Text(
              'Hapus',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // [PERUBAHAN 08-10-2026] Mengambil foto profil untuk pratinjau langsung di tampilan
  Future<void> _ambilFoto(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 800,
      );

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        if (mounted) {
          setState(() {
            _selectedImageFile = pickedFile;
            _selectedImageBytes = bytes;
          });
        }
      }
    } catch (e) {
      debugPrint('Gagal memilih foto: $e');
    }
  }

  @override
  void initState() {
    super.initState();

    /// SET DATA AWAL
    _nameController.text = controller.profilData.value.fullName;

    _phoneController.text = controller.profilData.value.phoneNumber;

    /// LISTENER PROFILE
    _profileWorker = ever(controller.profilData, (data) {
      if (!mounted) return;

      _nameController.text = data.fullName;

      _phoneController.text = data.phoneNumber;
    });
  }

  @override
  void dispose() {
    /// DISPOSE LISTENER
    _profileWorker.dispose();

    /// DISPOSE CONTROLLER
    _nameController.dispose();

    _phoneController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,

        centerTitle: true,

        iconTheme: IconThemeData(color: TextColors.grey700),

        title: Text(
          'Informasi Akun',

          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 16.sp,
          ),
        ),

        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: primaryColor),

            onPressed: () {
              controller.loadProfil();
            },
          ),
        ],
      ),

      body: Obx(() {
        /// LOADING
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: primaryColor));
        }

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),

          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),

            child: Form(
              key: _formKey,

              child: Column(
                children: [
                  /// PROFILE CARD
                  Container(
                    width: double.infinity,

                    padding: EdgeInsets.symmetric(
                      vertical: 24.h,
                      horizontal: 20.w,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(22.r),

                      border: Border.all(color: const Color(0xFFE8EDF3)),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),

                          blurRadius: 8,

                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),

                    child: Column(
                      children: [
                        // [PERUBAHAN 08-10-2026] Avatar foto profil reaktif dengan tombol kamera
                        Obx(() {
                          final fotoUrl = controller.profilData.value.foto;
                          final isUploading = controller.isUploadingPhoto.value;

                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 76.r,
                                height: 76.r,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: primaryColor.withValues(alpha: 0.12),
                                  border: Border.all(
                                    color: primaryColor.withValues(alpha: 0.25),
                                    width: 2,
                                  ),
                                ),
                                child: ClipOval(
                                  child: _selectedImageBytes != null
                                    ? Image.memory(
                                        _selectedImageBytes!,
                                        fit: BoxFit.cover,
                                        width: 76.r,
                                        height: 76.r,
                                      )
                                    : (fotoUrl != null && fotoUrl.isNotEmpty)
                                        ? Image.network(
                                            fotoUrl,
                                            fit: BoxFit.cover,
                                            width: 76.r,
                                            height: 76.r,
                                            loadingBuilder: (context, child, progress) {
                                              if (progress == null) return child;
                                              return Center(
                                                child: SizedBox(
                                                  width: 22.w,
                                                  height: 22.w,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    color: primaryColor,
                                                  ),
                                                ),
                                              );
                                            },
                                            errorBuilder: (context, error, stackTrace) {
                                              return Icon(
                                                Icons.person,
                                                size: 38.sp,
                                                color: primaryColor,
                                              );
                                            },
                                          )
                                        : Icon(
                                            Icons.person,
                                            size: 38.sp,
                                            color: primaryColor,
                                          ),
                                ),
                              ),
                              if (isUploading)
                                Container(
                                  width: 76.r,
                                  height: 76.r,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black38,
                                  ),
                                  child: Center(
                                    child: SizedBox(
                                      width: 22.w,
                                      height: 22.w,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: GestureDetector(
                                  onTap: isUploading ? null : _pilihSumberFoto,
                                  child: Container(
                                    padding: EdgeInsets.all(6.w),
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.15),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.camera_alt,
                                      size: 14.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),

                        SizedBox(height: 14.h),

                        Text(
                          controller.profilData.value.fullName.isEmpty
                              ? 'Pengguna'
                              : controller.profilData.value.fullName,

                          textAlign: TextAlign.center,

                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),

                        SizedBox(height: 4.h),

                        Text(
                          'Kelola data akun anda',

                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  /// FORM CARD
                  Container(
                    padding: EdgeInsets.all(18.w),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(22.r),

                      border: Border.all(color: const Color(0xFFE8EDF3)),
                    ),

                    child: Column(
                      children: [
                        /// NAMA
                        InputFormField(
                          controller: _nameController,

                          label: 'Nama Lengkap',

                          hintText: 'Masukkan nama lengkap',

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Harus diisi';
                            }

                            return null;
                          },
                        ),

                        SizedBox(height: 18.h),

                        /// PHONE
                        InputFormField(
                          controller: _phoneController,

                          label: 'Nomor HP',

                          hintText: 'Masukkan nomor HP',

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Harus diisi';
                            }

                            return null;
                          },
                        ),

                        SizedBox(height: 28.h),

                        /// BUTTON
                        // [PERUBAHAN 08-10-2026] Simpan perubahan menyimpan foto baru dan informasi akun
                        Obx(() {
                          final isSaving = controller.isUpdating.value ||
                              controller.isUploadingPhoto.value;

                          return ButtonFill(
                            text: 'Simpan Perubahan',
                            textColor: Colors.white,
                            isLoading: isSaving,
                            onPressed: isSaving
                                ? null
                                : () async {
                                    if (_formKey.currentState!.validate()) {
                                      // Jika pengguna telah memilih foto baru, unggah foto terlebih dahulu
                                      if (_selectedImageFile != null) {
                                        final photoSuccess =
                                            await controller.uploadProfilePhoto(
                                          filePath: _selectedImageFile!.path,
                                          fileBytes: _selectedImageBytes,
                                          fileName: _selectedImageFile!.name,
                                          showSuccessSnackbar: false,
                                        );
                                        if (!photoSuccess) {
                                          return;
                                        }
                                      }

                                      final success =
                                          await controller.updateProfileInfo(
                                        fullName: _nameController.text,
                                        phoneNumber: _phoneController.text,
                                      );

                                      if (success) {
                                        if (mounted) {
                                          setState(() {
                                            _selectedImageFile = null;
                                            _selectedImageBytes = null;
                                          });
                                        }

                                        Get.snackbar(
                                          'Berhasil',
                                          'Profil berhasil diperbarui',
                                          snackPosition: SnackPosition.TOP,
                                          backgroundColor: const Color(
                                            0xFF3F8FC1,
                                          ),
                                          colorText: Colors.white,
                                        );
                                      }
                                    }
                                  },
                          );
                        }),
                      ],
                    ),
                  ),

                  /// ERROR MESSAGE
                  if (controller.errorMessage.value.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 16.h),

                      child: Text(
                        controller.errorMessage.value,

                        style: TextStyle(color: Colors.red, fontSize: 13.sp),
                      ),
                    ),

                  SizedBox(height: 24.h),

                  /// HAPUS AKUN (ROLE DESA & KECAMATAN)
                  Obx(() {
                    final roleId = controller.profilData.value.idRole.trim();
                    final isDesaOrKecamatan =
                        roleId == '1' || roleId == '2' || roleId.isEmpty;

                    if (!isDesaOrKecamatan) return const SizedBox.shrink();

                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(18.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22.r),
                        border: Border.all(color: const Color(0xFFFEE2E2)),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x05000000),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(6.w),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEF2F2),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Icon(
                                  Icons.warning_amber_rounded,
                                  color: const Color(0xFFDC2626),
                                  size: 18.sp,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Zona Bahaya',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF991B1B),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Menghapus akun akan menghilangkan seluruh data akun dan riwayat laporan dari basis data secara permanen.',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey.shade600,
                              height: 1.4,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              icon: Icon(
                                Icons.delete_forever_rounded,
                                color: const Color(0xFFDC2626),
                                size: 18.sp,
                              ),
                              label: Text(
                                'Hapus Akun',
                                style: TextStyle(
                                  color: const Color(0xFFDC2626),
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: const Color(0xFFFEF2F2),
                                side: const BorderSide(
                                  color: Color(0xFFFECACA),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 13.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              onPressed: () {
                                _showDeleteAccountDialog(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    final roleId = controller.profilData.value.idRole.trim();
    final roleName = roleId == '1'
        ? 'Desa'
        : (roleId == '2' ? 'Kecamatan' : 'Desa / Kecamatan');

    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// ICON
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: const BoxDecoration(
                  color: Color(0xFFFEF2F2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.delete_forever_rounded,
                  color: const Color(0xFFDC2626),
                  size: 34.sp,
                ),
              ),

              SizedBox(height: 18.h),

              /// TITLE
              Text(
                'Hapus Akun',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF991B1B),
                ),
              ),

              SizedBox(height: 8.h),

              /// ROLE BADGE
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: const Color(0xFFFECACA)),
                ),
                child: Text(
                  'Role: $roleName',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFB91C1C),
                  ),
                ),
              ),

              SizedBox(height: 12.h),

              /// DESC
              Text(
                'Apakah Anda yakin ingin menghapus akun Anda secara permanen?\n\nSeluruh data akun dan laporan terkait akan dihapus dari sistem basis data dan tindakan ini tidak dapat dibatalkan.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
              ),

              SizedBox(height: 24.h),

              /// BUTTONS
              Obx(() {
                final isDeleting = controller.isDeleting.value;

                return Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                        ),
                        onPressed: isDeleting ? null : () => Get.back(),
                        child: Text(
                          'Batal',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                            fontSize: 13.sp,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 12.w),

                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: const Color(0xFFDC2626),
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                        ),
                        onPressed: isDeleting
                            ? null
                            : () async {
                                final success =
                                    await controller.deleteAccount();
                                if (success) {
                                  Get.back(); // Tutup dialog konfirmasi
                                  Get.snackbar(
                                    'Akun Berhasil Dihapus',
                                    'Data akun Anda telah berhasil dihapus dari tabel dan basis data.',
                                    snackPosition: SnackPosition.TOP,
                                    backgroundColor: const Color(0xFF16A34A),
                                    colorText: Colors.white,
                                    margin: const EdgeInsets.all(12),
                                    borderRadius: 12,
                                    duration: const Duration(seconds: 3),
                                  );
                                  Get.offAll(() => WelcomeScreen());
                                }
                              },
                        child: isDeleting
                            ? SizedBox(
                                height: 18.w,
                                width: 18.w,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Hapus Akun',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13.sp,
                                ),
                              ),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

