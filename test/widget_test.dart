import 'package:flutter_test/flutter_test.dart';

import 'package:antitela/main.dart';

void main() {
  testWidgets('exibe a tela inicial e navega entre abas', (tester) async {
    await tester.pumpWidget(const AntiTelaApp());

    expect(find.text('Modo Foco'), findsOneWidget);

    await tester.tap(find.text('Iniciar Foco'));
    await tester.pump();

    expect(find.text('TEMPO DE ECRÃ HOJE'), findsOneWidget);

    await tester.tap(find.text('Missões'));
    await tester.pump();

    expect(find.text('Missões Offline'), findsOneWidget);
  });
}
