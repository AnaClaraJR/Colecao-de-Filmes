import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/filme_model.dart';
import '../providers/autenticacao_provider.dart';
import '../providers/filme_provider.dart';

class TelaFormularioFilme extends StatefulWidget {
  final FilmeModel? filme;

  const TelaFormularioFilme({super.key, this.filme});

  @override
  State<TelaFormularioFilme> createState() => _TelaFormularioFilmeState();
}

class _TelaFormularioFilmeState extends State<TelaFormularioFilme> {
  final _chaveFormulario = GlobalKey<FormState>();
  late String _titulo;
  late String _diretor;
  late String _genero;
  late int _anoLancamento;
  late double _avaliacao;
  bool _estaSalvando = false;

  @override
  void initState() {
    super.initState();
    _titulo = widget.filme?.titulo ?? '';
    _diretor = widget.filme?.diretor ?? '';
    _genero = widget.filme?.genero ?? '';
    _anoLancamento = widget.filme?.anoLancamento ?? DateTime.now().year;
    _avaliacao = widget.filme?.avaliacao ?? 0.0;
  }

  Future<void> _salvarFormulario() async {
    if (_chaveFormulario.currentState!.validate()) {
      _chaveFormulario.currentState!.save();
      setState(() => _estaSalvando = true);

      final scaffoldMessenger = ScaffoldMessenger.of(context);
      final navigator = Navigator.of(context);

      try {
        final auth = Provider.of<AutenticacaoProvider>(context, listen: false);
        final filmeProvider = Provider.of<FilmeProvider>(context, listen: false);

        if (widget.filme == null) {
          await filmeProvider.adicionarFilme(FilmeModel(
            titulo: _titulo,
            diretor: _diretor,
            genero: _genero,
            anoLancamento: _anoLancamento,
            avaliacao: _avaliacao,
            usuarioId: auth.usuario!.id!,
          ));
        } else {
          await filmeProvider.atualizarFilme(widget.filme!.copiarCom(
            titulo: _titulo,
            diretor: _diretor,
            genero: _genero,
            anoLancamento: _anoLancamento,
            avaliacao: _avaliacao,
          ));
        }
        
        navigator.pop();
      } catch (e) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Erro ao salvar: $e')),
        );
      } finally {
        if (mounted) {
          setState(() => _estaSalvando = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.filme == null ? 'Novo Filme' : 'Editar Filme'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _chaveFormulario,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  initialValue: _titulo,
                  decoration: const InputDecoration(labelText: 'Título'),
                  validator: (valor) => valor!.isEmpty ? 'Campo obrigatório' : null,
                  onSaved: (valor) => _titulo = valor!,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _diretor,
                  decoration: const InputDecoration(labelText: 'Diretor'),
                  validator: (valor) => valor!.isEmpty ? 'Campo obrigatório' : null,
                  onSaved: (valor) => _diretor = valor!,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _genero,
                  decoration: const InputDecoration(labelText: 'Gênero'),
                  validator: (valor) => valor!.isEmpty ? 'Campo obrigatório' : null,
                  onSaved: (valor) => _genero = valor!,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: _anoLancamento.toString(),
                        decoration: const InputDecoration(labelText: 'Ano'),
                        keyboardType: TextInputType.number,
            validator: (valor) {
              if (valor == null || valor.isEmpty) {
                return 'Campo obrigatório';
              }

              final ano = int.tryParse(valor);
              if (ano == null) {
                return 'Insira um ano válido';
              }

              if (ano < 1885) {
                return 'O ano não pode ser anterior a 1885';
              }

              if (ano > 2026) {
                return 'O ano não pode ser maior do que 2026';
              }

              return null;
            },
            onSaved: (valor) => _anoLancamento = int.parse(valor!),
          ),

                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        initialValue: _avaliacao.toString(),
                        decoration: const InputDecoration(labelText: 'Nota (0-10)'),
                        keyboardType: TextInputType.number,
                        validator: (valor) {
                          final avaliacao = double.tryParse(valor!);
                          if (avaliacao == null || avaliacao < 0 || avaliacao > 10) return '0 a 10';
                          return null;
                        },
                        onSaved: (valor) => _avaliacao = double.parse(valor!),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: _estaSalvando
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _salvarFormulario,
                          child: const Text('SALVAR FILME'),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
