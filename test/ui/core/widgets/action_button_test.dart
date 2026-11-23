import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/_import.dart';

void main() {
  testWidgets('Renders icon when icon is provided', (tester) async {
    await tester.pumpWidget(MaterialApp(home: ActionButton(icon: Icons.star)));
    expect(find.byIcon(Icons.star), findsOneWidget);
  });

  testWidgets('Renders text when text is provided', (tester) async {
    await tester.pumpWidget(MaterialApp(home: ActionButton(text: 'Tap me')));
    expect(find.text('Tap me'), findsOneWidget);
  });

  testWidgets('Calls onPressed when tapped', (tester) async {
    var called = false;
    await tester.pumpWidget(MaterialApp(
      home: ActionButton(icon: Icons.star, onPressed: () => called = true),
    ));
    await tester.tap(find.byType(IconButton));
    expect(called, isTrue);
  });

  testWidgets('Shows activeIcon when isActive is true and activeIcon is provided',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ActionButton(
        icon: Icons.star,
        isActive: true,
        activeIcon: Icons.favorite,
      ),
    ));
    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(find.byIcon(Icons.star), findsNothing);
  });

  testWidgets('Applies custom color', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ActionButton(icon: Icons.star, color: Colors.blue, onPressed: () {}),
    ));

    final icon = tester.widget<Icon>(find.byType(Icon));
    expect(icon.color, Colors.blue);
  });

  testWidgets('Greyed out when onPressed is null', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ActionButton(icon: Icons.star),
    ));

    final icon = tester.widget<Icon>(find.byType(Icon));
    expect(icon.color, Colors.grey.shade400);
  });
}
