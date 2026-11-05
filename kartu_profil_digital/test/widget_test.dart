import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kartu_profil_digital/main.dart';
import 'package:kartu_profil_digital/services/pref_service.dart';

void main() {
  testWidgets('Alur lengkap: edit profil, cek terakhir diedit, dan reset profil', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      'open_count': 2,
      'is_dark_mode': false,
    });
    final prefs = await PrefService.init();

    await tester.pumpWidget(MyApp(prefs: prefs));

    // Default profile
    expect(find.text('Fakhry Firdaus'), findsOneWidget);
    expect(find.textContaining('Terakhir diedit:'), findsNothing);

    // Edit profil
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Nama'), 'Mughni Ian Akmal');
    await tester.enterText(find.widgetWithText(TextFormField, 'Jabatan'), 'Mobile Developer');
    await tester.tap(find.widgetWithText(FilledButton, 'Simpan'));
    await tester.pumpAndSettle();

    expect(find.text('Mughni Ian Akmal'), findsOneWidget);
    expect(find.text('Mobile Developer'), findsOneWidget);
    expect(find.text('Profil tersimpan'), findsOneWidget);
    expect(find.textContaining('Terakhir diedit:'), findsOneWidget);

    // Tunggu SnackBar selesai agar tidak antre
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    // Reset profil
    await tester.tap(find.widgetWithText(OutlinedButton, 'Reset Profil'));
    await tester.pumpAndSettle();

    expect(find.text('Fakhry Firdaus'), findsOneWidget);
    expect(find.text('Profil dikembalikan ke bawaan'), findsOneWidget);
    expect(find.textContaining('Terakhir diedit:'), findsNothing);
  });
}
