import 'package:epkk_nganjuk/features/detail_laporan/detail_laporan_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EditLaporanScreen extends StatefulWidget {
  final String uuid;
  final int orgId;
  final Map<String, dynamic> initialData;

  const EditLaporanScreen({
    super.key,
    required this.uuid,
    required this.orgId,
    required this.initialData,
  });

  @override
  State<EditLaporanScreen> createState() => _EditLaporanScreenState();
}

class _EditLaporanScreenState extends State<EditLaporanScreen> {
  final _formKey = GlobalKey<FormState>();

  late Map<String, dynamic> _formData;

  final controller = Get.find<DetailLaporanController>();

  final Color primaryColor = const Color(0xFF3F8FC1);

  @override
  void initState() {
    super.initState();

    _formData = Map.from(widget.initialData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),

      resizeToAvoidBottomInset: true,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,

        centerTitle: true,

        title: Text(
          'Edit Laporan',

          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),

        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),

            child: InkWell(
              borderRadius: BorderRadius.circular(12.r),

              onTap: _submitForm,

              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),

                decoration: BoxDecoration(
                  color: primaryColor,

                  borderRadius: BorderRadius.circular(12.r),
                ),

                child: Row(
                  children: [
                    Icon(Icons.save_rounded, size: 18.sp, color: Colors.white),

                    SizedBox(width: 6.w),

                    Text(
                      'Simpan',

                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      body: Obx(() {
        return Stack(
          children: [
            GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),

              child: Form(
                key: _formKey,

                child: ListView(
                  padding: EdgeInsets.all(16.w),

                  children: _buildFormFields(),
                ),
              ),
            ),

            if (controller.isLoading.value)
              Container(
                color: Colors.black.withOpacity(0.1),

                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      }),
    );
  }

  List<Widget> _buildFormFields() {
    final editableData = Map.from(_formData)
      ..removeWhere(
        (key, value) =>
            key == 'uuid' ||
            key == 'id_user' ||
            key == 'status' ||
            key == 'created_at' ||
            key == 'id_role' ||
            key == 'id_organization',
      );

    return editableData.entries.map((entry) {
      return Container(
        margin: EdgeInsets.only(bottom: 16.h),

        padding: EdgeInsets.all(16.w),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(18.r),

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
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              _getFieldLabel(entry.key),

              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),

            SizedBox(height: 10.h),

            TextFormField(
              initialValue: entry.value?.toString() ?? '',

              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),

              decoration: InputDecoration(
                hintText: 'Masukkan ${_getFieldLabel(entry.key)}',

                hintStyle: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.grey.shade400,
                ),

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
              ),

              onSaved: (newValue) => _formData[entry.key] = newValue,

              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Field wajib diisi';
                }

                return null;
              },
            ),
          ],
        ),
      );
    }).toList();
  }

  String _getFieldLabel(String fieldName) {
    switch (fieldName) {
      case 'nama_kader':
        return 'Nama Kader';

      case 'jumlah_kegiatan':
        return 'Jumlah Kegiatan';

      case 'keterangan':
        return 'Keterangan';

      default:
        return fieldName.replaceAll('_', ' ').capitalizeFirst ?? fieldName;
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      _updateLaporan();
    }
  }

  void _updateLaporan() async {
    try {
      await controller.updateLaporan(
        uuid: widget.uuid,
        orgId: widget.orgId,
        data: _formData,
      );

      Get.snackbar(
        'Berhasil',
        'Laporan berhasil diperbarui',

        snackPosition: SnackPosition.BOTTOM,

        backgroundColor: Colors.green.shade100,

        colorText: Colors.green.shade800,
      );

      Navigator.pop(context, true);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal update: $e',

        snackPosition: SnackPosition.BOTTOM,

        backgroundColor: Colors.red.shade100,

        colorText: Colors.red.shade800,
      );
    }
  }
}
