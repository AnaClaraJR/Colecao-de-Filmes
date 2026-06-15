import 'package:flutter/material.dart';
import '../models/filme_model.dart';
import '../database/banco_dados_helper.dart';

class FilmeProvider with ChangeNotifier {
  final BancoDadosHelper _dbHelper = BancoDadosHelper();
  List<FilmeModel> _filmes = [];
  bool _estaCarregando = false;

  List<FilmeModel> get filmes => _filmes;
  bool get estaCarregando => _estaCarregando;

  Future<void> buscarFilmes(int usuarioId) async {
    _estaCarregando = true;
    notifyListeners();
    _filmes = await _dbHelper.buscarFilmesPorUsuario(usuarioId);
    _estaCarregando = false;
    notifyListeners();
  }

  Future<void> adicionarFilme(FilmeModel filme) async {
    await _dbHelper.inserirFilme(filme);
    await buscarFilmes(filme.usuarioId);
  }

  Future<void> atualizarFilme(FilmeModel filme) async {
    await _dbHelper.atualizarFilme(filme);
    await buscarFilmes(filme.usuarioId);
  }

  Future<void> excluirFilme(int filmeId, int usuarioId) async {
    await _dbHelper.excluirFilme(filmeId);
    await buscarFilmes(usuarioId);
  }

  Future<void> pesquisar(int usuarioId, String consulta) async {
    if (consulta.isEmpty) {
      await buscarFilmes(usuarioId);
    } else {
      _estaCarregando = true;
      notifyListeners();
      _filmes = await _dbHelper.pesquisarFilmes(usuarioId, consulta);
      _estaCarregando = false;
      notifyListeners();
    }
  }

  Future<void> filtrar(int usuarioId, String genero) async {
    if (genero == 'Todos' || genero.isEmpty) {
      await buscarFilmes(usuarioId);
    } else {
      _estaCarregando = true;
      notifyListeners();
      _filmes = await _dbHelper.filtrarPorGenero(usuarioId, genero);
      _estaCarregando = false;
      notifyListeners();
    }
  }

  Future<List<String>> buscarGenerosDisponiveis(int usuarioId) async {
    List<String> generos = await _dbHelper.buscarGeneros(usuarioId);
    return ['Todos', ...generos];
  }
}
