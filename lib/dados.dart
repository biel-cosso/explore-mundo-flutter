// Dados da agência Explore Mundo (fictícia). Preços e avaliações são só exemplo,
// as descrições dos lugares são reais.

class Destino {
  final String id;
  final String nome;
  final String local;
  final String imagem;
  final double nota; // média das avaliações (0 a 5)
  final int favoritos; // quantas pessoas marcaram como favorito
  final String descricao;
  final double latitude;
  final double longitude;
  final List<Avaliacao> avaliacoes;

  const Destino({
    required this.id,
    required this.nome,
    required this.local,
    required this.imagem,
    required this.nota,
    required this.favoritos,
    required this.descricao,
    required this.latitude,
    required this.longitude,
    this.avaliacoes = const [],
  });

  // usado na pesquisa: procura no nome, local e descrição, ignorando acento
  bool combinaCom(String busca) {
    final b = semAcento(busca.trim().toLowerCase());
    if (b.isEmpty) return true;
    return semAcento('$nome $local $descricao'.toLowerCase()).contains(b);
  }
}

class Avaliacao {
  final String autor;
  final int estrelas;
  final String comentario;
  const Avaliacao(this.autor, this.estrelas, this.comentario);
}

class Pacote {
  final String destinoId;
  final String titulo;
  final int noites;
  final String inclui;
  final double precoPorPessoa;
  const Pacote(
    this.destinoId,
    this.titulo,
    this.noites,
    this.inclui,
    this.precoPorPessoa,
  );
}

String semAcento(String s) {
  const de = 'áàâãäéèêëíìîïóòôõöúùûüçñ';
  const para = 'aaaaaeeeeiiiiooooouuuucn';
  final sb = StringBuffer();
  for (final c in s.split('')) {
    final i = de.indexOf(c);
    sb.write(i >= 0 ? para[i] : c);
  }
  return sb.toString();
}

/// plural('resultado', 'resultados', 1) -> "1 resultado"
String plural(int n, String singular, String pluralDaPalavra) =>
    '$n ${n == 1 ? singular : pluralDaPalavra}';

String formatarReais(double v) {
  final inteiro = v.round().toString();
  final partes = <String>[];
  for (var i = inteiro.length; i > 0; i -= 3) {
    partes.insert(0, inteiro.substring(i - 3 < 0 ? 0 : i - 3, i));
  }
  return 'R\$ ${partes.join('.')}';
}

