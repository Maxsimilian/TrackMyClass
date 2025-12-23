import 'class_model.dart';
import 'package:intl/intl.dart';

/// A data model representing a university term.
class TermData {
  final Map<String, List<ClassModel>> classesByDay;
  final DateTime startDate;
  final DateTime endDate;

  TermData({
    required this.classesByDay,
    required this.startDate,
    required this.endDate,
  });

  bool isHoliday(DateTime date) {
    return date.isBefore(startDate) || date.isAfter(endDate);
  }

  /// Retrieves the list of classes scheduled for a specific date.
  List<ClassModel> getClassesForDay(DateTime date) {
    if (isHoliday(date)) {
      return [];
    }

    // Converts the date into a full weekday name (e.g. "Tuesday")
    final String dayName = DateFormat('EEEE').format(date);

    // Retrieves classes for that specific day, or an empty list if none are found
    final List<ClassModel> classesForTheDay = classesByDay[dayName] ?? [];

    final DateTime now = DateTime.now();

    // Filters the class list to return only relevant and valid classes
    return classesForTheDay.where((classItem) {
      // Exclude classes that have already finished
      if (classItem.endTime != null && now.isAfter(classItem.endTime!)) {
        return false;
      }

      // If the class was marked as "Attended"
      if (classItem.status == "Attended") {
        // Include it only if an attendance timestamp exists
        if (classItem.attendedAt != null) {
          final diff = now.difference(classItem.attendedAt!);
          // Display the class only if it was attended within the last 3 seconds
          return diff.inSeconds <= 3;
        }
        // Exclude attended classes that don't have a timestamp
        return false;
      }

      // Include upcoming classes, not-yet-attended classes, etc.
      return true;
    }).toList();
  }
}

// University WiFi BSSID List
const List<String> wifiBSSID = [
  "d8:ec:5e:fe:ac:63",
  "00:13:10:85:fe:01",
  "34:fc:b9:fc:c2:f0",
  "34:fc:b9:fc:ba:90",
  "34:fc:b9:fc:e3:90",
  "34:fc:b9:fc:dd:10",
  "34:fc:b9:fc:cc:30",
  "34:fc:b9:fc:eb:50",
  "34:fc:b9:fc:d7:f0",
  "34:fc:b9:fc:d2:30",
  "34:fc:b9:fc:de:c0",
  "34:fc:b9:fc:dd:30",
  "34:fc:b9:fc:da:10",
  "34:fc:b9:fc:f2:c0",
  "34:fc:b9:fc:da:d0",
  "34:fc:b9:fc:f2:d0",
  "34:fc:b9:fc:df:70",
  "34:fc:b9:fc:de:d0",
  "34:fc:b9:fc:c3:e0",
  "34:fc:b9:fc:d9:b0",
  "34:fc:b9:fc:ce:b0",
  "34:fc:b9:fc:ea:90",
  "34:fc:b9:fc:cb:f0",
  "34:fc:b9:fc:ce:70",
  "34:fc:b9:fc:de:f0",
  "34:fc:b9:fc:c3:f0",
  "34:fc:b9:fc:e0:30",
  "34:fc:b9:fc:de:e0",
  "34:fc:b9:fc:df:91",
  "34:fc:b9:fc:df:71",
  "34:fc:b9:fc:c2:f1",
  "34:fc:b9:fc:d9:b2",
  "34:fc:b9:fc:f2:c1",
  "34:fc:b9:fc:ce:b1",
  "34:fc:b9:fc:dd:31",
  "34:fc:b9:fc:ce:62",
  "34:fc:b9:fc:da:d1",
  "34:fc:b9:fc:f2:d1",
  "34:fc:b9:fc:de:d1",
  "34:fc:b9:fc:c3:e1",
  "34:fc:b9:fc:ce:72",
  "34:fc:b9:fc:de:f1",
  "34:fc:b9:fc:c3:f1",
  "34:fc:b9:fc:e0:31",
  "34:fc:b9:fc:de:e1",
];

