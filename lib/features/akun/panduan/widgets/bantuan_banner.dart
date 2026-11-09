import 'package:flutter/material.dart';

import '../panduan_style.dart';
import 'panduan_shapes.dart';

/// Panel informasi "BANTUAN" (Figma 369x67, radius 23).
class BantuanBanner extends StatelessWidget {
  const BantuanBanner({
    super.key,
    this.title = 'BANTUAN',
    this.description =
        'Temukan bantuan dan solusi untuk menggunakan aplikasi E-PKK.',
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    const radius = BorderRadius.all(Radius.circular(23));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          borderRadius: radius,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFEAF3FF), Color(0xFFE8F2FF), Color(0xFFD8EAFF)],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 67),
            child: Stack(
              children: [
                // Lekukan di pojok kanan bawah kartu (84x40).
                const Positioned(
                  right: 0,
                  bottom: 0,
                  width: 84,
                  height: 40,
                  child: PanduanShape(PanduanShapeKind.cardCorner),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 12, 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _HelpIcon(),
                      const SizedBox(width: 23),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(title, style: PanduanStyle.bantuanTitle),
                              const SizedBox(height: 4),
                              Text(
                                description,
                                style: PanduanStyle.bantuanDescription,
                              ),
                            ],
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
    );
  }
}

/// Kotak ikon 50x51 berisi lingkaran biru 38 dengan tanda tanya.
///
/// CATATAN: gradient lingkaran adalah PERKIRAAN (belum dibaca dari Figma).
/// Jika ingin identik, ekspor layer "Lingkaran bantuan" (3324:3313) sebagai
/// PNG dan ganti isi lingkaran dengan Image.asset.
class _HelpIcon extends StatelessWidget {
  const _HelpIcon();

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Container(
        width: 50,
        height: 51,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFDCEBFF), Color(0xFFCBE3FF)],
          ),
        ),
        child: Container(
          width: 38,
          height: 38,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment(0.45, -0.89), // 153 deg
              end: Alignment(-0.45, 0.89),
              colors: [Color(0xFF1798FF), Color(0xFF0078E3), Color(0xFF0057B9)],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
          child: const Text(
            '?',
            style: TextStyle(
              fontFamily: PanduanStyle.fontFamily,
              fontWeight: FontWeight.w700,
              fontSize: 26,
              height: 1.1,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
