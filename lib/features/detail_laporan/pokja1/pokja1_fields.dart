enum Pokja1InputType {
  number,
  text,
  multiline,
}

class Pokja1FieldDefinition {
  final String key;
  final String label;
  final String? section;
  final Pokja1InputType type;

  const Pokja1FieldDefinition({
    required this.key,
    required this.label,
    this.section,
    this.type = Pokja1InputType.text,
  });
}

class Pokja1Config {
  static bool isPokja1(String uuid) {
    return uuid.startsWith('KP1-') ||
        uuid.startsWith('KP1B1-') ||
        uuid.startsWith('KP1B2-');
  }

  static String? getPokja1Category(String uuid) {
    if (uuid.startsWith('KP1-')) return 'kader_pokja1';
    if (uuid.startsWith('KP1B1-')) return 'penghayatan';
    if (uuid.startsWith('KP1B2-')) return 'gotong_royong';
    return null;
  }

  /// 1. Kader Pokja I (KP1-)
  static const List<Pokja1FieldDefinition> fieldsKaderPokja1 = [
    Pokja1FieldDefinition(
      key: 'kader_umum',
      label: 'Kader Umum',
      type: Pokja1InputType.number,
    ),
    Pokja1FieldDefinition(
      key: 'kader_khusus',
      label: 'Kader Khusus',
      type: Pokja1InputType.number,
    ),
  ];

  /// 2. Penghayatan dan Pengamalan Pancasila (KP1B1-)
  static const List<Pokja1FieldDefinition> fieldsPenghayatan = [
    // KISAH
    Pokja1FieldDefinition(
      key: 'kisah_kegiatan',
      label: 'Kegiatan',
      section: 'KISAH',
      type: Pokja1InputType.text,
    ),
    Pokja1FieldDefinition(
      key: 'kisah_vol',
      label: 'Volume',
      section: 'KISAH',
      type: Pokja1InputType.number,
    ),
    Pokja1FieldDefinition(
      key: 'kisah_metode',
      label: 'Metode',
      section: 'KISAH',
      type: Pokja1InputType.text,
    ),
    Pokja1FieldDefinition(
      key: 'kisah_sasaran',
      label: 'Sasaran',
      section: 'KISAH',
      type: Pokja1InputType.text,
    ),

    // KRISAN
    Pokja1FieldDefinition(
      key: 'krisan_kegiatan',
      label: 'Kegiatan',
      section: 'KRISAN',
      type: Pokja1InputType.text,
    ),
    Pokja1FieldDefinition(
      key: 'krisan_vol',
      label: 'Volume',
      section: 'KRISAN',
      type: Pokja1InputType.number,
    ),
    Pokja1FieldDefinition(
      key: 'krisan_metode',
      label: 'Metode',
      section: 'KRISAN',
      type: Pokja1InputType.text,
    ),
    Pokja1FieldDefinition(
      key: 'krisan_sasaran',
      label: 'Sasaran',
      section: 'KRISAN',
      type: Pokja1InputType.text,
    ),

    // KILAS
    Pokja1FieldDefinition(
      key: 'kilas_kegiatan',
      label: 'Kegiatan',
      section: 'KILAS',
      type: Pokja1InputType.text,
    ),
    Pokja1FieldDefinition(
      key: 'kilas_vol',
      label: 'Volume',
      section: 'KILAS',
      type: Pokja1InputType.number,
    ),
    Pokja1FieldDefinition(
      key: 'kilas_metode',
      label: 'Metode',
      section: 'KILAS',
      type: Pokja1InputType.text,
    ),
    Pokja1FieldDefinition(
      key: 'kilas_sasaran',
      label: 'Sasaran',
      section: 'KILAS',
      type: Pokja1InputType.text,
    ),

    // KIAT
    Pokja1FieldDefinition(
      key: 'kiat_kegiatan',
      label: 'Kegiatan',
      section: 'KIAT',
      type: Pokja1InputType.text,
    ),
    Pokja1FieldDefinition(
      key: 'kiat_vol',
      label: 'Volume',
      section: 'KIAT',
      type: Pokja1InputType.number,
    ),
    Pokja1FieldDefinition(
      key: 'kiat_metode',
      label: 'Metode',
      section: 'KIAT',
      type: Pokja1InputType.text,
    ),
    Pokja1FieldDefinition(
      key: 'kiat_sasaran',
      label: 'Sasaran',
      section: 'KIAT',
      type: Pokja1InputType.text,
    ),

    // KISAK
    Pokja1FieldDefinition(
      key: 'kisak_kegiatan',
      label: 'Kegiatan',
      section: 'KISAK',
      type: Pokja1InputType.text,
    ),
    Pokja1FieldDefinition(
      key: 'kisak_vol',
      label: 'Volume',
      section: 'KISAK',
      type: Pokja1InputType.number,
    ),
    Pokja1FieldDefinition(
      key: 'kisak_metode',
      label: 'Metode',
      section: 'KISAK',
      type: Pokja1InputType.text,
    ),
    Pokja1FieldDefinition(
      key: 'kisak_sasaran',
      label: 'Sasaran',
      section: 'KISAK',
      type: Pokja1InputType.text,
    ),

    // PKBN
    Pokja1FieldDefinition(
      key: 'pkbn_kegiatan',
      label: 'Kegiatan',
      section: 'PKBN',
      type: Pokja1InputType.text,
    ),
    Pokja1FieldDefinition(
      key: 'pkbn_vol',
      label: 'Volume',
      section: 'PKBN',
      type: Pokja1InputType.number,
    ),
    Pokja1FieldDefinition(
      key: 'pkbn_metode',
      label: 'Metode',
      section: 'PKBN',
      type: Pokja1InputType.text,
    ),
    Pokja1FieldDefinition(
      key: 'pkbn_sasaran',
      label: 'Sasaran',
      section: 'PKBN',
      type: Pokja1InputType.text,
    ),

    // INFORMASI TAMBAHAN
    Pokja1FieldDefinition(
      key: 'sumber_dana',
      label: 'Sumber Dana',
      section: 'INFORMASI TAMBAHAN',
      type: Pokja1InputType.text,
    ),
    Pokja1FieldDefinition(
      key: 'hasil_kegiatan',
      label: 'Hasil Kegiatan',
      section: 'INFORMASI TAMBAHAN',
      type: Pokja1InputType.multiline,
    ),
  ];

