import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/_import.dart';

void main() {
  testWidgets('Page renders with title Política de privacidade',
      (tester) async {
    await tester.pumpWidget(MaterialApp(home: PrivacyPolicyPage()));
    expect(find.text('Política de privacidade'), findsOneWidget);
  });

  testWidgets('Shows multiple BulletItem widgets', (tester) async {
    await tester.pumpWidget(MaterialApp(home: PrivacyPolicyPage()));
    expect(find.byType(BulletItem), findsNWidgets(5));
  });

  testWidgets('Has AppBar with back button', (tester) async {
    await tester.pumpWidget(MaterialApp(home: PrivacyPolicyPage()));
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byIcon(AppIcon.arrowBack), findsOneWidget);
  });
}
