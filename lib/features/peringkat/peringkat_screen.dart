import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'peringkat_controller.dart';
import 'peringkat_model.dart';
import 'peringkat_widgets.dart';

class PeringkatScreen extends StatelessWidget {
  const PeringkatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(PeringkatController(), tag: 'penuh');

    return Scaffold(
      backgroundColor: PeringkatColors.navy,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [PeringkatColors.headerTop, PeringkatColors.headerBottom],
          ),
        ),
        child: Column(children: [
          // ================= HEADER =================
          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 20.h),
              child: Row(children: [
                InkWell(
                  onTap: () => Get.back(),
                  borderRadius: BorderRadius.circular(20.r),
                  child: Padding(
                    padding: EdgeInsets.all(4.r),
                    child: Icon(Icons.arrow_back_rounded,
                        color: Colors.white, size: 26.r),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text('Peringkat',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700)),
                ),
                Image.asset('assets/images/logo_pkk.png',
                    width: 36.r, height: 36.r),
              ]),
            ),
          ),

          // ================= KONTEN PUTIH =================
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
              ),
              child: Column(children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
                  child: Obx(() => PeringkatToggle(
                        aktif: c.jenis.value,
                        onChanged: (j) => c.ganti(j: j),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
                  child: Obx(() => PeringkatPeriodeCard(
                        periode: c.periode.value,
                        onTap: () async {
                          final p = await pilihPeriode(context, c.periode.value);
                          if (p != null) c.ganti(p: p);
                        },
                      )),
                ),
                Expanded(child: Obx(() => _isi(c))),
              ]),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _isi(PeringkatController c) {
    if (c.loading.value) {
      return const Center(
          child: CircularProgressIndicator(color: PeringkatColors.navy));
    }
    if (c.error.value != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(c.error.value!, textAlign: TextAlign.center),
            TextButton(onPressed: c.muat, child: const Text('Coba lagi')),
          ]),
        ),
      );
    }
    if (c.items.isEmpty) {
      return const Center(child: Text('Belum ada data peringkat.'));
    }

    final top = c.items.where((e) => e.rank >= 1 && e.rank <= 3).toList();
    final sisa = c.items.where((e) => e.rank > 3).toList();

    return RefreshIndicator(
      onRefresh: c.muat,
      color: PeringkatColors.navy,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
        children: [
          if (top.isNotEmpty) PeringkatTopBox(items: top),
          if (top.isNotEmpty && sisa.isNotEmpty) SizedBox(height: 8.h),
          for (var i = 0; i < sisa.length; i++)
            PeringkatPlainRow(item: sisa[i], terakhir: i == sisa.length - 1),
        ],
      ),
    );
  }
}
