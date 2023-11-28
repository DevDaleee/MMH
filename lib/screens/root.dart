// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:mmh/named_routes.dart';
import 'package:mmh/screens/login_page.dart';
import 'package:mmh/screens/main_page.dart';

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
        backgroundColor: const Color(0xFF38453E),
        iconTheme: const IconThemeData(color: Color(0xffA6BD94)),
      ),
      drawer: Container(
        width: 260,
        child: Drawer(
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
                          Navigator.pushNamed(context, ProfileViewRoute);
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
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                          (route) => false),
                      child: const ListTile(
                        leading: Icon(
                          Icons.exit_to_app,
                          color: Color(0xffA6BD94),
                        ),
                        title: Text(
                          'Logout',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: const TelaInicial(),
    );
  }
}
