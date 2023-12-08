import 'package:flutter/material.dart';
import 'package:mmh/named_routes.dart';
import 'package:mmh/screens/main_page.dart';
import 'package:mmh/services/auth.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF324E3F),
        iconTheme: const IconThemeData(color: Color(0xffA6BD94)),
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFF38453E),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 30.0),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    ListTile(
                      leading:
                          const Icon(Icons.person, color: Color(0xffA6BD94)),
                      title: const Text("Perfil"),
                      textColor: Colors.white,
                      onTap: () {
                        Navigator.of(context)
                            .pushReplacementNamed(ProfileViewRoute);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.emoji_events,
                          color: Color(0xffA6BD94)),
                      title: const Text("Rank"),
                      textColor: Colors.white,
                      onTap: () {
                        Navigator.pushNamed(context, RankingViewRoute);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.help_center,
                          color: Color(0xffA6BD94)),
                      title: const Text("Entidades"),
                      textColor: Colors.white,
                      onTap: () {
                        Navigator.pushNamed(context, EntitiesTipsViewRoute);
                      },
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Color(0xffA6BD94),
                ),
                title: const Text("Sair"),
                textColor: Colors.white,
                onTap: () async {
                  await ServiceAuth().sair(context);
                },
              ),
            ),
          ],
        ),
      ),
      body: const TelaInicial(),
    );
  }
}
