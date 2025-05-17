import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cachorro_provider.dart';
import '../utils/image_helper.dart';

/// Tela de cadastro de um novo cachorro.
/// Permite o preenchimento de nome, raça, idade, tamanho, descrição e imagem.
class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>(); // chave para validação do formulário

  // Controladores dos campos de texto
  final _nomeController = TextEditingController();
  final _racaController = TextEditingController();
  final _idadeController = TextEditingController();
  final _descricaoController = TextEditingController();

  // Valor selecionado no dropdown
  String _tamanhoSelecionado = 'Médio';

  // Imagem selecionada da galeria
  File? _imagemSelecionada;

  // Opções disponíveis para o tamanho do cachorro
  final List<String> _tamanhos = ['Pequeno', 'Médio', 'Grande'];

  /// Abre a galeria e permite o usuário selecionar uma imagem
  Future<void> _selecionarImagem() async {
    final imagem = await ImageHelper.selecionarDaGaleria();
    if (imagem != null) {
      setState(() {
        _imagemSelecionada = imagem;
      });
    }
  }

  /// Valida o formulário e envia os dados para o provider
  void _salvar() {
    if (_formKey.currentState!.validate()) {
      // Envia os dados preenchidos para o provider e converte imagem para base64
      Provider.of<CachorroProvider>(context, listen: false).adicionarCachorro(
        nome: _nomeController.text,
        raca: _racaController.text,
        idade: _idadeController.text,
        tamanho: _tamanhoSelecionado,
        descricao: _descricaoController.text,
        imagem:
            _imagemSelecionada != null
                ? base64Encode(_imagemSelecionada!.readAsBytesSync())
                : null,
      );
      Navigator.pop(context); // Volta para a tela anterior após salvar
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar cachorro')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              /// Avatar circular para seleção e visualização da imagem
              Center(
                child: GestureDetector(
                  onTap: _selecionarImagem,
                  child: CircleAvatar(
                    radius: 55,
                    backgroundImage:
                        _imagemSelecionada != null
                            ? FileImage(_imagemSelecionada!)
                            : null,
                    backgroundColor: const Color(0xFFF1F1F1),
                    child:
                        _imagemSelecionada == null
                            ? const Icon(
                              Icons.add_a_photo,
                              size: 30,
                              color: Colors.grey,
                            )
                            : null,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// Campo: Nome
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator:
                    (v) => v == null || v.isEmpty ? 'Informe o nome' : null,
              ),

              const SizedBox(height: 16),

              /// Campo: Raça
              TextFormField(
                controller: _racaController,
                decoration: const InputDecoration(labelText: 'Raça'),
                validator:
                    (v) => v == null || v.isEmpty ? 'Informe a raça' : null,
              ),

              const SizedBox(height: 16),

              /// Campo: Idade
              TextFormField(
                controller: _idadeController,
                decoration: const InputDecoration(labelText: 'Idade'),
                validator:
                    (v) => v == null || v.isEmpty ? 'Informe a idade' : null,
              ),

              const SizedBox(height: 16),

              /// Dropdown: Tamanho
              DropdownButtonFormField<String>(
                value: _tamanhoSelecionado,
                items:
                    _tamanhos
                        .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                        .toList(),
                onChanged:
                    (v) => setState(() => _tamanhoSelecionado = v ?? 'Médio'),
                decoration: const InputDecoration(labelText: 'Tamanho'),
              ),

              const SizedBox(height: 16),

              /// Campo: Descrição
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                maxLines: 3,
                validator:
                    (v) =>
                        v == null || v.isEmpty ? 'Informe uma descrição' : null,
              ),

              const SizedBox(height: 24),

              /// Botão de salvar
              ElevatedButton(
                onPressed: _salvar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CB6AC), // fundo verde-água
                  foregroundColor: Colors.white, // texto branco
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text('Salvar cadastro'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
