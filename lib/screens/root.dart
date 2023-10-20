import 'package:flutter/material.dart';
import 'package:mmh/screens/main_page.dart';
import 'package:mmh/screens/profile_page.dart';
import 'package:mmh/screens/ranking_page.dart';
import 'package:mmh/services/auth.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  var _currentIndex = 1;
  final _children = [
    const ProfilePage(),
    const TelaInicial(),
    const RankingPage(),
  ];

  _onTap(int tab) {
    if (_currentIndex != tab) {
      setState(
        () {
          _currentIndex = tab;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Sair"),
              onTap: () {
                ServiceAuth().sair();
              },
            )
          ],
        ),
      ),
      body: Center(
        child: _children[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Perfil",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_esports),
            label: "Game",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: "Ranking",
          )
        ],
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}
