import 'package:epkk_nganjuk/common/appbar/custom_appbar.dart';
import 'package:epkk_nganjuk/common/component/card_pengumuman.dart';
import 'package:epkk_nganjuk/features/pengumuman/pengumuman_controller.dart';
import 'package:epkk_nganjuk/features/pengumuman/pengumuman_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// [CATATAN 08-10-2026] Halaman penuh RiwayatPengumumanScreen dipertahankan untuk kompatibilitas rute.
// Ikon kalender pada halaman Pengumuman kini menggunakan popup zoom (RiwayatPengumumanPopup)
// sesuai arahan revisi tampilan antarmuka.

class RiwayatPengumumanScreen extends StatefulWidget {
  const RiwayatPengumumanScreen({super.key});

  @override
  State<RiwayatPengumumanScreen> createState() => _RiwayatPengumumanScreenState();
}

class _RiwayatPengumumanScreenState extends State<RiwayatPengumumanScreen> {
  final PengumumanController controller = Get.find<PengumumanController>();

  late DateTime _selectedMonth;
  DateTime? _selectedDate;
  // [PERUBAHAN 08-10-2026] Pemilih bulan dan tahun cepat
  bool _isPickingMonthYear = false;
  late int _pickerYear;

  final Color primaryColor = const Color(0xFF3F8FC1);

