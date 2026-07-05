import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/_import.dart';

void main() {
  testWidgets('Renders with default hint text Procurar...', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: SearchInput()),
    ));
    expect(find.text('Procurar...'), findsOneWidget);
  });

  testWidgets('Renders custom hintText', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: SearchInput(hintText: 'Pesquisar...')),
    ));
    expect(find.text('Pesquisar...'), findsOneWidget);
    expect(find.text('Procurar...'), findsNothing);
  });

  testWidgets('Calls onChanged when text changes', (tester) async {
    var changedValue = '';
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: SearchInput(onChanged: (v) => changedValue = v)),
    ));

    await tester.enterText(find.byType(TextField), 'hello');
    expect(changedValue, 'hello');
  });

  testWidgets('Shows clear button when text is entered', (tester) async {
    final controller = TextEditingController(text: 'some text');
    addTearDown(controller.dispose);

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: SearchInput(controller: controller)),
    ));

    expect(find.byIcon(AppIcon.clear), findsOneWidget);
  });

  testWidgets('Calls onReset when clear button is pressed', (tester) async {
    var resetCalled = false;
    final controller = TextEditingController(text: 'some text');
    addTearDown(controller.dispose);

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SearchInput(controller: controller, onReset: () => resetCalled = true),
      ),
    ));

    await tester.tap(find.byIcon(AppIcon.clear));
    expect(resetCalled, isTrue);
  });

  testWidgets('Does not show clear button when text is empty', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: SearchInput()),
    ));
    expect(find.byIcon(AppIcon.clear), findsNothing);
  });
}
