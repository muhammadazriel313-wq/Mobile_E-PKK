class PeringkatItem {
  final int rank;
  final String nama;
  final num poin;
  final String? foto;
  final String? kecamatan; // opsional, dipakai untuk teks "Kec. ..."

  PeringkatItem({
    required this.rank,
    required this.nama,
    required this.poin,
    this.foto,
    this.kecamatan,
  });

  factory PeringkatItem.fromJson(Map<String, dynamic> j) {
    final kec = j['kecamatan'] ?? j['nama_kecamatan'] ?? j['sub'];
    return PeringkatItem(
      rank: int.tryParse('${j['rank']}') ?? 0,
      nama: '${j['nama'] ?? '-'}',
      poin: num.tryParse('${j['poin']}') ?? 0,
      foto: (j['foto'] == null || '${j['foto']}'.isEmpty) ? null : '${j['foto']}',
      kecamatan: (kec == null || '$kec'.isEmpty) ? null : '$kec',
    );
  }
}

enum PeringkatJenis { desa, kecamatan }

enum PeringkatPeriode {
  bulanIni('bulan_ini', 'Bulan Ini'),
  bulanLalu('bulan_lalu', 'Bulan Lalu'),
  tahunIni('tahun_ini', 'Tahun Ini'),
  tahunLalu('tahun_lalu', 'Tahun Lalu');

  final String kode;
  final String label;
  const PeringkatPeriode(this.kode, this.label);

  static const _bulan = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
  ];

  /// Contoh: "1 - 30 November 2026" atau "1 Januari - 31 Desember 2026"
  String get rentang {
    final now = DateTime.now();
    switch (this) {
      case PeringkatPeriode.bulanIni:
        return _rentangBulan(DateTime(now.year, now.month, 1));
      case PeringkatPeriode.bulanLalu:
        return _rentangBulan(DateTime(now.year, now.month - 1, 1));
      case PeringkatPeriode.tahunIni:
        return '1 Januari - 31 Desember ${now.year}';
      case PeringkatPeriode.tahunLalu:
        return '1 Januari - 31 Desember ${now.year - 1}';
    }
  }

  static String _rentangBulan(DateTime awal) {
    final akhir = DateTime(awal.year, awal.month + 1, 0);
    return '1 - ${akhir.day} ${_bulan[awal.month - 1]} ${awal.year}';
  }
}
