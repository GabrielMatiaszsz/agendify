import 'package:flutter/material.dart';
import '../models/cachorro.dart';
import '../screens/detalhes_screen.dart';

/// Widget personalizado que representa um card de cachorro na listagem.
/// Mostra imagem, nome, raça, tamanho e status de adoção.
/// Ao clicar, leva para a tela de detalhes do cachorro.
class CachorroTile extends StatelessWidget {
  final Cachorro cachorro;

  const CachorroTile({super.key, required this.cachorro});

  @override
  Widget build(BuildContext context) {
    /// Define a cor do ícone com base no status de adoção
    final corAdocao = cachorro.adotado ? Colors.green : Colors.grey;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3, // sombra do card
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),

        /// Avatar circular com a imagem base64 ou ícone padrão
        leading: CircleAvatar(
          radius: 28,
          backgroundImage:
              cachorro.imagemBytes != null
                  ? MemoryImage(cachorro.imagemBytes!)
                  : null,
          backgroundColor: Colors.teal[50],
          child:
              cachorro.imagem == null
                  ? const Icon(Icons.pets, size: 28, color: Colors.teal)
                  : null,
        ),

        /// Nome do cachorro em destaque
        title: Text(
          cachorro.nome,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),

        /// Raça e tamanho do cachorro
        subtitle: Text('${cachorro.raca} • ${cachorro.tamanho}'),

        /// Ícone de status: adotado (verde) ou disponível (cinza)
        trailing: Icon(
          cachorro.adotado ? Icons.check_circle : Icons.check_circle_outline,
          color: corAdocao,
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
