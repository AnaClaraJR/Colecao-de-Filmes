import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../models/usuario_model.dart';
import '../models/filme_model.dart';

class BancoDadosHelper {
  static final BancoDadosHelper _instancia = BancoDadosHelper._interno();
  factory BancoDadosHelper() => _instancia;
  BancoDadosHelper._interno();

  static Database? _bancoDados;

  Future<Database> get bancoDados async {
    if (_bancoDados != null) return _bancoDados!;
    _bancoDados = await _inicializarBanco();
    return _bancoDados!;
  }

  Future<Database> _inicializarBanco() async {
    if (!kIsWeb && (Platform.isWindows || Platform.isLinux)) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    if (kIsWeb) {
      throw Exception("SQLite não suportado no navegador.");
    }

    String caminho = join(await getDatabasesPath(), 'colecao_filmes.db');
    return await openDatabase(
      caminho,
      version: 1,
      onCreate: _aoCriar,
    );
  }

  Future _aoCriar(Database db, int versao) async {
    await db.execute('''
      CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nomeUsuario TEXT NOT NULL UNIQUE,
        senha TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE filmes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        diretor TEXT NOT NULL,
        genero TEXT NOT NULL,
        anoLancamento INTEGER NOT NULL,
        avaliacao REAL NOT NULL,
        usuarioId INTEGER NOT NULL,
        FOREIGN KEY (usuarioId) REFERENCES usuarios (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<int> inserirUsuario(UsuarioModel usuario) async {
    Database db = await bancoDados;
    return await db.insert('usuarios', usuario.paraMapa());
  }

  Future<UsuarioModel?> buscarUsuario(String nomeUsuario, String senha) async {
    Database db = await bancoDados;
    List<Map<String, dynamic>> mapas = await db.query(
      'usuarios',
      where: 'nomeUsuario = ? AND senha = ?',
      whereArgs: [nomeUsuario, senha],
    );
    if (mapas.isNotEmpty) {
      return UsuarioModel.deMapa(mapas.first);
    }
    return null;
  }

  Future<int> inserirFilme(FilmeModel filme) async {
    Database db = await bancoDados;
    return await db.insert('filmes', filme.paraMapa());
  }

  Future<List<FilmeModel>> buscarFilmesPorUsuario(int usuarioId) async {
    Database db = await bancoDados;
    List<Map<String, dynamic>> mapas = await db.query(
      'filmes',
      where: 'usuarioId = ?',
      whereArgs: [usuarioId],
    );
    return List.generate(mapas.length, (i) {
      return FilmeModel.deMapa(mapas[i]);
    });
  }

  Future<int> atualizarFilme(FilmeModel filme) async {
    Database db = await bancoDados;
    return await db.update(
      'filmes',
      filme.paraMapa(),
      where: 'id = ?',
      whereArgs: [filme.id],
    );
  }

  Future<int> excluirFilme(int id) async {
    Database db = await bancoDados;
    return await db.delete(
      'filmes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<FilmeModel>> pesquisarFilmes(int usuarioId, String consulta) async {
    Database db = await bancoDados;
    List<Map<String, dynamic>> mapas = await db.query(
      'filmes',
      where: 'usuarioId = ? AND (titulo LIKE ? OR diretor LIKE ? OR genero LIKE ?)',
      whereArgs: [usuarioId, '%$consulta%', '%$consulta%', '%$consulta%'],
    );
    return List.generate(mapas.length, (i) {
      return FilmeModel.deMapa(mapas[i]);
    });
  }

  Future<List<FilmeModel>> filtrarPorGenero(int usuarioId, String genero) async {
    Database db = await bancoDados;
    List<Map<String, dynamic>> mapas = await db.query(
      'filmes',
      where: 'usuarioId = ? AND genero = ?',
      whereArgs: [usuarioId, genero],
    );
    return List.generate(mapas.length, (i) {
      return FilmeModel.deMapa(mapas[i]);
    });
  }

  Future<List<String>> buscarGeneros(int usuarioId) async {
    Database db = await bancoDados;
    List<Map<String, dynamic>> mapas = await db.rawQuery(
      'SELECT DISTINCT genero FROM filmes WHERE usuarioId = ?',
      [usuarioId],
    );
    return List.generate(mapas.length, (i) {
      return mapas[i]['genero'] as String;
    });
  }
}
