import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/autenticacao_provider.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final _controleUsuario = TextEditingController();
  final _controleSenha = TextEditingController();
  final _controleConfirmarSenha = TextEditingController();
  bool _estaCarregando = false;

  Future<void> _registrar() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    if (_controleUsuario.text.isEmpty || _controleSenha.text.isEmpty) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos')),
      );
      return;
    }

    if (_controleSenha.text != _controleConfirmarSenha.text) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('As senhas não coincidem')),
      );
      return;
    }

    setState(() => _estaCarregando = true);
    try {
      final authProvider = Provider.of<AutenticacaoProvider>(context, listen: false);
      bool sucesso = await authProvider.registrar(
        _controleUsuario.text,
        _controleSenha.text,
      );

      if (sucesso) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Usuário cadastrado com sucesso!')),
        );
        navigator.pop();
      } else {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Erro ao cadastrar usuário (usuário já existe?)')),
        );
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Erro inesperado: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _estaCarregando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Usuário')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _controleUsuario,
                    decoration: const InputDecoration(
                      labelText: 'Novo Usuário',
                      prefixIcon: Icon(Icons.person_add),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _controleSenha,
                    decoration: const InputDecoration(
                      labelText: 'Senha',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _controleConfirmarSenha,
                    decoration: const InputDecoration(
                      labelText: 'Confirmar Senha',
                      prefixIcon: Icon(Icons.lock_reset),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: _estaCarregando
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: _registrar,
                            child: const Text('CADASTRAR'),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controleUsuario.dispose();
    _controleSenha.dispose();
    _controleConfirmarSenha.dispose();
    super.dispose();
  }
}
