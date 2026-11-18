import 'package:flutter/material.dart';

/// Jenis notifikasi yang muncul di lonceng Beranda.
enum TipeNotifikasi {
  laporanMasuk,
  laporanRevisi,
  laporanDisetujui,
  laporanDibatalkan,
  pengumuman,
}

class NotifikasiItem {
  final String id;
  final TipeNotifikasi tipe;
  final String judul;
  final String pesan;
  final DateTime waktu;
  final bool dibaca;

  const NotifikasiItem({
    required this.id,
    required this.tipe,
    required this.judul,
    required this.pesan,
    required this.waktu,
    this.dibaca = false,
  });

  NotifikasiItem copyWith({bool? dibaca}) {
    return NotifikasiItem(
      id: id,
      tipe: tipe,
      judul: judul,
      pesan: pesan,
      waktu: waktu,
      dibaca: dibaca ?? this.dibaca,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'tipe': tipe.name,
        'judul': judul,
        'pesan': pesan,
        'waktu': waktu.toIso8601String(),
        'dibaca': dibaca,
      };

  factory NotifikasiItem.fromJson(Map<String, dynamic> j) {
    return NotifikasiItem(
      id: j['id']?.toString() ?? '',
      tipe: TipeNotifikasi.values.firstWhere(
        (t) => t.name == j['tipe'],
        orElse: () => TipeNotifikasi.pengumuman,
      ),
      judul: j['judul']?.toString() ?? '',
      pesan: j['pesan']?.toString() ?? '',
      waktu: DateTime.tryParse(j['waktu']?.toString() ?? '') ?? DateTime.now(),
      dibaca: j['dibaca'] == true,
    );
  }

  /// Ikon dan warna dibuat jelas dan kontras agar mudah dikenali lansia.
  IconData get ikon {
    switch (tipe) {
      case TipeNotifikasi.laporanMasuk:
        return Icons.mark_email_read_rounded;
      case TipeNotifikasi.laporanRevisi:
        return Icons.edit_note_rounded;
      case TipeNotifikasi.laporanDisetujui:
        return Icons.check_circle_rounded;
      case TipeNotifikasi.laporanDibatalkan:
        return Icons.cancel_rounded;
      case TipeNotifikasi.pengumuman:
        return Icons.campaign_rounded;
    }
  }

  Color get warna {
    switch (tipe) {
      case TipeNotifikasi.laporanMasuk:
        return const Color(0xFF3F8FC1);
      case TipeNotifikasi.laporanRevisi:
        return const Color(0xFFE8590C);
      case TipeNotifikasi.laporanDisetujui:
        return const Color(0xFF2F9E44);
      case TipeNotifikasi.laporanDibatalkan:
        return const Color(0xFFE03131);
      case TipeNotifikasi.pengumuman:
        return const Color(0xFF0073AB);
    }
  }

  /// true bila notifikasi ini terkait laporan (membuka tab Riwayat).
  bool get terkaitLaporan => tipe != TipeNotifikasi.pengumuman;
}
