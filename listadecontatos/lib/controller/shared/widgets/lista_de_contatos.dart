import 'package:alphabet_search_view/alphabet_search_view.dart';
import 'package:flutter/material.dart';

import '../../../model/app_contatos_model.dart';
import '../../repository/app_contatos_repository.dart';

class ListaContatos extends StatefulWidget {
  const ListaContatos({Key? key}) : super(key: key);

  @override
  State<ListaContatos> createState() => _ListaContatosState();
}

class _ListaContatosState extends State<ListaContatos> {
  late AppContatosRepository appContatosRepository;

  AppContatosModel _appContatosModel =
      AppContatosModel([]); // Inicialize sem argumentos
  bool carregando = false;

  @override
  void initState() {
    super.initState();
    appContatosRepository = AppContatosRepository();
    obterContatos();
  }

  void obterContatos() async {
    setState(() {
      carregando = true;
    });

    try {
      // Pega todos os contatos como um objeto AppContatosModel
      AppContatosModel contatos =
          await appContatosRepository.obterTodosContatos();

      setState(() {
        // Atualiza o modelo de contatos com os dados recebidos
        _appContatosModel = contatos;
        carregando = false;
      });
    } catch (e) {
      // Lida com erros durante a obtenção de contatos
      print("Erro ao obter contatos: $e");
      setState(() {
        carregando = false;
      });
    }
  }

  ImageProvider<Object> _getImageProvider(AppContatoModel contato) {
    if (contato.image != null &&
        contato.image!.url != null &&
        contato.image!.url!.isNotEmpty) {
      return NetworkImage(contato.image!.url!);
    } else {
      // Use uma imagem padrão dos ativos (substitua pelo caminho real)
      return const AssetImage('assets/images/user03.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _appContatosModel.results.isNotEmpty
            ? AlphabetSearchView<AppContatosModel>.list(
                decoration: AlphabetSearchDecoration.fromContext(
                  context,
                  withSearch: false,
                  titleStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                list: _appContatosModel.results
                    .map(
                      (contato) => AlphabetSearchModel<AppContatosModel>(
                        title: contato.nome!,
                        subtitle: contato.email,
                        data: _appContatosModel,
                      ),
                    )
                    .toList(),
                onItemTap: (_, __, item) {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(item.title),
                  ));
                },
                buildItem: (_, index, item) {
                  var contato = item.data.results[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 8,
                    child: ListTile(
                      leading: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(.25),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: _getImageProvider(contato)),
                          border: Border.all(
                            width: 5,
                            color: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .color!
                                .withOpacity(.1),
                          ),
                        ),
                      ),
                      title: Text(
                        contato.telefone.toString(),
                        style: const TextStyle(fontSize: 30),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Nome: ${contato.nome}",
                            style: const TextStyle(fontSize: 15),
                          ),
                          Text(
                            "Telefone: ${contato.telefone}",
                            style: const TextStyle(fontSize: 15),
                          ),
                          Text(
                            "Email: ${contato.email}",
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            : const Center(
                child: Text("Lista de contatos vazia"),
              ),
      ),
    );
  }
}
