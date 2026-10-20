import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login_regis_app/main.dart';
import 'package:login_regis_app/pages/landing_page.dart';
import 'package:login_regis_app/pages/register_page.dart';

void main() {
  testWidgets('App renders login screen properly', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Selamat Datang Kembali'), findsOneWidget);
    expect(find.text('Username'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Masuk (Login)'), findsOneWidget);
  });

  testWidgets('Navigates to register page when tapped', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    final registerLink = find.text('Daftar di sini');
    expect(registerLink, findsOneWidget);
    await tester.tap(registerLink);
    await tester.pumpAndSettle();

    expect(find.byType(RegisterPage), findsOneWidget);
    expect(find.text('Fullname'), findsOneWidget);
    expect(find.text('Tanggal Lahir'), findsOneWidget);
    expect(find.text('Jenis Kelamin'), findsOneWidget);
    expect(find.text('No. Handphone'), findsOneWidget);
    expect(find.text('Alamat'), findsOneWidget);
    expect(find.text('Submit (Daftar Sekarang)'), findsOneWidget);
  });

  testWidgets('Login with default user navigates to landing page', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Default seeded user: ahmadfauzi / 123
    await tester.enterText(find.widgetWithText(TextFormField, 'Username'), 'ahmadfauzi');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), '123');

    await tester.tap(find.text('Masuk (Login)'));
    await tester.pumpAndSettle();

    expect(find.byType(LandingPage), findsOneWidget);
    expect(find.text('Ahmad Fauzi'), findsWidgets);
    expect(find.text('ahmadfauzi'), findsWidgets);
    expect(find.text('20 Mei 2001'), findsOneWidget);
  });
}
