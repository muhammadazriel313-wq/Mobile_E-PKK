import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'splash_screen.dart';

class IntroSplashScreen extends StatefulWidget {
  const IntroSplashScreen({super.key});

  @override
  State<IntroSplashScreen> createState() => _IntroSplashScreenState();
}

class _IntroSplashScreenState extends State<IntroSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  Timer? _navigationTimer;
  late Animation<double> scaleAnimation;
  late Animation<double> fadeAnimation;

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    scaleAnimation = Tween<double>(begin: 0, end: 18).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOutCubic),
    );

    fadeAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.7, 1, curve: Curves.easeOut),
      ),
    );

    controller.forward();

    _navigationTimer = Timer(const Duration(milliseconds: 2000), () {
      Get.off(
        () => const SplashScreen(),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 600),
      );
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: AnimatedBuilder(
        animation: controller,

        builder: (context, child) {
          return Opacity(
            opacity: fadeAnimation.value,

            child: Transform.scale(
              scale: scaleAnimation.value,

              child: Center(
                child: Container(
                  width: 120,
                  height: 120,

                  decoration: const BoxDecoration(
                    color: Color(0xFF4D8FC3),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
