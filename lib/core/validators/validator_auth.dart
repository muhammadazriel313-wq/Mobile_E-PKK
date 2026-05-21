class ValidatorAuth {
  static String? validateNumberPhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor Whatsapp tidak boleh kosong';
    } else if (value.length < 12) {
      return 'Minimal 12 karakter';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama tidak boleh kosong';
    } else if (value.length < 1) {
      return 'Minimal 3 karakter';
    }
    return null;
  }

  static String? validatePasswordLogin(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    } else if (value.length < 8) {
      return 'Minimal 8 karakter';
    }
    return null;
  }
}
