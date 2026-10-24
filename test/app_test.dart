import 'package:explore_mundo/dados.dart';
import 'package:explore_mundo/main.dart';
import 'package:explore_mundo/telas/destino.dart';
import 'package:explore_mundo/widgets/reserva.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('funções', () {
    test('pesquisa ignora acento e maiúscula', () {
      expect(destinos.where((d) => d.combinaCom('BRASIL')).length, 3);
      expect(
        destinos.where((d) => d.combinaCom('lencois')).single.id,
        'lencois',
      );
      expect(
        destinos.where((d) => d.combinaCom('   ')).length,
        destinos.length,
      );
      expect(destinos.where((d) => d.combinaCom('xyz123')), isEmpty);
    });

    test('preço em reais', () {
      expect(formatarReais(890), r'R$ 890');
      expect(formatarReais(2890), r'R$ 2.890');
      expect(formatarReais(40200), r'R$ 40.200');
      expect(formatarReais(1234567), r'R$ 1.234.567');
    });

    test('plural', () {
      expect(plural(1, 'pessoa', 'pessoas'), '1 pessoa');
      expect(plural(3, 'pessoa', 'pessoas'), '3 pessoas');
      expect(plural(0, 'resultado', 'resultados'), '0 resultados');
    });

    test('todo pacote aponta pra um destino que existe', () {
      for (final p in pacotes) {
        expect(() => destinoPorId(p.destinoId), returnsNormally);
      }
    });
  });

  group('telas', () {
    testWidgets('app abre e a pesquisa filtra os destinos', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pump();
      expect(find.text('Destaques'), findsOneWidget);

      await tester.enterText(find.byType(SearchBar), 'brasil');
      await tester.pump();
      expect(find.text('3 resultados para "brasil"'), findsOneWidget);

      await tester.enterText(find.byType(SearchBar), 'xyz');
      await tester.pump();
      expect(find.textContaining('Nenhum destino encontrado'), findsOneWidget);

      // tira o app da tela pra parar o timer do banner
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('favorito soma e desfaz', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: DestinoPage(destino: destinos.first)),
      );
      expect(find.text('41'), findsOneWidget);

      // as avaliações também têm estrelas, então procura pelo botão do favorito
      await tester.tap(find.byTooltip('Marcar como favorito'));
      await tester.pumpAndSettle();
      expect(find.text('42'), findsOneWidget);

      await tester.tap(find.byTooltip('Remover dos favoritos'));
      await tester.pumpAndSettle();
      expect(find.text('41'), findsOneWidget);
    });

    testWidgets('reserva não confirma sem nome e sem data', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: FormularioReserva(pacote: pacotes.first)),
        ),
      );
      await tester.tap(find.text('Confirmar reserva'));
      await tester.pump();
      expect(find.text('Digite seu nome'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), 'Ana');
      await tester.tap(find.text('Confirmar reserva'));
      await tester.pump();
      expect(find.text('Escolha a data de ida.'), findsOneWidget);
    });

    testWidgets('total da reserva acompanha o número de pessoas', (
      tester,
    ) async {
      final p = pacotes.first; // Rio Clássico, R$ 2.890
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: FormularioReserva(pacote: p)),
        ),
      );
      expect(
        find.text('Total estimado: R\$ 5.780'),
        findsOneWidget,
      ); // começa com 2 pessoas

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      expect(find.text('Total estimado: R\$ 8.670'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.remove));
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();
      expect(find.text('Total estimado: R\$ 2.890'), findsOneWidget);
      // com 1 pessoa o botão de diminuir fica desligado
      final menos = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.remove),
      );
      expect(menos.onPressed, isNull);
    });
  });
}
