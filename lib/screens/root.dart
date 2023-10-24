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
      appBar: AppBar(
        backgroundColor: const Color(0xFF38453E),
        iconTheme: const IconThemeData(color: Color(0xffA6BD94)),
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xff38453E),
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Sair"),
              textColor: Colors.white,
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
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedFontSize: 17.0,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        backgroundColor: const Color(0xff38453E),
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
        unselectedItemColor: Colors.white,
        unselectedFontSize: 14,
        selectedItemColor: const Color(0xffA6BD94),
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}
