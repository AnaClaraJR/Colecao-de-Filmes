class FilmeModel {
  final int? id;
  final String titulo;
  final String diretor;
  final String genero;
  final int anoLancamento;
  final double avaliacao;
  final int usuarioId;

  FilmeModel({
    this.id,
    required this.titulo,
    required this.diretor,
    required this.genero,
    required this.anoLancamento,
    required this.avaliacao,
    required this.usuarioId,
  });

  Map<String, dynamic> paraMapa() {
    return {
      'id': id,
      'titulo': titulo,
      'diretor': diretor,
      'genero': genero,
      'anoLancamento': anoLancamento,
      'avaliacao': avaliacao,
      'usuarioId': usuarioId,
    };
  }

  factory FilmeModel.deMapa(Map<String, dynamic> mapa) {
    return FilmeModel(
      id: mapa['id'],
      titulo: mapa['titulo'],
      diretor: mapa['diretor'],
      genero: mapa['genero'],
      anoLancamento: mapa['anoLancamento'],
      avaliacao: (mapa['avaliacao'] as num).toDouble(),
      usuarioId: mapa['usuarioId'],
    );
  }

  FilmeModel copiarCom({
    int? id,
    String? titulo,
    String? diretor,
    String? genero,
    int? anoLancamento,
    double? avaliacao,
    int? usuarioId,
  }) {
    return FilmeModel(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      diretor: diretor ?? this.diretor,
      genero: genero ?? this.genero,
      anoLancamento: anoLancamento ?? this.anoLancamento,
      avaliacao: avaliacao ?? this.avaliacao,
      usuarioId: usuarioId ?? this.usuarioId,
    );
  }
}
