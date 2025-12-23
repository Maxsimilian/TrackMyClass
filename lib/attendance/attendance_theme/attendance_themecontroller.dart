import 'package:get/get.dart';
import 'package:track_my_class/attendance/attendance_gloabelclass/attendance_prefsname.dart';
import 'package:track_my_class/attendance/attendance_theme/attendance_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';


class AttendanceThemecontroler extends GetxController {
  var isdark = false; // Observable for theme mode
  var phoneNumber = "07552537962".obs; // Observable phone number
  var profileImage = Rx<File?>(null); // Observable profile image
  final String defaultProfileImagePath =
      'assets/attendance_assets/attendance_pngimage/photo.png'; // Default image path

  @override
  void onInit() {
    super.onInit();
    _loadPreferences(); // Load saved preferences on initialization
  }

  /// Load preferences from SharedPreferences
  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Load dark mode preference
    isdark = prefs.getBool(attendanceDarkMode) ?? false;
    if (isdark) {
      Get.changeTheme(AttendanceMythemes.darkTheme);
    } else {
      Get.changeTheme(AttendanceMythemes.lightTheme);
    }

    // Load phone number
    phoneNumber.value = prefs.getString('phoneNumber') ?? "07552537962";

    // Load profile image
    final imagePath = prefs.getString('profileImage');
    if (imagePath != null && imagePath.isNotEmpty && File(imagePath).existsSync()) {
      profileImage.value = File(imagePath);
    } else {
      profileImage.value = null; // Use default image if no valid path is found
    }

    update(); // Notify listeners
  }

  /// Update dark/light theme and save the preference
  Future<void> changeThem(bool state) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isdark = state;

    prefs.setBool(attendanceDarkMode, isdark);

    if (state) {
      Get.changeTheme(AttendanceMythemes.darkTheme);
    } else {
      Get.changeTheme(AttendanceMythemes.lightTheme);
    }

    update(); // Notify listeners
  }

  /// Update phone number and save it in SharedPreferences
  Future<void> updatePhoneNumber(String newPhoneNumber) async {
    if (newPhoneNumber.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      phoneNumber.value = newPhoneNumber; // Update Rx value
      await prefs.setString('phoneNumber', newPhoneNumber); // Save to preferences
      update(); // Notify listeners
    }
  }

  /// Update profile image and save the path in SharedPreferences
  Future<void> updateProfileImage(File newImage) async {
    if (newImage.existsSync()) {
      profileImage.value = newImage; // Update Rx value
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('profileImage', newImage.path);
      update(); // Notify listeners
    }
  }
}