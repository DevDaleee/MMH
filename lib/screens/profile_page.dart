import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mmh/named_routes.dart';
import 'package:mmh/services/auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? nick = '';
  String? image = '';
  String? points = '';

  Future _getUserData() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        setState(() {
          nick = snapshot.data()!["nick"];
          points = snapshot.data()!["points"];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF38453E),
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
                          const Icon(Icons.house, color: Color(0xffA6BD94)),
                      title: const Text("Inicial"),
                      textColor: Colors.white,
                      onTap: () {
                        Navigator.pushNamed(context, InitialViewRoute);
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
              child: ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Color(0xffA6BD94),
                ),
                title: const Text("Sair"),
                textColor: Colors.white,
                onTap: () {
                  ServiceAuth().sair();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
