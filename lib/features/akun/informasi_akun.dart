import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/features/akun/profile_controller.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:epkk_nganjuk/features/auth/component/input_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

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

  late Worker _profileWorker;

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
                        CircleAvatar(
                          radius: 34.r,

                          backgroundColor: primaryColor.withOpacity(0.12),

                          child: Icon(
                            Icons.person,
                            size: 36.sp,
                            color: primaryColor,
                          ),
                        ),

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
                        Obx(
                          () => ButtonFill(
                            text: 'Simpan Perubahan',

                            textColor: Colors.white,

                            isLoading: controller.isUpdating.value,

                            onPressed: controller.isUpdating.value
                                ? null
                                : () async {
                                    if (_formKey.currentState!.validate()) {
                                      final success = await controller
                                          .updateProfileInfo(
                                            fullName: _nameController.text,

                                            phoneNumber: _phoneController.text,
                                          );

                                      if (success) {
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
                          ),
                        ),
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
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
