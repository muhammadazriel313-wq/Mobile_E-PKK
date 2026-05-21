class ValidatorForm {

  /// ======================
  /// VALIDASI ANGKA
  /// ======================

  static String? validateNumber(
    String? value,
  ) {
    if (value == null ||
        value.trim().isEmpty) {
      return 'Form tidak boleh kosong';
    }

    if (!RegExp(r'^[0-9]+$')
        .hasMatch(value)) {
      return 'Hanya boleh angka';
    }

    return null;
  }

  /// ======================
  /// VALIDASI BULAN
  /// ======================

  static String? validateBulan(
    String? value,
  ) {
    if (value == null ||
        value.isEmpty) {
      return 'Bulan wajib dipilih';
    }

    return null;
  }

  /// ======================
  /// PKBN
  /// ======================

  static String? validatePKBN(
    String? value,
  ) {
    if (value == null ||
        value.isEmpty) {
      return 'PKBN tidak boleh kosong';
    }

    return null;
  }

  /// ======================
  /// PKDRT
  /// ======================

  static String? validatePKDRT(
    String? value,
  ) {
    if (value == null ||
        value.isEmpty) {
      return 'PKDRT tidak boleh kosong';
    }

    return null;
  }

  /// ======================
  /// POLA ASUH
  /// ======================

  static String? validatePolaA(
    String? value,
  ) {
    if (value == null ||
        value.isEmpty) {
      return 'Pola Asuh tidak boleh kosong';
    }

    return null;
  }

  /// ======================
  /// PPP KEL 1
  /// ======================

  static String? validatePPPkel1(
    String? value,
  ) {
    if (value == null ||
        value.isEmpty) {
      return 'Pola Asuh tidak boleh kosong';
    }

    return null;
  }

  /// ======================
  /// PPP ANGGOTA 1
  /// ======================

  static String? validatePPPanggota1(
    String? value,
  ) {
    if (value == null ||
        value.isEmpty) {
      return 'Pola Asuh tidak boleh kosong';
    }

    return null;
  }

  /// ======================
  /// PPP KEL 2
  /// ======================

  static String? validatePPPkel2(
    String? value,
  ) {
    if (value == null ||
        value.isEmpty) {
      return 'Pola Asuh tidak boleh kosong';
    }

    return null;
  }

  /// ======================
  /// PPP ANGGOTA 2
  /// ======================

  static String? validatePPPanggota2(
    String? value,
  ) {
    if (value == null ||
        value.isEmpty) {
      return 'Pola Asuh tidak boleh kosong';
    }

    return null;
  }

  /// ======================
  /// PPP KEL 3
  /// ======================

  static String? validatePPPkel3(
    String? value,
  ) {
    if (value == null ||
        value.isEmpty) {
      return 'Pola Asuh tidak boleh kosong';
    }

    return null;
  }

  /// ======================
  /// PPP ANGGOTA 3
  /// ======================

  static String? validatePPPanggota3(
    String? value,
  ) {
    if (value == null ||
        value.isEmpty) {
      return 'Pola Asuh tidak boleh kosong';
    }

    return null;
  }

  /// ======================
  /// PPP KEL 4
  /// ======================

  static String? validatePPPkel4(
    String? value,
  ) {
    if (value == null ||
        value.isEmpty) {
      return 'Pola Asuh tidak boleh kosong';
    }

    return null;
  }

  /// ======================
  /// PPP ANGGOTA 4
  /// ======================

  static String? validatePPPanggota4(
    String? value,
  ) {
    if (value == null ||
        value.isEmpty) {
      return 'Pola Asuh tidak boleh kosong';
    }

    return null;
  }

  /// ======================
  /// DEFAULT
  /// ======================

  static String? validateDefault(
    String? value,
  ) {
    if (value == null ||
        value.isEmpty) {
      return 'Form tidak boleh kosong';
    }

    return null;
  }
}