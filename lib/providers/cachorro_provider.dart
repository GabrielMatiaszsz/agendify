import 'package:flutter/material.dart';
import '../models/cachorro.dart';
import '../repositories/cachorro_repository.dart';

/// Provider responsável por gerenciar o estado dos cachorros no app.
/// Ele interage com o repositório (que acessa a API) e notifica os widgets quando necessário.
class CachorroProvider with ChangeNotifier {
  /// Repositório responsável por se comunicar com a API Flask.
  final CachorroRepository _repository = CachorroRepository();

  /// Lista interna de cachorros, atualizada ao buscar da API.
  List<Cachorro> _cachorros = [];

  /// Getter público para a lista de cachorros.
  List<Cachorro> get cachorros => _cachorros;

  /// Indica se a aplicação está carregando os dados.
  bool carregando = false;

  /// Carrega todos os cachorros da API e atualiza o estado.
  Future<void> carregarCachorros() async {
    carregando = true;
    notifyListeners(); // notifica a UI para mostrar loading, se necessário

    try {
      _cachorros = await _repository.buscarTodos(); // busca todos da API
    } catch (e) {
      print('Erro ao buscar cachorros: $e');
    }

    carregando = false;
    notifyListeners(); // atualiza a tela com os dados
  }

  /// Adiciona um novo cachorro à base de dados via API e recarrega a lista.
  Future<void> adicionarCachorro({
    required String nome,
    required String raca,
    required String idade,
    required String tamanho,
    required String descricao,
    String? imagem,
  }) async {
    final novo = Cachorro(
      nome: nome,
      raca: raca,
      idade: idade,
      tamanho: tamanho,
      descricao: descricao,
      imagem: imagem,
    );

    try {
      await _repository.adicionarCachorro(novo); // envia para o backend
      await carregarCachorros(); // recarrega a lista após adicionar
    } catch (e) {
      print('Erro ao adicionar cachorro: $e');
    }
  }

  /// Marca um cachorro como adotado na API e atualiza o estado local.
  Future<void> marcarComoAdotado(String id) async {
    try {
      await _repository.marcarComoAdotado(id); // PATCH na API
      await carregarCachorros(); // atualiza o estado local
    } catch (e) {
      print('Erro ao marcar como adotado: $e');
    }
  }
}
