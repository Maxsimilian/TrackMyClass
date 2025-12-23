import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

class ClassModel {
  final String courseName;
  final String time; // Raw time string (e.g., "11:00 AM - 12:00 PM")
  String status; // N/A, Attended, or Not Attended
  final bool isOnline; // Indicates if the class is online
  final List<Map<String, double>> locations; // Multiple valid GPS locations
  final List<String>? wifiBSSIDs; // List of WiFi BSSIDs for the location
  final DateTime? startTime; // Parsed start time with today's date
  final DateTime? endTime; // Parsed end time with today's date
  DateTime? attendedAt;

  ClassModel({
    required this.courseName,
    required this.time,
    this.status = "N/A", // Default status
    this.isOnline = false, // Default to offline
    required this.locations, // List of valid GPS locations
    this.wifiBSSIDs, // List of WiFi BSSIDs
    this.attendedAt,
  })  : startTime = _parseStartTime(time),
        endTime = _parseEndTime(time) {
    if (!_validateTimeFormat(time)) {
      throw ArgumentError(
          "Invalid time format. Expected format: 'hh:mm a - hh:mm a'");
    }
    _validateLocationData();
  }

  // Helper function to parse the start time and attach today's date
  static DateTime? _parseStartTime(String time) {
    try {
      final today = DateTime.now();
      final parts = time.split(" - ");
      if (parts.isNotEmpty) {
        final parsedTime = DateFormat('hh:mm a').parse(parts[0]);
        return DateTime(today.year, today.month, today.day, parsedTime.hour,
            parsedTime.minute);
      }
    } catch (e) {
      debugPrint("Error parsing start time: $e");
    }
    return null;
  }

  // Helper function to parse the end time and attach today's date
  static DateTime? _parseEndTime(String time) {
    try {
      final today = DateTime.now();
      final parts = time.split(" - ");
      if (parts.length > 1) {
        final parsedTime = DateFormat('hh:mm a').parse(parts[1]);
        return DateTime(today.year, today.month, today.day, parsedTime.hour,
            parsedTime.minute);
      }
    } catch (e) {
      debugPrint("Error parsing end time: $e");
    }
    return null;
  }

  // Helper function to validate the time string format
  static bool _validateTimeFormat(String time) {
    final regex = RegExp(r'^\d{1,2}:\d{2} (AM|PM) - \d{1,2}:\d{2} (AM|PM)$');
    return regex.hasMatch(time);
  }

  // Improved validation for location data
  void _validateLocationData() {
    if (!isOnline) {
      if (locations.isEmpty) {
        debugPrint("Warning: Offline class missing GPS coordinates.");
      }
      if (wifiBSSIDs == null || wifiBSSIDs!.isEmpty) {
        debugPrint("Warning: Offline class missing WiFi BSSIDs.");
      }
    }
  }
}
