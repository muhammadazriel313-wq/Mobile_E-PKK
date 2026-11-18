import 'package:epkk_nganjuk/core/api_helper.dart';
import 'package:epkk_nganjuk/features/Riwayat/riwayat_model.dart';
import 'package:get/get.dart';

/// Tahap pertumbuhan pohon pada Kebun Laporan.
class TahapKebun {
  final String nama;
  final int mulaiDari; // jumlah laporan disetujui minimal untuk tahap ini

  const TahapKebun(this.nama, this.mulaiDari);
}

/// Mengelola data Kebun Laporan di Beranda.
///
/// Aturan:
/// - Satu angka saja: jumlah laporan yang sudah DISETUJUI KABUPATEN dan tidak
///   sedang direvisi pada BULAN BERJALAN.
/// - Pohon bisa menyusut: hitungan selalu dibuat ulang dari status terbaru.
///   Jika laporan yang tadinya selesai dikembalikan atau direvisi, atau belum
///   sampai ke Kabupaten, laporan itu tidak dihitung lagi.
/// - Reset otomatis: setiap pergantian bulan, hitungan kembali ke 0 karena
///   laporan difilter berdasarkan bulan dan tahun dari tanggal kirim
///   (`created_at`). Tidak ada data yang dihapus dan tidak perlu server cron.
class KebunLaporanController extends GetxController {
  /// Target laporan disetujui per bulan (pohon penuh di angka ini).
  static const int targetBulanan = 20;

  /// Status laporan yang dihitung: hanya yang sudah disetujui Kabupaten
  /// ('Disetujui2'). Status 'Proses', 'Disetujui1' (baru Kecamatan), 'Revisi',
  /// dan 'Dibatalkan' tidak dihitung.
  static const Set<String> statusDihitung = {'Disetujui2'};

  static const List<TahapKebun> tahap = [
    TahapKebun('Benih', 0),
    TahapKebun('Tunas', 1),
    TahapKebun('Bibit', 3),
    TahapKebun('Pohon Muda', 6),
    TahapKebun('Pohon Dewasa', 10),
    TahapKebun('Pohon Berbuah', 15),
  ];

  final ApiHelper _api = ApiHelper();
  final List<Laporan> _semuaLaporan = [];

  final jumlahBulanIni = 0.obs;
  final jumlahBulanLalu = 0.obs;

  /// Laporan bulan ini yang belum selesai (diproses, baru Kecamatan, revisi).
  final jumlahBelumSelesai = 0.obs;

  /// Judul banner mengikuti peran: Desa atau Kecamatan.
  final judul = 'Kebun Laporan'.obs;
  final periode = DateTime.now().obs;
  final isLoading = false.obs;

  // ================= TAHAP =================
  static int indeksTahap(int jumlah) {
    var hasil = 0;
    for (var i = 0; i < tahap.length; i++) {
      if (jumlah >= tahap[i].mulaiDari) hasil = i;
    }
    return hasil;
  }

  static TahapKebun tahapUntuk(int jumlah) => tahap[indeksTahap(jumlah)];

  /// Teks petunjuk di bawah bar progres.
  static String petunjuk(int jumlah) {
    if (jumlah <= 0) {
      return 'Laporan yang disetujui Kabupaten akan menumbuhkan tunas';
    }
    final i = indeksTahap(jumlah);
    if (i < tahap.length - 1) {
      final sisa = tahap[i + 1].mulaiDari - jumlah;
      return '$sisa laporan lagi menuju ${tahap[i + 1].nama}';
    }
    if (jumlah < targetBulanan) {
      return '${targetBulanan - jumlah} laporan lagi menuju target bulan ini';
    }
    return 'Target bulan ini tercapai';
  }

  /// Sisa hari sebelum reset otomatis (reset terjadi setiap tanggal 1).
  int get sisaHariSebelumReset {
    final now = periode.value;
    final hariTerakhir = DateTime(now.year, now.month + 1, 0).day;
    return hariTerakhir - now.day + 1;
  }

  // ================= DATA DARI PUSAT NOTIFIKASI =================
  String _idPengguna = '';

  /// Atur akun yang sedang aktif. Bila akun berganti, data akun lama dibuang
  /// supaya pohon tidak menampilkan hitungan milik orang lain.
  void aturPengguna({required String idUser, required String idRole}) {
    judul.value =
        idRole == '2' ? 'Kebun Laporan Kecamatan' : 'Kebun Laporan Desa';

    if (idUser != _idPengguna) {
      _idPengguna = idUser;
      _semuaLaporan.clear();
      hitung();
    }
  }

  /// Dipanggil NotifikasiController setiap kali data laporan terbaru diterima
  /// (satu permintaan data dipakai bersama, jadi pohon tumbuh atau menyusut
  /// tanpa menunggu pengguna membuka ulang Beranda).
  void perbarui(List<Laporan> data) {
    _semuaLaporan
      ..clear()
      ..addAll(data);
    hitung();
  }

  // ================= LOAD =================
  Future<void> load({
    required String idUser,
    required String idRole,
    required String idOrganization,
  }) async {
    // id_role '1' = Desa, '2' = Kecamatan
    judul.value =
        idRole == '2' ? 'Kebun Laporan Kecamatan' : 'Kebun Laporan Desa';

    try {
      isLoading.value = true;

      final response = await _api.get(
        '/riwayat',
        queryParameters: {
          'user_id': idUser,
          'user_role': idRole,
          'user_org': idOrganization,
        },
      );

      final hasil = RiwayatResponse.fromJson(response.data);

      if (hasil.statusCode == 200) {
        _semuaLaporan
          ..clear()
          ..addAll(hasil.data);
      }
    } catch (e) {
      // Gagal memuat: tampilkan hitungan terakhir yang diketahui.
      // ignore: avoid_print
      print('ERROR KEBUN LAPORAN: $e');
    } finally {
      isLoading.value = false;
      hitung();
    }
  }

  // ================= HITUNG =================
  /// Hitung ulang dari data yang sudah dimuat. Aman dipanggil kapan saja,
  /// misalnya saat tengah malam atau saat aplikasi kembali aktif, sehingga
  /// pergantian bulan langsung me-reset pohon tanpa memuat ulang data.
  void hitung([DateTime? sekarang]) {
    final now = sekarang ?? DateTime.now();
    final bulanLalu = DateTime(now.year, now.month - 1, 1);

    periode.value = now;
    jumlahBulanIni.value = _hitungBulan(now);
    jumlahBulanLalu.value = _hitungBulan(bulanLalu);
    jumlahBelumSelesai.value = _hitungBelumSelesai(now);
  }

  int _hitungBulan(DateTime bulan) {
    return _semuaLaporan.where((l) {
      final tanggal = l.createdAt.toLocal();
      return statusDihitung.contains(l.status) &&
          tanggal.year == bulan.year &&
          tanggal.month == bulan.month;
    }).length;
  }

  int _hitungBelumSelesai(DateTime bulan) {
    return _semuaLaporan.where((l) {
      final tanggal = l.createdAt.toLocal();
      return !statusDihitung.contains(l.status) &&
          l.status != 'Dibatalkan' &&
          tanggal.year == bulan.year &&
          tanggal.month == bulan.month;
    }).length;
  }
}
