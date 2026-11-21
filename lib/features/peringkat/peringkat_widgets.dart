import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'peringkat_model.dart';

class PeringkatColors {
  static const biru = Color(0xFF0B6EC7); // warna Figma: header & tab aktif
  static const navy = Color(0xFF0B4F8A);
  static const navyDark = Color(0xFF0A3F73);
  static const headerTop = biru;
  static const headerBottom = biru;
  static const pill = Color(0xFFE6F0FA);
  static const softBlue = Color(0xFFE8F1FB);
  static const border = Color(0xFFDCE6F1);
  static const grey = Color(0xFF6B7280);

  static const gold = Color(0xFFF5B82E);
  static const goldBg = Color(0xFFFFF1CC);
  static const goldBorder = Color(0xFFFBD777);
  static const silver = Color(0xFF8A94A6);
  static const silverBg = Color(0xFFE9EEF6);
  static const silverBorder = Color(0xFFD3DCE8);
  static const bronze = Color(0xFFD9895C);
  static const bronzeBg = Color(0xFFFBE6DB);
  static const bronzeBorder = Color(0xFFF3C9B2);

  static Color badge(int rank) =>
      rank == 1 ? gold : rank == 2 ? silver : bronze;
  static Color bg(int rank) =>
      rank == 1 ? goldBg : rank == 2 ? silverBg : bronzeBg;
  static Color stroke(int rank) =>
      rank == 1 ? goldBorder : rank == 2 ? silverBorder : bronzeBorder;
}

/// 89.2 -> "89,2" | 90 -> "90"
String formatPoin(num poin) {
  final s = poin == poin.roundToDouble()
      ? poin.toInt().toString()
      : poin.toStringAsFixed(1);
  return s.replaceAll('.', ',');
}

String? _subteks(PeringkatItem i) {
  final k = i.kecamatan;
  if (k == null) return null;
  return k.toLowerCase().startsWith('kec') ? k : 'Kec. $k';
}

// ---------------------------------------------------------------- TOGGLE
class PeringkatToggle extends StatelessWidget {
  final PeringkatJenis aktif;
  final ValueChanged<PeringkatJenis> onChanged;
  const PeringkatToggle({super.key, required this.aktif, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    Widget tab(String label, PeringkatJenis j) {
      final on = aktif == j;
      return Expanded(
        child: GestureDetector(
          onTap: () => onChanged(j),
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 40.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: on ? PeringkatColors.biru : Colors.transparent,
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: on ? Colors.white : PeringkatColors.navy,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: PeringkatColors.pill,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(children: [
        tab('Desa', PeringkatJenis.desa),
        tab('Kecamatan', PeringkatJenis.kecamatan),
      ]),
    );
  }
}

// ---------------------------------------------------------------- KARTU PERIODE
class PeringkatPeriodeCard extends StatelessWidget {
  final PeringkatPeriode periode;
  final VoidCallback onTap;
  const PeringkatPeriodeCard({super.key, required this.periode, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: PeringkatColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(children: [
        Icon(Icons.emoji_events_rounded, color: PeringkatColors.gold, size: 34.r),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Peringkat ${periode.label}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: PeringkatColors.navy)),
              SizedBox(height: 2.h),
              Text('Periode: ${periode.rentang}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11.sp, color: PeringkatColors.grey)),
            ],
          ),
        ),
        SizedBox(width: 8.w),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10.r),
          child: Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: PeringkatColors.softBlue,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(Icons.calendar_month_outlined,
                color: const Color(0xFF2B7BD1), size: 22.r),
          ),
        ),
      ]),
    );
  }
}

// ---------------------------------------------------------------- BARIS
/// Foto anggota; kalau tidak ada / gagal dimuat -> ikon rumah
class _Avatar extends StatelessWidget {
  final PeringkatItem item;
  final double ukuran;
  final Color bg;
  const _Avatar({required this.item, required this.ukuran, required this.bg});

  @override
  Widget build(BuildContext context) {
    final ikon = Icon(Icons.home_rounded,
        color: PeringkatColors.navy, size: ukuran * 0.55);
    return Container(
      width: ukuran,
      height: ukuran,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      child: item.foto == null
          ? ikon
          : Image.network(
              item.foto!,
              width: ukuran,
              height: ukuran,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => ikon,
            ),
    );
  }
}

class _Skor extends StatelessWidget {
  final num poin;
  const _Skor(this.poin);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(formatPoin(poin),
            style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
                color: PeringkatColors.navy)),
        Text('Poin',
            style: TextStyle(fontSize: 11.sp, color: PeringkatColors.grey)),
      ],
    );
  }
}

class _NamaDesa extends StatelessWidget {
  final PeringkatItem item;
  const _NamaDesa(this.item);

