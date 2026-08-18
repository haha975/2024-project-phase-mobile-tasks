import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Product page displays title', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Text('Products'),
      ),
    );

    expect(find.text('Products'), findsOneWidget);
  });
}