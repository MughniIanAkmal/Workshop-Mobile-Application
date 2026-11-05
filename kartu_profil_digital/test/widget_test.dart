import 'package:flutter_test/flutter_test.dart';

import 'package:kartu_profil_digital/main.dart';

void main() {
  testWidgets('Menampilkan profil awal', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Kartu Profil Digital'), findsOneWidget);
    expect(find.text('Fakhry Firdaus'), findsOneWidget);
  });
}
