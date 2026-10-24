import 'dart:async';

import 'package:flutter/material.dart';

import '../dados.dart';
import '../telas/destino.dart';

// degradê escuro embaixo da foto pra o texto branco ser lido em qualquer foto
// (testado em test/contraste_test.dart)
const degradeBanner = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [Color(0x00000000), Color(0xE0000000)],
  stops: [0.25, 1],
);

// Banner de destaque: as fotos trocam sozinhas a cada 4 segundos e
// tocar numa foto abre o destino
class BannerDestaque extends StatefulWidget {
  final List<Destino> itens;
  const BannerDestaque({super.key, required this.itens});

  @override
  State<BannerDestaque> createState() => _BannerDestaqueState();
}

class _BannerDestaqueState extends State<BannerDestaque> {
  final _controle = PageController();
  Timer? _timer;
  int _atual = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_controle.hasClients || widget.itens.isEmpty) return;
      final proxima = (_atual + 1) % widget.itens.length;
      _controle.animateToPage(
        proxima,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Stack(
        children: [
          PageView.builder(
            controller: _controle,
            itemCount: widget.itens.length,
            onPageChanged: (i) => setState(() => _atual = i),
            itemBuilder: (context, i) => _slide(context, widget.itens[i]),
          ),
          // bolinhas que mostram qual foto está aparecendo
          Positioned(
            bottom: 10,
            right: 16,
            child: Row(
              children: [
                for (var i = 0; i < widget.itens.length; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: i == _atual ? 18 : 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(
                        alpha: i == _atual ? 1 : 0.6,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Stack da microatividade 5: foto, degradê e texto por cima
  Widget _slide(BuildContext context, Destino d) {
    return GestureDetector(
      onTap: () => abrirDestino(context, d),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
            tag: 'foto-${d.id}',
            child: Image.asset(d.imagem, fit: BoxFit.cover),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(gradient: degradeBanner),
          ),
          Positioned(
            left: 16,
            bottom: 14,
            right: 110,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  d.nome,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(d.local, style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
