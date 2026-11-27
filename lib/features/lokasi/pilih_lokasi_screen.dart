import 'dart:async';

import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/core/lokasi_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

/// Hasil pemilihan lokasi di peta.
class HasilLokasi {
  final double latitude;
  final double longitude;
  final String alamat;

  const HasilLokasi({
    required this.latitude,
    required this.longitude,
    required this.alamat,
  });
}

/// Layar peta untuk memilih tempat kegiatan.
///
/// Cara pakai: geser peta sampai pin merah tepat di lokasi, alamat terisi
/// otomatis, lalu tekan "Gunakan Lokasi Ini". Tombol lokasi memusatkan peta
/// ke posisi GPS, dan kotak cari dipakai untuk mencari nama tempat.
class PilihLokasiScreen extends StatefulWidget {
  final LatLng? posisiAwal;

  const PilihLokasiScreen({super.key, this.posisiAwal});

  @override
  State<PilihLokasiScreen> createState() => _PilihLokasiScreenState();
}

class _PilihLokasiScreenState extends State<PilihLokasiScreen> {
  // Pusat Kabupaten Nganjuk (dipakai bila GPS belum tersedia)
  static const LatLng _pusatNganjuk = LatLng(-7.6048, 111.9034);

  final MapController _map = MapController();
  final TextEditingController _cari = TextEditingController();

  late LatLng _pusat;
  String? _alamat;
  bool _memuatAlamat = false;
  bool _mencariPosisi = false;
  Timer? _tunda;
  int _permintaan = 0;

  @override
  void initState() {
    super.initState();
    _pusat = widget.posisiAwal ?? _pusatNganjuk;
  }

  @override
  void dispose() {
    _tunda?.cancel();
    _cari.dispose();
    _map.dispose();
    super.dispose();
  }

  void _pesan(String teks) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(teks)));
  }

  void _petaSiap() {
    _perbaruiAlamat();
    if (widget.posisiAwal == null) _lokasiSaya();
  }

  void _saatGeser(MapCamera camera, bool hasGesture) {
    _pusat = camera.center;
    _tunda?.cancel();
    _tunda = Timer(const Duration(milliseconds: 600), _perbaruiAlamat);
  }

  Future<void> _perbaruiAlamat() async {
    final ini = ++_permintaan;
    if (mounted) setState(() => _memuatAlamat = true);

    final hasil = await LokasiService.alamat(_pusat.latitude, _pusat.longitude);

    if (!mounted || ini != _permintaan) return;
    setState(() {
      _alamat = hasil;
      _memuatAlamat = false;
    });
  }

  Future<void> _lokasiSaya() async {
    setState(() => _mencariPosisi = true);
    final hasil = await LokasiService.posisiSaatIni();
    if (!mounted) return;
    setState(() => _mencariPosisi = false);

    if (hasil.posisi != null) {
      _map.move(hasil.posisi!, 17);
    } else if (hasil.pesan != null) {
      _pesan(hasil.pesan!);
    }
  }

  Future<void> _cariTempat(String kata) async {
    final q = kata.trim();
    if (q.isEmpty) return;
    FocusScope.of(context).unfocus();

    final hasil = await LokasiService.cari(q);
    if (!mounted) return;

    if (hasil == null) {
      _pesan('Tempat tidak ditemukan. Coba kata lain.');
      return;
    }
    _map.move(hasil.posisi, 17);
  }

  void _gunakan() {
    final alamat = (_alamat != null && _alamat!.trim().isNotEmpty)
        ? _alamat!
        : '${_pusat.latitude.toStringAsFixed(5)}, '
            '${_pusat.longitude.toStringAsFixed(5)}';

    Get.back(
      result: HasilLokasi(
        latitude: _pusat.latitude,
        longitude: _pusat.longitude,
        alamat: alamat,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ---------- PETA ----------
          Positioned.fill(
            child: FlutterMap(
              mapController: _map,
              options: MapOptions(
                initialCenter: _pusat,
                initialZoom: 16,
                minZoom: 5,
                maxZoom: 19,
                onMapReady: _petaSiap,
                onPositionChanged: _saatGeser,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.epkk_nganjuk',
                ),
                RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution('© OpenStreetMap contributors'),
                  ],
                ),
              ],
            ),
          ),

          // ---------- PIN DI TENGAH ----------
          const IgnorePointer(
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 44),
                child: Icon(Icons.location_on, size: 48, color: Colors.red),
              ),
            ),
          ),

          // ---------- KOTAK CARI ----------
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Row(
                children: [
                  Material(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    elevation: 3,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      tooltip: 'Kembali',
                      onPressed: () => Get.back(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      elevation: 3,
                      child: TextField(
                        controller: _cari,
                        textInputAction: TextInputAction.search,
                        onSubmitted: _cariTempat,
                        style: const TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          hintText: 'Cari tempat (desa, balai, masjid...)',
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 14,
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () => _cariTempat(_cari.text),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ---------- KARTU ALAMAT + TOMBOL ----------
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      heroTag: 'lokasi_saya',
                      backgroundColor: Colors.white,
                      foregroundColor: BrandColors.brandPrimary500,
                      tooltip: 'Lokasi saya',
                      onPressed: _mencariPosisi ? null : _lokasiSaya,
                      child: _mencariPosisi
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.my_location),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x33000000),
                            blurRadius: 14,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Lokasi dipilih',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                          const SizedBox(height: 4),
                          _memuatAlamat
                              ? const Row(
                                  children: [
                                    SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Mencari alamat...',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                )
                              : Text(
                                  _alamat ??
                                      'Alamat tidak ditemukan. Koordinat '
                                          'peta akan dipakai.',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    height: 1.3,
                                  ),
                                ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _memuatAlamat ? null : _gunakan,
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: BrandColors.brandPrimary500,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text(
                                'Gunakan Lokasi Ini',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
