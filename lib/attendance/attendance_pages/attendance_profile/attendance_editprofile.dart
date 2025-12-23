import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:track_my_class/attendance/attendance_gloabelclass/attendance_color.dart';
import 'package:track_my_class/attendance/attendance_gloabelclass/attendance_fontstyle.dart';
import 'package:track_my_class/attendance/attendance_theme/attendance_themecontroller.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

/// A screen allowing the user to edit their profile information.
class AttendanceEditprofile extends StatefulWidget {
  const AttendanceEditprofile({Key? key}) : super(key: key);

  @override
  State<AttendanceEditprofile> createState() => _AttendanceEditprofileState();
}

class _AttendanceEditprofileState extends State<AttendanceEditprofile> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;

// Theme controller for managing light/dark mode and user data
  final themedata = Get.put(AttendanceThemecontroler());

  final String firstName = "Maxsimilian";
  final String lastName = "Amalathas";
  final String email = "zlac425@live.rhul.ac.uk";
  final ImagePicker _picker = ImagePicker();

  /// Allows the user to pick an image from the camera or gallery.
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      final newImage = File(pickedFile.path);

      // Update global state only
      await themedata.updateProfileImage(newImage);

      Get.snackbar(
        "Profile Updated",
        "Profile picture has been updated successfully.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AttendanceColor.primary,
        colorText: AttendanceColor.white,
      );
    }
  }

  // Function to update phone number globally
  void _updatePhoneNumber() async {
    if (themedata.phoneNumber.value.isNotEmpty) {
      await themedata.updatePhoneNumber(
          themedata.phoneNumber.value); // Update global state

      Get.snackbar(
        "Profile Updated",
        "Phone number has been updated successfully.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AttendanceColor.primary,
        colorText: AttendanceColor.white,
      );
    } else {
      Get.snackbar(
        "Error",
        "Phone number cannot be empty.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

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
          ),
        ),
        title: Text(
          "Edit_Profile".tr,
          style: lmedium.copyWith(fontSize: 18),
        ),
      ),
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: width / 36, vertical: height / 36),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: themedata.profileImage.value != null
                        ? FileImage(themedata.profileImage.value!)
                        : AssetImage(themedata.defaultProfileImagePath)
                            as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        _showImageSourceDialog();
                      },
                      child: Container(
                        width: height / 24,
                        height: height / 24,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AttendanceColor.primary,
                          border: Border.all(
                            color: AttendanceColor.white,
                            width: 1,
                          ),
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
            SizedBox(height: height / 36),
            _buildNonEditableField("First Name", firstName),
            _buildNonEditableField("Last Name", lastName),
            _buildNonEditableField("Email Address", email),
            _buildEditableField(
              "Phone Number",
              themedata.phoneNumber.value, // Use global phone number
              onChanged: (value) {
                themedata.phoneNumber.value =
                    value; // Update global state dynamically
              },
            ),
            const Spacer(),
            InkWell(
              onTap: _updatePhoneNumber,
              child: Container(
                height: height / 15,
                width: width / 1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AttendanceColor.primary,
                ),
                child: Center(
                  child: Text(
                    "Update".tr,
                    style: lmedium.copyWith(
                      fontSize: 16,
                      color: AttendanceColor.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a read-only field used to display fixed profile information.
  Widget _buildNonEditableField(String label, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: height / 96),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AttendanceColor.primary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width / 36, vertical: height / 96),
            child: Text(
              label,
              style: lmedium.copyWith(
                fontSize: 12,
                color: AttendanceColor.primary,
              ),
            ),
          ),
          TextFormField(
            initialValue: value,
            style: lmedium.copyWith(fontSize: 14, color: Colors.grey),
            enabled: false,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: width / 36),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds an editable text field, used for updating profile values.
  Widget _buildEditableField(String label, String value,
      {required Function(String) onChanged}) {
    return Container(
      margin: EdgeInsets.only(bottom: height / 96),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AttendanceColor.primary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width / 36, vertical: height / 96),
            child: Text(
              label,
              style: lmedium.copyWith(
                fontSize: 12,
                color: AttendanceColor.primary,
              ),
            ),
          ),
          TextFormField(
            initialValue: value,
            style: lmedium.copyWith(fontSize: 14),
            onChanged: onChanged,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: width / 36),
            ),
          ),
        ],
      ),
    );
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: height / 4,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Take a Picture"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text("Choose from Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
