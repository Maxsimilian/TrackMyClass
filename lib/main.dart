import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:track_my_class/attendance/attendance_pages/attendance_authentication/attendance_splash.dart';
import 'package:track_my_class/attendance/attendance_theme/attendance_theme.dart';
import 'package:track_my_class/attendance/attendance_theme/attendance_themecontroller.dart';
import 'package:track_my_class/attendance/attendance_translation/stringtranslation.dart';

// Entry point of the application
Future<void> main() async {
  // Ensures Flutter bindings are initialised before running the app
  WidgetsFlutterBinding.ensureInitialized();

  // Restricts the app's orientation to portrait mode only
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

  // Starts the application
  runApp(const MyApp());
}

// Root widget of the application
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Controller to manage theme data using GetX
  final themedata = Get.put(AttendanceThemecontroler());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false, // Disables the debug banner
      // Dynamically sets the theme based on user preference
      theme: themedata.isdark
          ? AttendanceMythemes.darkTheme
          : AttendanceMythemes.lightTheme,
      fallbackLocale: const Locale('en', 'US'),
      // Provides translation strings for the application
      translations: AttendanceApptranslation(),
      locale: const Locale('en', 'US'),
      // Sets the splash screen as the initial screen
      home: const AttendanceSplash(),
    );
  }
}
