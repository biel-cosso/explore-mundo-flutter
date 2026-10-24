import 'package:flutter/material.dart';

import '../dados.dart';
import '../widgets/banner_destaque.dart';
import 'destino.dart';

// aba Destinos: pesquisa, banner e lista
class InicioTab extends StatefulWidget {
  const InicioTab({super.key});

  @override
  State<InicioTab> createState() => _InicioTabState();
}

class _InicioTabState extends State<InicioTab> {
  final _busca = TextEditingController();
  String _termo = '';

  @override
  void dispose() {
    _busca.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final encontrados = destinos.where((d) => d.combinaCom(_termo)).toList();
    final buscando = _termo.trim().isNotEmpty;

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: SearchBar(
            controller: _busca,
            hintText: 'Para onde você quer ir?',
            leading: const Icon(Icons.search),
            trailing: [
              if (buscando)
                IconButton(
                  tooltip: 'Limpar',
                  icon: const Icon(Icons.close),
                  onPressed: () => setState(() {
                    _busca.clear();
                    _termo = '';
                  }),
                ),
            ],
            onChanged: (t) => setState(() => _termo = t),
          ),
        ),
        if (!buscando) ...[
          const _Titulo('Destaques'),
          BannerDestaque(itens: destinos),
          const _Titulo('Todos os destinos'),
        ] else
          _Titulo(
            '${plural(encontrados.length, 'resultado', 'resultados')} para "${_termo.trim()}"',
          ),
        if (encontrados.isEmpty)
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Icon(
                  Icons.search_off,
                  size: 48,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Nenhum destino encontrado.\nTente "praia", "Brasil" ou "montanha".',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        for (final d in encontrados) _CartaoDestino(destino: d),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _Titulo extends StatelessWidget {
  final String texto;
  const _Titulo(this.texto);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
    child: Text(
      texto,
      style: Theme.of(context).textTheme.titleMedium
          ?.copyWith(fontWeight: FontWeight.bold),
    ),
  );
}

class _CartaoDestino extends StatelessWidget {
  final Destino destino;
  const _CartaoDestino({required this.destino});

  @override
  Widget build(BuildContext context) {
    final d = destino;
    final pacote = pacotes.where((p) => p.destinoId == d.id).firstOrNull;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.only(right: 8),
        leading: Image.asset(
          d.imagem,
          width: 88,
          height: 72,
          fit: BoxFit.cover,
        ),
        title: Text(
          d.nome,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(d.local),
            Estrelas(nota: d.nota, rotulo: d.nota.toStringAsFixed(1)),
            if (pacote != null)
              Text('a partir de ${formatarReais(pacote.precoPorPessoa)}'),
          ],
        ),
        trailing: const Icon(Icons.keyboard_arrow_right),
        onTap: () => abrirDestino(context, d),
      ),
    );
  }
}
