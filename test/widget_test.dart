// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:payments_management/features/alerts/screens/alerts_screen.dart';

import 'package:payments_management/main.dart';
import 'package:integration_test/integration_test.dart';
import 'package:payments_management/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:fake_async/fake_async.dart';

Widget wrapWithProvider(Widget child) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
    ],
    child: MaterialApp(
      home: child,
    ),
  );
}

void main() {
  // testWidgets('Counter increments smoke test', (WidgetTester tester) async {
  //   // Build our app and trigger a frame.
  //   await tester.pumpWidget(const MyApp());

  //   // Verify that our counter starts at 0.
  //   expect(find.text('0'), findsOneWidget);
  //   expect(find.text('1'), findsNothing);

  //   // Tap the '+' icon and trigger a frame.
  //   await tester.tap(find.byIcon(Icons.add));
  //   await tester.pump();

  //   // Verify that our counter has incremented.
  //   expect(find.text('0'), findsNothing);
  //   expect(find.text('1'), findsOneWidget);
  // });

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // testWidgets('Flujo de inicio de sesión', (WidgetTester tester) async {
  //   await tester.pumpWidget(MyApp());

  //   // await tester.enterText(find.byType(TextField), 'usuario');
  //   await tester.enterText(find.byType(TextField), 'Email:');
  //   await tester.enterText(find.byKey(Key('passwordField')), 'Contraseña:');
  //   await tester.tap(find.text('INGRESAR'));
  //   await tester.pumpAndSettle();

  //   expect(find.text('Bienvenido'), findsOneWidget);
  // });
  // testWidgets('Flujo de inicio de sesión', (WidgetTester tester) async {
  //   await tester.pumpWidget(const AlertsScreen());

  //   expect(find.text('Alertas'), findsOneWidget);
  // });

//ALERTS
  testWidgets('Test AlertsScreen', (WidgetTester tester) async {
    await tester.pumpWidget(wrapWithProvider(const AlertsScreen()));

    expect(find.text('Alertas'), findsOneWidget);
    // expect(find.text('¡No existen alertas para mostrar!'), findsOneWidget);
  });

  testWidgets(
      'Muestra CircularProgressIndicator mientras se cargan las alertas',
      (WidgetTester tester) async {
    await tester
        // .pumpWidget(wrapWithProvider(MaterialApp(home: AlertsScreen())));
        .pumpWidget(wrapWithProvider(AlertsScreen()));

    // Verifica que se muestra el indicador de carga inicialmente
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Avanza el tiempo simulado para completar la carga de datos
    fakeAsync((async) {
      async.elapse(Duration(seconds: 1));
      async.flushMicrotasks();
    });

    // Actualiza el estado del widget
    await tester.pump();

    // Verifica que se muestra el texto cuando alerts está vacío
    expect(find.text('¡No existen alertas para mostrar!'), findsOneWidget);
  });
}
