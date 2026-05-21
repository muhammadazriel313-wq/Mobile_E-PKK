import 'package:epkk_nganjuk/common/appbar/custom_appbar.dart';
import 'package:epkk_nganjuk/common/component/card_pengumuman.dart';
import 'package:epkk_nganjuk/features/home/nav_controller.dart';
import 'package:epkk_nganjuk/features/pengumuman/pengumuman_controller.dart';
import 'package:epkk_nganjuk/features/pengumuman/pengumuman_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PengumumanScreen extends StatefulWidget {
  const PengumumanScreen({super.key});

  @override
  State<PengumumanScreen> createState() => _PengumumanScreenState();
}

class _PengumumanScreenState extends State<PengumumanScreen> {
  final PengumumanController pengumumanController =
      Get.find<PengumumanController>();
  final RefreshController _refreshController = RefreshController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    await pengumumanController.loadPengumuman(isRefresh: true);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreData();
    }
  }

  Future<void> _loadMoreData() async {
    if (!pengumumanController.isLoadMore.value &&
        pengumumanController.hasMore.value) {
      await pengumumanController.loadPengumuman();
    }
  }

  Future<void> _onRefresh() async {
    try {
      await pengumumanController.refreshData();
      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.refreshFailed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarPrimary(
        title: 'Pengumuman',
        backgroundColor: Colors.white,
        onBack: () {
          final NavController navController = Get.find<NavController>();
          navController.changeTabIndex(0);
          Get.back();
        },
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        enablePullDown: true,
        enablePullUp: pengumumanController.hasMore.value,
        onLoading: _loadMoreData,
        header: const ClassicHeader(
          idleText: 'Tarik untuk refresh',
          releaseText: 'Lepaskan untuk refresh',
          completeText: 'Refresh selesai',
        ),
        footer: CustomFooter(
          builder: (context, mode) {
            if (mode == LoadStatus.loading) {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            return const SizedBox();
          },
        ),
        child: Obx(() {
          if (pengumumanController.isLoading.value &&
              pengumumanController.pengumumanList.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (pengumumanController.errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    pengumumanController.errorMessage.value,
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: _loadInitialData,
                    child: Text('Coba Lagi', style: TextStyle(fontSize: 14.sp)),
                  ),
                ],
              ),
            );
          }

          if (pengumumanController.pengumumanList.isEmpty) {
            return Center(
              child: Text(
                "Belum ada pengumuman",
                style: TextStyle(fontSize: 16.sp),
              ),
            );
          }

          return ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            itemCount:
                pengumumanController.pengumumanList.length +
                (pengumumanController.hasMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= pengumumanController.pengumumanList.length) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Center(
                    child: pengumumanController.isLoadMore.value
                        ? const CircularProgressIndicator()
                        : Text(
                            'Tarik untuk memuat lebih banyak',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey,
                            ),
                          ),
                  ),
                );
              }

              final pengumuman = pengumumanController.pengumumanList[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: CardPengumuman(
                  title: pengumuman.judul,
                  subTitle: pengumuman.tempat,
                  dateText: DateFormat('dd-MM-yyyy').format(pengumuman.tanggal),
                  onTab: () => _showPengumumanDetail(context, pengumuman),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  void _showPengumumanDetail(BuildContext context, Pengumuman pengumuman) {
    showDialog(
      context: context,

      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,

          insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),

          child: Container(
            width: double.infinity,

            padding: EdgeInsets.all(20.w),

            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),

              borderRadius: BorderRadius.circular(24.r),
            ),

            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  /// HEADER
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.w),

                        decoration: BoxDecoration(
                          color: const Color(0xFF3F8FC1).withOpacity(0.10),

                          borderRadius: BorderRadius.circular(14.r),
                        ),

                        child: Icon(
                          Icons.campaign_rounded,
                          color: const Color(0xFF3F8FC1),
                          size: 24.sp,
                        ),
                      ),

                      SizedBox(width: 12.w),

                      Expanded(
                        child: Text(
                          'Detail Pengumuman',

                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),

                      InkWell(
                        borderRadius: BorderRadius.circular(100.r),

                        onTap: () => Navigator.pop(context),

                        child: Padding(
                          padding: EdgeInsets.all(4.w),

                          child: Icon(
                            Icons.close_rounded,

                            size: 22.sp,

                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  /// JUDUL
                  Container(
                    width: double.infinity,

                    padding: EdgeInsets.all(14.w),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(16.r),

                      border: Border.all(color: const Color(0xFFE7EDF3)),
                    ),

                    child: Text(
                      pengumuman.judul,

                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                  ),

                  SizedBox(height: 18.h),

                  /// LOKASI
                  Container(
                    width: double.infinity,

                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 12.h,
                    ),

                    decoration: BoxDecoration(
                      color: const Color(0xFF3F8FC1).withOpacity(0.06),

                      borderRadius: BorderRadius.circular(14.r),

                      border: Border.all(
                        color: const Color(0xFF3F8FC1).withOpacity(0.15),
                      ),
                    ),

                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          color: const Color(0xFF3F8FC1),
                          size: 20.sp,
                        ),

                        SizedBox(width: 10.w),

                        Expanded(
                          child: Text(
                            pengumuman.tempat,

                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.grey.shade800,
                              height: 1.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 12.h),

                  /// TANGGAL
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(100.r),

                      border: Border.all(color: const Color(0xFFE7EDF3)),
                    ),

                    child: Row(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16.sp,
                          color: const Color(0xFF3F8FC1),
                        ),

                        SizedBox(width: 8.w),

                        Text(
                          DateFormat('dd MMMM yyyy').format(pengumuman.tanggal),

                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF3F8FC1),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 22.h),

                  /// LABEL DESKRIPSI
                  Text(
                    'Isi Pengumuman',

                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),

                  SizedBox(height: 10.h),

                  /// DESKRIPSI
                  Container(
                    width: double.infinity,

                    padding: EdgeInsets.all(14.w),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(16.r),

                      border: Border.all(color: const Color(0xFFE7EDF3)),
                    ),

                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 250.h),

                      child: SingleChildScrollView(
                        child: Text(
                          pengumuman.deskripsi ?? 'Tidak ada deskripsi',

                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.grey.shade800,
                            height: 1.7,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  /// BUTTON
                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,

                        backgroundColor: const Color(0xFF3F8FC1),

                        foregroundColor: Colors.white,

                        padding: EdgeInsets.symmetric(vertical: 14.h),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),

                      onPressed: () => Navigator.pop(context),

                      child: Text(
                        'Tutup',

                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow({required IconData icon, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16.w, color: Colors.grey),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(text, style: TextStyle(fontSize: 12.sp)),
        ),
      ],
    );
  }
}
