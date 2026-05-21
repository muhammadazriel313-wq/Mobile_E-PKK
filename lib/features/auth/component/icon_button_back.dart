import 'package:epkk_nganjuk/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class IconButtonBack extends StatelessWidget {
  final VoidCallback onTab;

  const IconButtonBack({super.key, required this.onTab});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: TextColors.grey50,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            strokeAlign: 1,
            color: TextColors.grey200,
          )),
      child: IconButton(
        onPressed: onTab,
        icon: Icon(
          Icons.arrow_back_rounded,
          color: TextColors.grey700,
        ),
      ),
    );
  }
}
