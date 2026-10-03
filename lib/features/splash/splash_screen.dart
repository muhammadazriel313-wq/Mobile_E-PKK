import 'package:epkk_nganjuk/features/auth/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  final authController = Get.put(AuthController());

  late AnimationController _controller;

  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _controller.forward();

    Future.delayed(
      const Duration(seconds: 3),
      () {
        authController.checkLoginStatus();
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFF4D8FC3),

      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: fadeAnimation,

            child: SlideTransition(
              position: slideAnimation,

              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Image.asset(
                      'assets/images/logo_pkk.png',
                      width: 200.w,
                      height: 200.w,
                      fit: BoxFit.contain,
                    ),

                  SizedBox(height: 14.h),

                  Text(
                    'PKK',
                    style: TextStyle(
                      fontSize: 34.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'DMSans',
                    ),
                  ),

                  SizedBox(height: 12.h),

                  Text(
                    'Pemberdayaan Kesejahteraan\nMasyarakat',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      height: 1.5,
                      color: Colors.white.withOpacity(0.95),
                      fontFamily: 'DMSans',
                    ),
                  ),

                  SizedBox(height: 50.h),

                  SizedBox(
                    width: 26.w,
                    height: 26.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}