import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cachorro.dart';
import '../providers/cachorro_provider.dart';

/// Tela que exibe os detalhes de um cachorro selecionado,
/// permitindo visualizar informações e marcar como adotado.
class DetalhesScreen extends StatelessWidget {
  final Cachorro cachorro;

  const DetalhesScreen({super.key, required this.cachorro});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CachorroProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// Avatar central com imagem do cachorro (base64) ou ícone padrão
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage:
                    cachorro.imagemBytes != null
                        ? MemoryImage(cachorro.imagemBytes!)
                        : null,
                backgroundColor: const Color(0xFFF1F1F1),
                child:
                    cachorro.imagem == null
                        ? const Icon(Icons.pets, size: 40, color: Colors.grey)
                        : null,
              ),
            ),

            const SizedBox(height: 24),

            /// Nome do cachorro
            Text(
              cachorro.nome,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            /// Informações adicionais: raça, idade e tamanho
            Text(
              '${cachorro.raca} • ${cachorro.idade} • ${cachorro.tamanho}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 24),

            /// Seção de descrição
            const Text(
              'Descrição:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(cachorro.descricao),

            const Spacer(),

            /// Verifica se o cachorro já foi adotado
            cachorro.adotado
                ? Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, color: Colors.green),
                      SizedBox(width: 8),
                      Text(
                        'Já adotado',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
                : ElevatedButton.icon(
                  onPressed: () {
                    if (cachorro.id != null) {
                      // Marca como adotado e retorna para a tela anterior
                      provider.marcarComoAdotado(cachorro.id!);
                      Navigator.pop(context);
                    } else {
                      // Mostra erro se o ID estiver ausente
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Erro: ID do cachorro não disponível'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CB6AC), // fundo
                    foregroundColor: Colors.white, // texto branco
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  icon: const Icon(Icons.check),
                  label: const Text('Marcar como adotado'),
                ),
          ],
        ),
      ),
    );
  }
}
