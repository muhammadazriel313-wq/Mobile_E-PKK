import 'package:epkk_nganjuk/common/appbar/custom_appbar.dart';
import 'package:epkk_nganjuk/features/notifikasi/notifikasi_controller.dart';
import 'package:epkk_nganjuk/features/notifikasi/notifikasi_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

/// Daftar notifikasi (dibuka dari lonceng di Beranda).
/// Huruf dibuat besar dan kontras agar mudah dibaca lansia.
class NotifikasiScreen extends StatefulWidget {
  const NotifikasiScreen({super.key});

  @override
  State<NotifikasiScreen> createState() => _NotifikasiScreenState();
}

class _NotifikasiScreenState extends State<NotifikasiScreen> {
  final NotifikasiController c = Get.find<NotifikasiController>();

  static const String _font = 'DMSans';

  @override
  void initState() {
    super.initState();
    c.layarTerbuka.value = true; // pop up tidak muncul saat layar ini terbuka
  }

  @override
  void dispose() {
    c.layarTerbuka.value = false;
    super.dispose();
  }

  String _waktu(DateTime w) {
    final selisih = DateTime.now().difference(w);
    if (selisih.inMinutes < 1) return 'Baru saja';
    if (selisih.inMinutes < 60) return '${selisih.inMinutes} menit lalu';
    if (selisih.inHours < 24) return '${selisih.inHours} jam lalu';
    return DateFormat('d MMM yyyy, HH:mm', 'id_ID').format(w);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomeAppBar(title: 'Notifikasi', onBack: () => Get.back()),
      body: Column(
        children: [
          // ---------- BARIS ATAS ----------
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 4.h, 8.w, 0),
            child: Row(
              children: [
                Expanded(
                  child: Obx(
                    () => Text(
                      c.jumlahBelumDibaca.value == 0
                          ? 'Semua sudah dibaca'
                          : '${c.jumlahBelumDibaca.value} belum dibaca',
                      style: TextStyle(
                        fontFamily: _font,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF374151),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => TextButton(
                    onPressed: c.jumlahBelumDibaca.value == 0
                        ? null
                        : c.tandaiSemuaDibaca,
                    child: Text(
                      'Tandai semua dibaca',
                      style: TextStyle(
                        fontFamily: _font,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ---------- DAFTAR ----------
          Expanded(
            child: RefreshIndicator(
              onRefresh: c.sinkron,
              child: Obx(() {
                if (c.items.isEmpty) return _kosong();

                return ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                  itemCount: c.items.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (_, i) => _kartu(c.items[i]),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _kosong() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: 120.h),
        Icon(
          Icons.notifications_none_rounded,
          size: 72.sp,
          color: const Color(0xFF9CA3AF),
        ),
        SizedBox(height: 16.h),
        Center(
          child: Text(
            'Belum ada notifikasi',
            style: TextStyle(
              fontFamily: _font,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF374151),
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Text(
            'Kabar tentang laporan dan pengumuman akan muncul di sini.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: _font,
              fontSize: 16.sp,
              height: 1.4,
              color: const Color(0xFF6B7280),
            ),
          ),
        ),
      ],
    );
  }

  Widget _kartu(NotifikasiItem n) {
    final belum = !n.dibaca;

    return Material(
      color: belum ? const Color(0xFFEFFAFF) : Colors.white,
      borderRadius: BorderRadius.circular(18.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(18.r),
        onTap: () => c.bukaTujuan(n),
        child: Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: belum ? n.warna.withValues(alpha: 0.6) : const Color(0xFFE5E7EB),
              width: belum ? 1.6 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52.w,
                height: 52.w,
                decoration: BoxDecoration(
                  color: n.warna.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(n.ikon, color: n.warna, size: 30.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (belum)
                          Container(
                            width: 10.w,
                            height: 10.w,
                            margin: EdgeInsets.only(right: 6.w),
                            decoration: BoxDecoration(
                              color: n.warna,
                              shape: BoxShape.circle,
                            ),
                          ),
                        Expanded(
                          child: Text(
                            n.judul,
                            style: TextStyle(
                              fontFamily: _font,
                              fontSize: 18.sp,
                              fontWeight: belum ? FontWeight.w800 : FontWeight.w600,
                              color: const Color(0xFF1F2A37),
                              height: 1.25,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      n.pesan,
                      style: TextStyle(
                        fontFamily: _font,
                        fontSize: 16.sp,
                        height: 1.35,
                        color: const Color(0xFF374151),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      _waktu(n.waktu),
                      style: TextStyle(
                        fontFamily: _font,
                        fontSize: 14.sp,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
