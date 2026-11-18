import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../panduan_style.dart';
import 'panduan_shapes.dart';

/// Header: foto kantor bupati + lapisan biru + foto Ketua PKK + lekukan,
/// ditambah top bar (tombol kembali, logo, identitas E-PKK).
///
/// Semua posisi dihitung dari lebar layar (skala = lebar / 400) supaya
/// proporsi crop foto sama dengan Figma di ukuran layar apa pun.
class PanduanHeader extends StatelessWidget {
  const PanduanHeader({super.key, this.onBack});

  final VoidCallback? onBack;

  static const String _bgAsset = 'assets/images/header_kantor_bupati.png';
  static const String _personAsset = 'assets/images/ketua_pkk_header.png';
  static const String _logoAsset = 'assets/images/logo_epkk.png';

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final s = width / PanduanStyle.designWidth;

        return SizedBox(
          height: PanduanStyle.headerDesignHeight * s,
          child: Stack(
            children: [
              // 1. Foto latar (Figma 400x227, object-cover)
              Positioned.fill(
                child: Image.asset(
                  _bgAsset,
                  fit: BoxFit.cover,
                  excludeFromSemantics: true,
                ),
              ),
              // 2. Lapisan biru (gradient kiri -> kanan)
              const Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color.fromRGBO(229, 242, 255, 0.88),
                        Color.fromRGBO(232, 245, 255, 0.57),
                        Color.fromRGBO(217, 237, 255, 0.30),
                      ],
                      stops: [0.0, 0.55, 1.0],
                    ),
                  ),
                ),
              ),
              // 3. Foto Ketua PKK (Figma left 234, top 60, 166x167)
              Positioned(
                left: 234 * s,
                top: 60 * s,
                width: 166 * s,
                height: 167 * s,
                child: Image.asset(
                  _personAsset,
                  fit: BoxFit.fill,
                  excludeFromSemantics: true,
                ),
              ),
              // 4. Lekukan header
              Positioned(
                left: 0,
                top: 0,
                width: width,
                height: 30 * s,
                child: const PanduanShape(PanduanShapeKind.headerCurve),
              ),
              Positioned(
                left: 0,
                top: 0,
                width: 235 * s,
                height: 25 * s,
                child: const PanduanShape(PanduanShapeKind.headerCurveLine),
              ),
              // 5. Lengkungan pembatas (Figma top 213, 400x55; dipotong di 227)
              Positioned(
                left: 0,
                top: 213 * s,
                width: width,
                height: 55 * s,
                child: const PanduanShape(PanduanShapeKind.headerDivider),
              ),
              // 6. Top bar. Status bar memakai status bar sistem, bukan gambar.
              Positioned(
                left: 12,
                top: topInset + 8,
                child: _TopBar(onBack: onBack, logoAsset: _logoAsset),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onBack, required this.logoAsset});

  final VoidCallback? onBack;
  final String logoAsset;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Area tekan 48x48; tampilan tetap lingkaran 32 seperti Figma.
        Semantics(
          button: true,
          label: 'Kembali',
          excludeSemantics: true,
          child: InkResponse(
            onTap: onBack ?? () => Get.back(),
            radius: 24,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(255, 255, 255, 0.8),
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  size: 16,
                  color: PanduanStyle.chevronBlue,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        Semantics(
          image: true,
          label: 'Logo E-PKK Kabupaten Nganjuk',
          child: Image.asset(
            logoAsset,
            width: 42,
            height: 39,
            fit: BoxFit.contain,
            excludeFromSemantics: true,
          ),
        ),
        const SizedBox(width: 12),
        const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('E-PKK', style: PanduanStyle.appTitle),
            SizedBox(height: 1),
            Text('Kabupaten Nganjuk', style: PanduanStyle.appSubtitle),
          ],
        ),
      ],
    );
  }
}
