import 'dart:math' as math;

/// Membuat gambar pohon (SVG string) untuk Kebun Laporan.
///
/// Pohon tumbuh dari benih sampai berbuah mengikuti jumlah laporan yang
/// disetujui pada bulan berjalan (0 - [maksLaporan]).
///
///   0      -> benih
///   1 - 2  -> tunas
///   3 - 5  -> bibit
///   6 - 9  -> pohon muda
///   10 - 14 -> pohon dewasa (mulai berbunga dan berbuah)
///   15+    -> pohon berbuah
///
/// Hasilnya di-cache per jumlah laporan, jadi aman dipanggil berulang kali.
class KebunPohonSvg {
  KebunPohonSvg._();

  static const int maksLaporan = 20;

  static final Map<int, String> _cache = {};

  static String build(int jumlahLaporan) {
    final n = jumlahLaporan.clamp(0, maksLaporan).toInt();
    return _cache.putIfAbsent(n, () => _gen(n));
  }

  // ---------------------------------------------------------------------------
  // Data bentuk pohon (koordinat dalam ruang 333 x 156, pohon berpusat di x=252)
  // ---------------------------------------------------------------------------
  static const List<String> _palet = [
    '#1B5230',
    '#226238',
    '#2B7343',
    '#358850',
    '#47A05D',
    '#62B96E',
    '#86CC86',
  ];

  // [cx, cy, radius]
  static const List<List<double>> _gugus = [
    [252, 58, 36],
    [222, 70, 28],
    [284, 70, 28],
    [236, 40, 26],
    [272, 40, 26],
    [252, 30, 20],
    [212, 86, 16],
    [292, 86, 16],
    [252, 82, 30],
  ];

  // [x, y, radius dasar buah]
  static const List<List<double>> _buah = [
    [232, 52, 5.2],
    [268, 48, 4.8],
    [250, 72, 5.8],
    [222, 76, 4.4],
    [284, 74, 4.6],
    [244, 35, 4],
    [262, 90, 4.2],
    [236, 92, 4.4],
    [256, 29, 3.8],
    [280, 57, 4.4],
    [214, 58, 4],
    [204, 84, 3.6],
  ];

  static const List<List<double>> _bunga = [
    [246, 46],
    [262, 74],
    [228, 66],
    [276, 36],
  ];

  // [path, lebar, ambang tumbuh]
  static const List<List<Object>> _cabang = [
    ['M252 104 L232 80', 4.0, 0.2],
    ['M253 104 L274 78', 4.0, 0.2],
    ['M252 98 L252 68', 3.0, 0.1],
    ['M236 86 L220 73', 2.4, 0.45],
    ['M270 84 L285 72', 2.4, 0.45],
  ];

  static final List<_Daun> _daun = _buatDaun();

  static List<_Daun> _buatDaun() {
    var seed = 7;
    double rnd() {
      seed = (seed * 16807) % 2147483647;
      return seed / 2147483647;
    }

    final hasil = <_Daun>[];
    for (final g in _gugus) {
      final cx = g[0], cy = g[1], r = g[2];
      final jumlah = (r * r / 60).floor() + 14;
      for (var i = 0; i < jumlah; i++) {
        final a = rnd() * 6.283;
        final d = r * math.sqrt(rnd()) * 1.02;
        final x = cx + d * math.cos(a);
        final y = cy + d * math.sin(a);
        final rot = rnd() * 140 - 70 + (x < cx ? -30 : 30);
        final rx = 5.5 + rnd() * 2.5;
        final ry = rx * (0.45 + rnd() * 0.15);
        var s = 0.5 +
            (-(x - cx) * 0.45 - (y - cy) * 0.85) / (r * 2) +
            (rnd() * 0.36 - 0.18);
        s = s.clamp(0.0, 0.999).toDouble();
        final jarak = math.sqrt(math.pow(x - 252, 2) + math.pow(y - 76, 2));
        final ambang = 0.1 + 0.9 * math.min(1.0, jarak / 68) + rnd() * 0.04;
        hasil.add(
          _Daun(
            y: y,
            ambang: ambang,
            svg: '<ellipse cx="${_f(x)}" cy="${_f(y)}" rx="${_f(rx)}" '
                'ry="${_f(ry)}" transform="rotate(${rot.toStringAsFixed(0)} '
                '${_f(x)} ${_f(y)})" fill="${_palet[(s * 7).floor()]}"/>',
          ),
        );
      }
    }
    hasil.sort((a, b) => a.y.compareTo(b.y));
    return hasil;
  }

