import 'package:flutter/material.dart';

class ListaFavoritos extends StatelessWidget {
  const ListaFavoritos({super.key});

  @override
  Widget build(BuildContext context) {
    // Substitua isso pelo código que exibe sua lista de contatos
    return Container(
      height: 800.0, // Altura da lista de contatos
      child: ListView.builder(
        itemCount: 20, // Número de contatos
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/images/user02.jpg'),
              ),
              title: Text("Rodrigo Sousa"),
              subtitle: Text("33 99923 - 8494"));
        },
      ),
    );
  }
}