  @override
  Widget build(BuildContext context) {
    final sub = _subteks(item);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(item.nama,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: PeringkatColors.navy)),
        if (sub != null)
          Text(sub,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11.sp, color: PeringkatColors.grey)),
      ],
    );
  }
}

/// Baris juara 1-3 (berwarna)
class PeringkatTopRow extends StatelessWidget {
  final PeringkatItem item;
  const PeringkatTopRow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final r = item.rank.clamp(1, 3);
    return Stack(clipBehavior: Clip.none, children: [
      Container(
        margin: EdgeInsets.symmetric(vertical: 4.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: PeringkatColors.bg(r),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: PeringkatColors.stroke(r)),
        ),
        child: Row(children: [
          Container(
            width: 28.r,
            height: 28.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: PeringkatColors.badge(r), shape: BoxShape.circle),
            child: Text('${item.rank}',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800)),
          ),
          SizedBox(width: 10.w),
          _Avatar(item: item, ukuran: 40.r, bg: Colors.white),
          SizedBox(width: 10.w),
          Expanded(child: _NamaDesa(item)),
          SizedBox(width: 8.w),
          _Skor(item.poin),
        ]),
      ),
      if (r == 1)
        Positioned(
          right: 8.w,
          top: 0,
          child: Icon(Icons.workspace_premium_rounded,
              color: PeringkatColors.gold, size: 16.r),
        ),
    ]);
  }
}

/// Kotak berbingkai yang membungkus juara 1-3
class PeringkatTopBox extends StatelessWidget {
  final List<PeringkatItem> items;
  const PeringkatTopBox({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: PeringkatColors.border),
      ),
      child: Column(
          children: items.map((e) => PeringkatTopRow(item: e)).toList()),
    );
  }
}

/// Baris peringkat 4 dst (polos)
class PeringkatPlainRow extends StatelessWidget {
  final PeringkatItem item;
  final bool terakhir;
  const PeringkatPlainRow({super.key, required this.item, this.terakhir = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
      decoration: BoxDecoration(
        border: terakhir
            ? null
            : const Border(bottom: BorderSide(color: Color(0xFFE5ECF4))),
      ),
      child: Row(children: [
        Container(
          width: 28.r,
          height: 28.r,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              color: PeringkatColors.softBlue, shape: BoxShape.circle),
          child: Text('${item.rank}',
              style: TextStyle(
                  color: PeringkatColors.navy,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700)),
        ),
        SizedBox(width: 10.w),
        _Avatar(item: item, ukuran: 36.r, bg: PeringkatColors.softBlue),
        SizedBox(width: 10.w),
        Expanded(child: _NamaDesa(item)),
        SizedBox(width: 8.w),
        _Skor(item.poin),
      ]),
    );
  }
}

// ---------------------------------------------------------------- KARTU PODIUM (BERANDA)
class PeringkatPodiumCard extends StatelessWidget {
  final PeringkatItem item;
  final double tinggi;
  const PeringkatPodiumCard({super.key, required this.item, required this.tinggi});

  @override
  Widget build(BuildContext context) {
    final r = item.rank.clamp(1, 3);
    return Container(
      height: tinggi,
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      decoration: BoxDecoration(
        color: PeringkatColors.bg(r),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: PeringkatColors.stroke(r)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 24.r,
            height: 24.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: PeringkatColors.badge(r), shape: BoxShape.circle),
            child: Text('${item.rank}',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800)),
          ),
          SizedBox(height: 6.h),
          Text(item.nama,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: PeringkatColors.navy)),
          SizedBox(height: 2.h),
          Text(formatPoin(item.poin),
              style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w800,
                  color: PeringkatColors.navy)),
          Text('Poin',
              style: TextStyle(fontSize: 11.sp, color: PeringkatColors.grey)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------- PILIH PERIODE
Future<PeringkatPeriode?> pilihPeriode(
    BuildContext context, PeringkatPeriode aktif) {
  return showModalBottomSheet<PeringkatPeriode>(
    context: context,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (_) => SafeArea(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Padding(
          padding: EdgeInsets.all(16.r),
          child: Text('Pilih periode',
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: PeringkatColors.navy)),
        ),
        for (final p in PeringkatPeriode.values)
          ListTile(
            title: Text(p.label,
                style: TextStyle(
                    fontWeight: p == aktif ? FontWeight.w700 : FontWeight.w500,
                    color: PeringkatColors.navy)),
            subtitle: Text(p.rentang, style: TextStyle(fontSize: 12.sp)),
            trailing: p == aktif
                ? const Icon(Icons.check_circle, color: PeringkatColors.navy)
                : null,
            onTap: () => Navigator.pop(context, p),
          ),
        SizedBox(height: 8.h),
      ]),
    ),
  );
}
