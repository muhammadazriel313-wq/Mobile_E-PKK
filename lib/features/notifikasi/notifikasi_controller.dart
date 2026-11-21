import 'dart:async';
import 'dart:convert';

import 'package:epkk_nganjuk/core/api_helper.dart';
import 'package:epkk_nganjuk/features/Riwayat/riwayat_model.dart';
import 'package:epkk_nganjuk/features/home/kebun/kebun_laporan_controller.dart';
import 'package:epkk_nganjuk/features/home/nav_controller.dart';
import 'package:epkk_nganjuk/features/notifikasi/notifikasi_model.dart';
import 'package:epkk_nganjuk/features/notifikasi/notifikasi_screen.dart';
import 'package:epkk_nganjuk/features/pengumuman/pengumuman_model.dart';
import 'package:epkk_nganjuk/services/preferences/preferences_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Pusat notifikasi (lonceng di Beranda).
///
/// Cara kerja (tanpa perubahan di server):
/// - Setiap [intervalSinkron] dan saat aplikasi dibuka kembali, data laporan
///   (`/riwayat`) dibandingkan dengan keadaan terakhir yang tersimpan di HP.
/// - Laporan baru masuk, berubah menjadi Revisi, Disetujui Kecamatan,
///   Disetujui Kabupaten, atau Dibatalkan -> dibuatkan notifikasi.
/// - Pengumuman baru minggu ini -> dibuatkan notifikasi.
/// - Perubahan yang terjadi saat aplikasi tertutup tetap terdeteksi saat
///   aplikasi dibuka lagi (notifikasi yang terlewat).
/// - Setiap notifikasi baru memunculkan pop up di bagian atas layar.
///
/// Batasan: notifikasi hanya terdeteksi saat aplikasi sedang dibuka. Untuk
/// notifikasi saat aplikasi tertutup diperlukan push (FCM) dari server.
class NotifikasiController extends GetxController with WidgetsBindingObserver {
  static const Duration intervalSinkron = Duration(seconds: 60);
  static const int maksTersimpan = 100;

  final ApiHelper _api = ApiHelper();

  final items = <NotifikasiItem>[].obs;
  final jumlahBelumDibaca = 0.obs;

  /// true saat layar Notifikasi sedang dibuka (pop up tidak perlu muncul).
  final layarTerbuka = false.obs;

  String _idUser = '';
  String _idRole = '';
  String _idOrg = '';

  Timer? _timer;
  bool _sedangSinkron = false;

  /// uuid laporan -> status terakhir. null = belum pernah disinkronkan.
  Map<String, String>? _snapshot;

  /// id pengumuman yang sudah diketahui. null = belum pernah disinkronkan.
  Set<String>? _pengumumanDikenal;

  // ================= MULAI / BERHENTI =================
  Future<void> mulai({
    required String idUser,
    required String idRole,
    required String idOrganization,
  }) async {
    if (idUser.isEmpty) return;

    final gantiAkun = idUser != _idUser;
    _idUser = idUser;
    _idRole = idRole;
    _idOrg = idOrganization;

    if (gantiAkun) {
      _snapshot = null;
      _pengumumanDikenal = null;
      items.clear();
      await _muatTersimpan();
    }

    if (_timer == null || gantiAkun) {
      WidgetsBinding.instance.removeObserver(this);
      WidgetsBinding.instance.addObserver(this);
      _timer?.cancel();
      _timer = Timer.periodic(intervalSinkron, (_) => sinkron());
    }

    await sinkron();
  }

