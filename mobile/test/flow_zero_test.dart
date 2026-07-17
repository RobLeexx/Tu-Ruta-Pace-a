import 'package:ayni_ruta/modules/auth/presentation/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('starts with the Flow 0 welcome screen', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: WelcomeScreen(onCreateAccount: () {}, onSignIn: () {}),
      ),
    );

    expect(find.text('Tu ruta, a tu ritmo'), findsOneWidget);
    expect(find.text('Continuar'), findsOneWidget);
  });
}