const destinos = <Destino>[
  Destino(
    id: 'oeschinen',
    nome: 'Lago Oeschinen',
    local: 'Kandersteg, Suíça',
    imagem: 'images/lake.jpg',
    nota: 4.9,
    favoritos: 41,
    latitude: 46.4983,
    longitude: 7.7272,
    descricao:
        'O Lago Oeschinen fica aos pés do Blüemlisalp, nos Alpes Berneses. Situado a 1.578 metros acima do '
        'nível do mar, é um dos lagos alpinos mais amplos. Um passeio de teleférico a partir de Kandersteg, '
        'seguido por meia hora de caminhada por pastagens e floresta de pinheiros, leva você ao lago, que '
        'aquece até 20 graus Celsius no verão. As atividades incluem remo e tobogã de verão.',
    avaliacoes: [
      Avaliacao(
        'M. S.',
        5,
        'A água tem uma cor inacreditável. Vale cada minuto da trilha.',
      ),
      Avaliacao(
        'R. A.',
        5,
        'O teleférico já é um passeio. Leve casaco, venta bastante.',
      ),
      Avaliacao('C. L.', 4, 'Lindo! No verão fica cheio, chegue cedo.'),
    ],
  ),
  Destino(
    id: 'rio',
    nome: 'Rio de Janeiro',
    local: 'Rio de Janeiro, Brasil',
    imagem: 'images/rio.jpg',
    nota: 4.8,
    favoritos: 87,
    latitude: -22.9519,
    longitude: -43.2105,
    descricao:
        'A Cidade Maravilhosa reúne praias famosas como Copacabana e Ipanema, o Cristo Redentor no alto do '
        'Corcovado e o bondinho do Pão de Açúcar, de onde se vê a Baía de Guanabara. O pacote inclui '
        'passeios guiados aos principais cartões-postais e tempo livre para aproveitar a orla.',
    avaliacoes: [
      Avaliacao('J. P.', 5, 'O pôr do sol no Pão de Açúcar é imperdível.'),
      Avaliacao('A. C.', 4, 'Cidade linda, guia muito atencioso no Corcovado.'),
    ],
  ),
  Destino(
    id: 'noronha',
    nome: 'Fernando de Noronha',
    local: 'Pernambuco, Brasil',
    imagem: 'images/noronha.jpg',
    nota: 4.9,
    favoritos: 64,
    latitude: -3.8549,
    longitude: -32.4239,
    descricao:
        'Arquipélago vulcânico no Atlântico, com parte da área protegida pelo Parque Nacional Marinho. '
        'É conhecido pelas águas cristalinas, pelo Morro do Pico, pela Baía do Sancho e pelos golfinhos-'
        'rotadores. O número de visitantes é controlado e há taxa de preservação ambiental.',
    avaliacoes: [
      Avaliacao(
        'L. M.',
        5,
        'Mergulho com tartarugas foi a melhor experiência da vida.',
      ),
      Avaliacao(
        'F. R.',
        5,
        'Paraíso. Reserve os passeios do parque com antecedência.',
      ),
    ],
  ),
  Destino(
    id: 'paris',
    nome: 'Paris',
    local: 'Île-de-France, França',
    imagem: 'images/paris.jpg',
    nota: 4.7,
    favoritos: 92,
    latitude: 48.8584,
    longitude: 2.2945,
    descricao:
        'A capital francesa encanta com a Torre Eiffel, construída para a Exposição Universal de 1889, o '
        'Museu do Louvre, a Catedral de Notre-Dame e os passeios de barco pelo Rio Sena. Na primavera, '
        'os jardins e parques da cidade ficam floridos.',
    avaliacoes: [
      Avaliacao('B. T.', 5, 'Subir a Torre Eiffel à noite é mágico.'),
      Avaliacao(
        'G. N.',
        4,
        'Muita coisa pra ver; recomendo ficar pelo menos 5 noites.',
      ),
    ],
  ),
  Destino(
    id: 'machu',
    nome: 'Machu Picchu',
    local: 'Cusco, Peru',
    imagem: 'images/machu-picchu.jpg',
    nota: 4.9,
    favoritos: 58,
    latitude: -13.1631,
    longitude: -72.5450,
    descricao:
        'Cidadela inca do século XV construída no alto dos Andes, a cerca de 2.430 metros de altitude. '
        'Patrimônio Mundial da UNESCO desde 1983, é acessada de trem até Aguas Calientes e depois de ônibus, '
        'ou pela tradicional Trilha Inca.',
    avaliacoes: [
      Avaliacao('D. F.', 5, 'Ver o nascer do sol lá de cima não tem preço.'),
      Avaliacao(
        'P. O.',
        5,
        'Organização impecável, guia explicou toda a história.',
      ),
    ],
  ),
  Destino(
    id: 'lencois',
    nome: 'Lençóis Maranhenses',
    local: 'Maranhão, Brasil',
    imagem: 'images/lencois.jpg',
    nota: 4.8,
    favoritos: 49,
    latitude: -2.5333,
    longitude: -43.1167,
    descricao:
        'Parque Nacional com enormes dunas de areia branca que, na época das chuvas, formam lagoas de água '
        'doce entre elas. As lagoas costumam estar mais cheias entre junho e setembro. Os passeios saem de '
        'Barreirinhas em veículos 4x4.',
    avaliacoes: [
      Avaliacao(
        'S. V.',
        5,
        'Parece outro planeta. Fui em julho, lagoas cheias.',
      ),
      Avaliacao('E. K.', 4, 'Passeio de 4x4 é animado. Leve protetor solar!'),
    ],
  ),
];

const pacotes = <Pacote>[
  Pacote(
    'rio',
    'Rio Clássico',
    4,
    'Aéreo + hotel em Copacabana + Cristo e Pão de Açúcar',
    2890,
  ),
  Pacote(
    'noronha',
    'Noronha Mergulho',
    5,
    'Aéreo + pousada + taxa de preservação + mergulho',
    6450,
  ),
  Pacote(
    'lencois',
    'Lençóis de 4x4',
    4,
    'Aéreo + hotel em Barreirinhas + passeios 4x4',
    3290,
  ),
  Pacote(
    'machu',
    'Caminhos Incas',
    6,
    'Aéreo + hotéis + trem + ingresso Machu Picchu',
    7980,
  ),
  Pacote(
    'paris',
    'Paris Primavera',
    7,
    'Aéreo + hotel + Torre Eiffel + passeio no Sena',
    11900,
  ),
  Pacote(
    'oeschinen',
    'Alpes Suíços',
    6,
    'Aéreo + hotel em Kandersteg + teleférico',
    13400,
  ),
];

Destino destinoPorId(String id) => destinos.firstWhere((d) => d.id == id);