  static String _f(double v) => v.toStringAsFixed(1);

  // ---------------------------------------------------------------------------
  // Pembuat SVG
  // ---------------------------------------------------------------------------
  static String _gen(int n) {
    final b = StringBuffer()
      ..write('<svg xmlns="http://www.w3.org/2000/svg" viewBox="170 0 164 156">')
      ..write(_defs)
      ..write('<ellipse cx="252" cy="143" rx="82" ry="10" fill="url(#ground)"/>');

    if (n == 0) {
      b
        ..write('<ellipse cx="252" cy="141.5" rx="17" ry="5" fill="#7A5535"/>')
        ..write('<ellipse cx="252" cy="140" rx="9" ry="2.6" fill="#9A6D42"/>')
        ..write('<ellipse cx="253" cy="139" rx="3.4" ry="2" fill="#C99A5B"/>')
        ..write('</svg>');
      return b.toString();
    }

    // Tunas (1 - 2 laporan)
    if (n <= 2) {
      final h = n == 1 ? 15.0 : 26.0;
      final y = 142 - h;
      b
        ..write('<ellipse cx="253" cy="143" rx="${_f(10 + h / 2)}" ry="3" '
            'fill="#0B2F5E" opacity="0.3"/>')
        ..write('<path d="M252 142 C252 ${_f(142 - h * .5)} '
            '252 ${_f(142 - h * .8)} 252 ${_f(y)}" stroke="#5FA85A" '
            'stroke-width="2" stroke-linecap="round" fill="none"/>')
        ..write('<ellipse cx="245" cy="${_f(y)}" rx="7.5" ry="3.4" '
            'transform="rotate(-25 245 ${_f(y)})" fill="#6BBF73"/>')
        ..write('<ellipse cx="259" cy="${_f(y)}" rx="7.5" ry="3.4" '
            'transform="rotate(25 259 ${_f(y)})" fill="#86CC86"/>');
      if (n == 2) {
        b.write('<ellipse cx="252" cy="${_f(y - 5)}" rx="3" ry="5.5" '
            'fill="#7ACB7F"/>');
      }
      b.write('</svg>');
      return b.toString();
    }

    // Bibit sampai pohon berbuah (3 - 20 laporan)
    final t = math.min(1.0, (n - 1) / 15);
    final skala = 0.34 + 0.66 * t;
    final buahMatang = math.max(0, n - 9);

    b
      ..write('<ellipse cx="254" cy="143" rx="${_f(40 * skala)}" ry="4" '
          'fill="#0B2F5E" opacity="0.3"/>')
      ..write('<g transform="translate(252 143) scale(${skala.toStringAsFixed(3)}) '
          'translate(-252 -143)">')
      ..write('<path d="M240 143 C246 136 247 124 248 98 L257 98 '
          'C258 124 260 136 266 143 Q253 147 240 143 Z" fill="url(#trunk)"/>')
      ..write('<path d="M250 135 C250.5 124 250.5 114 250 104 '
          'M255 138 C255.4 126 255 116 254.6 106" stroke="#3E2610" '
          'stroke-width="0.8" opacity="0.5" fill="none"/>');

    for (final c in _cabang) {
      if (t >= (c[2] as double)) {
        b.write('<path d="${c[0]}" stroke="#6B4423" stroke-width="${c[1]}" '
            'stroke-linecap="round" fill="none"/>');
      }
    }

    // Lapisan dasar tajuk (tumbuh bertahap)
    for (final g in _gugus) {
      final jarak = math.sqrt(
        math.pow(g[0] - 252, 2) + math.pow(g[1] - 76, 2),
      );
      final ambang = 0.05 + 0.9 * math.min(1.0, jarak / 68);
      final k = ((t - ambang) / 0.25).clamp(0.0, 1.0).toDouble();
      if (k > 0) {
        b.write('<circle cx="${g[0]}" cy="${g[1]}" r="${_f(g[2] * 0.85 * k)}" '
            'fill="#1B5230"/>');
      }
    }

    // Daun
    for (final d in _daun) {
      if (d.ambang <= t) b.write(d.svg);
    }

    // Bunga dan buah (mulai 10 laporan)
    if (n >= 10) {
      final faktor = 0.55 + 0.45 * math.min(buahMatang, 14) / 14;
      final jumlahBunga = math.min(4, math.max(0, 15 - n));
      for (var i = 0; i < jumlahBunga; i++) {
        final x = _bunga[i][0], y = _bunga[i][1];
        for (final o in const [
          [-1.4, 0.0],
          [1.4, 0.0],
          [0.0, -1.4],
          [0.0, 1.4],
        ]) {
          b.write('<circle cx="${_f(x + o[0])}" cy="${_f(y + o[1])}" r="1.5" '
              'fill="#FF9DBB"/>');
        }
        b.write('<circle cx="${_f(x)}" cy="${_f(y)}" r="0.9" fill="#FFE066"/>');
      }

      final jumlahBuah = math.min(buahMatang, _buah.length);
      for (var i = 0; i < jumlahBuah; i++) {
        final x = _buah[i][0], y = _buah[i][1];
        final r = double.parse((_buah[i][2] * faktor).toStringAsFixed(1));
        b
          ..write('<circle cx="${_f(x + .6)}" cy="${_f(y + 1)}" r="$r" '
              'fill="#0F3D22" opacity="0.35"/>')
          ..write('<path d="M${_f(x)} ${_f(y - r)} q0.8 -2.6 2.2 -3.2" '
              'stroke="#3C2A14" stroke-width="0.7" fill="none" '
              'stroke-linecap="round"/>')
          ..write('<circle cx="${_f(x)}" cy="${_f(y)}" r="$r" fill="url(#ripe)"/>')
          ..write('<ellipse cx="${_f(x - r * .35)}" cy="${_f(y - r * .4)}" '
              'rx="${_f(r * .28)}" ry="${_f(r * .18)}" fill="#FFFFFF" '
              'opacity="0.55"/>');
      }
    }

    b
      ..write('</g>')
      ..write('</svg>');
    return b.toString();
  }

  static const String _defs = '<defs>'
      '<radialGradient id="ground" cx="0.5" cy="0.5" r="0.5">'
      '<stop offset="0" stop-color="#8FD18A" stop-opacity="0.95"/>'
      '<stop offset="1" stop-color="#4E9B5A" stop-opacity="0"/>'
      '</radialGradient>'
      '<radialGradient id="ripe" cx="0.35" cy="0.3" r="0.85">'
      '<stop offset="0" stop-color="#FFD36B"/>'
      '<stop offset="0.55" stop-color="#F28C28"/>'
      '<stop offset="1" stop-color="#C9561A"/>'
      '</radialGradient>'
      '<linearGradient id="trunk" x1="240" y1="0" x2="266" y2="0" '
      'gradientUnits="userSpaceOnUse">'
      '<stop offset="0" stop-color="#946032"/>'
      '<stop offset="1" stop-color="#5A3719"/>'
      '</linearGradient>'
      '</defs>';
}

class _Daun {
  final double y;
  final double ambang;
  final String svg;

  const _Daun({required this.y, required this.ambang, required this.svg});
}
