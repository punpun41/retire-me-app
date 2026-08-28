import 'package:flutter/material.dart';
import 'features/onboarding/screens/splash_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Retire Me!',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), // Bisa diubah nanti saat desain fix
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}