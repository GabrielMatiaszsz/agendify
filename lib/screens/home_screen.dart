import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cachorro.dart';
import '../providers/cachorro_provider.dart';
import 'cadastro_screen.dart';
import 'detalhes_screen.dart';

/// Tela principal que exibe a listagem dos cachorros para adoção,
/// com funcionalidades de busca e filtros.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _buscaController = TextEditingController();

  /// Filtros selecionados pelo usuário
  String _filtroTamanho = 'Todos';
  String _filtroStatus = 'Todos';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CachorroProvider>(context);
    final todos = provider.cachorros;

    /// Aplica os filtros: busca por nome/raça, tamanho e status
    final resultado =
        todos.where((c) {
          final textoBusca = _buscaController.text.toLowerCase();

          // Verifica se o nome ou raça contém o texto da busca
          final condNomeOuRaca =
              c.nome.toLowerCase().contains(textoBusca) ||
              c.raca.toLowerCase().contains(textoBusca);

          // Verifica o filtro de tamanho
          final condTamanho =
              _filtroTamanho == 'Todos' || c.tamanho == _filtroTamanho;

          // Verifica o filtro de status de adoção
          final condStatus =
              _filtroStatus == 'Todos' ||
              (_filtroStatus == 'Disponíveis' && !c.adotado) ||
              (_filtroStatus == 'Adotados' && c.adotado);

          return condNomeOuRaca && condTamanho && condStatus;
        }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Cachorros para Adoção')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Campo de busca por nome ou raça
            TextField(
              controller: _buscaController,
              decoration: const InputDecoration(
                hintText: 'Buscar por nome ou raça...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (_) => setState(() {}), // Atualiza a lista ao digitar
            ),
            const SizedBox(height: 12),

            /// Filtros por tamanho e status
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _filtroTamanho,
                    decoration: const InputDecoration(labelText: 'Tamanho'),
                    items:
                        ['Todos', 'Pequeno', 'Médio', 'Grande']
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                    onChanged:
                        (v) => setState(() => _filtroTamanho = v ?? 'Todos'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _filtroStatus,
                    decoration: const InputDecoration(labelText: 'Status'),
                    items:
                        ['Todos', 'Disponíveis', 'Adotados']
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                    onChanged:
                        (v) => setState(() => _filtroStatus = v ?? 'Todos'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            /// Exibe os resultados (lista de cards ou mensagem vazia)
            Expanded(
              child:
                  resultado.isEmpty
                      ? const Center(
                        child: Text('Nenhum resultado encontrado.'),
                      )
                      : ListView.builder(
                        itemCount: resultado.length,
                        itemBuilder: (context, index) {
                          final cachorro = resultado[index];
                          return _CachorroCard(cachorro: cachorro);
                        },
                      ),
            ),
          ],
        ),
      ),

      /// Botão flutuante para navegar à tela de cadastro
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4CB6AC),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CadastroScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// Widget que representa visualmente um cachorro em forma de card.
class _CachorroCard extends StatelessWidget {
  final Cachorro cachorro;

  const _CachorroCard({required this.cachorro});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),

        /// Exibe a imagem, se houver, ou ícone padrão
        leading: CircleAvatar(
          radius: 30,
          backgroundImage:
              cachorro.imagemBytes != null
                  ? MemoryImage(cachorro.imagemBytes!)
                  : null,
          backgroundColor: const Color(0xFFF1F1F1),
          child:
              cachorro.imagem == null
                  ? const Icon(Icons.pets, color: Colors.grey)
                  : null,
        ),

        /// Nome e detalhes do cachorro
        title: Text(
          cachorro.nome,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${cachorro.raca} • ${cachorro.tamanho}'),

        /// Ícone de status (adotado ou não)
        trailing: Icon(
          cachorro.adotado ? Icons.check_circle : Icons.check_circle_outline,
          color: cachorro.adotado ? Colors.green : Colors.grey,
        ),

        /// Ao tocar no card, abre a tela de detalhes
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetalhesScreen(cachorro: cachorro),
            ),
          );
        },
      ),
    );
  }
}
