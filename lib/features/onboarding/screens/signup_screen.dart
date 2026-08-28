import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'onboarding_screen.dart';
import '../../../core/widgets/continue_button.dart';

import '../widgets/custom_text_field.dart';
import '../widgets/custom_checkbox.dart';
import '../widgets/social_login_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Variabel untuk menyimpan status checkbox
  bool _rememberPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              Text(
                "Join Us!",
                style: GoogleFonts.fraunces(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0C1325),
                ),
              ),
              const SizedBox(height: 8),

              Text(
                "Start planning your exciting and worry-free\nretirement!",
                style: GoogleFonts.fraunces(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF0C1325),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              const CustomTextField(
                label: "Email",
                hintText: "Input email...",
              ),
              const SizedBox(height: 16),
              const CustomTextField(
                label: "Password",
                hintText: "Input Password...",
                isPassword: true,
              ),
              const SizedBox(height: 16),
              const CustomTextField(
                label: "Confirm password",
                hintText: "Confirm password...",
                isPassword: true,
              ),
              const SizedBox(height: 16),

              // 4. Checkbox
              CustomCheckbox(
                value: _rememberPassword,
                label: "Remember password",
                onChanged: (bool? newValue) {
                  setState(() {
                    _rememberPassword = newValue ?? false;
                  });
                },
              ),
              const SizedBox(height: 32),

              // 5. Main Button
              ContinueButton(
                text: "Continue", // Typo "Countinue" pada desain telah diperbaiki
                hasArrow: false,
                onPressed: () {
                  // Logika registrasi
                },
              ),
              const SizedBox(height: 16),

              // 6. Teks Login Alternatif
              Center(
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.fraunces(
                      fontSize: 14,
                      color: const Color(0xFF0C1325),
                    ),
                    children: const [
                      TextSpan(text: "Already have an account? "),
                      TextSpan(
                        text: "Log in",
                        style: TextStyle(
                          color: Color(0xFFFF935D),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 7. Divider "OR"
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "OR",
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                ],
              ),
              const SizedBox(height: 24),

              // 8. Social Login Button (Google)
              SocialLoginButton(
                text: "Continue with Google",
                iconPath: "assets/images/google_icon.png", // Sesuaikan nama file gambar Anda
                onPressed: () {
                  // Logika login Google
                },
              ),
              const SizedBox(height: 16),

              // 9. Guest Mode TextButton
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OnboardingScreen(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF0C1325),
                  ),
                  child: Text(
                    "Login using guest mode",
                    style: GoogleFonts.fraunces(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}