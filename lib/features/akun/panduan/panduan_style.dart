import 'package:flutter/material.dart';

/// Token desain dari frame Figma "Panduan E-PKK Kabupaten Nganjuk"
/// (node 3324:3294). Lebar acuan desain = 400, tinggi = 710.31.
class PanduanStyle {
  PanduanStyle._();

  // ---- Ukuran acuan ----
  static const double designWidth = 400;
  static const double headerDesignHeight = 227;

  // ---- Font ----
  /// Font aplikasi yang terdaftar di pubspec.yaml dan diset di ThemeData main.dart.
  static const String fontFamily = 'DMSans';

  // ---- Warna ----
  static const Color pageBackground = Color(0xFFF8FBFF);
  static const Color navy = Color(0xFF082B96);
  static const Color mutedBlue = Color(0xFF536DC3);
  static const Color subtitleBlue = Color(0xFF3A6DB5);
  static const Color accentBlue = Color(0xFF007DEF);
  static const Color chevronBlue = Color(0xFF0046CB);
  static const Color cardBorder = Color(0xFFE9F1FF);

  // ---- Gaya teks (height = line height / font size) ----
  static const TextStyle appTitle = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 18,
    height: 22 / 18,
    color: navy,
  );

  static const TextStyle appSubtitle = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 11,
    height: 14 / 11,
    color: subtitleBlue,
  );

  static const TextStyle bantuanTitle = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 15,
    height: 18 / 15,
    color: navy,
  );

  static const TextStyle bantuanDescription = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 10.7,
    height: 13 / 10.7,
    color: mutedBlue,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 15,
    height: 19 / 15,
    color: navy,
  );

  static const TextStyle menuTitle = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 12.5,
    height: 15 / 12.5,
    color: navy,
  );

  static const TextStyle menuDescription = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 10.7,
    height: 12 / 10.7,
    color: mutedBlue,
  );
}
