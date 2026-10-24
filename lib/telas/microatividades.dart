import 'package:flutter/material.dart';

// menu lateral com uma tela pra cada microatividade
class MenuMicroatividades extends StatelessWidget {
  const MenuMicroatividades({super.key});

  static final itens = <(String, IconData, Widget)>[
    (
      '2 · MaterialApp, Scaffold e AppBar',
      Icons.web_asset,
      const StatelessWidgetExemplo('Olá Flutter - MaterialApp'),
    ),
    ('3 · Layout com Row e Column', Icons.view_column, const Microatividade3()),
    ('4 · ListView com ListTile', Icons.list, const Microatividade4()),
    ('5 · Stack (widgets empilhados)', Icons.layers, const Microatividade5()),
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: const Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Microatividades\nDGT2812',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          for (final (titulo, icone, tela) in itens)
            ListTile(
              leading: Icon(icone),
              title: Text(titulo),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => tela),
                );
              },
            ),
        ],
      ),
    );
  }
}

/// Microatividade 2: MaterialApp + Scaffold + AppBar + Text.
class StatelessWidgetExemplo extends StatelessWidget {
  final String _appBarTitle;
  const StatelessWidgetExemplo(this._appBarTitle, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_appBarTitle)),
      body: const Center(
        child: Text('Olá, Explore Mundo!', style: TextStyle(fontSize: 22)),
      ),
    );
  }
}

/// Microatividade 3: três Columns (ícone + texto) dentro de uma Row.
class Microatividade3 extends StatelessWidget {
  const Microatividade3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Row e Column')),
      body: const Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(children: <Widget>[Icon(Icons.call), Text('Call')]),
            Column(children: <Widget>[Icon(Icons.directions), Text('Route')]),
            Column(children: <Widget>[Icon(Icons.share), Text('Share')]),
          ],
        ),
      ),
    );
  }
}

/// Microatividade 4: ListView com três ListTile.
class Microatividade4 extends StatelessWidget {
  const Microatividade4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ListView')),
      body: ListView(
        children: const [
          ListTile(
            title: Text('Flutter'),
            subtitle: Text('Tudo é um widget'),
            leading: Icon(Icons.flash_on),
            trailing: Icon(Icons.keyboard_arrow_right),
          ),
          ListTile(
            title: Text('Dart'),
            subtitle: Text('É fácil'),
            leading: Icon(Icons.mood),
            trailing: Icon(Icons.keyboard_arrow_right),
          ),
          ListTile(
            title: Text('Firebase'),
            subtitle: Text('Combina com Flutter'),
            leading: Icon(Icons.whatshot),
            trailing: Icon(Icons.keyboard_arrow_right),
          ),
        ],
      ),
    );
  }
}

/// Microatividade 5: Stack com três Containers empilhados.
class Microatividade5 extends StatelessWidget {
  const Microatividade5({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stack')),
      body: Center(
        child: Stack(
          children: [
            Container(width: 250, height: 250, color: Colors.blue),
            Container(width: 200, height: 200, color: Colors.red),
            Container(width: 150, height: 150, color: Colors.yellow),
          ],
        ),
      ),
    );
  }
}
