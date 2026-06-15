import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/autenticacao_provider.dart';
import '../providers/filme_provider.dart';
import 'tela_formulario_filme.dart';
import 'tela_login.dart';

class TelaListaFilmes extends StatefulWidget {
  const TelaListaFilmes({super.key});

  @override
  State<TelaListaFilmes> createState() => _TelaListaFilmesState();
}

class _TelaListaFilmesState extends State<TelaListaFilmes> {
  String _generoSelecionado = 'Todos';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = Provider.of<AutenticacaoProvider>(context, listen: false);
      if (auth.usuario != null) {
        Provider.of<FilmeProvider>(context, listen: false).buscarFilmes(auth.usuario!.id!);
      }
    });
  }

  void _sair() {
    Provider.of<AutenticacaoProvider>(context, listen: false).logout();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const TelaLogin()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AutenticacaoProvider>(context);
    final filmeProvider = Provider.of<FilmeProvider>(context);

    if (auth.usuario == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Filmes', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _sair),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Pesquisar título, diretor...',
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (valor) {
                filmeProvider.pesquisar(auth.usuario!.id!, valor);
              },
            ),
          ),
          FutureBuilder<List<String>>(
            future: filmeProvider.buscarGenerosDisponiveis(auth.usuario!.id!),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.length > 1) {
                return Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: snapshot.data!.map((genero) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(genero),
                          selected: _generoSelecionado == genero,
                          onSelected: (selecionado) {
                            setState(() => _generoSelecionado = genero);
                            filmeProvider.filtrar(auth.usuario!.id!, genero);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                );
              }
              return const SizedBox(height: 8);
            },
          ),
          Expanded(
            child: filmeProvider.estaCarregando
                ? const Center(child: CircularProgressIndicator())
                : filmeProvider.filmes.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.movie_outlined, size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'Nenhum filme encontrado',
                              style: TextStyle(color: Colors.grey[600], fontSize: 16),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: filmeProvider.filmes.length,
                        itemBuilder: (context, indice) {
                          final filme = filmeProvider.filmes[indice];
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text(
                                  filme.avaliacao.toStringAsFixed(1),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                              title: Text(filme.titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text('${filme.genero} • ${filme.anoLancamento}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => TelaFormularioFilme(filme: filme),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _confirmarExclusao(context, filme, auth.usuario!.id!),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const TelaFormularioFilme()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _confirmarExclusao(BuildContext context, dynamic filme, int usuarioId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir Filme'),
        content: Text('Deseja realmente excluir "${filme.titulo}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              Provider.of<FilmeProvider>(context, listen: false).excluirFilme(filme.id!, usuarioId);
              Navigator.of(ctx).pop();
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
