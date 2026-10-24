import 'package:flutter/material.dart';

import '../dados.dart';
import '../widgets/reserva.dart';
import 'destino.dart';

// aba Pacotes: ListView com ListTile, preço e botão de reservar
class PacotesTab extends StatelessWidget {
  const PacotesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: pacotes.length + 1,
      separatorBuilder: (_, i) =>
          i == 0 ? const SizedBox.shrink() : const Divider(height: 1),
      itemBuilder: (context, i) {
        if (i == 0) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              'Valores por pessoa (exemplo). Toque no pacote para ver o destino.',
              style: TextStyle(color: cores.onSurfaceVariant),
            ),
          );
        }
        final p = pacotes[i - 1];
        final d = destinoPorId(p.destinoId);
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(d.imagem),
            radius: 26,
          ),
          title: Text(
            p.titulo,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text('${d.nome} · ${p.noites} noites\n${p.inclui}'),
          isThreeLine: true,
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatarReais(p.precoPorPessoa),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: cores.primary,
                ),
              ),
              const SizedBox(height: 2),
              SizedBox(
                height: 30,
                child: FilledButton.tonal(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  onPressed: () => mostrarReserva(context, p),
                  child: const Text('Reservar'),
                ),
              ),
            ],
          ),
          onTap: () => abrirDestino(context, d),
        );
      },
    );
  }
}
