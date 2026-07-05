import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/_import.dart';

void main() {
  testWidgets('Both buttons disabled when hasPrevious=false and hasNext=false',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ContentNavButtons(hasPrevious: false, hasNext: false),
    ));

    final buttons = find.byType(FloatingActionButton);
    expect(buttons, findsNWidgets(2));
    for (final fab in tester.widgetList(buttons).cast<FloatingActionButton>()) {
      expect(fab.onPressed, isNull);
    }
  });

  testWidgets('Previous button enabled when hasPrevious=true, calls onPrevious',
      (tester) async {
    var called = false;
    await tester.pumpWidget(MaterialApp(
      home: ContentNavButtons(
        hasPrevious: true,
        hasNext: false,
        onPrevious: () => called = true,
      ),
    ));

    final buttons = find.byType(FloatingActionButton);
    await tester.tap(buttons.first);
    expect(called, isTrue);
  });

  testWidgets('Next button enabled when hasNext=true, calls onNext',
      (tester) async {
    var called = false;
    await tester.pumpWidget(MaterialApp(
      home: ContentNavButtons(
        hasPrevious: false,
        hasNext: true,
        onNext: () => called = true,
      ),
    ));

    final buttons = find.byType(FloatingActionButton);
    await tester.tap(buttons.last);
    expect(called, isTrue);
  });

  testWidgets('Both buttons enabled when both are true', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ContentNavButtons(
        hasPrevious: true,
        hasNext: true,
        onPrevious: () {},
        onNext: () {},
      ),
    ));

    final buttons = find.byType(FloatingActionButton);
    expect(buttons, findsNWidgets(2));

    expect(
      tester.widget<FloatingActionButton>(buttons.first).onPressed,
      isNotNull,
    );
    expect(
      tester.widget<FloatingActionButton>(buttons.last).onPressed,
      isNotNull,
    );
  });

  testWidgets(
      'Buttons disabled when hasPrevious/hasNext are true but callbacks are null',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ContentNavButtons(hasPrevious: true, hasNext: true),
    ));

    final buttons = find.byType(FloatingActionButton);
    for (final fab in tester.widgetList(buttons).cast<FloatingActionButton>()) {
      expect(fab.onPressed, isNull);
    }
  });
}
