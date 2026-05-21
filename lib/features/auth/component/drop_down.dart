import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:epkk_nganjuk/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class DropdownComponent extends StatelessWidget {
  final Widget? suffixIcon;
  final String hintText;
  final String randomlabel;
  final String errorKosong;
  final String svgIconPath;
  final List<String> listItem;
  final ValueChanged<String> onChanged;
  final String? selectedValue;
  final double? maxHeight;

  DropdownComponent({
    Key? key,
    this.suffixIcon,
    required this.randomlabel,
    required this.errorKosong,
    required this.listItem,
    required this.hintText,
    required this.svgIconPath,
    required this.onChanged,
    this.selectedValue,
    this.maxHeight,
  }) : super(key: key);

  final TextEditingController dropdownSearch = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TextColors.grey50,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: DropdownButtonFormField2<String>(

        /// 🔥 INI YANG BENAR DI v2
        value: listItem.contains(selectedValue) ? selectedValue : null,

        isExpanded: true,

        decoration: InputDecoration(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(
              width: 1.w,
              color: TextColors.grey300,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(
              width: 1.w,
              color: TextColors.grey300,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(
              width: 1.w,
              color: TextColors.grey300,
            ),
          ),

          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 14.h,
              horizontal: 13.w,
            ),
            child: SvgPicture.asset(
              svgIconPath,
              color: TextColors.grey500,
            ),
          ),

          suffixIcon: suffixIcon,
        ),

        hint: Text(
          hintText,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
            fontFamily: 'DMSans',
          ),
        ),

        /// 🔥 INI SUDAH BENAR (TIDAK MERAH)
        items: listItem.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade700,
              ),
            ),
          );
        }).toList(),

        validator: (value) {
          if (value == null) {
            return errorKosong;
          }
          return null;
        },

        onChanged: (value) {
          if (value != null) {
            onChanged(value);
          }
        },

        /// 🔥 SEARCH (VERSI KATING)
        dropdownSearchData: DropdownSearchData(
          searchController: dropdownSearch,

          searchInnerWidgetHeight: 50,

          searchInnerWidget: Container(
            height: 50.h,
            padding: EdgeInsets.only(
              top: 10.h,
              right: 8.w,
              left: 8.w,
            ),
            child: TextFormField(
              controller: dropdownSearch,
              decoration: InputDecoration(
                hintText: 'Cari disini...',
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 8.h,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),

          searchMatchFn: (item, searchValue) {
            return item.value!
                .toLowerCase()
                .contains(searchValue.toLowerCase());
          },
        ),

        ///  CLEAR SEARCH
        onMenuStateChange: (isOpen) {
          if (!isOpen) {
            dropdownSearch.clear();
          }
        },

        dropdownStyleData: DropdownStyleData(
          maxHeight: maxHeight ?? 300.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
    );
  }
}