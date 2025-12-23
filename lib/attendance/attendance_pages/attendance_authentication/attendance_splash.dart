import 'package:flutter/material.dart';
import 'package:track_my_class/attendance/attendance_gloabelclass/attendance_icons.dart';
import 'package:track_my_class/attendance/attendance_pages/attendance_authentication/attendance_login.dart';
import 'package:track_my_class/attendance/attendance_pages/attendance_dashboard/attendance_dashboard.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceSplash extends StatefulWidget {
  const AttendanceSplash({Key? key}) : super(key: key);

  @override
  State<AttendanceSplash> createState() => _AttendanceSplashState();
}

class _AttendanceSplashState extends State<AttendanceSplash> {
  @override
  void initState() {
    super.initState();
    requestPermissionsAndProceed(); // Call permission request function
  }

  // Request permissions and check login status
  Future<void> requestPermissionsAndProceed() async {
    if (await Permission.location.request().isGranted &&
        await Permission.locationWhenInUse.request().isGranted) {
      checkLoginStatus(); // Check login status if permissions are granted
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Location permissions are required to use this app.',
          ),
          duration: Duration(seconds: 3),
        ),
      );
      openAppSettings();
    }
  }

  // Check if user is already logged in
  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    await Future.delayed(const Duration(seconds: 2));

    if (isLoggedIn) {
      _navigateTo(AttendanceDashboard("0"));
    } else {
      _navigateTo(const AttendanceLogin());
    }
  }

  // Navigate function to simplify transitions
  void _navigateTo(Widget screen) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(opacity: animation, child: screen);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Image.asset(
          AttendancePngimage.splash1,
          height: height / 6,
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}
