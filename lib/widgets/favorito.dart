import 'package:flutter/material.dart';

// Funcionalidade personalizada (objetivo do trabalho): no roteiro a estrela e o
// número "41" são fixos. Aqui tocar na estrela marca/desmarca e o número muda.
class FavoritoWidget extends StatefulWidget {
  final int totalInicial;
  const FavoritoWidget({super.key, required this.totalInicial});

  @override
  State<FavoritoWidget> createState() => _FavoritoWidgetState();
}

class _FavoritoWidgetState extends State<FavoritoWidget> {
  bool _favorito = false;
  late int _total = widget.totalInicial;

  void _alternar() {
    setState(() {
      _favorito = !_favorito;
      _total += _favorito ? 1 : -1;
    });
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            _favorito ? 'Adicionado aos favoritos ⭐' : 'Removido dos favoritos',
          ),
          duration: const Duration(seconds: 1),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: _favorito ? 'Remover dos favoritos' : 'Marcar como favorito',
          onPressed: _alternar,
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, anim) =>
                ScaleTransition(scale: anim, child: child),
            child: Icon(
              _favorito ? Icons.star : Icons.star_border,
              key: ValueKey(_favorito),
              color: Colors.red[500],
            ),
          ),
        ),
        SizedBox(width: 24, child: Text('$_total')),
      ],
    );
  }
}
