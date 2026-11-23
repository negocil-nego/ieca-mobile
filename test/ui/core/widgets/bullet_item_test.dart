import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/_import.dart';

void main() {
  testWidgets('Renders title text', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: BulletItem(title: 'Test Title', description: 'Test Description'),
    ));

    expect(find.text('Test Title'), findsOneWidget);
  });

  testWidgets('Renders description text', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: BulletItem(title: 'Test Title', description: 'Test Description'),
    ));

    expect(find.text('Test Description'), findsOneWidget);
  });

  testWidgets('Has the pink dot indicator', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: BulletItem(title: 'Test Title', description: 'Test Description'),
    ));

    expect(
      find.byWidgetPredicate(
        (w) =>
            w is Container &&
            w.decoration is BoxDecoration &&
            (w.decoration as BoxDecoration).color == AppColors.primary &&
            (w.decoration as BoxDecoration).shape == BoxShape.circle,
      ),
      findsOneWidget,
    );
  });
}
