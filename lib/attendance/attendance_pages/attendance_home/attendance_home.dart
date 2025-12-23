import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // For DateFormat
import 'attendance_notification.dart'; // Import the notification screen
import 'package:track_my_class/attendance/attendance_gloabelclass/attendance_color.dart';
import 'package:track_my_class/attendance/attendance_gloabelclass/attendance_fontstyle.dart';
import 'class_model.dart';
import 'term_classes.dart'; // Import term data
import 'package:track_my_class/attendance/attendance_theme/attendance_themecontroller.dart';
import 'package:geolocator/geolocator.dart'; // For GPS functionality
import 'package:network_info_plus/network_info_plus.dart';
import 'dart:async'; // For Timer

// Shared list to store notifications
List<Map<String, String>> notifications = [];

class AttendanceHome extends StatefulWidget {
  const AttendanceHome({super.key});

  @override
  State<AttendanceHome> createState() => _AttendanceHomeState();
}

class _AttendanceHomeState extends State<AttendanceHome> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;

  final AttendanceThemecontroler themedata =
      Get.put(AttendanceThemecontroler());
  final NetworkInfo info = NetworkInfo();
  late TermData currentTerm;
  Timer? attendanceTimer;

  @override
  void initState() {
    super.initState();
    _setCurrentTerm();
    _scheduleNextCheck();
  }

  @override
  void dispose() {
    attendanceTimer?.cancel();
    super.dispose();
  }

  // Function to add a notification
  void addNotification(String title, String description) {
    notifications.add({
      'title': title,
      'description': description,
      'time': DateFormat('MMM d, yyyy, hh:mm a').format(DateTime.now()),
    });
  }

  // Determine the current term based on today's date
  void _setCurrentTerm() {
    DateTime today = DateTime.now();
    if (today.isAfter(DateTime(2024, 9, 23)) &&
        today.isBefore(DateTime(2024, 12, 13))) {
      currentTerm = autumnTerm;
    } else if (today.isAfter(DateTime(2025, 1, 13)) &&
        today.isBefore(DateTime(2025, 4, 4))) {
      currentTerm = springTerm;
    } else if (today.isAfter(DateTime(2025, 5, 5)) &&
        today.isBefore(DateTime(2025, 6, 13))) {
      currentTerm = summerTerm;
    } else {
      currentTerm = noActiveTerm;
    }
  }

  // Fetch the current GPS position
  Future<Position> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are denied.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    debugPrint(
        "Current GPS Position: ${position.latitude}, ${position.longitude}");
    return position;
  }

  Future<String?> getCurrentWifiBSSID() async {
    try {
      final String? bssid = await info.getWifiBSSID();
      debugPrint("Connected WiFi BSSID: $bssid");
      return bssid;
    } catch (e) {
      debugPrint("Error fetching WiFi BSSID: $e");
      return null;
    }
  }

  // Check if the user is in the correct location
  bool isInLocation(
      Position position, String? wifiBSSID, ClassModel classItem) {
    const double threshold = 50.0; // 50 meters radius

    bool inGpsLocation = classItem.locations.any((loc) {
      double distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        loc["latitude"]!,
        loc["longitude"]!,
      );
      return distance <= threshold;
    });

    bool inWifiLocation = classItem.wifiBSSIDs != null &&
        wifiBSSID != null &&
        classItem.wifiBSSIDs!.contains(wifiBSSID);

    return inGpsLocation && inWifiLocation;
  }

  // Check if the current time falls within the class time
  bool isClassTimeValid(ClassModel classItem) {
    DateTime now = DateTime.now();
    bool isValid = classItem.startTime != null &&
        classItem.endTime != null &&
        now.isAfter(classItem.startTime!) &&
        now.isBefore(classItem.endTime!);
    return isValid;
  }

  // Schedule the next attendance check
  void _scheduleNextCheck() {
    DateTime now = DateTime.now();
    List<ClassModel> todaysClasses = currentTerm.getClassesForDay(now);

    // Check for ongoing classes
    for (final classItem in todaysClasses) {
      if (isClassTimeValid(classItem)) {
        _checkAndMarkAttendance();
        return; // Immediate check for ongoing class
      }
    }

    // Schedule based on the next upcoming class
    for (final classItem in todaysClasses) {
      if (classItem.startTime != null && now.isBefore(classItem.startTime!)) {
        Duration diff = classItem.startTime!.difference(now);
        attendanceTimer?.cancel();
        attendanceTimer = Timer(diff, _checkAndMarkAttendance);
        return;
      }
    }

    // If no upcoming classes, fallback to a large interval
    attendanceTimer?.cancel();
    attendanceTimer = Timer(const Duration(hours: 1), _checkAndMarkAttendance);
  }

  Future<void> _checkAndMarkAttendance() async {
    try {
      Position position = await getCurrentPosition();
      String? wifiBSSID = await getCurrentWifiBSSID();

      setState(() {
        List<ClassModel> todaysClasses =
            currentTerm.getClassesForDay(DateTime.now());
        for (final classItem in todaysClasses) {
          if (!classItem.isOnline &&
              classItem.status == "N/A" &&
              isClassTimeValid(classItem) &&
              isInLocation(position, wifiBSSID, classItem)) {
            // Mark attendance and store timestamp
            classItem.status = "Attended";
            classItem.attendedAt = DateTime.now();

            addNotification(
              "Attendance Marked",
              "You have successfully attended ${classItem.courseName}.",
            );

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    "Attendance for ${classItem.courseName} has been marked successfully!"),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );

            // After 5 seconds, rebuild so `getClassesForDay()`
            // will exclude the class if the time is up.
            Future.delayed(const Duration(seconds: 3), () {
              if (mounted) {
                setState(() {});
              }
            });
          }
        }
      });

      _scheduleNextCheck();
    } catch (e) {
      debugPrint("Error during attendance check: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    DateTime today = DateTime.now();
    List<ClassModel> todaysClasses = currentTerm.getClassesForDay(today);

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            themedata.isdark ? AttendanceColor.black : AttendanceColor.bgcolor,
        toolbarHeight: height / 10,
        elevation: 0,
        leadingWidth: width / 1,
        leading: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width / 36, vertical: height / 56),
          child: Row(
            children: [
              Obx(() {
                final image = themedata.profileImage.value;
                return CircleAvatar(
                  radius: 25,
                  backgroundImage: image != null && image.existsSync()
                      ? FileImage(image)
                      : AssetImage(themedata.defaultProfileImagePath)
                          as ImageProvider,
                );
              }),
              SizedBox(width: width / 36),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Maxsimilian Amalathas".tr,
                    style: lbold.copyWith(
                        fontSize: 20,
                        color: themedata.isdark
                            ? AttendanceColor.white
                            : AttendanceColor.black),
                  ),
                  Text(
                    "Student".tr,
                    style: lregular.copyWith(
                        fontSize: 14,
                        color: themedata.isdark
                            ? AttendanceColor.white
                            : AttendanceColor.black),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width / 36),
            child: IconButton(
              icon: Icon(Icons.notifications,
                  color: AttendanceColor.primary, size: height / 36),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AttendanceNotification(
                      notifications: notifications,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width / 36, vertical: height / 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Today's Attendance".tr,
                  style: lbold.copyWith(fontSize: 24),
                ),
              ),
              SizedBox(height: height / 80),
              Center(
                child: Text(
                  DateFormat('EEEE, MMMM d, yyyy').format(today),
                  style: lregular.copyWith(
                      fontSize: 16, color: AttendanceColor.textgray),
                ),
              ),
              SizedBox(height: height / 36),
              todaysClasses.isEmpty
                  ? Center(
                      child: Text(
                        "No Classes Today".tr,
                        style: lsemiBold.copyWith(fontSize: 16),
                      ),
                    )
                  : GridView.builder(
                      itemCount: todaysClasses.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: height / 36,
                        crossAxisSpacing: width / 36,
                        childAspectRatio: (width / 2.4) / (height / 5.5),
                      ),
                      itemBuilder: (context, index) {
                        final classItem = todaysClasses[index];
                        return Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: width / 36, vertical: height / 56),
                          decoration: BoxDecoration(
                            color: themedata.isdark
                                ? AttendanceColor.lightblack
                                : AttendanceColor.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            border: Border.all(
                              color: classItem.status == "Attended"
                                  ? Colors.green
                                  : classItem.status == "Not Attended"
                                      ? Colors.red
                                      : Colors.grey,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                classItem.courseName,
                                style: lsemiBold.copyWith(fontSize: 16),
                              ),
                              SizedBox(height: height / 80),
                              Text(
                                classItem.time,
                                style: lregular.copyWith(
                                    fontSize: 14,
                                    color: AttendanceColor.textgray),
                              ),
                              const Spacer(),
                              classItem.isOnline
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Online",
                                          style: lregular.copyWith(
                                              fontSize: 14,
                                              color: AttendanceColor.textgray),
                                        ),
                                        Checkbox(
                                          value: classItem.status == "Attended",
                                          activeColor: Colors.green,
                                          onChanged: (bool? value) {
                                            if (value == true) {
                                              if (isClassTimeValid(classItem)) {
                                                setState(() {
                                                  classItem.status = "Attended";
                                                  addNotification(
                                                    "Attendance Marked",
                                                    "You have successfully attended ${classItem.courseName}.",
                                                  );
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    content: Text(
                                                      "Attendance for ${classItem.courseName} has been marked successfully!",
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    backgroundColor:
                                                        Colors.green,
                                                    duration: const Duration(
                                                        seconds: 2),
                                                  ));
                                                  Future.delayed(
                                                      const Duration(
                                                          seconds: 3), () {
                                                    if (mounted) {
                                                      setState(() {});
                                                    }
                                                  });
                                                });
                                              } else {
                                                // Display error SnackBar
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                    "Attendance for ${classItem.courseName} can only be marked during its scheduled class time.",
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  backgroundColor: Colors.red,
                                                  duration: const Duration(
                                                      seconds: 3),
                                                ));
                                              }
                                            }
                                          },
                                        ),
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        Icon(
                                          classItem.status == "Attended"
                                              ? Icons.check_circle
                                              : classItem.status ==
                                                      "Not Attended"
                                                  ? Icons.cancel
                                                  : Icons.info,
                                          color: classItem.status == "Attended"
                                              ? Colors.green
                                              : classItem.status ==
                                                      "Not Attended"
                                                  ? Colors.red
                                                  : Colors.grey,
                                          size: height / 36,
                                        ),
                                        SizedBox(width: width / 56),
                                        Text(
                                          classItem.status,
                                          style: lregular.copyWith(
                                            fontSize: 14,
                                            color:
                                                classItem.status == "Attended"
                                                    ? Colors.green
                                                    : AttendanceColor.textgray,
                                          ),
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
