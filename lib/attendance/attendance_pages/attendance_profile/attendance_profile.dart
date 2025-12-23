import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:track_my_class/attendance/attendance_gloabelclass/attendance_color.dart';
import 'package:track_my_class/attendance/attendance_gloabelclass/attendance_fontstyle.dart';
import 'package:track_my_class/attendance/attendance_gloabelclass/attendance_icons.dart';
import 'package:track_my_class/attendance/attendance_pages/attendance_profile/attendance_cms.dart';
import 'package:track_my_class/attendance/attendance_pages/attendance_profile/attendance_editprofile.dart';
import 'package:track_my_class/attendance/attendance_pages/attendance_profile/attendance_myprofile.dart';
import 'package:track_my_class/attendance/attendance_theme/attendance_themecontroller.dart';
import 'package:track_my_class/attendance/attendance_pages/attendance_authentication/attendance_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceProfile extends StatefulWidget {
  const AttendanceProfile({Key? key}) : super(key: key);

  @override
  State<AttendanceProfile> createState() => _AttendanceProfileState();
}

class _AttendanceProfileState extends State<AttendanceProfile> {
  // Variables to store screen dimensions
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  bool isdark = true;

  // Theme controller for managing app theme
  final themedata = Get.put(AttendanceThemecontroler());

