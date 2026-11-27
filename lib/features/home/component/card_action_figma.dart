import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CardActionFigma extends StatefulWidget {
  final String title;
  final String description;
  final String imageAsset;
  final VoidCallback onTap;

  const CardActionFigma({
    super.key,
    required this.title,
    required this.description,
    required this.imageAsset,
    required this.onTap,
  });

  @override
  State<CardActionFigma> createState() => _CardActionFigmaState();
}

class _CardActionFigmaState extends State<CardActionFigma> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${widget.title}, ${widget.description}',
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          transform: _isPressed
              ? Matrix4.translationValues(0, 2, 0)
              : Matrix4.identity(),
          constraints: BoxConstraints(minHeight: 112.h),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: const Color(0xFFD6E6F5), width: 1.w),
            boxShadow: [
              BoxShadow(
                color: const Color(0x1A0A4F8A), // rgba(10, 79, 138, 0.10)
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ikon 43x43
              ExcludeSemantics(
                child: Image.asset(
                  widget.imageAsset,
                  width: 43.w,
                  height: 43.w,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(width: 10.w),

              // Kolom Teks + Tombol Panah kanan bawah
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontFamily: 'DMSans',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0B3D73),
                            height: 1.3,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          widget.description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'DMSans',
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF5B7287),
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),

                    // Tombol Panah kecil 20x20 di kanan bawah
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ExcludeSemantics(
                        child: Container(
                          width: 20.w,
                          height: 20.w,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF3FC),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            'assets/icons/ic_chevron_right_blue.svg',
                            width: 12.w,
                            height: 12.w,
                          ),
                        ),
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
