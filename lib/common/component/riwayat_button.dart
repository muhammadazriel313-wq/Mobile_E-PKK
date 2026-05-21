import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatusFilterCard extends StatelessWidget {
  final String selectedStatus;
  final Function(String) onStatusSelected;

  const StatusFilterCard({
    super.key,
    required this.selectedStatus,
    required this.onStatusSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 14.h,
      ),

      padding: EdgeInsets.all(6.w),

      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),

        borderRadius: BorderRadius.circular(18.r),

        border: Border.all(
          color: const Color(0xFFE7EDF3),
        ),
      ),

      child: Row(
        children: [
          Expanded(
            child: _buildStatusButton(
              label: 'Proses',
              isActive:
                  selectedStatus == 'Proses',
            ),
          ),

          SizedBox(width: 8.w),

          Expanded(
            child: _buildStatusButton(
              label: 'Revisi',
              isActive:
                  selectedStatus == 'Revisi',
            ),
          ),

          SizedBox(width: 8.w),

          Expanded(
            child: _buildStatusButton(
              label: 'Selesai',
              isActive:
                  selectedStatus == 'Selesai',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusButton({
    required String label,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () => onStatusSelected(label),

      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 220,
        ),

        padding: EdgeInsets.symmetric(
          vertical: 12.h,
        ),

        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF3F8FC1)
              : Colors.transparent,

          borderRadius:
              BorderRadius.circular(14.r),

          border: Border.all(
            color: isActive
                ? const Color(0xFF3F8FC1)
                : const Color(0xFFE1E7EE),
          ),

          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: const Color(
                      0xFF3F8FC1,
                    ).withOpacity(0.18),

                    blurRadius: 10,

                    offset: const Offset(
                      0,
                      4,
                    ),
                  ),
                ]
              : [],
        ),

        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            Icon(
              _getStatusIcon(label),

              size: 16.sp,

              color: isActive
                  ? Colors.white
                  : Colors.grey.shade600,
            ),

            SizedBox(width: 6.w),

            Flexible(
              child: Text(
                label,

                overflow: TextOverflow.ellipsis,

                style: TextStyle(
                  fontSize: 12.sp,

                  fontWeight: FontWeight.w600,

                  color: isActive
                      ? Colors.white
                      : Colors.grey.shade700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Proses':
        return Icons.schedule_rounded;

      case 'Revisi':
        return Icons.edit_note_rounded;

      case 'Selesai':
        return Icons.check_circle_rounded;

      default:
        return Icons.circle;
    }
  }
}