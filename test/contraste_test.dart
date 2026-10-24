// Mede o contraste das cores do app pela fórmula da WCAG.
// Mínimo: 4,5:1 pra texto normal e 3:1 pra texto grande e ícones.
import 'dart:math';

import 'package:explore_mundo/main.dart';
import 'package:explore_mundo/widgets/banner_destaque.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

double luminancia(Color c) {
  double canal(double v) =>
      v <= 0.03928 ? v / 12.92 : pow((v + 0.055) / 1.055, 2.4).toDouble();
  return 0.2126 * canal(c.r) + 0.7152 * canal(c.g) + 0.0722 * canal(c.b);
}

double contraste(Color a, Color b) {
  final la = luminancia(a), lb = luminancia(b);
  return (max(la, lb) + 0.05) / (min(la, lb) + 0.05);
}

/// Cor [frente] com transparência aplicada por cima de [fundo].
Color sobre(Color frente, Color fundo) =>
    Color.lerp(fundo, frente.withValues(alpha: 1), frente.a)!;

void main() {
  for (final brilho in Brightness.values) {
    final c = esquemaDeCores(brilho);
    final estrela = brilho == Brightness.dark
        ? corEstrelaEscuro
        : corEstrelaClaro;
    final nome = brilho == Brightness.dark ? 'escuro' : 'claro';

    group('tema $nome', () {
      test('texto principal e secundário', () {
        expect(contraste(c.onSurface, c.surface), greaterThanOrEqualTo(4.5));
        expect(
          contraste(c.onSurfaceVariant, c.surface),
          greaterThanOrEqualTo(4.5),
        );
        // os cards usam surfaceContainerLow de fundo
        expect(
          contraste(c.onSurfaceVariant, c.surfaceContainerLow),
          greaterThanOrEqualTo(4.5),
        );
      });

      test('botões LIGAR/ROTA/COMPARTILHAR e preço (cor primária)', () {
        expect(contraste(c.primary, c.surface), greaterThanOrEqualTo(4.5));
      });

      test('botão principal (FilledButton)', () {
        expect(contraste(c.onPrimary, c.primary), greaterThanOrEqualTo(4.5));
      });

      test('barra de navegação', () {
        expect(contraste(c.onPrimary, c.primary), greaterThanOrEqualTo(4.5));
        // abas não selecionadas usam o texto com 70% de opacidade
        final abaApagada = sobre(c.onPrimary.withValues(alpha: 0.7), c.primary);
        expect(contraste(abaApagada, c.primary), greaterThanOrEqualTo(3));
      });

      test('ícones das estrelas', () {
        expect(contraste(estrela, c.surface), greaterThanOrEqualTo(3));
        expect(
          contraste(estrela, c.surfaceContainerLow),
          greaterThanOrEqualTo(3),
        );
      });
    });
  }

  test('texto branco do banner, pior caso (foto toda branca)', () {
    // escuridão do degradê numa altura t (0 = topo, 1 = base do banner)
    Color fundoEm(double t) {
      final g = degradeBanner;
      final p = ((t - g.stops![0]) / (g.stops![1] - g.stops![0])).clamp(
        0.0,
        1.0,
      );
      final escuro = Color.lerp(g.colors[0], g.colors[1], p)!;
      return sobre(escuro, Colors.white);
    }

    // banner de 220 px: o nome (22 px, negrito = texto grande) começa ~60 px acima da base
    expect(
      contraste(Colors.white, fundoEm(160 / 220)),
      greaterThanOrEqualTo(3),
    );
    // o local (texto normal, branco 70%) fica ~32 px acima da base
    final fundoLocal = fundoEm(188 / 220);
    expect(
      contraste(sobre(Colors.white70, fundoLocal), fundoLocal),
      greaterThanOrEqualTo(4.5),
    );
  });
}
