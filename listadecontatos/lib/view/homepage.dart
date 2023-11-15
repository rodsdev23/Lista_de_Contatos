import 'package:flutter/material.dart';
import 'package:listadecontatos/controller/repository/app_contatos_repository.dart';
import 'package:listadecontatos/controller/shared/widgets/custom_drawer.dart';
import 'package:listadecontatos/controller/shared/widgets/lista_de_contatos.dart';
import 'package:listadecontatos/model/app_contatos_model.dart';

import 'pages/pesquisar_contato_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool carregando = false;
  late AppContatosRepository appContatosRepository;

  AppContatosModel _appContatoModel = AppContatosModel([]); // começa com vazio

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isExpanded = false;
  var heart = false;
  PageController pageViewController = PageController(initialPage: 0);
  TextEditingController pesquisarController = TextEditingController();

  @override
  void dispose() {
    pageViewController.dispose();
    super.dispose();
  }

  void carregarDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void toggleExpansion() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  void _pesquisarContato() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PesquisarContatoPage()),
    );
  }

  void _addContato() {
    Navigator.pushNamed(
      context,
      '/addContato',
    );
  }

  // carregar Contatos
  @override
  void initState() {
    appContatosRepository = AppContatosRepository();
    super.initState();
    obterDados();
  }

  void obterDados() async {
    print("Iniciando o carregamento de dados...");
    setState(() {
      carregando = true; // Atualize a variável de estado
    });

    try {
      // Pega todos os contatos
      var contatos = await appContatosRepository.obterTodosContatos();

      setState(() {
        _appContatoModel = AppContatosModel(contatos.results);
        carregando = false;
      });
      print("Dados carregados com sucesso: $_appContatoModel");
    } catch (error) {
      // Lide com erros aqui, se necessário
      print('Erro ao obter dados: $error');
      setState(() {
        carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: const CustomDrawer(),
        extendBody: true,
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.teal,
              height: 230,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      children: [
                        SizedBox(
                          height: 60,
                          child: IconButton(
                              icon: const Icon(
                                Icons.supervised_user_circle_sharp,
                                size: 60,
                              ),
                              onPressed: () {}),
                        ),
                        Container(
                          height: 30,
                        ),
                        const Text(
                          "NOME DO CONTATO",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: IconButton(
                              onPressed:
                                  // Chame a função carregarDrawer ao pressionar o ícone
                                  carregarDrawer,
                              iconSize: 30,
                              color: Colors.black87,
                              icon: const Icon(Icons.menu),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              "Lista de Contatos",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: IconButton(
                                  onPressed:
                                      // Chame a função addContato ao pressionar o ícone
                                      _addContato,
                                  iconSize: 32,
                                  color: Colors.black87,
                                  icon: const Icon(Icons.add),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: IconButton(
                                  onPressed:
                                      // Chame a função _pesquisarContato() ao pressionar o ícone
                                      _pesquisarContato,
                                  iconSize: 32,
                                  color: Colors.black87,
                                  icon: const Icon(Icons.search_outlined),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30),
            ),
            Expanded(child: ListaContatos()),
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     setState(() {
        //       heart = !heart;
        //     });
        //   },
        //   backgroundColor: Colors.white,
        //   child: Icon(
        //     heart ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
        //     color: Colors.red,
        //   ),
        // ),
      ),
    );
  }
}
