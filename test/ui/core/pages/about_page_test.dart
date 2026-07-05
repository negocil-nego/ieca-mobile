import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/_import.dart';

void main() {
  testWidgets('Page renders with title Sobre', (tester) async {
    await tester.pumpWidget(MaterialApp(home: AboutPage()));
    expect(find.text('Sobre'), findsOneWidget);
  });

  testWidgets('Shows IECA church info', (tester) async {
    await tester.pumpWidget(MaterialApp(home: AboutPage()));
    expect(
      find.text('Igreja Evangélica Congregacional de Angola'),
      findsOneWidget,
    );
  });

  testWidgets('Shows developer info', (tester) async {
    await tester.pumpWidget(MaterialApp(home: AboutPage()));
    expect(find.text('Sedrac Lucas Calupeteca'), findsOneWidget);
    expect(find.text('Desenvolvido por'), findsOneWidget);
  });
}
