import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  // --- Variabel Keuangan & Proyeksi ---
  int _currentAge = 20;
  int _retirementAge = 55;
  double _estimatedFunds = 0;
  List<FlSpot> _projectionSpots = [];

  // --- Variabel Metrik Kesehatan ---
  int _sugarAvoided = 0;
  int _kcalAvoided = 0;
  int _nicotineAvoided = 0;
  int _waterAdded = 0;

  // --- Variabel Konversi ---
  int _sugarCubes = 0;
  int _riceServings = 0;
  int _nicotinePacks = 0;
  int _waterGlasses = 0;

  // --- Variabel Skor Pilar (Radar Chart) ---
  double _expFinancial = 0;
  double _expHealth = 0;
  double _expSocial = 0;
  double _expPurpose = 0;

  @override
  void initState() {
    super.initState();
    _loadAndCalculateData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAndCalculateData();
  }

  Future<void> _loadAndCalculateData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _currentAge = prefs.getInt('user_current_age') ?? 20;
      _retirementAge = prefs.getInt('user_retirement_age') ?? 55;

      int savedMoney = prefs.getInt('user_total_money_saved') ?? 0;

      _sugarAvoided = prefs.getInt('user_total_sugar') ?? 0;
      _kcalAvoided = prefs.getInt('user_total_kcal') ?? 0;
      _nicotineAvoided = prefs.getInt('user_avoided_nicotine') ?? 0; // Sesuai debug
      _waterAdded = prefs.getInt('user_total_water') ?? 0;

      // Ambil total EXP dan bagi merata JIKA data pilar masih kosong
      int totalExp = prefs.getInt('user_total_exp') ?? 0;

      // PERBAIKAN: Menggunakan getInt lalu di-convert ke double (karena di Home disave sbg int)
      _expFinancial = prefs.getInt('user_exp_financial')?.toDouble() ?? (totalExp / 4);
      _expHealth = prefs.getInt('user_exp_health')?.toDouble() ?? (totalExp / 4);
      _expSocial = prefs.getInt('user_exp_social')?.toDouble() ?? (totalExp / 4);
      _expPurpose = prefs.getInt('user_exp_purpose')?.toDouble() ?? (totalExp / 4);

      // 2. Kalkulasi Proyeksi Bunga Majemuk (Compound Interest)
      int t = _retirementAge - _currentAge;
      if (t <= 0) t = 1; // Keamanan agar pembagian grafik tidak error

      double p = savedMoney.toDouble();
      double r = 0.06; // Return 6% per tahun
      int n = 12; // Compounding bulanan

      // Nilai Proyeksi Akhir
      _estimatedFunds = p * pow((1 + r / n), n * t);

      // Pembuatan Titik (Spots) untuk Line Chart berdasarkan usia ke masa depan
      _projectionSpots.clear();
      int dataPoints = 6;
      for (int i = 0; i < dataPoints; i++) {
        double yearOffset = (t / (dataPoints - 1)) * i;
        double projectedAtYear = p * pow((1 + r / n), n * yearOffset);
        _projectionSpots.add(FlSpot(_currentAge + yearOffset, projectedAtYear));
      }

      // 3. Kalkulasi Konversi Kesehatan
      _sugarCubes = (_sugarAvoided / 4).round();
      _riceServings = (_kcalAvoided / 130).round();
      _nicotinePacks = (_nicotineAvoided / 20).round();
      _waterGlasses = _waterAdded * 4;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    String formattedFunds = currencyFormat.format(_estimatedFunds);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F9),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. HEADER SECTION ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60, bottom: 32),
              decoration: const BoxDecoration(
                color: Color(0xFFF2EFFF),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
              ),
              child: Center(
                child: Text(
                  "Progress",
                  style: GoogleFonts.fraunces(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0C1325),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // --- 2. FINANCIAL PROJECTION CARD ---
            // Catatan: bagian ini (funds card + line chart) TIDAK diubah,
            // sesuai permintaan karena sudah disesuaikan sebelumnya.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/images/money.png', width: 20, height: 20),
                        const SizedBox(width: 8),
                        Text(
                          "Total estimated funds",
                          style: GoogleFonts.fraunces(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0C1325),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      formattedFunds,
                      style: GoogleFonts.fraunces(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0C1325),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Grafik Garis (Line Chart) Dinamis
                    SizedBox(
                      height: 140,
                      child: LineChart(_buildLineChartData()),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        "Fund growth projected to age $_retirementAge",
                        style: GoogleFonts.fraunces(fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // --- 3. HEALTH HIGHLIGHTS SECTION ---
            // Sekarang dibungkus 1 card putih besar (sama seperti card funds
            // & radar chart) lengkap dengan shadow tipis, sesuai figma.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/images/health.png', width: 20, height: 20),
                        const SizedBox(width: 8),
                        Text(
                          "Health successfully saved",
                          style: GoogleFonts.fraunces(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0C1325),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: _buildHealthCard(
                            "Sugars to avoid",
                            "${(_sugarAvoided > 1000 ? (_sugarAvoided / 1000).toStringAsFixed(1) + 'k' : _sugarAvoided)} g",
                            "≈ $_sugarCubes cube sugar",
                            const Color(0xFFFFF0E5),
                            const Color(0xFFFF935D),
                            'assets/images/sugars.png',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildHealthCard(
                            "Calories avoided",
                            "${(_kcalAvoided > 1000 ? (_kcalAvoided / 1000).toStringAsFixed(1) + 'k' : _kcalAvoided)} kkal",
                            "≈ $_riceServings servings of rice",
                            const Color(0xFFE2F9DB),
                            const Color(0xFF6EBE71),
                            'assets/images/calories.png',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildHealthCard(
                            "Nicotine avoided",
                            "${(_nicotineAvoided > 1000 ? (_nicotineAvoided / 1000).toStringAsFixed(1) + 'k' : _nicotineAvoided)} pcs",
                            "≈ $_nicotinePacks packs",
                            const Color(0xFFF1EEFF),
                            const Color(0xFF8F7DF8),
                            'assets/images/nicotine.png',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildHealthCard(
                            "Water is added",
                            "${(_waterAdded > 1000 ? (_waterAdded / 1000).toStringAsFixed(1) + 'k' : _waterAdded)} liter",
                            "≈ $_waterGlasses glass",
                            const Color(0xFFFDEAE9),
                            const Color(0xFFEF5B4E),
                            'assets/images/water.png',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // --- 4. ACCUMULATED SCORE (RADAR CHART) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                width: double.infinity,
                // Padding bawah ditambah (24 -> 32) supaya label & angka pilar
                // "Purpose" di bagian bawah radar tidak terpotong tepi kartu.
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/images/chart.png', width: 20, height: 20),
                        const SizedBox(width: 8),
                        Text(
                          "Accumulated score of the 4 pillars",
                          style: GoogleFonts.fraunces(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0C1325),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // Tinggi dinaikkan (250 -> 280) supaya diagram + label
                    // sekelilingnya punya ruang cukup dan tidak mepet/kepotong.
                    SizedBox(
                      height: 280,
                      child: RadarChart(_buildRadarChartData()),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // --- HELPER UNTUK GRAFIK GARIS PROYEKSI (REAL DATA) ---
  LineChartData _buildLineChartData() {
    double maxYValue = _estimatedFunds > 0 ? _estimatedFunds : 10000;
    double yInterval = maxYValue / 4;

    // FIX 1: Membulatkan interval ke atas agar tidak ada angka desimal (Misal: 3.8 menjadi 4.0)
    double xInterval = ((_retirementAge - _currentAge) / 5).ceilToDouble();
    if (xInterval <= 0) xInterval = 1;

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: yInterval > 0 ? yInterval : 2500,
        verticalInterval: xInterval,
        getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.shade200, strokeWidth: 1),
        getDrawingVerticalLine: (value) => FlLine(color: Colors.grey.shade200, strokeWidth: 1),
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: xInterval,
            getTitlesWidget: (value, meta) {
              // FIX 2: Pencegahan overlap.
              // Jika titik ini bukan titik akhir, TAPI jaraknya terlalu dekat dengan titik akhir (< 70% interval), sembunyikan!
              if (value != meta.max && (meta.max - value) < (xInterval * 0.7)) {
                return const SizedBox.shrink(); // Sembunyikan
              }

              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text('Age ${value.toInt()}', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 10)),
              );
            },
          ),
        ),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
          left: BorderSide(color: Colors.grey.shade300, width: 1),
          right: BorderSide.none,
          top: BorderSide.none,
        ),
      ),
      minX: _currentAge.toDouble(),
      maxX: _retirementAge.toDouble(),
      minY: 0,
      maxY: maxYValue,
      lineBarsData: [
        LineChartBarData(
          spots: _projectionSpots.isEmpty ? [FlSpot(_currentAge.toDouble(), 0), FlSpot(_retirementAge.toDouble(), 0)] : _projectionSpots,
          isCurved: true,
          color: const Color(0xFF7C5BFF),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                const Color(0xFF7C5BFF).withOpacity(0.3),
                const Color(0xFF7C5BFF).withOpacity(0.0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHealthCard(String title, String value, String subtitle, Color bgColor, Color iconColor, String imagePath) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        // Border putih dihilangkan — di figma kartunya flat tanpa outline,
        // supaya warna pastel-nya menyatu bersih dengan background abu-abu.
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: iconColor, borderRadius: BorderRadius.circular(10)),
                child: Image.asset(imagePath, width: 14, height: 14, color: Colors.white),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.fraunces(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF0C1325)),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.fraunces(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0C1325)),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.fraunces(fontSize: 9, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  RadarChartData _buildRadarChartData() {
    return RadarChartData(
      radarShape: RadarShape.polygon,
      tickCount: 3,
      ticksTextStyle: const TextStyle(color: Colors.transparent),
      radarBackgroundColor: Colors.transparent,
      // Grid & border dibikin lebih tipis/lembut (shade300 -> shade200,
      // shade200 -> shade100) supaya kesannya subtle seperti di figma,
      // bukan jadi "kotak-kotak hitam" yang menumpuk di belakang data.
      // Bingkai terluar disamakan dengan warna grid di dalam (sama-sama
      // shade100) supaya tidak jadi 'kotak' gelap yang menonjol sendiri.
      radarBorderData: BorderSide(color: Colors.grey.shade400, width: 1),
      gridBorderData: BorderSide(color: Colors.grey.shade400, width: 1),
      // INI biang keladi kotak hitam pekat di tengah: tickBorderData
      // (cincin-cincin di titik skala tengah, karena tickCount: 3) defaultnya
      // BorderSide(color: Colors.black, width: 2) kalau tidak di-set eksplisit.
      // Dibikin transparan total di sini.
      tickBorderData: BorderSide(color: Colors.grey.shade300, width: 1),
      // Offset dikecilkan sedikit (0.2 -> 0.16) supaya label pilar (terutama
      // yang di bawah, "Purpose") tetap berada di dalam area SizedBox dan
      // tidak terpotong tepi card.
      titlePositionPercentageOffset: 0.16,
      getTitle: (index, angle) {
        String title = '';
        String value = '';
        switch (index) {
          case 0:
            title = 'Financial';
            value = _expFinancial.toInt().toString();
            break;
          case 1:
            title = 'Health';
            value = _expHealth.toInt().toString();
            break;
          case 2:
            title = 'Purpose';
            value = _expPurpose.toInt().toString();
            break;
          case 3:
            title = 'Social';
            value = _expSocial.toInt().toString();
            break;
        }
        return RadarChartTitle(
          text: '$title\n$value',
          angle: 0,
        );
      },
      titleTextStyle: GoogleFonts.fraunces(
        fontSize: 11,
        fontWeight: FontWeight.w600, // sedikit lebih tebal, mengikuti figma
        color: const Color(0xFF0C1325),
      ),
      dataSets: [
        RadarDataSet(
          // Sebelumnya transparan total (cuma garis oranye tipis) — di figma
          // area di dalamnya juga diisi warna oranye transparan.
          fillColor: const Color(0xFFFF935D).withOpacity(0.18),
          borderColor: const Color(0xFFFF935D),
          entryRadius: 0,
          dataEntries: [
            RadarEntry(value: _expFinancial == 0 ? 80 : _expFinancial + 20),
            RadarEntry(value: _expHealth == 0 ? 80 : _expHealth + 20),
            RadarEntry(value: _expPurpose == 0 ? 80 : _expPurpose + 20),
            RadarEntry(value: _expSocial == 0 ? 80 : _expSocial + 20),
          ],
          borderWidth: 2,
        ),
        RadarDataSet(
          // Warna sebelumnya (#0C1325) nyaris hitam sehingga kelihatan seperti
          // garis "hitam" alih-alih biru seperti di figma. Diganti jadi biru,
          // dan opacity fill dinaikkan (0.05 -> 0.18) supaya areanya kelihatan
          // terisi, bukan cuma outline kosong.
          fillColor: const Color(0xFF3D5AA8).withOpacity(0.18),
          borderColor: const Color(0xFF3D5AA8),
          entryRadius: 0,
          dataEntries: [
            RadarEntry(value: _expFinancial),
            RadarEntry(value: _expHealth),
            RadarEntry(value: _expPurpose),
            RadarEntry(value: _expSocial),
          ],
          borderWidth: 2,
        ),
      ],
    );
  }
}