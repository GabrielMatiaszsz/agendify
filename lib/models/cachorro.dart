import 'dart:convert';
import 'dart:typed_data';

/// Modelo de dados que representa um cachorro disponível para adoção.
/// Utilizado para mapear os dados trocados entre o Flutter e o backend (API Flask + MongoDB).
class Cachorro {
  /// Identificador único do cachorro (gerado pelo MongoDB).
  final String? id;

  /// Nome do cachorro.
  final String nome;

  /// Raça do cachorro.
  final String raca;

  /// Idade informada (como texto).
  final String idade;

  /// Tamanho (Pequeno, Médio, Grande).
  final String tamanho;

  /// Descrição livre sobre o cachorro.
  final String descricao;

  /// Imagem representada como string base64 (opcional).
  final String? imagem;

  /// Indica se o cachorro já foi adotado.
  bool adotado;

  /// Construtor da classe `Cachorro`.
  Cachorro({
    this.id,
    required this.nome,
    required this.raca,
    required this.idade,
    required this.tamanho,
    required this.descricao,
    this.imagem,
    this.adotado = false,
  });

  /// Cria uma instância de `Cachorro` a partir de um JSON (vindo da API).
  factory Cachorro.fromJson(Map<String, dynamic> json) {
    return Cachorro(
      id: json['_id'], // MongoDB retorna o ID no campo "_id"
      nome: json['nome'],
      raca: json['raca'],
      idade: json['idade'],
      tamanho: json['tamanho'],
      descricao: json['descricao'],
      imagem: json['imagem'],
      adotado: json['adotado'] ?? false, // valor padrão = false
    );
  }

  /// Converte a instância de `Cachorro` para um Map (JSON), usado no envio para a API.
  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'raca': raca,
      'idade': idade,
      'tamanho': tamanho,
      'descricao': descricao,
      'imagem': imagem,
      'adotado': adotado,
    };
  }

  /// Converte a imagem base64 para bytes, usada para exibir a imagem no Flutter com `MemoryImage`.
  Uint8List? get imagemBytes {
    if (imagem == null) return null;
    return base64Decode(imagem!);
  }
}
