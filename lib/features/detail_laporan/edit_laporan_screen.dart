import 'package:epkk_nganjuk/core/jabatan_options.dart';
import 'package:epkk_nganjuk/features/detail_laporan/detail_laporan_controller.dart';
import 'package:epkk_nganjuk/features/detail_laporan/pokja1/pokja1_fields.dart';
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

  List<Widget> _buildPokja1FormFields() {
    final fields = Pokja1Config.getFieldsForUuid(widget.uuid);
    final isKaderPokja1 = widget.uuid.startsWith('KP1-');
    final List<Widget> children = [];
    String? currentSection;

    for (final field in fields) {
      if (field.section != null && field.section != currentSection) {
        currentSection = field.section;
        children.add(
          Padding(
            padding: EdgeInsets.only(top: children.isEmpty ? 0 : 12.h, bottom: 10.h),
            child: Text(
              currentSection!,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F2937),
              ),
            ),
          ),
        );
      }

      children.add(
        Container(
          margin: EdgeInsets.only(bottom: 16.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: const Color(0xFFE8EDF3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                field.label,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(height: 10.h),
              TextFormField(
                initialValue: _formData[field.key]?.toString() ?? '',
                keyboardType: field.type == Pokja1InputType.number
                    ? TextInputType.number
                    : TextInputType.text,
                minLines: field.type == Pokja1InputType.multiline ? 3 : 1,
                maxLines: field.type == Pokja1InputType.multiline ? 5 : 1,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: field.type == Pokja1InputType.number
                      ? 'Masukkan jumlah'
                      : 'Masukkan ${field.label}',
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
                onSaved: (newValue) => _formData[field.key] = newValue,
                validator: (value) {
                  if (isKaderPokja1) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Field wajib diisi';
                    }
                    if (int.tryParse(value.trim()) == null) {
                      return 'Masukkan angka yang valid';
                    }
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      );
    }

    return children;
  }

  // Field yang boleh diubah dari mobile. Kolom identitas (id_*, *_id),
  // status, catatan admin, dan penanda aksi dari server tidak ikut dikirim.
  Map<String, dynamic> _editableData() {
    return Map.from(_formData)
      ..removeWhere(
        (key, value) =>
            key == 'uuid' ||
            key == 'status' ||
            key == 'created_at' ||
            key == 'updated_at' ||
            // Catatan revisi hanya diisi admin di website, bukan dari mobile
            key == 'catatan' ||
            // khusus Kegiatan: tidak boleh diedit dari mobile
            key == 'gambar_url' ||
            key == 'bidang' ||
            // Penanda hak aksi dari server, bukan isi laporan
            key == 'bisa_diedit' ||
            key == 'bisa_dikirim_ulang' ||
            key == 'bisa_dibatalkan' ||
            key.startsWith('id_') ||
            key.endsWith('_id') ||
            // Jabatan hanya untuk akun Bidang Umum
            (key == 'jabatan' &&
                widget.orgId.toString() != kIdOrganisasiBidangUmum),
      );
  }

  List<Widget> _buildFormFields() {
    if (Pokja1Config.isPokja1(widget.uuid)) {
      return _buildPokja1FormFields();
    }

    final editableData = _editableData();

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

            if (entry.key == 'jabatan')
              _buildJabatanField()
            else
              TextFormField(
              initialValue: entry.value?.toString() ?? '',

              minLines: 1,

              maxLines: entry.key == 'nama_peserta' ? 5 : 1,

              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),

              decoration: InputDecoration(
                hintText: entry.key == 'nama_peserta'
                    ? 'Satu nama per baris'
                    : 'Masukkan ${_getFieldLabel(entry.key)}',

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
                // Nama peserta boleh kosong
                if (entry.key == 'nama_peserta') return null;

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

  // Data Kegiatan (upload foto) ditandai dengan adanya gambar_url
  bool get _isKegiatan => _formData.containsKey('gambar_url');

  Widget _buildJabatanField() {
    final current = _formData['jabatan']?.toString();

    return DropdownButtonFormField<String>(
      // Nilai lama (isian bebas) yang tidak ada di daftar dikosongkan,
      // sehingga pengguna wajib memilih salah satu dari 15 pilihan.
      // ignore: deprecated_member_use
      value: kJabatanOptions.contains(current) ? current : null,

      isExpanded: true,

      hint: Text(
        'Pilih Jabatan',
        style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade400),
      ),

      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),

      decoration: InputDecoration(
        filled: true,

        fillColor: const Color(0xFFF8FAFC),

        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),

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

      items: kJabatanOptions
          .map((j) => DropdownMenuItem<String>(value: j, child: Text(j)))
          .toList(),

      onChanged: (value) => _formData['jabatan'] = value,

      onSaved: (value) => _formData['jabatan'] = value,

      validator: (value) => value == null ? 'Pilih jabatan' : null,
    );
  }

  String _getFieldLabel(String fieldName) {
    switch (fieldName) {
      case 'nama_kegiatan':
        return _isKegiatan ? 'Uraian Kegiatan' : 'Nama Kegiatan';

      case 'lokasi':
        return _isKegiatan ? 'Tempat Kegiatan' : 'Lokasi';

      case 'jabatan':
        return 'Jabatan';

      case 'nama_peserta':
        return 'Nama Peserta';

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
      final Map<String, dynamic> dataToSend;
      if (Pokja1Config.isPokja1(widget.uuid)) {
        final pokja1Fields = Pokja1Config.getFieldsForUuid(widget.uuid);
        dataToSend = {};
        for (final field in pokja1Fields) {
          if (_formData.containsKey(field.key)) {
            dataToSend[field.key] = _formData[field.key];
          }
        }
      } else {
        // Kirim hanya field yang tampil di form, bukan seluruh isi detail.
        // Kolom lain di database tidak ikut tertimpa saat menyimpan.
        dataToSend = {};
        for (final key in _editableData().keys) {
          if (_formData.containsKey(key)) {
            dataToSend[key] = _formData[key];
          }
        }
      }

      // Catatan revisi hanya diisi admin website; jangan pernah dikirim
      // dari mobile agar catatan admin tidak tertimpa.
      dataToSend.remove('catatan');

      await controller.updateLaporan(
        uuid: widget.uuid,
        orgId: widget.orgId,
        data: dataToSend,
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
