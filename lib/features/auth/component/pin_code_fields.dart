import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinCodeFields extends StatelessWidget {
  final TextEditingController controller;

  const PinCodeFields({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: PinCodeTextField(
        controller: controller,
        appContext: context,
        length: 4,

        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Harap isi kode verifikasi anda';
          }
          if (value.length < 4) {
            return 'Kode OTP harus 4 digit';
          }
          return null;
        },

        onChanged: (value) {},
        onCompleted: (value) {
          // bisa dipakai auto submit nanti
        },

        keyboardType: TextInputType.number,
        cursorColor: Colors.black,
        animationType: AnimationType.fade,

        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(8),
          fieldHeight: 56,
          fieldWidth: 56,
          activeFillColor: Colors.white,
          inactiveFillColor: Colors.grey.shade100,
          activeColor: Colors.grey.shade300,
          inactiveColor: Colors.grey.shade300,
          selectedColor: Colors.blue.shade500,
          selectedFillColor: Colors.white,
          borderWidth: 1.5,
        ),

        animationDuration: Duration(milliseconds: 300),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        enableActiveFill: true,
      ),
    );
  }
}