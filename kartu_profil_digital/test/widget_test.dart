import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kartu_profil_digital/main.dart';
import 'package:kartu_profil_digital/services/pref_service.dart';

void main() {
  testWidgets('Menampilkan profil dan edit profil tersimpan', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      'open_count': 1,
      'is_dark_mode': false,
    });
    final prefs = await PrefService.init();

    await tester.pumpWidget(MyApp(prefs: prefs));

    expect(find.text('Fakhry Firdaus'), findsOneWidget);

    // Tap icon edit
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();

    expect(find.text('Edit Profil'), findsOneWidget);

    // Ubah nama
    await tester.enterText(find.widgetWithText(TextFormField, 'Nama'), 'Mughni Ian');
    await tester.tap(find.widgetWithText(FilledButton, 'Simpan'));
    await tester.pumpAndSettle();

    expect(find.text('Mughni Ian'), findsOneWidget);
    expect(find.text('Profil tersimpan'), findsOneWidget);
    expect(prefs.profile.name, 'Mughni Ian');
  });
}