  static const List<String> _namaBulan = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  static const List<String> _namaHari = [
    'Sen',
    'Sel',
    'Rab',
    'Kam',
    'Jum',
    'Sab',
    'Min',
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = DateTime(now.year, now.month, 1);
    _pickerYear = now.year;
    // Muat data pengumuman untuk bulan yang sedang dilihat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadPengumumanBulan(_selectedMonth);
    });
  }

  void _pindahBulan(int delta) {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month + delta,
        1,
      );
      _pickerYear = _selectedMonth.year;
      _selectedDate = null;
      _isPickingMonthYear = false;
    });
    controller.loadPengumumanBulan(_selectedMonth);
  }

  Map<String, List<Pengumuman>> _groupPengumumanByDate(List<Pengumuman> list) {
    final Map<String, List<Pengumuman>> map = {};
    for (final item in list) {
      final key = DateFormat('yyyy-MM-dd').format(item.tanggal);
      map.putIfAbsent(key, () => []).add(item);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBarPrimary(
        title: 'Riwayat Pengumuman',
        backgroundColor: Colors.white,
        onBack: () => Get.back(),
      ),
      body: Obx(() {
        final isLoading = controller.isMonthlyLoading.value;
        final list = controller.monthlyPengumumanList;
        final groupedMap = _groupPengumumanByDate(list);

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= KARTU KALENDER =================
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22.r),
                  border: Border.all(color: const Color(0xFFE8EDF3)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // HEADER BULAN & TAHUN
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.chevron_left_rounded,
                            size: 26.sp,
                            color: Colors.grey.shade700,
                          ),
                          onPressed: isLoading ? null : () => _pindahBulan(-1),
                        ),
                        // Judul Bulan & Tahun (Dapat diklik untuk memilih bulan dan tahun secara cepat)
                        Expanded(
                          child: Center(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10.r),
                              onTap: () {
                                setState(() {
                                  _isPickingMonthYear = !_isPickingMonthYear;
                                  _pickerYear = _selectedMonth.year;
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        '${_namaBulan[_selectedMonth.month - 1]} ${_selectedMonth.year}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 4.w),
                                    Icon(
                                      _isPickingMonthYear
                                          ? Icons.arrow_drop_up_rounded
                                          : Icons.arrow_drop_down_rounded,
                                      size: 22.sp,
                                      color: primaryColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.chevron_right_rounded,
                            size: 26.sp,
                            color: Colors.grey.shade700,
                          ),
                          onPressed: isLoading ? null : () => _pindahBulan(1),
                        ),
                      ],
                    ),

                    if (_isPickingMonthYear)
                      _buildMonthYearPicker()
                    else ...[
                      SizedBox(height: 12.h),

                      // BARIS HARI (SEN - MIN)
                      Row(
                        children: _namaHari.map((hari) {
                          return Expanded(
                            child: Center(
                              child: Text(
                                hari,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      SizedBox(height: 10.h),
                      Divider(height: 1, color: Colors.grey.shade200),
                      SizedBox(height: 10.h),

                      // GRID TANGGAL
                      if (isLoading)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 40.h),
                          child: Center(
                            child: SizedBox(
                              width: 24.w,
                              height: 24.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: primaryColor,
                              ),
                            ),
                          ),
                        )
                      else
                        _buildCalendarGrid(today, groupedMap),
                    ],
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              // ================= DAFTAR PENGUMUMAN =================
              _buildPengumumanListSection(groupedMap),
            ],
          ),
        );
      }),
    );
  }

  // [PERUBAHAN 08-10-2026] Pemilih Bulan & Tahun Cepat
  Widget _buildMonthYearPicker() {
    final currentYear = DateTime.now().year;
    final startYear = 2020;
    final endYear = currentYear + 2;
    final years = List<int>.generate(
      endYear - startYear + 1,
      (i) => startYear + i,
    );

    return Column(
      children: [
        SizedBox(height: 10.h),
        // Baris Pengatur Tahun (< [2026 ▾] >)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                Icons.chevron_left_rounded,
                size: 26.sp,
                color: Colors.grey.shade700,
              ),
              onPressed: () {
                setState(() {
                  _pickerYear--;
                });
              },
            ),
            SizedBox(width: 8.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: primaryColor.withOpacity(0.20)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: years.contains(_pickerYear) ? _pickerYear : null,
                  hint: Text(
                    '$_pickerYear',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      color: primaryColor,
                    ),
                  ),
                  icon: Icon(Icons.arrow_drop_down_rounded, color: primaryColor),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    color: primaryColor,
                  ),
                  onChanged: (newYear) {
                    if (newYear != null) {
                      setState(() {
                        _pickerYear = newYear;
                      });
                    }
                  },
                  items: years.map((y) {
                    return DropdownMenuItem<int>(
                      value: y,
                      child: Text(
                        '$y',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            IconButton(
              icon: Icon(
                Icons.chevron_right_rounded,
                size: 26.sp,
                color: Colors.grey.shade700,
              ),
              onPressed: () {
                setState(() {
                  _pickerYear++;
                });
              },
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Divider(height: 1, color: Colors.grey.shade200),
        SizedBox(height: 12.h),
        // Grid 12 Bulan (4 baris x 3 kolom)
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 12,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10.h,
            crossAxisSpacing: 10.w,
            childAspectRatio: 2.2,
          ),
          itemBuilder: (context, index) {
            final monthIndex = index + 1;
            final isSelected = (_selectedMonth.year == _pickerYear &&
                _selectedMonth.month == monthIndex);
            final isCurrentMonth = (DateTime.now().year == _pickerYear &&
                DateTime.now().month == monthIndex);

            return InkWell(
              borderRadius: BorderRadius.circular(12.r),
              onTap: () {
                setState(() {
                  _selectedMonth = DateTime(_pickerYear, monthIndex, 1);
                  _selectedDate = null;
                  _isPickingMonthYear = false;
                });
                controller.loadPengumumanBulan(_selectedMonth);
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? primaryColor
                      : (isCurrentMonth
                          ? primaryColor.withOpacity(0.08)
                          : const Color(0xFFF8FAFC)),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isSelected
                        ? primaryColor
                        : (isCurrentMonth
                            ? primaryColor
                            : const Color(0xFFE7EDF3)),
                    width: isCurrentMonth && !isSelected ? 1.5 : 1,
                  ),
                ),
                child: Text(
                  _namaBulan[index],
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: isSelected || isCurrentMonth
                        ? FontWeight.bold
                        : FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : (isCurrentMonth ? primaryColor : Colors.black87),
                  ),
                ),
              ),
            );
          },
        ),
        SizedBox(height: 12.h),
      ],
    );
  }

  Widget _buildCalendarGrid(
    DateTime today,
    Map<String, List<Pengumuman>> groupedMap,
  ) {
    final firstDayWeekday = _selectedMonth.weekday; // 1 = Senin ... 7 = Minggu
    final daysInMonth = DateTime(
      _selectedMonth.year,
      _selectedMonth.month + 1,
      0,
    ).day;

    final leadingEmptyCells = firstDayWeekday - 1;
    final totalCells = leadingEmptyCells + daysInMonth;
    final rowCount = (totalCells / 7).ceil();

    return Column(
      children: List.generate(rowCount, (rowIndex) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 3.h),
          child: Row(
            children: List.generate(7, (colIndex) {
              final cellIndex = rowIndex * 7 + colIndex;
              final dayNumber = cellIndex - leadingEmptyCells + 1;

              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return const Expanded(child: SizedBox(height: 42));
              }

              final cellDate = DateTime(
                _selectedMonth.year,
                _selectedMonth.month,
                dayNumber,
              );
              final dateKey = DateFormat('yyyy-MM-dd').format(cellDate);
              final hasAnnouncement = groupedMap.containsKey(dateKey) &&
                  groupedMap[dateKey]!.isNotEmpty;
              final isToday = (today.year == cellDate.year &&
                  today.month == cellDate.month &&
                  today.day == cellDate.day);
              final isSelected = (_selectedDate != null &&
                  _selectedDate!.year == cellDate.year &&
                  _selectedDate!.month == cellDate.month &&
                  _selectedDate!.day == cellDate.day);

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedDate = null;
                      } else {
                        _selectedDate = cellDate;
                      }
                    });
                  },
                  child: Container(
                    height: 44.h,
                    margin: EdgeInsets.symmetric(horizontal: 2.w),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? primaryColor
                          : (isToday
                              ? primaryColor.withOpacity(0.08)
                              : Colors.transparent),
                      shape: BoxShape.circle,
                      border: isToday && !isSelected
                          ? Border.all(color: primaryColor, width: 1.5)
                          : null,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // [PERUBAHAN 08-10-2026] Ikon pengumuman diperbesar menutupi angka secara pudar halus
                        if (hasAnnouncement)
                          Icon(
                            Icons.campaign_rounded,
                            size: 24.sp,
                            color: isSelected
                                ? Colors.white.withOpacity(0.28)
                                : primaryColor.withOpacity(0.18),
                          ),
                        Text(
                          '$dayNumber',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: isSelected || isToday || hasAnnouncement
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: isSelected
                                ? Colors.white
                                : (isToday
                                    ? primaryColor
                                    : Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }

  Widget _buildPengumumanListSection(
    Map<String, List<Pengumuman>> groupedMap,
  ) {
    if (_selectedDate != null) {
      final key = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      final items = groupedMap[key] ?? [];
      final dateText =
          '${_selectedDate!.day} ${_namaBulan[_selectedDate!.month - 1]} ${_selectedDate!.year}';

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Pengumuman Tanggal $dateText',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedDate = null;
                  });
                },
                child: Text(
                  'Lihat Semua',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          if (items.isEmpty)
            _buildEmptyCard('Tidak ada pengumuman pada tanggal ini')
          else
            ...items.map((item) => _buildCard(item)),
        ],
      );
    }

    // Tampilkan seluruh pengumuman pada bulan ini bila belum memilih tanggal
    final allMonthItems = controller.monthlyPengumumanList;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daftar Pengumuman (${_namaBulan[_selectedMonth.month - 1]} ${_selectedMonth.year})',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12.h),
        if (allMonthItems.isEmpty)
          _buildEmptyCard('Belum ada pengumuman pada bulan ini')
        else
          ...allMonthItems.map((item) => _buildCard(item)),
      ],
    );
  }

  Widget _buildEmptyCard(String message) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFFE8EDF3)),
      ),
      child: Center(
        child: Text(
          message,
          style: TextStyle(
            fontSize: 13.sp,
            color: Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  Widget _buildCard(Pengumuman pengumuman) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: CardPengumuman(
        title: pengumuman.judul,
        subTitle: pengumuman.tempat,
        dateText: DateFormat('dd-MM-yyyy').format(pengumuman.tanggal),
        onTab: () => _showDetailPengumuman(pengumuman),
      ),
    );
  }

  void _showDetailPengumuman(Pengumuman pengumuman) {
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
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Icon(
                          Icons.campaign_rounded,
                          color: primaryColor,
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
                  SizedBox(height: 14.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(color: primaryColor.withOpacity(0.15)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          color: primaryColor,
                          size: 20.sp,
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Text(
                            pengumuman.tempat,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
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
                          color: primaryColor,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          DateFormat('dd MMMM yyyy').format(pengumuman.tanggal),
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Text(
                    'Isi Pengumuman',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  SizedBox(height: 8.h),
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
                          pengumuman.deskripsi,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.grey.shade800,
                            height: 1.7,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: primaryColor,
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
}
