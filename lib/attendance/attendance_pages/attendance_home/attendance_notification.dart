import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:track_my_class/attendance/attendance_gloabelclass/attendance_color.dart';
import 'package:track_my_class/attendance/attendance_gloabelclass/attendance_fontstyle.dart';
import 'package:track_my_class/attendance/attendance_theme/attendance_themecontroller.dart';

/// A screen that displays a list of notifications passed to it.
class AttendanceNotification extends StatefulWidget {
  final List<Map<String, String>>
      notifications; // Pass notifications dynamically

  const AttendanceNotification({
    super.key,
    required this.notifications,
  });

  @override
  State<AttendanceNotification> createState() => _AttendanceNotificationState();
}

class _AttendanceNotificationState extends State<AttendanceNotification> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themedata = Get.find<AttendanceThemecontroler>();

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
            Icons.chevron_left,
            size: height / 26,
          ),
        ),
        centerTitle: true,
        title: Text(
          "Notifications".tr,
          style: lmedium.copyWith(fontSize: 18),
        ),
      ),
      body: widget.notifications.isEmpty
          ? Center(
              child: Text(
                "No Notifications".tr,
                style: lsemiBold.copyWith(fontSize: 16),
              ),
            )
          : Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width / 36, vertical: height / 36),
              child: ListView.separated(
                itemCount: widget.notifications.length,
                itemBuilder: (context, index) {
                  final notification = widget.notifications[index];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: AttendanceColor.lightprimary,
                        child: Icon(
                          Icons.notifications_active,
                          color: AttendanceColor.primary,
                          size: height / 36,
                        ),
                      ),
                      SizedBox(width: width / 36),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notification['title'] ?? "Notification".tr,
                              style: lsemiBold.copyWith(fontSize: 14),
                            ),
                            SizedBox(height: height / 200),
                            Text(
                              notification['description'] ??
                                  "No description available".tr,
                              style: lregular.copyWith(fontSize: 12),
                            ),
                            SizedBox(height: height / 200),
                            Text(
                              notification['time'] ?? "",
                              style: lregular.copyWith(
                                fontSize: 12,
                                color: AttendanceColor.textgray,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(thickness: 1);
                },
              ),
            ),
    );
  }
}
