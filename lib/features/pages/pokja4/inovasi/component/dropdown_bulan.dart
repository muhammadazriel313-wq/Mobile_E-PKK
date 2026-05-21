/// =======================================================
/// FILE : dropdown_bulan.dart
/// =======================================================

import 'package:flutter/material.dart';

class DropdownBulan extends StatelessWidget {
  final String? value;

  final Function(String?) onChanged;

  final String? Function(String?)? validator;

  DropdownBulan({
    super.key,
    required this.value,
    required this.onChanged,
    this.validator,
  });

  final List<String> daftarBulan = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,

      decoration: InputDecoration(
        labelText: 'Bulan',

        hintText: 'Pilih Bulan',

        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(12),
        ),

        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
      ),

      items: daftarBulan.map((bulan) {
        return DropdownMenuItem<String>(
          value: bulan,
          child: Text(bulan),
        );
      }).toList(),

      onChanged: onChanged,

      validator: validator ??
          (value) {
            if (value == null ||
                value.isEmpty) {
              return 'Bulan wajib dipilih';
            }

            return null;
          },
    );
  }
}