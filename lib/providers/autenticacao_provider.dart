import 'package:flutter/material.dart';
import '../models/usuario_model.dart';
import '../database/banco_dados_helper.dart';

class AutenticacaoProvider with ChangeNotifier {
  UsuarioModel? _usuario;
  final BancoDadosHelper _dbHelper = BancoDadosHelper();

  UsuarioModel? get usuario => _usuario;

  bool get estaAutenticado => _usuario != null;

  Future<bool> login(String nomeUsuario, String senha) async {
    UsuarioModel? usuario = await _dbHelper.buscarUsuario(nomeUsuario, senha);
    if (usuario != null) {
      _usuario = usuario;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> registrar(String nomeUsuario, String senha) async {
    try {
      UsuarioModel novoUsuario = UsuarioModel(nomeUsuario: nomeUsuario, senha: senha);
      await _dbHelper.inserirUsuario(novoUsuario);
      return true;
    } catch (e) {
      return false;
    }
  }

  void logout() {
    _usuario = null;
    notifyListeners();
  }
}
