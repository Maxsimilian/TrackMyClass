import 'package:flutter/material.dart';
import 'package:track_my_class/attendance/attendance_gloabelclass/attendance_color.dart';
import 'package:track_my_class/attendance/attendance_gloabelclass/attendance_fontstyle.dart';
import 'package:track_my_class/attendance/attendance_pages/attendance_dashboard/attendance_dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:convert'; // For utf8
import 'package:crypto/crypto.dart'; // For sha256 hashing algorithm

class AttendanceLogin extends StatefulWidget {
  const AttendanceLogin({Key? key}) : super(key: key);

  @override
  State<AttendanceLogin> createState() => _AttendanceLoginState();
}

class _AttendanceLoginState extends State<AttendanceLogin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscureText = true;
  bool _isLoading = false;

  final Map<String, String> users = {
    'zlac425@live.rhul.ac.uk':
        'fb209eb9c5b0b21b005151b073c61e0ee5c8d5156ea39a979e4e3e58fd375d7b',
  };

  void _togglePasswordStatus() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  String hashPassword(String password) {
    // Hash the password using SHA-256 and convert to hex string
    return sha256.convert(utf8.encode(password)).toString();
  }

  Future<void> _login() async {
    String email = emailController.text.trim().toLowerCase();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar("Email and password cannot be empty");
      return;
    }
    if (!email.endsWith("@live.rhul.ac.uk")) {
      _showSnackBar("Please enter a valid RHUL email address");
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));

    // Hash the user’s entered password:
    final hashedInput = hashPassword(password);

    // Compare hashed input with what's stored in the map:
    if (users[email] == hashedInput) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (context, animation, secondaryAnimation) {
            return FadeTransition(
              opacity: animation,
              child: AttendanceDashboard("0"),
            );
          },
        ),
      );
    } else {
      _showSnackBar("Invalid email or password");
    }

    setState(() => _isLoading = false);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(message, style: const TextStyle(color: Colors.white))),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: width / 18, vertical: height / 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            // Animated Welcome Text
            Text("Welcome Back 👋", style: lmedium.copyWith(fontSize: 28))
                .animate()
                .fadeIn(duration: 600.ms)
                .slideY(begin: -0.5, duration: 800.ms), // Smooth slide-in

            const SizedBox(height: 5),
            Text("Login with your RHUL email to continue.",
                    style: lregular.copyWith(
                        fontSize: 14, color: AttendanceColor.textgray))
                .animate()
                .fadeIn(duration: 700.ms),

            const SizedBox(height: 30),

            // Email Input Field
            Text("Email", style: lmedium.copyWith(fontSize: 14))
                .animate()
                .fadeIn(duration: 700.ms)
                .slideX(
                    begin: -0.5, duration: 800.ms), // Smooth slide from left

            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: "Enter your RHUL email",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ).animate().fadeIn(duration: 800.ms),

            const SizedBox(height: 20),

            // Password Input Field
            Text("Password", style: lmedium.copyWith(fontSize: 14))
                .animate()
                .fadeIn(duration: 700.ms)
                .slideX(begin: -0.5, duration: 800.ms),

            TextField(
              controller: passwordController,
              obscureText: _obscureText,
              decoration: InputDecoration(
                hintText: "Enter your password",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                suffixIcon: IconButton(
                  icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility),
                  onPressed: _togglePasswordStatus,
                ),
              ),
            ).animate().fadeIn(duration: 800.ms),

            const SizedBox(height: 20),

            // Forgot Password (Shake effect if clicked)
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  _showSnackBar("Contact RHUL IT to reset your password.");
                },
                child: Text("Forgot Password?",
                        style: lregular.copyWith(
                            fontSize: 14, color: AttendanceColor.primary))
                    .animate()
                    .fadeIn(duration: 900.ms),
              ),
            ),

            const SizedBox(height: 20),

            // Login Button with Loading Effect
            InkWell(
              onTap: _isLoading ? null : _login,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: _isLoading
                      ? AttendanceColor.grey
                      : AttendanceColor.primary,
                ),
                child: Center(
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text("Login",
                          style: lmedium.copyWith(
                              fontSize: 16, color: Colors.white)),
                ),
              ),
            )
                .animate()
                .fadeIn(duration: 700.ms)
                .shake(duration: 500.ms), // Slight shake effect for interaction

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
