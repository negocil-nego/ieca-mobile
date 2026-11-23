import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/_import.dart';

void main() {
  testWidgets('Page renders with title Termos de uso', (tester) async {
    await tester.pumpWidget(MaterialApp(home: TermsOfUsePage()));
    expect(find.text('Termos de uso'), findsOneWidget);
  });

  testWidgets('Shows multiple BulletItem widgets', (tester) async {
    await tester.pumpWidget(MaterialApp(home: TermsOfUsePage()));
    expect(find.byType(BulletItem), findsNWidgets(5));
  });

  testWidgets('Has AppBar with back button', (tester) async {
    await tester.pumpWidget(MaterialApp(home: TermsOfUsePage()));
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byIcon(AppIcon.arrowBack), findsOneWidget);
  });
}
