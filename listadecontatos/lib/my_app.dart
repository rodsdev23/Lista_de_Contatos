import 'package:flutter/material.dart';
import 'package:listadecontatos/view/homepage.dart';

import 'view/pages/criar_contato_page.dart';
import 'view/pages/pesquisar_contato_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      // home: HomePage(),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/pesquisarContato': (context) => const PesquisarContatoPage(),
        '/addContato': (context) => const CriarContatoPage(),
        '/ModeListWithBuilderExamplePage': (context) => PesquisarContatoPage(),
      },
    );
  }
}
