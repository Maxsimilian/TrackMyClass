import 'package:flutter/material.dart';
import 'package:track_my_class/attendance/attendance_gloabelclass/attendance_color.dart';
import 'package:track_my_class/attendance/attendance_gloabelclass/attendance_fontstyle.dart';

/// Defines custom light and dark themes for the app.
class AttendanceMythemes {
  static final lightTheme = ThemeData(
    primaryColor: AttendanceColor.primary,
    primarySwatch: Colors.grey,
    textTheme: const TextTheme(),
    fontFamily: 'LexendMedium',
    scaffoldBackgroundColor: AttendanceColor.bgcolor,
    appBarTheme: AppBarTheme(
      iconTheme: const IconThemeData(color: AttendanceColor.black),
      centerTitle: true,
      elevation: 0,
      titleTextStyle: lmedium.copyWith(
        color: AttendanceColor.black,
        fontSize: 16,
      ),
      color: AttendanceColor.transparent,
    ),
  );

  static final darkTheme = ThemeData(
    fontFamily: 'LexendMedium',
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      iconTheme: const IconThemeData(color: AttendanceColor.white),
      centerTitle: true,
      elevation: 0,
      titleTextStyle: lmedium.copyWith(
        color: AttendanceColor.white,
        fontSize: 15,
      ),
      color: AttendanceColor.transparent,
    ),
  );
}
