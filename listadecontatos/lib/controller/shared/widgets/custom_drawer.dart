import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              UserAccountsDrawerHeader(
                  currentAccountPicture:
                      Image(image: AssetImage("assets/images/user03.png")),
                  accountName: Text("Rodrigo"),
                  accountEmail: Text("rodsdev@gmail.com")),
              InkWell(
                child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                    width: double.infinity,
                    child: const Text("Dados Cadastrais")),
                onTap: () {},
              ),
            ])));
  }
}
