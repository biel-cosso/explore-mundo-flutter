# Explore Mundo (Flutter)

Trabalho prático da disciplina **DGT2812 - Desenvolvimento de Aplicativos Móveis com Flutter** (Estácio),
missão "Posso criar um App de outra forma!".
Aluno: Gabriel Cosso

App da agência de viagens Explore Mundo (caso do enunciado), feito em Flutter. O mesmo código gera o app Android e o
site complementar que a agência pediu.

- Site: https://biel-cosso.github.io/explore-mundo-flutter/
- Documentação com os prints: [docs/Documentacao-DGT2812.pdf](docs/Documentacao-DGT2812.pdf)

## Prints

<table>
  <tr>
    <td align="center"><img src="docs/prints/01-inicio.png" width="200"><br>Início</td>
    <td align="center"><img src="docs/prints/07-pesquisa.png" width="200"><br>Pesquisa</td>
    <td align="center"><img src="docs/prints/02-destino.png" width="200"><br>Destino</td>
    <td align="center"><img src="docs/prints/04-avaliacoes.png" width="200"><br>Avaliações</td>
  </tr>
  <tr>
    <td align="center"><img src="docs/prints/05-reserva.png" width="200"><br>Reserva</td>
    <td align="center"><img src="docs/prints/06-reserva-confirmada.png" width="200"><br>Reserva solicitada</td>
    <td align="center"><img src="docs/prints/08-pacotes.png" width="200"><br>Pacotes</td>
    <td align="center"><img src="docs/prints/09-contato.png" width="200"><br>Contato</td>
  </tr>
  <tr>
    <td align="center"><img src="docs/prints/10-sobre.png" width="200"><br>Sobre nós</td>
    <td align="center"><img src="docs/prints/11-menu-microatividades.png" width="200"><br>Menu das microatividades</td>
    <td align="center"><img src="docs/prints/17-tema-escuro.png" width="200"><br>Tema escuro</td>
    <td align="center"><img src="docs/prints/18-tema-escuro-destino.png" width="200"><br>Destino no tema escuro</td>
  </tr>
</table>

Microatividades 2 a 5:

<table>
  <tr>
    <td align="center"><img src="docs/prints/12-micro2-materialapp.png" width="200"><br>MaterialApp, Scaffold e AppBar</td>
    <td align="center"><img src="docs/prints/13-micro3-row-column.png" width="200"><br>Row e Column</td>
    <td align="center"><img src="docs/prints/14-micro4-listview.png" width="200"><br>ListView</td>
    <td align="center"><img src="docs/prints/15-micro5-stack.png" width="200"><br>Stack</td>
  </tr>
</table>

Site (versão web):

<img src="docs/prints/16-site-web.png" width="820">

## O que tem no app

- Banner de destaque com fotos dos destinos que trocam sozinhas, tocar na foto abre o destino
- Barra de navegação com Destinos, Pacotes, Contato e Sobre nós
- Pesquisa rápida (procura no nome, país e descrição, sem ligar para acento)
- Página de cada destino montada como no roteiro (passos 5 a 9): foto, título, botões LIGAR/ROTA/COMPARTILHAR e texto,
  tudo dentro de uma ListView. Também mostra as avaliações dos clientes
- Estrela de favorito que soma/desfaz (a "funcionalidade personalizada" pedida nos objetivos)
- Reserva com nome, data e número de pessoas, calculando o total
- Menu lateral com uma tela para cada microatividade (2 a 5)
- Tema claro e escuro, seguindo o celular

## Pastas

```
lib/main.dart            MaterialApp, tema e a tela principal com as abas
lib/dados.dart           destinos, pacotes e avaliações
lib/telas/               uma tela por arquivo (inicio, destino, pacotes, contato, sobre, microatividades)
lib/widgets/             banner, favorito e formulário de reserva
images/                  fotos dos destinos (créditos em images/CREDITOS.md)
test/                    testes
```

## Como rodar

```
flutter pub get
flutter run              (com o emulador Android aberto)
flutter run -d chrome    (versão web)
flutter test             (testes)
```

## Observações

- O `RaisedButton` citado nos objetivos foi removido do Flutter, então usei os botões novos (`FilledButton` e
  `ElevatedButton`).
- A agência, os preços, as avaliações e os contatos são inventados para o trabalho. A reserva e o formulário de contato
  não enviam nada, só mostram a confirmação.
- As fotos são do Wikimedia Commons, com licenças livres. Os autores estão em `images/CREDITOS.md`.
