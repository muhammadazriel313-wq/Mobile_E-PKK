import 'package:epkk_nganjuk/features/akun/profile_controller.dart';
import 'package:epkk_nganjuk/features/home/nav_controller.dart';
import 'package:epkk_nganjuk/features/splash/intro_splash_screen.dart';
import 'package:epkk_nganjuk/features/auth/auth_controller.dart';
import 'package:epkk_nganjuk/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


/// BACKGROUND HANDLER
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
  RemoteMessage message,
) async {
  await Firebase.initializeApp();

  print("BACKGROUND MESSAGE:");
  print(message.notification?.title);
  print(message.notification?.body);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // FIREBASE INIT
  await Firebase.initializeApp();

  // BACKGROUND NOTIFICATION
  FirebaseMessaging.onBackgroundMessage(
    firebaseMessagingBackgroundHandler,
  );

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await dotenv.load(fileName: ".env");

  await initializeDateFormatting('id_ID', null);

  // GETX CONTROLLER
  Get.put(AuthController(), permanent: true);
  Get.put(NavController(), permanent: true);
  Get.put(ProfilController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,

      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,

          title: 'E-PKK Nganjuk',

          // PERFORMANCE
          showPerformanceOverlay: false,

          // SMOOTH TRANSITION GLOBAL
          defaultTransition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 300),

          // GLOBAL THEME
          theme: ThemeData(
            useMaterial3: true,
            fontFamily: 'DMSans',

            scaffoldBackgroundColor: Colors.white,

            splashFactory: NoSplash.splashFactory,

            appBarTheme: const AppBarTheme(
              elevation: 0,
              centerTitle: true,
              backgroundColor: Colors.transparent,
            ),
          ),

          // SPLASH AWAL
          home: const IntroSplashScreen(),

          // ROUTES
          getPages: AppPages.pages,
        );
      },
    );
  }
}