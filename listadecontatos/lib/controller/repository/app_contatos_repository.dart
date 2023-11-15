import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

import '../../model/app_contatos_model.dart';

class AppContatosRepository {
  var _dio = Dio();

  AppContatosRepository() {
    _dio = Dio();
    _dio.options.headers["X-Parse-Application-Id"] =
        'WocKSZokIRt7RTYFJCDkNBqO6fxRRPiRfi3MQJGK';
    _dio.options.headers["X-Parse-REST-API-Key"] =
        '7TJ72J7UFSqKGoZjC5SDtGuCPurK7tJZLBblPggs'; // Substitua com sua chave de API real
    _dio.options.headers["Content-Type"] = "application/json";
    _dio.options.baseUrl = "https://parseapi.back4app.com/classes";
  }

  Future<AppContatosModel> obterTodosContatos() async {
    try {
      final response = await _dio.get("/dbcontatos");
      print("Response status: ${response.statusCode}");
      print("Response data: ${response.data}");
      return AppContatosModel.fromJson(response.data);
    } catch (error) {
      print('Erro ao obter todos os contatos: $error');
      rethrow;
    }
  }

  Future<void> criar(AppContatoModel appContatoModel) async {
    try {
      var response = await _dio.post("/dbcontatos",
          data: jsonEncode({
            "nome": appContatoModel.nome,
            "email": appContatoModel.email,
            "telefone": appContatoModel.telefone,
            "profile": {
              "__type": "File",
              "name": appContatoModel.image?.name ?? "default.jpg",
              "url": appContatoModel.image?.url ?? "/path/to/default.jpg",
            },
          }));

      print('Status da resposta: ${response.statusCode}');
      print('Resposta do servidor: ${response.data}');

      if (response.statusCode == 201) {
        print('Contato criado com sucesso!');
      } else {
        print('Erro ao criar contato: ${response.statusCode}');
        print('Resposta do servidor: ${response.data}');
        print('Dados da solicitação: ${response.requestOptions.data}');
      }
    } catch (error) {
      print('Erro ao criar contato: $error');
      rethrow;
    }
  }

  Future<void> enviarFotoParaBack4App(File foto) async {
    // lógica da função
  }
}
