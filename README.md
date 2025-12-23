# Final Year Project  

# 📚 **TrackMyClass - Smart Attendance Management App**  

![Flutter](https://img.shields.io/badge/Flutter-v3.10-blue) ![Dart](https://img.shields.io/badge/Dart-v2.19-blue) ![License](https://img.shields.io/badge/license-MIT-green)  

---

## 📖 **Overview**  

**TrackMyClass** is a smart attendance management app that automates student attendance registration using **GPS** and **WiFi-based location services**. The app leverages Flutter’s **Geolocator** and **Network_Info_Plus** packages to verify students' physical presence and mark attendance in real time. Designed with a clean, intuitive interface, **TrackMyClass** reduces manual tracking errors and enhances student engagement through instant notifications.  

---

## 🚀 **Features**  

- ✅ **Automatic Attendance Registration:** Combines GPS and WiFi validation.  
- ✅ **Real-Time Notifications:** Instant updates after successful attendance registration.  
- ✅ **Dynamic Class Scheduling:** Automatically fetches relevant classes based on term schedules.  
- ✅ **Theme Management:** Supports light/dark themes using Flutter’s Material Design principles.  
- ✅ **Dark Mode**: Improves UI experience based on user preference.
- ✅ **Secure & Private:** Follows best practices in data handling and permissions management.  

---

## 🛠️ **Tech Stack**  

- **Framework:** Flutter (Dart)  
- **Core Libraries:**  
  - `Geolocator` - GPS tracking  
  - `NetworkInfoPlus` - WiFi BSSID detection  
  - `GetX` - State management  
  - `intl` - Date/time formatting  

---

## 📂 **Project Structure**  

```plaintext
PROJECT/
│
├── TrackMyClass/
│   ├── lib/
│   │   ├── main.dart                          # App entry point
│   │   ├── attendance/
│   │   │   ├── attendance_globelclass/        # Global UI settings and styles
│   │   │   │   ├── attendance_color.dart      # Theme colours
│   │   │   │   ├── attendance_fontstyle.dart  # Font styles
│   │   │   │   ├── attendance_icons.dart      # Custom icons definitions
│   │   │   │   └── attendance_presname.dart   # Preset names and constants
│   │   │   ├── attendance_translation/        # Language and string translations
│   │   │   │   └── stringtranslation.dart     # String translation mappings
│   │   │   ├── attendance_theme/              # Theme definitions
│   │   │   │   └── attendance_theme.dart      # Dark Mode theme setup
│   │   │   │   └── attendance_themecontroller.dart  #Handles theme, phone number, and profile image settings.
│   │   │   ├── attendance_page/               # Main app screens
│   │   │   │   ├── attendance_authentication/  
│   │   │   │   │   ├── attendance_login.dart        # Login screen
│   │   │   │   │   └── attendance_splash.dart       # Splash screen
│   │   │   │   ├── attendance_dashboard/      
│   │   │   │   │   └── attendance_dashboard.dart    # Main dashboard screen
│   │   │   │   ├── attendance_home/
│   │   │   │   │   ├── attendance_home.dart         # Main attendance screen
│   │   │   │   │   ├── attendance_notification.dart # Notifications system
│   │   │   │   │   ├── class_model.dart             # Class data model
│   │   │   │   │   └── term_classes.dart            # Term data structure  
│   │   │   │   └── attendance_profile/
│   │   │   │       ├── attendance_cms.dart          # Terms & Conditions and Privacy Policy screens
│   │   │   │       ├── attendance_editprofile.dart  # Edit profile screen
│   │   │   │       ├── attendance_myprofile.dart    # User profile info
│   │   │   │       └── attendance_profile.dart      # Profile screen
│   │
│   ├── pubspec.yaml                          # App dependencies
│
├── README.md                                 # Project documentation
├── .gitignore                                # Git ignored files
```

---

## 📦 **Installation Instructions**

Below are two straightforward options for running the **TrackMyClass** Android application. Choose whichever method best suits your workflow.

---

### 1. Flutter SDK Method

If you plan to run the project from source or make modifications, you'll need to set up the Flutter SDK along with Visual Studio Code (VS Code) for development.

> **Important:** Make sure you have **JDK (Java Development Kit) version 17** installed on your system, as it is required for building and running the app.

   You can download JDK 17 from the official Oracle archive:  
   [https://www.oracle.com/java/technologies/javase/jdk17-archive-downloads.html](https://www.oracle.com/java/technologies/javase/jdk17-archive-downloads.html)

1. **Install Flutter SDK and VSCode:**  
   - Download and install Flutter from the official site: [Flutter Install Guide](https://flutter.dev/docs/get-started/install).  
   - Download and install [VSCode](https://code.visualstudio.com/).  
   - Open VSCode and install **Dart** and **Flutter** extensions from the Extensions tab.

2. **Open the Project in VSCode:**  
   - Launch **VSCode**.  
   - Click **File** from the top menu and select **Open Folder...**.  
   - Navigate to the project folder:  
     ```
     .../track_my_class
     ```
   - Click **Select Folder**.

3. **Get Dependencies & Run the app:**  
   > If platform-specific folders like `windows/`, `ios/`, or `web/` are missing, you can easily regenerate them (optionally).  

   **Steps:**  
   1. **Open the Terminal** in VSCode.  
   2. **Navigate to the Project Folder (if not already there):**  
      ```bash
      cd .../track_my_class
      ```
   3. **Install the required packages:**  
      ```bash
      flutter pub get
      ```
   4. **Recreate Platform Folders (Optionally):**  
      ```bash
      flutter create .
      ```
   5. **Run the App:** Launch the application:  
      ```bash
      flutter run
      ```
      > **Ensure that either an Android emulator (via Android Studio) is running, or a physical device with Developer Mode enabled is connected via USB.**

---

### 2. Docker Method

If you prefer (or need) to generate the `.apk` from a Docker container, ensure Docker is installed on your system. Then follow these steps:

#### Build or Pull the Docker Image

You can build your own image using the `Dockerfile` provided in the `track_my_class`. Firstly, run **Docker** on your system.

#### Navigate to the project folder 

 **Open the Project in VSCode or other IDE:**  
   - Launch **VSCode**.  
   - Click **File** from the top menu and select **Open Folder...**.  
   - Navigate to the project folder:  
      ```
      .../track_my_class
      ```
   - Click **Select Folder**.

**Navigate to the Project Folder from the IDE terminal (if not already there):**  
   ```bash
   cd .../track_my_class
   ```

#### Build the Docker image
```powershell
docker build -t trackmyclass-app .
```

#### Run the Container (without auto-removal)
```powershell
docker run --name trackmyclass-builder trackmyclass-app
```

#### Copy the APK to Your Host Machine
```powershell
docker cp trackmyclass-builder:/app/build/app/outputs/flutter-apk/app-release.apk .
```

#### Run the apk on an Android Device or Emulator

- **Physical Device**:  
  Transfer the APK to your Android phone. Enable **"Install from unknown sources"** in your device settings, then install and run the app.

- **Android Emulator**:  
  Use Android Studio to create or launch an emulator. Then install the APK using one of the following methods:
  - Drag-and-drop the APK into the emulator window.
  - Use `adb install` from the terminal.

#### (Optional) Remove the Container
```powershell
docker rm trackmyclass-builder
```

---

# 💻 **Usage Instructions**  

## 📍 Grant Permissions  
- Allow **GPS** and **WiFi** access for accurate attendance validation.  

## 🗓️ View Dashboard  
- The app displays **today’s scheduled classes** after a successful login.  

## ✅ Mark Attendance  
- **Attendance is marked automatically** when **GPS** and **WiFi checks** pass predefined thresholds.  

## 🔔 Receive Notifications  
- **Instant notifications** confirm successful **attendance registration** and important updates.  

---

# 📊 **Testing & Development**  

## 🧪 Manual Testing  
- Conducted on **Android devices** and **emulators** to ensure functionality and reliability.  

## ✅ Core Tests  
- **GPS and WiFi Validation:** Ensures accurate location-based attendance marking.  
- **Real-Time Notifications:** Confirms attendance registration through instant alerts.  
- **Performance Stability:** Evaluates app responsiveness under different **network conditions**.  

## 🎯 Test Scenarios  
- **Valid and Invalid GPS/WiFi Combinations:** Tested for correct and incorrect location data inputs.  
- **System Performance:** Verified across **multiple Android versions** and **various screen sizes** to ensure compatibility.  

---

# 📜 **License**  

This project was developed as a **Final Year Project (FYP)** for **Royal Holloway, University of London**. It is now open-source and available under the **MIT License**.  

---

# 📧 **Contact**  

**Project Author:** Maxsimilian Amalathas  
**Email:** [gyumiho@protonmail.com](mailto:gyumiho@protonmail.com)
