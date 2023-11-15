import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:listadecontatos/controller/repository/app_contatos_repository.dart';
import 'package:listadecontatos/model/app_contatos_model.dart';

class CriarContatoPage extends StatefulWidget {
  const CriarContatoPage({Key? key}) : super(key: key);

  @override
  State<CriarContatoPage> createState() => _CriarContatoPageState();
}

class _CriarContatoPageState extends State<CriarContatoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  Photo? foto;
  final AppContatosRepository _appContatosRepository = AppContatosRepository();

  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Contato')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildPhotoContainer(),
            const SizedBox(height: 10),
            _buildForm(),
            const SizedBox(height: 10),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoContainer() {
    return GestureDetector(
      onTap: _showImageOptions,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(.25),
          shape: BoxShape.circle,
          image: foto != null && foto!.url != null && foto!.url!.isNotEmpty
              ? DecorationImage(
                  image: MemoryImage(
                    base64Decode(foto!.url!),
                  ),
                  fit: BoxFit.cover,
                )
              : const DecorationImage(
                  image: AssetImage("assets/images/user03.png"),
                  fit: BoxFit.cover,
                ),
          border: Border.all(
            width: 5,
            color:
                Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.1),
          ),
        ),
      ),
    );
  }

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Container(
            height: 130,
            width: double.infinity,
            child: Column(
              children: [
                _buildElevatedButton(
                  "Câmera",
                  () async {
                    await _takePhotoAndSaveToGallery();
                  },
                ),
                _buildElevatedButton(
                  "Galeria",
                  () {
                    _chooseImageFromGallery();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextField('nome', nomeController, 'Digite o nome'),
          _buildTextField('email', emailController, 'Digite o email'),
          _buildTextField('telefone', telefoneController, 'Digite o telefone'),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _isSaving ? null : _salvarContato,
      child:
          _isSaving ? const CircularProgressIndicator() : const Text("Salvar"),
    );
  }

  Widget _buildElevatedButton(String label, void Function() onPressed) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 5,
      ),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }

  Widget _buildTextField(
      String name, TextEditingController controller, String labelText) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Campo obrigatório';
        }
        return null;
      },
    );
  }

  Future<void> _takePhotoAndSaveToGallery() async {
    final imagePicker = ImagePicker();
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        foto = _fotoParaFile(File(image.path));
      });
    }
  }

  Future<void> _chooseImageFromGallery() async {
    final imagePicker = ImagePicker();
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        foto = _fotoParaFile(File(image.path));
      });
    }
  }

  Photo? _fotoParaFile(File file) {
    try {
      if (file.existsSync()) {
        List<int> imageBytes = file.readAsBytesSync();
        String base64Image = base64Encode(imageBytes);

        String randomFileName =
            generateRandomName(); // Use a função de geração de nome aleatório

        return Photo(
          sType: 'Bytes',
          name: '$randomFileName.jpg',
          url: base64Image,
        );
      } else {
        _showError('Arquivo de imagem não encontrado.');
        return null;
      }
    } catch (error) {
      print('Erro ao converter foto para objeto Photo: $error');
      return null;
    }
  }

  String generateRandomName() {
    DateTime now = DateTime.now();
    return "profile${now.year}${now.month}${now.day}_${now.hour}${now.minute}${now.second}_${Random().nextInt(9999)}";
  }

  Future<void> _salvarContato() async {
    try {
      setState(() {
        _isSaving = true;
      });

      if (foto == null) {
        _showError('Por favor, escolha uma imagem antes de salvar.');
        return;
      }

      AppContatoModel novoContato = AppContatoModel(
        nome: nomeController.text,
        email: emailController.text,
        telefone: int.tryParse(telefoneController.text) ?? 0,
        image: foto ?? Photo(),
      );

      // print("Dados antes de criar contato: ${novoContato.toJson()}");
      await _appContatosRepository.criar(novoContato);

      // Limpa os Controles
      // nomeController.clear();
      // emailController.clear();
      // telefoneController.clear();
      // foto = null;

      setState(() {
        _isSaving = false;
      });
    } catch (e) {
      _showError('Erro ao salvar contato: $e');

      setState(() {
        _isSaving = false;
      });
    }
  }

  void _showError(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(errorMessage),
    ));
  }
}
