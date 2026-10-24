import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'telas/contato.dart';
import 'telas/inicio.dart';
import 'telas/microatividades.dart';
import 'telas/pacotes.dart';
import 'telas/sobre.dart';

void main() => runApp(const MyApp());

const corBase = Color(0xFF00796B);

// estrelas: o âmbar padrão fica claro demais no fundo branco, por isso uma cor pra cada tema
const corEstrelaClaro = Color(0xFFB45309);
const corEstrelaEscuro = Color(0xFFFBBF24);

ColorScheme esquemaDeCores(Brightness brilho) =>
    ColorScheme.fromSeed(seedColor: corBase, brightness: brilho);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Explore Mundo',
      debugShowCheckedModeBanner: false,
      // deixa o calendário e os textos do Flutter em português
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [Locale('pt', 'BR')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: ThemeData(colorScheme: esquemaDeCores(Brightness.light)),
      darkTheme: ThemeData(colorScheme: esquemaDeCores(Brightness.dark)),
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const secoes = [
    Tab(icon: Icon(Icons.travel_explore), text: 'Destinos'),
    Tab(icon: Icon(Icons.card_travel), text: 'Pacotes'),
    Tab(icon: Icon(Icons.support_agent), text: 'Contato'),
    Tab(icon: Icon(Icons.info_outline), text: 'Sobre nós'),
  ];

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    return DefaultTabController(
      length: secoes.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: cores.primary,
          foregroundColor: cores.onPrimary,
          title: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.public),
              SizedBox(width: 8),
              Text(
                'Explore Mundo',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          bottom: TabBar(
            tabs: secoes,
            labelColor: cores.onPrimary,
            unselectedLabelColor: cores.onPrimary.withValues(alpha: 0.7),
            indicatorColor: cores.onPrimary,
          ),
        ),
        drawer: const MenuMicroatividades(),
        body: const LarguraMaxima(
          child: TabBarView(
            children: [InicioTab(), PacotesTab(), ContatoTab(), SobreTab()],
          ),
        ),
      ),
    );
  }
}

// no computador (site) o conteúdo não estica a tela toda
class LarguraMaxima extends StatelessWidget {
  final Widget child;
  const LarguraMaxima({super.key, required this.child});

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 900),
      child: child,
    ),
  );
}
