import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ql_hoc_phan/main.dart';

void main() {
  testWidgets('login page shows admin form', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));

    expect(find.text('Chào mừng trở lại!'), findsOneWidget);
    expect(find.text('ĐĂNG NHẬP'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
  });
}
