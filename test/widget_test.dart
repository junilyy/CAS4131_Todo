// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:todo/main.dart';

void main() {
  testWidgets('todo can be added and removed', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    expect(find.text('등록된 할 일이 없습니다.'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '과제 제출하기');
    await tester.tap(find.text('추가'));
    await tester.pump();

    expect(find.text('과제 제출하기'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pump();

    expect(find.text('과제 제출하기'), findsNothing);
  });
}
