class UsuarioModel {
  final int? id;
  final String nomeUsuario;
  final String senha;

  UsuarioModel({
    this.id,
    required this.nomeUsuario,
    required this.senha,
  });

  Map<String, dynamic> paraMapa() {
    return {
      'id': id,
      'nomeUsuario': nomeUsuario,
      'senha': senha,
    };
  }

  factory UsuarioModel.deMapa(Map<String, dynamic> mapa) {
    return UsuarioModel(
      id: mapa['id'],
      nomeUsuario: mapa['nomeUsuario'],
      senha: mapa['senha'],
    );
  }
}
