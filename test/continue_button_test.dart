import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:retire_me/core/widgets/continue_button.dart';
// Ganti 'nama_project_anda' sesuai dengan nama proyek Anda di pubspec.yaml

void main() {
  // Skenario 1: Memastikan tombol default (tanpa panah) tampil dengan benar
  testWidgets('Tombol menampilkan teks dan menyembunyikan panah secara bawaan', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ContinueButton(
            text: 'Submit',
            onPressed: () {},
          ),
        ),
      ),
    );

    // Verifikasi teks ditemukan
    expect(find.text('Submit'), findsOneWidget);
    // Verifikasi ikon panah tidak ada di layar
    expect(find.byIcon(Icons.arrow_outward), findsNothing);
  });

  testWidgets('Tombol menampilkan ikon panah jika hasArrow true', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ContinueButton(
            text: 'Let Us Help!',
            hasArrow: true,
            onPressed: () {},
          ),
        ),
      ),
    );

    expect(find.text('Let Us Help!'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_outward), findsOneWidget);
  });

  testWidgets('Fungsi onPressed tereksekusi ketika tombol ditekan', (WidgetTester tester) async {
    bool isTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ContinueButton(
            text: 'Tap Me',
            onPressed: () {
              isTapped = true;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byType(ContinueButton));
    await tester.pump(); // Memperbarui frame UI setelah ada aksi

    expect(isTapped, isTrue);
  });
}