import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:track_my_class/attendance/attendance_gloabelclass/attendance_color.dart';
import 'package:track_my_class/attendance/attendance_gloabelclass/attendance_fontstyle.dart';
import 'package:track_my_class/attendance/attendance_theme/attendance_themecontroller.dart';
import 'package:track_my_class/attendance/attendance_gloabelclass/attendance_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:flutter/services.dart' show rootBundle;

/// A profile screen that displays personal information
class AttendanceMyprofile extends StatefulWidget {
  const AttendanceMyprofile({Key? key}) : super(key: key);

  @override
  State<AttendanceMyprofile> createState() => _AttendanceMyprofileState();
}

class _AttendanceMyprofileState extends State<AttendanceMyprofile> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  int selected = 0;
  final themedata = Get.put(AttendanceThemecontroler());

  List<String> title1 = ["Personal".tr, "Documents".tr];

  List<String> doctype = [
    "Student Status Certificate",
    "Tuition Fee Invoice",
    "Candidate Number",
  ];

  // Handles reading a PDF from assets and opening it from local storage.
  Future<void> _downloadPdf(String assetPath, String fileName) async {
    try {
      final byteData = await rootBundle.load(assetPath);
      final directory = await getApplicationDocumentsDirectory();
      final filePath = "${directory.path}/$fileName.pdf";
      final file = File(filePath);
      await file.writeAsBytes(byteData.buffer.asUint8List());

      Get.snackbar(
        "Download Complete",
        "Saved to: $filePath",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AttendanceColor.primary,
        colorText: AttendanceColor.white,
      );
      await OpenFile.open(filePath);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to download or open the file.",
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
          "My_Profile".tr,
          style: lmedium.copyWith(fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width / 36, vertical: height / 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                final image = themedata.profileImage.value;
                return Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: image != null && image.existsSync()
                        ? FileImage(image)
                        : AssetImage(themedata.defaultProfileImagePath)
                            as ImageProvider,
                  ),
                );
              }),
              SizedBox(height: height / 36),

              // Personal Section
              if (selected == 0) ...[
                Text(
                  "Student_ID".tr,
                  style: lregular.copyWith(
                      fontSize: 12, color: AttendanceColor.textgray),
                ),
                Text(
                  "101029579".tr, // Example Student ID
                  style: lregular.copyWith(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: height / 96),
                const Divider(),
                SizedBox(height: height / 96),
                Text(
                  "Full_Name".tr,
                  style: lregular.copyWith(
                      fontSize: 12, color: AttendanceColor.textgray),
                ),
                Text(
                  "Maxsimilian Amalathas".tr,
                  style: lregular.copyWith(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: height / 96),
                const Divider(),
                SizedBox(height: height / 96),
                Text(
                  "Email_Address".tr,
                  style: lregular.copyWith(
                      fontSize: 12, color: AttendanceColor.textgray),
                ),
                Text(
                  "zlac425@live.rhul.ac.uk".tr,
                  style: lregular.copyWith(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: height / 96),
                const Divider(),
                SizedBox(height: height / 96),
                Text(
                  "Phone_Number".tr,
                  style: lregular.copyWith(
                      fontSize: 12, color: AttendanceColor.textgray),
                ),
                Text(
                  themedata.phoneNumber
                      .value, // Corrected to use .value for RxString
                  style: lregular.copyWith(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: height / 96),
                const Divider(),
                SizedBox(height: height / 96),
                Text(
                  "Address".tr,
                  style: lregular.copyWith(
                      fontSize: 12, color: AttendanceColor.textgray),
                ),
                Text(
                  "156, Somervell Road, Harrow, Greater London, HA2 8TS".tr,
                  style: lregular.copyWith(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: height / 96),
                const Divider(),
              ],

              // Documents Section
              if (selected == 1) ...[
                ListView.builder(
                  itemCount: doctype.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Row(
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
                            SizedBox(width: width / 26),
                            Text(
                              doctype[index],
                              style: lmedium.copyWith(fontSize: 16),
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () {
                                String assetPath;
                                switch (index) {
                                  case 0:
                                    assetPath =
                                        'assets/documents/student_status_certificate.pdf';
                                    break;
                                  case 1:
                                    assetPath =
                                        'assets/documents/tuition_fee_invoice.pdf';
                                    break;
                                  case 2:
                                    assetPath =
                                        'assets/documents/candidate_number.pdf';
                                    break;
                                  default:
                                    assetPath = '';
                                }
                                _downloadPdf(assetPath, doctype[index]);
                              },
                              child: Image.asset(
                                AttendancePngimage.document,
                                height: height / 36,
                                color: themedata.isdark
                                    ? AttendanceColor.white
                                    : AttendanceColor.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: height / 96),
                        const Divider(),
                        SizedBox(height: height / 96),
                      ],
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
