import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/autenticacao_provider.dart';
import 'tela_cadastro.dart';
import 'tela_lista_filmes.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _controleUsuario = TextEditingController();
  final _controleSenha = TextEditingController();
  bool _estaCarregando = false;

  Future<void> _entrar() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    if (_controleUsuario.text.isEmpty || _controleSenha.text.isEmpty) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos')),
      );
      return;
    }

    setState(() => _estaCarregando = true);
    try {
      final authProvider = Provider.of<AutenticacaoProvider>(context, listen: false);
      bool sucesso = await authProvider.login(
        _controleUsuario.text,
        _controleSenha.text,
      );

      if (sucesso) {
        navigator.pushReplacement(
          MaterialPageRoute(builder: (_) => const TelaListaFilmes()),
        );
      } else {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Usuário ou senha inválidos')),
        );
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Erro: $e')),
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
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.movie_filter, size: 80, color: Color(0xff1A237E)),
              const SizedBox(height: 16),
              const Text(
                'CineCatalog',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff1A237E),
                ),
              ),
              const SizedBox(height: 32),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _controleUsuario,
                        decoration: const InputDecoration(
                          labelText: 'Usuário',
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _controleSenha,
                        decoration: const InputDecoration(
                          labelText: 'Senha',
                          prefixIcon: Icon(Icons.lock),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: _estaCarregando
                            ? const Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                                onPressed: _entrar,
                                child: const Text('ENTRAR'),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const TelaCadastro()),
                  );
                },
                child: const Text('Não tem uma conta? Cadastre-se'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controleUsuario.dispose();
    _controleSenha.dispose();
    super.dispose();
  }
}
