class PeringkatItem {
  final int rank;
  final String nama;
  final num poin;
  final String? foto;

  PeringkatItem({
    required this.rank,
    required this.nama,
    required this.poin,
    this.foto,
  });

  factory PeringkatItem.fromJson(Map<String, dynamic> j) => PeringkatItem(
        rank: int.tryParse('${j['rank']}') ?? 0,
        nama: '${j['nama'] ?? '-'}',
        poin: num.tryParse('${j['poin']}') ?? 0,
        foto: (j['foto'] == null || '${j['foto']}'.isEmpty) ? null : '${j['foto']}',
      );
}

enum PeringkatJenis { desa, kecamatan }

enum PeringkatPeriode {
  bulanIni('bulan_ini', 'Bulan ini'),
  bulanLalu('bulan_lalu', 'Bulan lalu'),
  tahunIni('tahun_ini', 'Tahun ini'),
  tahunLalu('tahun_lalu', 'Tahun lalu');

  final String kode;
  final String label;
  const PeringkatPeriode(this.kode, this.label);
}
