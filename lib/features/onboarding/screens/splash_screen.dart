import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Wajib ditambahkan

import '../../../core/widgets/continue_button.dart';
import 'signup_screen.dart'; // Pastikan huruf u kapital menyesuaikan penamaan Anda (SignUpScreen)
import '../../../core/utils/main_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  Future<void> _checkUserStatus() async {
    // 1. Membuka penyimpanan lokal
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // 2. Mengecek eksistensi data 'user_name'
    final String? userName = prefs.getString('user_name');

    if (mounted) {
      if (userName != null && userName.isNotEmpty) {
        // JIKA ADA DATA PENGGUNA LAMA: Langsung arahkan ke MainNavigation (bypass halaman ini)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigation()),
        );
      } else {
        // JIKA PENGGUNA BARU: Hentikan status loading agar UI Intro Screen ditampilkan
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Menampilkan layar putih sementara sistem melakukan pengecekan data di latar belakang
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
      );
    }

    // Mengembalikan UI asli Anda jika yang membuka adalah pengguna baru
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // 1. Headline Text
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontFamily: 'Fraunces',
                    fontSize: 48,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0C1325),
                    height: 1.11,
                    letterSpacing: 0.24,
                  ),
                  children: [
                    TextSpan(text: "What's\n"),
                    TextSpan(text: "Your Dream\n"),
                    TextSpan(
                      text: "Retirement",
                      style: TextStyle(color: Color(0xFFFF935D)),
                    ),
                    TextSpan(text: "?"),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 2. Sub-headline Text
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontFamily: 'Fraunces',
                    fontSize: 16,
                    color: Color(0xFF0C1325),
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(text: "Let's plan an exciting and "),
                    TextSpan(
                      text: "worry-free\nretirement!",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // 3. Main Illustration Image
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: 390,
                    height: 520,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          top: 0,
                          left: -15,
                          child: Transform.rotate(
                            angle: -0.15,
                            child: Image.asset('assets/images/traveller.png', width: 200),
                          ),
                        ),
                        Positioned(
                          top: -2,
                          right: -15,
                          child: Transform.rotate(
                            angle: 0.1,
                            child: Image.asset('assets/images/familyperson.png', width: 205),
                          ),
                        ),
                        Positioned(
                          top: 105,
                          left: 90,
                          child: Transform.rotate(
                            angle: -0.05,
                            child: Image.asset('assets/images/slowliving.png', width: 210),
                          ),
                        ),
                        Positioned(
                          top: 215,
                          left: -35,
                          child: Transform.rotate(
                            angle: -0.12,
                            child: Image.asset('assets/images/creativesoul.png', width: 215),
                          ),
                        ),
                        Positioned(
                          top: 230,
                          right: -35,
                          child: Transform.rotate(
                            angle: 0.08,
                            child: Image.asset('assets/images/financialfreedom.png', width: 215),
                          ),
                        ),
                        Positioned(
                          top: 300,
                          left: 75,
                          child: Transform.rotate(
                            angle: -0.02,
                            child: Image.asset('assets/images/earlyretirement.png', width: 240),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 36),

              // 4. Custom Continue Button
              ContinueButton(
                text: "Let Us Help!",
                hasArrow: true,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      // Pastikan penamaan kelas ini sesuai (SignUpScreen atau SignupScreen)
                      builder: (context) => const SignUpScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}