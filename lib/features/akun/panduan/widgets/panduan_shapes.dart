import 'package:flutter/material.dart';

import '../panduan_style.dart';

/// Jenis dekorasi vektor pada halaman Panduan.
/// Path diambil langsung dari layer Figma (vectorPaths), bukan dari tebakan.
enum PanduanShapeKind {
  /// Layer "Lekukan header" (400x30)
  headerCurve,

  /// Layer "Garis lekukan header" (235x25)
  headerCurveLine,

  /// Layer "Lengkungan pembatas" (400x55)
  headerDivider,

  /// Layer "Lekukan kartu panduan" (84x40)
  cardCorner,

  /// Layer "Gelombang biru muda bawah" (400x60)
  waveLight,

  /// Layer "Gelombang biru bawah" (164x77)
  waveDark,
}

class PanduanShape extends StatelessWidget {
  const PanduanShape(this.kind, {super.key});

  final PanduanShapeKind kind;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size.infinite, painter: _ShapePainter(kind));
  }
}

class _ShapePainter extends CustomPainter {
  const _ShapePainter(this.kind);

  final PanduanShapeKind kind;

  @override
  void paint(Canvas canvas, Size size) {
    final spec = _specs[kind]!;
    // Skala path desain ke ukuran widget sebenarnya.
    canvas.scale(
      size.width / spec.designSize.width,
      size.height / spec.designSize.height,
    );
    canvas.drawPath(
      spec.buildPath(),
      Paint()
        ..color = spec.color
        ..isAntiAlias = true,
    );
  }

  @override
  bool shouldRepaint(covariant _ShapePainter oldDelegate) =>
      oldDelegate.kind != kind;
}

class _ShapeSpec {
  const _ShapeSpec(this.designSize, this.color, this.buildPath);

  final Size designSize;
  final Color color;
  final Path Function() buildPath;
}

final Map<PanduanShapeKind, _ShapeSpec> _specs = {
  PanduanShapeKind.headerCurve: _ShapeSpec(
    const Size(400, 30),
    const Color.fromRGBO(237, 246, 255, 0.72),
    () => Path()
      ..moveTo(0, 1.0714)
      ..cubicTo(84.112, 0, 142.056, 17.143, 228.037, 13.929)
      ..cubicTo(285.981, 11.786, 314.019, 0, 366.355, 0)
      ..lineTo(400, 0)
      ..cubicTo(321.495, 13.929, 310.280, 28.929, 228.037, 27.857)
      ..lineTo(0, 30)
      ..close(),
  ),
  PanduanShapeKind.headerCurveLine: _ShapeSpec(
    const Size(235, 25),
    const Color.fromRGBO(255, 255, 255, 0.47),
    () => Path()
      ..moveTo(0, 0)
      ..cubicTo(58.75, 0, 115.196, 21.913, 168.186, 13.391)
      ..cubicTo(191.225, 8.522, 199.289, 1.217, 216.569, 0)
      ..lineTo(235, 0)
      ..cubicTo(188.922, 15.826, 177.402, 28, 124.412, 24.348)
      ..cubicTo(73.725, 21.913, 33.407, 4.870, 0, 6.087)
      ..close(),
  ),
  PanduanShapeKind.headerDivider: _ShapeSpec(
    const Size(400, 55),
    PanduanStyle.pageBackground,
    () => Path()
      ..moveTo(0, 42)
      ..cubicTo(2, 20, 17, 14, 40, 14)
      ..lineTo(354, 14)
      ..cubicTo(376, 14, 390, 9, 400, 0)
      ..lineTo(400, 55)
      ..lineTo(0, 55)
      ..close(),
  ),
  PanduanShapeKind.cardCorner: _ShapeSpec(
    const Size(84, 40),
    const Color(0xFFD5E7FF),
    () => Path()
      ..moveTo(0, 40)
      ..cubicTo(27, 12, 47, 7, 84, 0)
      ..lineTo(84, 17)
      ..cubicTo(84, 31, 76, 40, 62, 40)
      ..close(),
  ),
  PanduanShapeKind.waveLight: _ShapeSpec(
    const Size(400, 60),
    const Color(0xFFC4E0FF),
    () => Path()
      ..moveTo(0, 14)
      ..cubicTo(44, 20, 56, 45, 113, 39)
      ..cubicTo(158, 34, 163, 68, 213, 49)
      ..cubicTo(265, 29, 271, 20, 322, 19)
      ..cubicTo(355, 20, 382, 16, 400, 0)
      ..lineTo(400, 60)
      ..lineTo(0, 60)
      ..close(),
  ),
  PanduanShapeKind.waveDark: _ShapeSpec(
    const Size(164, 77),
    const Color(0xFF3096F2),
    () => Path()
      ..moveTo(0, 77)
      ..cubicTo(42, 40, 74, 44, 114, 30)
      ..cubicTo(137, 22, 150, 14, 164, 0)
      ..lineTo(164, 77)
      ..lineTo(0, 77)
      ..close(),
  ),
};

/// Dekorasi gelombang biru di dasar halaman (Figma y=650 s.d. 710).
class PanduanBottomWaves extends StatelessWidget {
  const PanduanBottomWaves({super.key, required this.scale});

  /// Lebar layar / 400.
  final double scale;

  @override
  Widget build(BuildContext context) {
    final s = scale;
    return ExcludeSemantics(
      child: SizedBox(
        height: 60 * s,
        width: double.infinity,
        child: ClipRect(
          child: Stack(
            children: [
              // Biru muda: Figma top 666 -> 16 dari tepi atas area (650).
              Positioned(
                left: 0,
                right: 0,
                top: 16 * s,
                height: 60 * s,
                child: const PanduanShape(PanduanShapeKind.waveLight),
              ),
              // Biru tua: Figma left 236, top 650.
              Positioned(
                left: 236 * s,
                top: 0,
                width: 164 * s,
                height: 77 * s,
                child: const PanduanShape(PanduanShapeKind.waveDark),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
