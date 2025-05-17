import 'dart:io';
import 'package:image_picker/image_picker.dart';

/// Classe auxiliar (helper) para selecionar imagens da galeria ou da câmera.
/// Usa o pacote `image_picker` para capturar imagens como arquivos locais.
class ImageHelper {
  /// Instância interna do ImagePicker (utilizada pelos métodos estáticos)
  static final ImagePicker _picker = ImagePicker();

  /// Abre a galeria do dispositivo e permite selecionar uma imagem.
  /// Retorna a imagem como um [File] se o usuário escolher uma,
  /// ou retorna `null` se o usuário cancelar.
  static Future<File?> selecionarDaGaleria() async {
    final imagem = await _picker.pickImage(source: ImageSource.gallery);
    if (imagem != null) {
      return File(imagem.path); // converte o caminho da imagem em um File
    }
    return null; // usuário cancelou
  }

  /// Abre a câmera do dispositivo para capturar uma nova foto.
  /// Retorna a imagem como um [File] se capturada, ou `null` se cancelada.
  static Future<File?> tirarFoto() async {
    final imagem = await _picker.pickImage(source: ImageSource.camera);
    if (imagem != null) {
      return File(imagem.path); // imagem tirada com sucesso
    }
    return null; // usuário cancelou
  }
}