  // Logout Function
  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false); // Clear login session

    // Navigate back to Login screen after logout
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AttendanceLogin()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve screen size
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width / 36, vertical: height / 36),
          child: Column(
            children: [
              SizedBox(
                height: height / 36,
              ),
              // Display the profile image with an edit icon
              Center(
                child: Stack(
                  children: [
                    // Display the profile image using the theme data
                    Obx(() {
                      final image = themedata.profileImage.value;
                      return CircleAvatar(
                        radius: 50,
                        backgroundImage: image != null && image.existsSync()
                            ? FileImage(image)
                            : AssetImage(themedata.defaultProfileImagePath)
                                as ImageProvider,
                      );
                    }),
                    // Edit icon positioned at the bottom-right of the image
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () {
                          // Navigate to the edit profile page
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return const AttendanceEditprofile();
                            },
                          ));
                        },
                        child: Container(
                          width: height / 24,
                          height: height / 24,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AttendanceColor.primary,
                            border: Border.all(
                                color: AttendanceColor.white, width: 1),
                          ),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: AttendanceColor.white,
                            size: height / 40,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height / 46,
              ),

              // Display the user's name
              Text("Maxsimilian Amalathas".tr,
                  style: lsemiBold.copyWith(
                    fontSize: 20,
                  )),
              SizedBox(
                height: height / 120,
              ),

              // Display the user's role
              Text("Student".tr,
                  style: lregular.copyWith(
                    fontSize: 14,
                  )),
              SizedBox(
                height: height / 36,
              ),

              // Button to edit the profile
              InkWell(
                splashColor: AttendanceColor.transparent,
                highlightColor: AttendanceColor.transparent,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const AttendanceEditprofile();
                    },
                  ));
                },
                child: Container(
                  height: height / 15,
                  width: width / 1,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AttendanceColor.primary),
                  child: Center(
                    child: Text("Edit_Profile".tr,
                        style: lmedium.copyWith(
                            fontSize: 16, color: AttendanceColor.white)),
                  ),
                ),
              ),
              SizedBox(
                height: height / 20,
              ),

              // Navigation to the "My Profile" page
              InkWell(
                splashColor: AttendanceColor.transparent,
                highlightColor: AttendanceColor.transparent,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const AttendanceMyprofile();
                    },
                  ));
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: themedata.isdark
                          ? AttendanceColor.lightblack
                          : AttendanceColor.lightgrey,
                      child: Image.asset(
                        AttendancePngimage.profile,
                        height: height / 36,
                        color: themedata.isdark
                            ? AttendanceColor.white
                            : AttendanceColor.black,
                      ),
                    ),
                    SizedBox(
                      width: width / 26,
                    ),
                    Text("My_Profile".tr,
                        style: lmedium.copyWith(
                          fontSize: 16,
                        )),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: height / 46,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: height / 96,
              ),
              Divider(
                  color: themedata.isdark
                      ? AttendanceColor.lightblack
                      : AttendanceColor.lightgrey),
              SizedBox(
                height: height / 96,
              ),

              // Navigation to "Terms and Conditions"
              InkWell(
                splashColor: AttendanceColor.transparent,
                highlightColor: AttendanceColor.transparent,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const AttendanceCms("Terms");
                    },
                  ));
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: themedata.isdark
                          ? AttendanceColor.lightblack
                          : AttendanceColor.lightgrey,
                      child: Image.asset(
                        AttendancePngimage.tems,
                        height: height / 36,
                        color: themedata.isdark
                            ? AttendanceColor.white
                            : AttendanceColor.black,
                      ),
                    ),
                    SizedBox(
                      width: width / 26,
                    ),
                    Text("Terms_Conditions".tr,
                        style: lmedium.copyWith(
                          fontSize: 16,
                        )),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: height / 46,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: height / 96,
              ),
              Divider(
                  color: themedata.isdark
                      ? AttendanceColor.lightblack
                      : AttendanceColor.lightgrey),
              SizedBox(
                height: height / 96,
              ),

              // Navigation to "Privacy Policy"
              InkWell(
                splashColor: AttendanceColor.transparent,
                highlightColor: AttendanceColor.transparent,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const AttendanceCms("Privacy");
                    },
                  ));
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: themedata.isdark
                          ? AttendanceColor.lightblack
                          : AttendanceColor.lightgrey,
                      child: Image.asset(
                        AttendancePngimage.privacy,
                        height: height / 36,
                        color: themedata.isdark
                            ? AttendanceColor.white
                            : AttendanceColor.black,
                      ),
                    ),
                    SizedBox(
                      width: width / 26,
                    ),
                    Text("Privacy_Policy".tr,
                        style: lmedium.copyWith(
                          fontSize: 16,
                        )),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: height / 46,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: height / 96,
              ),
              Divider(
                  color: themedata.isdark
                      ? AttendanceColor.lightblack
                      : AttendanceColor.lightgrey),
              SizedBox(
                height: height / 96,
              ),

              // Navigation to change layout settings
              InkWell(
                splashColor: AttendanceColor.transparent,
                highlightColor: AttendanceColor.transparent,
                onTap: () {
                  _showbottomsheet();
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: themedata.isdark
                          ? AttendanceColor.lightblack
                          : AttendanceColor.lightgrey,
                      child: Image.asset(
                        AttendancePngimage.swap,
                        height: height / 36,
                        color: themedata.isdark
                            ? AttendanceColor.white
                            : AttendanceColor.black,
                      ),
                    ),
                    SizedBox(
                      width: width / 26,
                    ),
                    Text("Change_layout".tr,
                        style: lmedium.copyWith(
                          fontSize: 16,
                        )),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: height / 46,
                    )
                  ],
                ),
              ),

              SizedBox(height: height / 96),
              Divider(
                  color: themedata.isdark
                      ? AttendanceColor.lightblack
                      : AttendanceColor.lightgrey),
              SizedBox(height: height / 96),
              // DarkMode
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: themedata.isdark
                        ? AttendanceColor.lightblack
                        : AttendanceColor.lightgrey,
                    child: Image.asset(
                      AttendancePngimage.darkmode,
                      height: height / 36,
                      color: themedata.isdark
                          ? AttendanceColor.white
                          : AttendanceColor.black,
                    ),
                  ),
                  SizedBox(
                    width: width / 26,
                  ),
                  Text("Dark_Mode".tr,
                      style: lmedium.copyWith(
                        fontSize: 16,
                      )),
                  const Spacer(),
                  SizedBox(
                    height: height / 36,
                    child: Switch(
                      activeColor: AttendanceColor.primary,
                      onChanged: (state) {
                        setState(() {
                          themedata.changeThem(state);
                          isdark = state;
                          themedata.update();
                        });
                      },
                      value: themedata.isdark,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height / 96,
              ),
              Divider(
                  color: themedata.isdark
                      ? AttendanceColor.lightblack
                      : AttendanceColor.lightgrey),
              SizedBox(
                height: height / 96,
              ),
              // Logout
              InkWell(
                splashColor: AttendanceColor.transparent,
                highlightColor: AttendanceColor.transparent,
                onTap: () async {
                  bool confirmLogout =
                      await onbackpressed(); // Show confirmation modal
                  if (confirmLogout) {
                    _logout(); // Only log out if confirmed
                  }
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: AttendanceColor.lightorange,
                      child: Transform.flip(
                        // Flip the icon horizontally
                        flipX: true,
                        child: Image.asset(
                          AttendancePngimage.logout,
                          height: height / 36,
                          color: AttendanceColor.orange,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width / 26,
                    ),
                    Text("Log_out".tr,
                        style: lmedium.copyWith(
                          fontSize: 16,
                        )),
                    const Spacer(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

// Displays the application layout selection modal
  _showbottomsheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              decoration: BoxDecoration(
                // color: Colors.white,
                borderRadius: BorderRadius.circular(7),
              ),
              height: height / 4,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    child: Text('selectapplicationlayout'.tr,
                        style: lsemiBold.copyWith(
                          fontSize: 14,
                        )),
                  ),
                  const Divider(),

                  // Option 1: Left-to-right layout selection
                  SizedBox(
                    height: height / 26,
                    child: InkWell(
                      highlightColor: AttendanceColor.transparent,
                      splashColor: AttendanceColor.transparent,
                      onTap: () async {
                        await Get.updateLocale(const Locale('en', 'US'));
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'ltr'.tr,
                            style: lmedium.copyWith(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),

                  // Option 2: Right-to-left layout selection
                  SizedBox(
                    height: height / 26,
                    child: InkWell(
                      highlightColor: AttendanceColor.transparent,
                      splashColor: AttendanceColor.transparent,
                      onTap: () async {
                        await Get.updateLocale(const Locale('ar', 'ab'));
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'rtl'.tr,
                            style: lmedium.copyWith(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),

                  // Option 3: Cancel and close the modal
                  SizedBox(
                    height: height / 26,
                    child: InkWell(
                      highlightColor: AttendanceColor.transparent,
                      splashColor: AttendanceColor.transparent,
                      onTap: () async {
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'cancel'.tr,
                            style: lmedium.copyWith(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }

  Future<bool> onbackpressed() async {
    return await showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          backgroundColor: themedata.isdark ? Colors.grey[900] : Colors.white,
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Warning Icon
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.redAccent,
                    size: 50,
                  ),
                  const SizedBox(height: 10),

                  // Logout Warning Text
                  Text(
                    "Are you sure you want to log out?".tr,
                    style: lsemiBold.copyWith(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),

                  // Informational text
                  Text(
                    "Logging out will require you to log in again.".tr,
                    style: lregular.copyWith(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Buttons
                  Row(
                    children: [
                      // Cancel Button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pop(false); // Dismiss the dialog
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AttendanceColor.lightgrey,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text(
                            "Cancel".tr,
                            style: lmedium.copyWith(
                                fontSize: 16, color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Logout Button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(true); // Confirm logout
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text(
                            "Log Out".tr,
                            style: lmedium.copyWith(
                                fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ) ??
        false; // Default to false if dismissed
  }
}