  void berhenti() {
    _timer?.cancel();
    _timer = null;
    WidgetsBinding.instance.removeObserver(this);
    _idUser = '';
    _snapshot = null;
    _pengumumanDikenal = null;
    items.clear();
    jumlahBelumDibaca.value = 0;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) sinkron();
  }

  @override
  void onClose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  // ================= SINKRON LAPORAN =================
  Future<void> sinkron() async {
    if (_idUser.isEmpty || _sedangSinkron) return;
    _sedangSinkron = true;

    try {
      // Pengguna sudah keluar (logout)? Hentikan pemantauan.
      if (await PreferencesService.getUser() == null) {
        berhenti();
        return;
      }

      final response = await _api.get(
        '/riwayat',
        queryParameters: {
          'user_id': _idUser,
          'user_role': _idRole,
          'user_org': _idOrg,
        },
      );

      final hasil = RiwayatResponse.fromJson(response.data);
      if (hasil.statusCode != 200) return;

      // Kebun Laporan memakai data yang sama (tanpa permintaan ganda).
      if (Get.isRegistered<KebunLaporanController>()) {
        Get.find<KebunLaporanController>().perbarui(hasil.data);
      }

      await _periksaLaporan(hasil.data);
    } catch (e) {
      debugPrint('ERROR SINKRON NOTIFIKASI: $e');
    } finally {
      _sedangSinkron = false;
    }
  }

  Future<void> _periksaLaporan(List<Laporan> data) async {
    final peta = {for (final l in data) l.uuid: l.status};
    final baru = <NotifikasiItem>[];

    // Sinkron pertama kali hanya mencatat keadaan awal (tanpa notifikasi),
    // supaya laporan lama tidak membanjiri notifikasi.
    if (_snapshot != null) {
      for (final l in data) {
        final lama = _snapshot![l.uuid];
        if (lama == null) {
          baru.add(_buat(
            TipeNotifikasi.laporanMasuk,
            'Laporan sudah masuk',
            'Laporan tanggal ${_tanggal(l)} sudah diterima dan sedang diproses.',
          ));
        } else if (lama != l.status) {
          final n = _perubahanStatus(l);
          if (n != null) baru.add(n);
        }
      }
    }

    _snapshot = peta;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('notif_snapshot_$_idUser', jsonEncode(peta));

    await _tambah(baru);
  }

  NotifikasiItem? _perubahanStatus(Laporan l) {
    final tgl = _tanggal(l);
    switch (l.status) {
      case 'Revisi':
        return _buat(
          TipeNotifikasi.laporanRevisi,
          'Laporan perlu direvisi',
          'Laporan tanggal $tgl dikembalikan untuk diperbaiki. '
              'Buka Riwayat lalu pilih Revisi.',
        );
      case 'Disetujui1':
        return _buat(
          TipeNotifikasi.laporanDisetujui,
          'Laporan disetujui Kecamatan',
          'Laporan tanggal $tgl sudah disetujui Kecamatan dan diteruskan '
              'ke Kabupaten.',
        );
      case 'Disetujui2':
        return _buat(
          TipeNotifikasi.laporanDisetujui,
          'Laporan disetujui Kabupaten',
          'Laporan tanggal $tgl sudah disetujui Kabupaten. Terima kasih!',
        );
      case 'Dibatalkan':
        return _buat(
          TipeNotifikasi.laporanDibatalkan,
          'Laporan dibatalkan',
          'Laporan tanggal $tgl dibatalkan.',
        );
      case 'Proses':
        return _buat(
          TipeNotifikasi.laporanMasuk,
          'Laporan sedang diproses',
          'Laporan tanggal $tgl sedang diproses kembali.',
        );
      default:
        return null;
    }
  }

  // ================= PENGUMUMAN =================
  Future<void> periksaPengumuman(List<Pengumuman> daftar) async {
    if (_idUser.isEmpty || daftar.isEmpty) return;

    final idSekarang = daftar.map((p) => p.id).toSet();
    final prefs = await SharedPreferences.getInstance();

    // Pertama kali: catat saja sebagai keadaan awal.
    if (_pengumumanDikenal == null) {
      _pengumumanDikenal = idSekarang;
      await prefs.setStringList('notif_peng_$_idUser', idSekarang.toList());
      return;
    }

    final baru = <NotifikasiItem>[];
    for (final p in daftar) {
      if (!_pengumumanDikenal!.contains(p.id)) {
        baru.add(_buat(
          TipeNotifikasi.pengumuman,
          'Pengumuman baru',
          p.judul,
        ));
      }
    }

    _pengumumanDikenal = {..._pengumumanDikenal!, ...idSekarang};
    await prefs.setStringList(
      'notif_peng_$_idUser',
      _pengumumanDikenal!.toList(),
    );

    await _tambah(baru);
  }

  // ================= DAFTAR NOTIFIKASI =================
  NotifikasiItem _buat(TipeNotifikasi tipe, String judul, String pesan) {
    return NotifikasiItem(
      id: '${DateTime.now().microsecondsSinceEpoch}_${tipe.name}',
      tipe: tipe,
      judul: judul,
      pesan: pesan,
      waktu: DateTime.now(),
    );
  }

  String _tanggal(Laporan l) =>
      DateFormat('d MMMM yyyy', 'id_ID').format(l.createdAt.toLocal());

  Future<void> _tambah(List<NotifikasiItem> baru) async {
    if (baru.isEmpty) return;

    items.insertAll(0, baru);
    if (items.length > maksTersimpan) {
      items.removeRange(maksTersimpan, items.length);
    }

    await _simpanItems();
    _hitungBelumDibaca();
    _tampilkanPopup(baru);
  }

  Future<void> tandaiDibaca(String id) async {
    final i = items.indexWhere((e) => e.id == id);
    if (i < 0 || items[i].dibaca) return;
    items[i] = items[i].copyWith(dibaca: true);
    await _simpanItems();
    _hitungBelumDibaca();
  }

  Future<void> tandaiSemuaDibaca() async {
    for (var i = 0; i < items.length; i++) {
      if (!items[i].dibaca) items[i] = items[i].copyWith(dibaca: true);
    }
    await _simpanItems();
    _hitungBelumDibaca();
  }

  Future<void> hapusSemua() async {
    items.clear();
    await _simpanItems();
    _hitungBelumDibaca();
  }

  void _hitungBelumDibaca() {
    jumlahBelumDibaca.value = items.where((e) => !e.dibaca).length;
  }

  // ================= PENYIMPANAN =================
  Future<void> _muatTersimpan() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final s = prefs.getString('notif_items_$_idUser');
      if (s != null) {
        final list = (jsonDecode(s) as List)
            .map((e) => NotifikasiItem.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        items.assignAll(list);
      }

      final snap = prefs.getString('notif_snapshot_$_idUser');
      if (snap != null) {
        _snapshot = Map<String, String>.from(jsonDecode(snap));
      }

      final peng = prefs.getStringList('notif_peng_$_idUser');
      if (peng != null) _pengumumanDikenal = peng.toSet();
    } catch (e) {
      debugPrint('ERROR MUAT NOTIFIKASI: $e');
    }
    _hitungBelumDibaca();
  }

  Future<void> _simpanItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        'notif_items_$_idUser',
        jsonEncode(items.map((e) => e.toJson()).toList()),
      );
    } catch (e) {
      debugPrint('ERROR SIMPAN NOTIFIKASI: $e');
    }
  }

  // ================= POP UP =================
  void bukaLayar() {
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
    Get.to(() => const NotifikasiScreen());
  }

  /// Buka tujuan dari sebuah notifikasi: laporan -> Riwayat, pengumuman -> Pengumuman.
  void bukaTujuan(NotifikasiItem n) {
    tandaiDibaca(n.id);
    Get.back();
    Get.find<NavController>().changeTabIndex(n.terkaitLaporan ? 1 : 2);
  }

  void _tampilkanPopup(List<NotifikasiItem> baru) {
    if (layarTerbuka.value || baru.isEmpty) return;

    // Utamakan yang perlu tindakan (revisi).
    final utama = baru.firstWhere(
      (n) => n.tipe == TipeNotifikasi.laporanRevisi,
      orElse: () => baru.first,
    );
    final jumlah = baru.length;
    final judul = jumlah == 1 ? utama.judul : '$jumlah notifikasi baru';
    final pesan =
        jumlah == 1 ? utama.pesan : '${utama.judul} dan ${jumlah - 1} lainnya';

    try {
      HapticFeedback.mediumImpact();
      if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();

      Get.showSnackbar(
        GetSnackBar(
          snackPosition: SnackPosition.TOP,
          snackStyle: SnackStyle.FLOATING,
          margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          borderRadius: 20,
          backgroundColor: Colors.white,
          borderColor: utama.warna,
          borderWidth: 2,
          boxShadows: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 18,
              offset: Offset(0, 6),
            ),
          ],
          duration: const Duration(seconds: 8),
          animationDuration: const Duration(milliseconds: 400),
          isDismissible: true,
          dismissDirection: DismissDirection.up,
          onTap: (_) => bukaLayar(),
          icon: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: utama.warna.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: Icon(utama.ikon, color: utama.warna, size: 30),
          ),
          titleText: Text(
            judul,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'DMSans',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2A37),
            ),
          ),
          messageText: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              pesan,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'DMSans',
                fontSize: 16,
                height: 1.3,
                color: Color(0xFF4B5563),
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      debugPrint('ERROR POP UP NOTIFIKASI: $e');
    }
  }
}
