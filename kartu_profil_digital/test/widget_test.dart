import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kartu_profil_digital/main.dart';
import 'package:kartu_profil_digital/services/pref_service.dart';

void main() {
  testWidgets('Menampilkan open count dan toggle mode gelap', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      'open_count': 5,
      'is_dark_mode': false,
    });
    final prefs = await PrefService.init();
    await prefs.increaseOpenCount();

    await tester.pumpWidget(MyApp(prefs: prefs));

    expect(find.text('Kartu ini sudah dibuka 6 kali'), findsOneWidget);
    expect(find.text('Mode Gelap'), findsOneWidget);

    // Toggle switch mode gelap
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    expect(prefs.isDarkMode, isTrue);
  });
}
