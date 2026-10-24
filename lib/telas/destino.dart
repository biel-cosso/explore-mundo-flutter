import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../dados.dart';
import '../main.dart';
import '../widgets/favorito.dart';
import '../widgets/reserva.dart';

const telefoneAgencia = '08000000000'; // número fictício

void abrirDestino(BuildContext context, Destino d) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (_) => DestinoPage(destino: d)));
}

// Página do destino, seguindo os passos 5 a 9 do roteiro
class DestinoPage extends StatelessWidget {
  final Destino destino;
  const DestinoPage({super.key, required this.destino});

  @override
  Widget build(BuildContext context) {
    final d = destino;
    final cores = Theme.of(context).colorScheme;
    final color = cores.primary;

    // Passo 5: Seção Título
    Widget titleSection = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    d.nome,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                Text(d.local, style: TextStyle(color: cores.onSurfaceVariant)),
                const SizedBox(height: 6),
                Estrelas(
                  nota: d.nota,
                  rotulo:
                      '${d.nota.toStringAsFixed(1)} · ${plural(d.avaliacoes.length, 'avaliação', 'avaliações')}',
                ),
              ],
            ),
          ),
          FavoritoWidget(totalInicial: d.favoritos),
        ],
      ),
    );

    // Passo 6: Seção de Botões
    Widget buttonSection = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildButtonColumn(color, Icons.call, 'LIGAR', () => _ligar(context)),
        _buildButtonColumn(color, Icons.near_me, 'ROTA', () => _rota(context)),
        _buildButtonColumn(
          color,
          Icons.share,
          'COMPARTILHAR',
          () => _compartilhar(context),
        ),
      ],
    );

    // Passo 7: Seção de Texto
    Widget textSection = Container(
      padding: const EdgeInsets.all(32),
      child: Text(
        d.descricao,
        softWrap: true,
        style: const TextStyle(height: 1.5),
      ),
    );

    final pacote = pacotes.where((p) => p.destinoId == d.id).firstOrNull;

    return Scaffold(
      appBar: AppBar(title: Text(d.nome)),
      // Passo 9: ListView no lugar da Column pra poder rolar
      body: LarguraMaxima(
        child: ListView(
          children: [
            // Passo 8: imagem
            Hero(
              tag: 'foto-${d.id}',
              child: Image.asset(
                d.imagem,
                width: 600,
                height: 240,
                fit: BoxFit.cover,
              ),
            ),
            titleSection,
            buttonSection,
            textSection,
            if (pacote != null) _cartaoPacote(context, pacote),
            const Padding(
              padding: EdgeInsets.fromLTRB(32, 24, 32, 4),
              child: Text(
                'Avaliações dos clientes',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            for (final a in d.avaliacoes)
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 32),
                leading: CircleAvatar(child: Text(a.autor.substring(0, 1))),
                title: Estrelas(nota: a.estrelas.toDouble()),
                subtitle: Text('${a.comentario}\n— ${a.autor}'),
                isThreeLine: true,
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _cartaoPacote(BuildContext context, Pacote p) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.titulo,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${p.noites} noites · a partir de ${formatarReais(p.precoPorPessoa)}/pessoa',
                  ),
                ],
              ),
            ),
            // o RaisedButton do roteiro não existe mais no Flutter, usei o FilledButton
            // (botão cheio) porque reservar é a ação principal da tela
            FilledButton.icon(
              onPressed: () => mostrarReserva(context, p),
              icon: const Icon(Icons.event_available),
              label: const Text('Reservar'),
            ),
          ],
        ),
      ),
    );
  }

  // método do passo 6, com InkWell pra ficar clicável
  Widget _buildButtonColumn(
    Color color,
    IconData icon,
    String label,
    VoidCallback aoTocar,
  ) {
    return InkWell(
      onTap: aoTocar,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            Container(
              margin: const EdgeInsets.only(top: 8),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _ligar(BuildContext context) async {
    final ok = await launchUrl(Uri(scheme: 'tel', path: telefoneAgencia));
    if (!ok && context.mounted) {
      _aviso(context, 'Não foi possível abrir o discador.');
    }
  }

  Future<void> _rota(BuildContext context) async {
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${destino.latitude},${destino.longitude}',
    );
    final ok = await launchUrl(url, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      _aviso(context, 'Não foi possível abrir o mapa.');
    }
  }

  Future<void> _compartilhar(BuildContext context) async {
    await Clipboard.setData(
      ClipboardData(
        text:
            'Olha esse destino da Explore Mundo: ${destino.nome} (${destino.local}) ⭐ ${destino.nota}',
      ),
    );
    if (context.mounted) {
      _aviso(context, 'Texto copiado! É só colar no WhatsApp ou e-mail.');
    }
  }

  void _aviso(BuildContext context, String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}

// 5 estrelas (cheia, meia ou vazia) de acordo com a nota
class Estrelas extends StatelessWidget {
  final double nota;
  final String? rotulo;
  const Estrelas({super.key, required this.nota, this.rotulo});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final corEstrela = tema.brightness == Brightness.dark
        ? corEstrelaEscuro
        : corEstrelaClaro;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 1; i <= 5; i++)
          Icon(
            nota >= i
                ? Icons.star
                : (nota >= i - 0.5 ? Icons.star_half : Icons.star_border),
            size: 16,
            color: corEstrela,
          ),
        if (rotulo != null) ...[
          const SizedBox(width: 6),
          Text(
            rotulo!,
            style: TextStyle(
              fontSize: 12,
              color: tema.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}