  /// 3. Gotong Royong (KP1B2-)
  static const List<Pokja1FieldDefinition> fieldsGotongRoyong = [
    // KERJA BAKTI
    Pokja1FieldDefinition(
      key: 'kerja_bakti_kegiatan',
      label: 'Kegiatan',
      section: 'KERJA BAKTI',
      type: Pokja1InputType.text,
    ),
    Pokja1FieldDefinition(
      key: 'kerja_bakti_vol',
      label: 'Volume',
      section: 'KERJA BAKTI',
      type: Pokja1InputType.number,
    ),
    Pokja1FieldDefinition(
      key: 'kerja_bakti_metode',
      label: 'Metode',
      section: 'KERJA BAKTI',
      type: Pokja1InputType.text,
    ),
    Pokja1FieldDefinition(
      key: 'kerja_bakti_sasaran',
      label: 'Sasaran',
      section: 'KERJA BAKTI',
      type: Pokja1InputType.text,
    ),

    // BANTUAN ANAK YATIM
    Pokja1FieldDefinition(
      key: 'bantuan_yatim_kegiatan',
      label: 'Kegiatan',
      section: 'BANTUAN ANAK YATIM',
      type: Pokja1InputType.text,
    ),
    Pokja1FieldDefinition(
      key: 'bantuan_yatim_vol',
      label: 'Volume',
      section: 'BANTUAN ANAK YATIM',
      type: Pokja1InputType.number,
    ),
    Pokja1FieldDefinition(
      key: 'bantuan_yatim_metode',
      label: 'Metode',
      section: 'BANTUAN ANAK YATIM',
      type: Pokja1InputType.text,
    ),
    Pokja1FieldDefinition(
      key: 'bantuan_yatim_sasaran',
      label: 'Sasaran',
      section: 'BANTUAN ANAK YATIM',
      type: Pokja1InputType.text,
    ),

    // KEGIATAN SOSIAL
    Pokja1FieldDefinition(
      key: 'kegiatan_sosial_kegiatan',
      label: 'Kegiatan',
      section: 'KEGIATAN SOSIAL',
      type: Pokja1InputType.text,
    ),
    Pokja1FieldDefinition(
      key: 'kegiatan_sosial_vol',
      label: 'Volume',
      section: 'KEGIATAN SOSIAL',
      type: Pokja1InputType.number,
    ),
    Pokja1FieldDefinition(
      key: 'kegiatan_sosial_metode',
      label: 'Metode',
      section: 'KEGIATAN SOSIAL',
      type: Pokja1InputType.text,
    ),
    Pokja1FieldDefinition(
      key: 'kegiatan_sosial_sasaran',
      label: 'Sasaran',
      section: 'KEGIATAN SOSIAL',
      type: Pokja1InputType.text,
    ),

    // INFORMASI TAMBAHAN
    Pokja1FieldDefinition(
      key: 'sumber_dana',
      label: 'Sumber Dana',
      section: 'INFORMASI TAMBAHAN',
      type: Pokja1InputType.text,
    ),
    Pokja1FieldDefinition(
      key: 'hasil_kegiatan',
      label: 'Hasil Kegiatan',
      section: 'INFORMASI TAMBAHAN',
      type: Pokja1InputType.multiline,
    ),
  ];

  static List<Pokja1FieldDefinition> getFieldsForUuid(String uuid) {
    if (uuid.startsWith('KP1B1-')) return fieldsPenghayatan;
    if (uuid.startsWith('KP1B2-')) return fieldsGotongRoyong;
    if (uuid.startsWith('KP1-')) return fieldsKaderPokja1;
    return const [];
  }
}

