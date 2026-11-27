import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'peringkat_controller.dart';
import 'peringkat_model.dart';
import 'peringkat_widgets.dart';

/// Taruh di home_screen.dart (sudah terpasang di bawah tombol layanan).
class PeringkatHomeSection extends StatefulWidget {
  /// desa -> podium desa, kecamatan -> podium kecamatan
  final PeringkatJenis jenis;
  const PeringkatHomeSection({super.key, this.jenis = PeringkatJenis.desa});

  @override
  State<PeringkatHomeSection> createState() => _PeringkatHomeSectionState();
}

class _PeringkatHomeSectionState extends State<PeringkatHomeSection> {
  late final PeringkatController c;

  @override
  void initState() {
    super.initState();
    c = Get.put(
      PeringkatController()
        ..limit = 3
        ..jenis.value = widget.jenis
        ..periode.value = PeringkatPeriode.bulanIni,
      tag: 'beranda',
    );
    // controller bisa sudah ada dari sebelumnya -> pastikan jenisnya cocok
    if (c.jenis.value != widget.jenis) c.ganti(j: widget.jenis);
  }

  @override
  void didUpdateWidget(covariant PeringkatHomeSection old) {
    super.didUpdateWidget(old);
    if (old.jenis != widget.jenis) c.ganti(j: widget.jenis);
  }

  @override
  Widget build(BuildContext context) {

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // ================= JUDUL =================
      Row(children: [
        ExcludeSemantics(
          child: SvgPicture.asset(
            'assets/icons/ic_trophy.svg',
            width: 22.r,
            height: 22.r,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Obx(() => Text('Peringkat ${c.periode.value.label}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: PeringkatColors.navy))),
        ),
        InkWell(
          onTap: () => Get.toNamed('/peringkat',
              arguments: {'jenis': widget.jenis.name}),
          child: Row(children: [
            Text('Lihat Semua',
                style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2B7BD1))),
            Icon(Icons.chevron_right_rounded,
                size: 20.r, color: const Color(0xFF2B7BD1)),
          ]),
        ),
      ]),
      SizedBox(height: 12.h),

      // ================= PODIUM =================
      Obx(() {
        if (c.loading.value) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h),
            child: const Center(
                child: CircularProgressIndicator(color: PeringkatColors.navy)),
          );
        }
        if (c.error.value != null) {
          return InkWell(
            onTap: c.muat,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Text('${c.error.value}\n\nKetuk untuk coba lagi.',
                  style: TextStyle(fontSize: 12.sp)),
            ),
          );
        }

        PeringkatItem? ke(int r) =>
            c.items.firstWhereOrNull((e) => e.rank == r);
        final p1 = ke(1), p2 = ke(2), p3 = ke(3);
        if (p1 == null && p2 == null && p3 == null) {
          return const Text('Belum ada data peringkat.');
        }

        Widget slot(PeringkatItem? it, double tinggi) => Expanded(
              child: it == null
                  ? SizedBox(height: tinggi)
                  : PeringkatPodiumCard(item: it, tinggi: tinggi),
            );

        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            slot(p2, 104.h),
            SizedBox(width: 10.w),
            slot(p1, 122.h),
            SizedBox(width: 10.w),
            slot(p3, 104.h),
          ],
        );
      }),
    ]);
  }
}
