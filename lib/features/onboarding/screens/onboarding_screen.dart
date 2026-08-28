import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import komponen UI yang sudah dibuat sebelumnya
import '../widgets/onboarding_progress_bar.dart';
import '../widgets/icon_text_field.dart';
import '../widgets/age_slider.dart';
import '../widgets/retirement_style_card.dart';
import '../widgets/habit_card.dart';
import '../../../core/widgets/continue_button.dart';

// Import untuk navigasi
import '../../../core/utils/main_navigation.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // Kontrol Navigasi
  final PageController _pageController = PageController();
  int _currentPage = 1;

  // --- State Data Screen 1 ---
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  double _retirementAge = 42.0;

  // --- State Data Screen 2 ---
  String? _selectedArchetype;

  // --- State Data Screen 3 ---
  String? _selectedHabit;
  final TextEditingController _expenseController = TextEditingController();

  // Data Dummy untuk Kartu
  final List<Map<String, String>> archetypes = [
    {
      'id': 'Traveler',
      'title': 'The Traveler',
      'desc': 'Travel the world, explore new places, and collect exciting stories!',
      'img': 'assets/images/the_traveler.png'
    },
    {
      'id': 'Family',
      'title': 'Family Person',
      'desc': 'Quality time with family is the top priority.',
      'img': 'assets/images/the_familyperson.png'
    },
    {
      'id': 'SlowLiving',
      'title': 'Slow Living',
      'desc': 'A peaceful, simple life focused on the little joys.',
      'img': 'assets/images/the_slowliving.png'
    },
    {
      'id': 'Others',
      'title': 'Others',
      'desc': 'Something different? Tell us what matters most to you.',
      'img': 'assets/images/others.png'
    },
  ];

  final List<Map<String, String>> habits = [
    {
      'id': 'Coffee',
      'title': 'Coffee & Boba',
      'desc': '~25g Sugar',
      'img': 'assets/images/coffee.png'
    },
    {
      'id': 'Cigarette',
      'title': 'Cigarettes & Vapes',
      'desc': '~10 Nicotine Sticks',
      'img': 'assets/images/cigarette.png'
    },
    {
      'id': 'JunkFood',
      'title': 'Junk Food',
      'desc': '~500 kcal',
      'img': 'assets/images/junkfood.png'
    },
    {
      'id': 'Impulse',
      'title': 'Impulse Buying',
      'desc': 'impulsive habits',
      'img': 'assets/images/impulse.png'
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _nicknameController.dispose();
    _ageController.dispose();
    _expenseController.dispose();
    super.dispose();
  }

  // Logika Berpindah Halaman atau Submit Data
  void _nextPage() {
    // --- Validasi Layar 1 ---
    if (_currentPage == 1) {
      if (_nicknameController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Mohon isi Nickname Anda.")),
        );
        return;
      }

      if (_ageController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Mohon isi umur Anda saat ini.")),
        );
        return;
      }

      // Validasi logika umur pensiun vs umur saat ini
      int currentAgeParsed = int.tryParse(_ageController.text) ?? 0;
      if (_retirementAge <= currentAgeParsed) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(
              "Umur target pensiun harus lebih besar dari umur saat ini.")),
        );
        return;
      }
    }

    // --- Validasi Layar 2 ---
    if (_currentPage == 2 && _selectedArchetype == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mohon pilih salah satu gaya pensiun.")),
      );
      return;
    }

    // --- Validasi Layar 3 ---
    if (_currentPage == 3) {
      if (_selectedHabit == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Mohon pilih satu kebiasaan harian Anda.")),
        );
        return;
      }

      if (_expenseController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Mohon isi estimasi pengeluaran Anda.")),
        );
        return;
      }
    }

    // --- Eksekusi Transisi atau Submit ---
    if (_currentPage < 3) {
      // Tutup keyboard (jika masih terbuka) sebelum geser halaman
      FocusScope.of(context).unfocus();

      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _submitData();
    }
  }

  // Fungsi Penyimpanan Data Lokal
  Future<void> _submitData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String cleanExpense = _expenseController.text.replaceAll(
        RegExp(r'[^0-9]'), '');
    int dailySavings = cleanExpense.isEmpty ? 0 : int.parse(cleanExpense);

    await prefs.setString('user_name', _nicknameController.text);
    await prefs.setInt('user_current_age', int.parse(_ageController.text));
    await prefs.setInt('user_retirement_age', _retirementAge.toInt());
    await prefs.setString('user_archetype', _selectedArchetype!);
    await prefs.setString('user_habit', _selectedHabit!);
    await prefs.setInt('user_daily_savings', dailySavings);

    await prefs.setInt('user_total_exp', 0);
    await prefs.setInt('user_exp_financial', 0);
    await prefs.setInt('user_exp_health', 0);
    await prefs.setInt('user_exp_social', 0);
    await prefs.setInt('user_exp_purpose', 0);

    await prefs.setInt('user_avoided_sugar', 0);
    await prefs.setInt('user_avoided_calories', 0);
    await prefs.setInt('user_avoided_nicotine', 0);
    await prefs.setInt('user_avoided_impulse', 0);
    await prefs.setInt('user_total_money_saved', 0);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigation()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _currentPage = index + 1;
          });
        },
        children: [
          _buildStep1(),
          _buildStep2(),
          _buildStep3(),
        ],
      ),
    );
  }

  // ==================== SCREEN 1 ====================
  Widget _buildStep1() {
    return Container(
      color: const Color(0xFFE8E2FF),
      // Mewarnai seluruh latar belakang Screen 1
      child: Stack(
        children: [
          // 1. Maskot (Berada di Belakang)
          Positioned(
            // Menempatkan gambar tepat di bawah status bar/notch secara dinamis
            top: MediaQuery
                .of(context)
                .padding
                .top - 40,
            left: 0,
            right: 0,
            // Height dihapus agar gambar menyesuaikan proporsi aslinya
            child: Image.asset(
              'assets/images/mascot_onboarding.png',
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              fit: BoxFit
                  .fitWidth, // Memaksa gambar menyentuh ujung kiri dan kanan layar
            ),
          ),

          // 2. Kontainer Putih Melengkung (Berada di Depan)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              // Ditingkatkan menjadi 72% (sekitar 3/4 dari total tinggi layar)
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.72,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const OnboardingProgressBar(currentStep: 1),
                    const SizedBox(height: 24),
                    Text(
                      "Let's Get to Know You!",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.fraunces(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0C1325),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Tell us a little about yourself so we can help plan your dream future.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.fraunces(
                        fontSize: 14,
                        color: const Color(0xFF0C1325),
                      ),
                    ),
                    const SizedBox(height: 32),
                    IconTextField(
                      label: "Nickname",
                      hintText: "Input nickname...",
                      prefixIcon: Icons.person,
                      controller: _nicknameController,
                    ),
                    const SizedBox(height: 16),
                    IconTextField(
                      label: "Current age",
                      hintText: "Input your current age...",
                      prefixIcon: Icons.calendar_today,
                      keyboardType: TextInputType.number,
                      controller: _ageController,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "What age do you want to retire?",
                      style: GoogleFonts.fraunces(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0C1325),
                      ),
                    ),
                    const SizedBox(height: 8),
                    AgeSlider(
                      value: _retirementAge,
                      onChanged: (value) {
                        setState(() {
                          _retirementAge = value;
                        });
                      },
                    ),
                    const SizedBox(height: 32),
                    ContinueButton(
                      text: "Continue",
                      hasArrow: true,
                      onPressed: _nextPage,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== SCREEN 2 ====================
  Widget _buildStep2() {
    return SafeArea(
      child: Stack(
        children: [
          // 1. Seluruh Konten (Judul + Kartu) Bisa Di-scroll
          ListView(
            padding: const EdgeInsets.only(bottom: 120),
            // Memberi ruang agar kartu terakhir tidak tertutup tombol
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: OnboardingProgressBar(currentStep: 2),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  "What Does Your Dream Retirement Look Like?",
                  style: GoogleFonts.fraunces(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0C1325),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  "Choose the retirement lifestyle that feels right for you.",
                  style: GoogleFonts.fraunces(fontSize: 14),
                ),
              ),
              const SizedBox(height: 24),

              // Melakukan perulangan daftar kartu secara langsung di dalam ListView
              ...archetypes.map((arc) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: RetirementStyleCard(
                    title: arc['title']!,
                    description: arc['desc']!,
                    imagePath: arc['img']!,
                    isSelected: _selectedArchetype == arc['id'],
                    onTap: () {
                      setState(() {
                        _selectedArchetype = arc['id'];
                      });
                    },
                  ),
                );
              }),
            ],
          ),

          // 2. Efek Blur dan Tombol Sticky di Bawah (Tetap pada posisinya)
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                child: Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.white,
                        Colors.white.withOpacity(0.1),
                      ],
                    ),
                  ),
                  child: ContinueButton(
                    text: "Choose this style",
                    hasArrow: true,
                    onPressed: _nextPage,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

// ==================== SCREEN 3 ====================
  Widget _buildStep3() {
    return SafeArea(
      child: Stack(
        children: [
          // 1. Seluruh Konten Bisa Di-scroll (Termasuk Input Nominal)
          ListView(
            padding: const EdgeInsets.only(bottom: 120), // Memberi ruang agar input tidak tertutup tombol
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: OnboardingProgressBar(currentStep: 3),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  "Habits You Want to Cut Back On?",
                  style: GoogleFonts.fraunces(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0C1325),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  "Choose 1 daily habit that drains your wallet & health the most.",
                  style: GoogleFonts.fraunces(fontSize: 14),
                ),
              ),
              const SizedBox(height: 24),

              // GridView harus menggunakan shrinkWrap agar bisa masuk ke dalam ListView
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: habits.length,
                  itemBuilder: (context, index) {
                    final habit = habits[index];
                    return HabitCard(
                      title: habit['title']!,
                      subtitle: habit['desc']!,
                      imagePath: habit['img']!,
                      isSelected: _selectedHabit == habit['id'],
                      onTap: () {
                        setState(() {
                          _selectedHabit = habit['id'];
                        });
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),

              // Memindahkan Input Field ke area scroll, persis di bawah Grid kartu
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "How much do you spend per day on this?",
                      style: GoogleFonts.fraunces(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0C1325),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _expenseController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Memblokir input selain angka
                      decoration: InputDecoration(
                        prefixText: "Rp  ",
                        prefixStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        hintText: "0",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF0C1325)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // 2. Blur Overlay hanya untuk Tombol Saja
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                child: Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.white,
                        Colors.white.withOpacity(0.1),
                      ],
                    ),
                  ),
                  child: ContinueButton(
                    text: "Start Future Journey!",
                    hasArrow: true,
                    onPressed: _nextPage,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
