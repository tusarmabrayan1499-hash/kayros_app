import 'package:flutter_test/flutter_test.dart';
import 'package:kayros_app/main.dart';

void main() {
  testWidgets('Renderiza pantalla de inicio', (tester) async {
    await tester.pumpWidget(const KayrosApp());

    expect(find.text('KAYROS B&T'), findsOneWidget);
    expect(find.text('Iniciar sesión'), findsOneWidget);
  });
}
