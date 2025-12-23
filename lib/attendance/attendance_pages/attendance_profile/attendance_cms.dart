import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:track_my_class/attendance/attendance_gloabelclass/attendance_color.dart';
import 'package:track_my_class/attendance/attendance_gloabelclass/attendance_fontstyle.dart';
import 'package:track_my_class/attendance/attendance_theme/attendance_themecontroller.dart';

// ignore: must_be_immutable
class AttendanceCms extends StatefulWidget {
  final String? type;
  const AttendanceCms(this.type, {super.key});

  @override
  State<AttendanceCms> createState() => _AttendanceCmsState();
}

class _AttendanceCmsState extends State<AttendanceCms> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;

  final themedata = Get.put(AttendanceThemecontroler());

  // Helper getters for text colors in each mode
  Color get mainTextColor =>
      themedata.isdark ? AttendanceColor.white : AttendanceColor.textblack;
  Color get secondaryTextColor =>
      themedata.isdark ? AttendanceColor.white : AttendanceColor.textgray;
  Color get headerColor =>
      themedata.isdark ? AttendanceColor.white : AttendanceColor.primary;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor:
            themedata.isdark ? AttendanceColor.black : AttendanceColor.bgcolor,
        leading: InkWell(
          splashColor: AttendanceColor.transparent,
          highlightColor: AttendanceColor.transparent,
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            size: height / 36,
            color: mainTextColor,
          ),
        ),
        title: Text(
          widget.type == "Terms"
              ? "Terms & Conditions".tr
              : "Privacy Policy".tr,
          style: lmedium.copyWith(
            fontSize: 18,
            color: mainTextColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width / 36, vertical: height / 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // "Last update" text
              Text(
                "Last update: 25/11/2024".tr,
                style: lmedium.copyWith(
                  fontSize: 13,
                  color: secondaryTextColor,
                ),
              ),
              SizedBox(height: height / 66),
              // Intro text
              Text(
                widget.type == "Terms"
                    ? "Please read these Terms & Conditions carefully before using Track My Class (TMC), operated by Maxsimilian Amalathas."
                    : "Please read this Privacy Policy carefully to understand how your information is handled by Track My Class (TMC).",
                style: lregular.copyWith(
                  fontSize: 15,
                  color: mainTextColor,
                ),
              ),
              SizedBox(height: height / 36),

              // Section Title
              Text(
                widget.type == "Terms"
                    ? "Conditions of Use".tr
                    : "Privacy Policy".tr,
                style: lregular.copyWith(
                  fontSize: 20,
                  color: headerColor,
                ),
              ),
              SizedBox(height: height / 66),

              // Main body text
              RichText(
                text: TextSpan(
                  // This makes sure the default text color is visible in dark mode
                  style: lregular.copyWith(fontSize: 15, color: mainTextColor),
                  children: [
                    if (widget.type == "Privacy") ...[
                      const TextSpan(
                        text:
                            "Track My Class values your privacy. Here's how your data is handled:\n\n",
                      ),
                      const TextSpan(
                        text: "• Personal Information: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(
                        text:
                            "Includes name, email, student ID, and attendance records.\n\n",
                      ),
                      const TextSpan(
                        text: "• Data Security: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(
                        text:
                            "Measures are taken to ensure your data is encrypted.\n\n",
                      ),
                      const TextSpan(
                        text: "• Your Rights: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(
                        text:
                            "You can request to access or delete your data by contacting us at zlac425@live.rhul.ac.uk.\n",
                      ),
                    ] else ...[
                      const TextSpan(
                        text:
                            "Welcome to Track My Attendance. By using this app, you agree to the following:\n\n",
                      ),
                      const TextSpan(
                        text: "• Usage Agreement: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(
                        text:
                            "The app is intended for students and staff of Royal Holloway, University of London.\n\n",
                      ),
                      const TextSpan(
                        text: "• Intellectual Property: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(
                        text:
                            "All content within this app is the intellectual property of Maxsimilian Amalathas.\n\n",
                      ),
                      const TextSpan(
                        text: "• User Data and Privacy: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(
                        text:
                            "Information collected is used for academic purposes.\n\n",
                      ),
                    ]
                  ],
                ),
              ),
              SizedBox(height: height / 36),

              // Link to Privacy Policy (if we're on Terms page)
              if (widget.type == "Terms")
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AttendanceCms("Privacy"),
                      ),
                    );
                  },
                  child: Text(
                    "Privacy Policy".tr,
                    style: lregular.copyWith(
                      fontSize: 15,
                      // Underlined link that remains visible in both modes
                      color: themedata.isdark
                          ? AttendanceColor.white
                          : AttendanceColor.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
