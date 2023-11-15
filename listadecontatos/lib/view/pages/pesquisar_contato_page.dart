import 'package:alphabet_search_view/alphabet_search_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:listadecontatos/model/app_contatos_model.dart';

import '../../controller/repository/app_contatos_repository.dart';

class PesquisarContatoPage extends StatefulWidget {
  const PesquisarContatoPage({Key? key}) : super(key: key);

  @override
  State<PesquisarContatoPage> createState() => _PesquisarContatoPageState();
}

class _PesquisarContatoPageState extends State<PesquisarContatoPage> {
  final formatter = DateFormat('dd/MM/yyyy');
  late AppContatosRepository appContatosRepository;
  late AppContatosModel _appContatosModel = AppContatosModel([]);

  bool carregando = false;

  @override
  void initState() {
    appContatosRepository = AppContatosRepository();
    super.initState();
    obterContatos();
  }

  void obterContatos() async {
    try {
      setState(() {
        carregando = true;
      });

      AppContatosModel contatos =
          await appContatosRepository.obterTodosContatos();

      setState(() {
        _appContatosModel = contatos;
        carregando = false;
      });
    } catch (error) {
      print('Erro ao obter contatos: $error');
      setState(() {
        carregando = false;
      });
      // Adicione um tratamento de erro apropriado, como exibir uma mensagem para o usuário.
    }
  }

  // Método privado para obter o provedor de imagem
  ImageProvider<Object> _getImageProvider(Photo? photo) {
    if (photo?.url != null && photo!.url!.isNotEmpty) {
      return NetworkImage(photo!.url!);
    } else {
      return const AssetImage('assets/images/user02.jpg');
    }
  }

  // Método privado para construir o item da lista
  Widget _buildListItem(BuildContext context, int index,
      AlphabetSearchModel<AppContatosModel> item) {
    var contato = item.data.results[index];
    return SafeArea(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 8,
        child: ListTile(
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(.25),
              shape: BoxShape.circle,
              image: DecorationImage(
                image: _getImageProvider(contato.image),
              ),
              border: Border.all(
                width: 5,
                color: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .color!
                    .withOpacity(.1),
              ),
            ),
          ),
          title: Text(
            item.title,
            style: const TextStyle(fontSize: 25),
          ),
          subtitle: Wrap(
            children: [
              if (contato.telefone != null)
                Text(
                  "Telefone: ${contato.telefone}",
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
              if (contato.email != null)
                Text(
                  "Email: ${contato.email}",
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesquisar Contato - ModelList (width Builder)'),
      ),
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : _appContatosModel.results.isNotEmpty
              ? AlphabetSearchView<AppContatosModel>.list(
                  decoration: AlphabetSearchDecoration.fromContext(
                    context,
                    titleStyle: Theme.of(context).textTheme.headline6?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  list: _appContatosModel.results
                      .map(
                        (e) => AlphabetSearchModel<AppContatosModel>(
                          title: e.nome!,
                          subtitle: e.email,
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
                  buildItem: _buildListItem, // Utilizando o método privado
                )
              : const Center(
                  child: Text("Lista de contatos vazia"),
                ),
    );
  }
}
