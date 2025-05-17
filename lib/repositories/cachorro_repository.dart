import 'dart:convert'; // Para codificar/decodificar JSON
import 'package:http/http.dart' as http;
import '../models/cachorro.dart';

/// Classe responsável por fazer a comunicação com a API Flask.
/// Contém os métodos HTTP usados pelo Provider.
class CachorroRepository {
  /// URL base da API. Pode ser localhost ou IP da máquina rodando o backend.
  static const String baseUrl = 'http://localhost:5000';

  /// Realiza um GET na rota /cachorros e retorna uma lista de objetos Cachorro
  Future<List<Cachorro>> buscarTodos() async {
    final response = await http.get(Uri.parse('$baseUrl/cachorros'));

    if (response.statusCode == 200) {
      // Converte o corpo da resposta para uma lista JSON
      final List jsonData = jsonDecode(response.body);

      // Mapeia cada item JSON para um objeto Cachorro
      return jsonData.map((e) => Cachorro.fromJson(e)).toList();
    } else {
      // Lança um erro se a requisição falhar
      throw Exception('Erro ao buscar cachorros');
    }
  }

  /// Envia um novo cachorro para o backend via POST
  Future<void> adicionarCachorro(Cachorro cachorro) async {
    final response = await http.post(
      Uri.parse('$baseUrl/cachorros'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(cachorro.toJson()), // Converte o objeto para JSON
    );

    if (response.statusCode != 201) {
      // Verifica se a criação foi bem sucedida (HTTP 201 Created)
      throw Exception('Erro ao cadastrar cachorro');
    }
  }

  /// Atualiza o campo 'adotado' de um cachorro via PATCH
  Future<void> marcarComoAdotado(String id) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/cachorros/$id/adotar'),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar status de adoção');
    }
  }
}
