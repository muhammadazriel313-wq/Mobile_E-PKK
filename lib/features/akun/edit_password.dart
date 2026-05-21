import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/features/akun/profile_controller.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EditPasswordScreen extends StatefulWidget {
  const EditPasswordScreen({super.key});

  @override
  State<EditPasswordScreen> createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _currentPassController = TextEditingController();

  final _newPassController = TextEditingController();

  final _confirmPassController = TextEditingController();

  bool _isCurrentHidden = true;
  bool _isNewHidden = true;
  bool _isConfirmHidden = true;

  final ProfilController controller = Get.find<ProfilController>();

  final Color primaryColor = const Color(0xFF3F8FC1);

  @override
  void dispose() {
    _currentPassController.dispose();
    _newPassController.dispose();
    _confirmPassController.dispose();

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

        title: Text(
          'Ubah Password',

          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
      ),

      body: Obx(() {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),

          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),

            child: Form(
              key: _formKey,

              child: Column(
                children: [
                  /// HEADER CARD
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
                            Icons.lock_rounded,
                            size: 34.sp,
                            color: primaryColor,
                          ),
                        ),

                        SizedBox(height: 14.h),

                        Text(
                          'Keamanan Akun',

                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),

                        SizedBox(height: 4.h),

                        Text(
                          'Gunakan password yang aman dan mudah diingat',

                          textAlign: TextAlign.center,

                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey.shade600,
                            height: 1.5,
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
                        /// PASSWORD LAMA
                        _buildPasswordField(
                          controller: _currentPassController,

                          label: 'Password Saat Ini',

                          obscureText: _isCurrentHidden,

                          onToggle: () {
                            setState(() {
                              _isCurrentHidden = !_isCurrentHidden;
                            });
                          },

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Harus diisi';
                            }

                            return null;
                          },
                        ),

                        SizedBox(height: 18.h),

                        /// PASSWORD BARU
                        _buildPasswordField(
                          controller: _newPassController,

                          label: 'Password Baru',

                          obscureText: _isNewHidden,

                          onToggle: () {
                            setState(() {
                              _isNewHidden = !_isNewHidden;
                            });
                          },

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Harus diisi';
                            }

                            if (value.length < 6) {
                              return 'Minimal 6 karakter';
                            }

                            return null;
                          },
                        ),

                        SizedBox(height: 18.h),

                        /// KONFIRMASI
                        _buildPasswordField(
                          controller: _confirmPassController,

                          label: 'Konfirmasi Password',

                          obscureText: _isConfirmHidden,

                          onToggle: () {
                            setState(() {
                              _isConfirmHidden = !_isConfirmHidden;
                            });
                          },

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Harus diisi';
                            }

                            if (value != _newPassController.text) {
                              return 'Password tidak sama';
                            }

                            return null;
                          },
                        ),

                        SizedBox(height: 28.h),

                        /// BUTTON
                        ButtonFill(
                          text: 'Simpan Password',

                          textColor: Colors.white,

                          isLoading: controller.isUpdating.value,

                          onPressed: controller.isUpdating.value
                              ? null
                              : () async {
                                  if (_formKey.currentState!.validate()) {
                                    final success = await controller
                                        .updatePassword(
                                          currentPassword:
                                              _currentPassController.text,

                                          newPassword: _newPassController.text,
                                        );

                                    if (success) {
                                      _currentPassController.clear();

                                      _newPassController.clear();

                                      _confirmPassController.clear();

                                      controller.errorMessage.value = '';

                                      Get.snackbar(
                                        'Berhasil',
                                        'Password berhasil diperbarui',

                                        snackPosition: SnackPosition.TOP,

                                        backgroundColor: Colors.green.shade100,

                                        colorText: Colors.green.shade800,
                                      );

                                      Get.back();
                                    }
                                  }
                                },
                        ),
                      ],
                    ),
                  ),

                  /// ERROR
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

  Widget _buildPasswordField({
    required TextEditingController controller,

    required String label,

    required bool obscureText,

    required VoidCallback onToggle,

    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          label,

          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),

        SizedBox(height: 10.h),

        TextFormField(
          controller: controller,

          obscureText: obscureText,

          validator: validator,

          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),

          decoration: InputDecoration(
            hintText: label,

            filled: true,

            fillColor: const Color(0xFFF8FAFC),

            contentPadding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 14.h,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),

              borderSide: BorderSide.none,
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),

              borderSide: BorderSide(color: Colors.grey.shade200),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),

              borderSide: BorderSide(color: primaryColor, width: 1.5),
            ),

            suffixIcon: IconButton(
              icon: Icon(
                obscureText
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,

                color: Colors.grey.shade500,
              ),

              onPressed: onToggle,
            ),
          ),
        ),
      ],
    );
  }
}