// Autumn Term Data
final TermData autumnTerm = TermData(
  startDate: DateTime(2024, 9, 23),
  endDate: DateTime(2024, 12, 13),
  classesByDay: {
    "Monday": [
      ClassModel(
        courseName: "IY3501: Security Management [Online]",
        time: "01:00 PM - 02:00 PM",
        isOnline: true,
        locations: [
          // {"latitude": 51.556221, "longitude": -0.364831}, // Home (Testing)
          {"latitude": 51.424722, "longitude": -0.563480}, // RHUL Campus
        ],
        wifiBSSIDs: wifiBSSID,
      ),
    ],
    "Tuesday": [
      ClassModel(
        courseName: "PC3001: User-centred design [Lecture]",
        time: "11:00 AM - 12:00 PM",
        locations: [
          // {"latitude": 51.556221, "longitude": -0.364831}, // Home (Testing)
          {"latitude": 51.425844, "longitude": -0.565809}, // Windsor Building
        ],
        wifiBSSIDs: wifiBSSID,
      ),
      ClassModel(
        courseName: "CS3003: IT Project Management [Lecture]",
        time: "01:00 PM - 02:00 PM",
        locations: [
          // {"latitude": 51.556221, "longitude": -0.364831}, // Home (Testing)
          {"latitude": 51.425715, "longitude": -0.561341}, // Shilling Building
        ],
        wifiBSSIDs: wifiBSSID,
      ),
    ],
    "Wednesday": [],
    "Thursday": [
      ClassModel(
        courseName: "PC3001: User-centred design [LAB]",
        time: "09:00 AM - 11:00 AM",
        locations: [
          // {"latitude": 51.556221, "longitude": -0.364831}, // Home (Testing)
          {"latitude": 51.426255, "longitude": -0.569208}, // Wetton's Annexe
        ],
        wifiBSSIDs: wifiBSSID,
      ),
      ClassModel(
        courseName: "CS3003: IT Project Management [Lecture]",
        time: "04:00 PM - 05:00 PM",
        locations: [
          // {"latitude": 51.556221, "longitude": -0.364831}, // Home (Testing)
          {"latitude": 51.427061, "longitude": -0.564763}, // Boilerhouse
        ],
        wifiBSSIDs: wifiBSSID,
      ),
    ],
    "Friday": [
      ClassModel(
        courseName: "IY3501: Security Management [Lecture]",
        time: "01:00 PM - 03:00 PM",
        locations: [
          // {"latitude": 51.556221, "longitude": -0.364831}, // Home (Testing)
          {"latitude": 51.426431, "longitude": -0.561252}, // Queen's Building
        ],
        wifiBSSIDs: wifiBSSID,
      ),
      ClassModel(
        courseName: "CS3003: IT Project Management [Lecture]",
        time: "05:00 PM - 06:00 PM",
        locations: [
          // {"latitude": 51.556221, "longitude": -0.364831}, // Home (Testing)
          {"latitude": 51.425844, "longitude": -0.565809}, // Windsor Building
        ],
        wifiBSSIDs: wifiBSSID,
      ),
    ],
    "Saturday": [],
    "Sunday": [],
  },
);

// Spring Term Data
final TermData springTerm = TermData(
  startDate: DateTime(2025, 1, 13),
  endDate: DateTime(2025, 4, 4),
  classesByDay: {
    "Monday": [
      ClassModel(
        courseName: "IY3612: Critical Infrastructure Security [Lecture]",
        time: "09:00 AM - 12:00 PM",
        locations: [
          // {"latitude": 51.556221, "longitude": -0.364831}, // Home (Testing)
          {"latitude": 51.426255, "longitude": -0.569208}, // Wetton's Annexe
        ],
        wifiBSSIDs: wifiBSSID,
      ),
      ClassModel(
        courseName: "IY5607: Malicious Software [LAB]",
        time: "05:00 PM - 06:00 PM",
        locations: [
          // {"latitude": 51.556221, "longitude": -0.364831}, // Home (Testing)
          {"latitude": 51.425952, "longitude": -0.563478}, // Bedford Building
        ],
        wifiBSSIDs: wifiBSSID,
      ),
    ],
    "Tuesday": [
      ClassModel(
        courseName: "IY3840: Malicious Software [LAB]",
        time: "04:00 PM - 06:00 PM",
        locations: [
          // {"latitude": 51.556221, "longitude": -0.364831}, // Home (Testing)
          {"latitude": 51.426322, "longitude": -0.562760}, // Bourne Building
        ],
        wifiBSSIDs: wifiBSSID,
      ),
    ],
    "Wednesday": [
      ClassModel(
        courseName: "IY3609: Digital Forensics [Lecture]",
        time: "09:00 AM - 12:00 PM",
        locations: [
          // {"latitude": 51.556221, "longitude": -0.364831}, // Home (Testing)
          {"latitude": 51.426431, "longitude": -0.561252}, // Queen's Building
        ],
        wifiBSSIDs: wifiBSSID,
      ),
      ClassModel(
        courseName: "CS3810: Project Session [Lecture]",
        time: "02:00 PM - 03:00 PM",
        locations: [
          // {"latitude": 51.556221, "longitude": -0.364831}, // Home (Testing)
          {"latitude": 51.425715, "longitude": -0.561341}, // Shilling Building
        ],
        wifiBSSIDs: wifiBSSID,
      ),
    ],
    "Thursday": [],
    "Friday": [],
    "Saturday": [],
    "Sunday": [],
  },
);

// Summer Term Data
final TermData summerTerm = TermData(
  startDate: DateTime(2025, 5, 5),
  endDate: DateTime(2025, 6, 13),
  classesByDay: {
    "Monday": [],
    "Tuesday": [],
    "Wednesday": [],
    "Thursday": [],
    "Friday": [],
    "Saturday": [],
    "Sunday": [],
  },
);

/// An empty term for when no active term is found.
final TermData noActiveTerm = TermData(
  startDate: DateTime(2025, 1, 1),
  endDate: DateTime(2100, 1, 1),
  classesByDay: {
    "Monday": [],
    "Tuesday": [],
    "Wednesday": [],
    "Thursday": [],
    "Friday": [],
    "Saturday": [],
    "Sunday": [],
  },
);
