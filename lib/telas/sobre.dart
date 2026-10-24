import 'package:flutter/material.dart';

import '../dados.dart';

class SobreTab extends StatelessWidget {
  const SobreTab({super.key});

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    final media =
        destinos.map((d) => d.nota).reduce((a, b) => a + b) / destinos.length;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Icon(Icons.public, size: 72, color: cores.primary),
        const SizedBox(height: 8),
        Text(
          'Explore Mundo',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const Text('Agência de Viagens', textAlign: TextAlign.center),
        const SizedBox(height: 24),
        // mesma ideia da microatividade 3 (Row com 3 Columns)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _numero(cores, Icons.place, '${destinos.length}', 'destinos'),
            _numero(cores, Icons.card_travel, '${pacotes.length}', 'pacotes'),
            _numero(cores, Icons.star, media.toStringAsFixed(1), 'nota média'),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'A Explore Mundo nasceu para ajudar você a descobrir lugares incríveis com segurança e '
          'tranquilidade. Montamos roteiros com aéreo, hospedagem e passeios guiados, e acompanhamos '
          'cada viagem do planejamento até a volta para casa.\n\n'
          'Pelo app você explora destinos, compara pacotes, faz sua reserva e fala com a nossa equipe.',
          style: TextStyle(height: 1.5),
        ),
        const SizedBox(height: 24),
        Text(
          'App feito para trabalho da faculdade. A agência, os preços e as avaliações são fictícios. '
          'Fotos: Wikimedia Commons (créditos no repositório).',
          style: TextStyle(fontSize: 12, color: cores.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _numero(
    ColorScheme cores,
    IconData icone,
    String valor,
    String rotulo,
  ) => Column(
    children: [
      Icon(icone, color: cores.primary),
      Text(
        valor,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
      Text(rotulo),
    ],
  );
}
