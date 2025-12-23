import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:track_my_class/attendance/attendance_gloabelclass/attendance_color.dart';
import 'package:track_my_class/attendance/attendance_gloabelclass/attendance_fontstyle.dart';
import 'package:track_my_class/attendance/attendance_pages/attendance_home/attendance_home.dart';
import 'package:track_my_class/attendance/attendance_pages/attendance_profile/attendance_profile.dart';
import 'package:track_my_class/attendance/attendance_theme/attendance_themecontroller.dart';
import 'package:track_my_class/attendance/attendance_gloabelclass/attendance_icons.dart';

/// The main dashboard view, managing navigation between Home and Profile pages.
// ignore: must_be_immutable
class AttendanceDashboard extends StatefulWidget {
  String? index;

  AttendanceDashboard(this.index, {super.key});

  @override
  State<AttendanceDashboard> createState() => _AttendanceDashboardState();
}

class _AttendanceDashboardState extends State<AttendanceDashboard> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themedata = Get.put(AttendanceThemecontroler());

  PageController pageController = PageController();
  int _selectedItemIndex = 0; // Default to Home tab

  final List<Widget> _pages = const [
    AttendanceHome(),
    AttendanceProfile(),
  ];

  @override
  void initState() {
    super.initState();
    init();
  }

// Placeholder for initial logic
  void init() async {}

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  /// Displays a confirmation dialog when the user attempts to exit the app.
  Future<bool> onbackpressed() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
          child: Text(
            "HR Attendance".tr,
            textAlign: TextAlign.center,
            style: lbold.copyWith(fontSize: 16),
          ),
        ),
        content: Text(
          "Are_you_sure_to_exit_from_this_app".tr,
          style: lregular.copyWith(fontSize: 12),
        ),
        actionsAlignment: MainAxisAlignment.end,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AttendanceColor.primary),
            onPressed: () {
              SystemNavigator.pop();
            },
            child: Text(
              "Yes",
              style: lregular.copyWith(color: AttendanceColor.white),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AttendanceColor.primary),
            child: Text(
              "No",
              style: lregular.copyWith(color: AttendanceColor.white),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the bottom navigation bar for switching between pages.
  Widget _bottomTabBar() {
    return BottomNavigationBar(
      currentIndex: _selectedItemIndex,
      onTap: _onTap,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      backgroundColor:
          themedata.isdark ? AttendanceColor.black : AttendanceColor.bgcolor,
      selectedItemColor: AttendanceColor.primary, // Highlight color
      unselectedItemColor: themedata.isdark
          ? AttendanceColor.white
          : AttendanceColor.textgray, // Default color for inactive items
      showUnselectedLabels: false,
      showSelectedLabels: false,
      items: <BottomNavigationBarItem>[
        // Home Icon
        BottomNavigationBarItem(
          icon: Image.asset(
            AttendancePngimage.home,
            height: height / 36,
            color: _selectedItemIndex == 0
                ? AttendanceColor.primary // Active color
                : (themedata.isdark
                    ? AttendanceColor.white
                    : AttendanceColor.textgray), // Inactive color
          ),
          label: '',
        ),
        // Profile Icon
        BottomNavigationBarItem(
          icon: Image.asset(
            AttendancePngimage.profile,
            height: height / 36,
            color: _selectedItemIndex == 1
                ? AttendanceColor.primary // Active color
                : (themedata.isdark
                    ? AttendanceColor.white
                    : AttendanceColor.textgray), // Inactive color
          ),
          label: '',
        ),
      ],
    );
  }

  /// Updates the selected page index based on user tab selection.
  void _onTap(int index) {
    setState(() {
      _selectedItemIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: onbackpressed,
      child: GetBuilder<AttendanceThemecontroler>(builder: (controller) {
        return Scaffold(
          bottomNavigationBar: _bottomTabBar(),
          body: _pages[_selectedItemIndex],
        );
      }),
    );
  }
}
