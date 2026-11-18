import 'package:epkk_nganjuk/features/pengumuman/pengumuman_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Status titik merah pada ikon lonceng di header Beranda.
///
/// Titik merah muncul bila ada pengumuman minggu ini yang belum dilihat.
/// Saat lonceng diketuk, daftar pengumuman saat itu ditandai sudah dilihat
/// (disimpan di perangkat), dan titik merah hilang sampai ada yang baru.
class NotifBellController extends GetxController {
  static const String _kunci = 'pengumuman_terakhir_dilihat';

  final adaBaru = false.obs;

  String _tandaTangan(List<Pengumuman> daftar) {
    if (daftar.isEmpty) return '';
    final ids = daftar
        .map((p) => '${p.id}|${p.judul}|${p.updatedAt.millisecondsSinceEpoch}')
        .toList()
      ..sort();
    return ids.join(';');
  }

  Future<void> periksa(List<Pengumuman> daftar) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final terakhir = prefs.getString(_kunci) ?? '';
      final sekarang = _tandaTangan(daftar);
      adaBaru.value = sekarang.isNotEmpty && sekarang != terakhir;
    } catch (_) {
      adaBaru.value = daftar.isNotEmpty;
    }
  }

  Future<void> tandaiDilihat(List<Pengumuman> daftar) async {
    adaBaru.value = false;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kunci, _tandaTangan(daftar));
    } catch (_) {}
  }
}
