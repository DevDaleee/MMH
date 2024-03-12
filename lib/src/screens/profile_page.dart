import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mmh/named_routes.dart';
import 'package:mmh/src/services/auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF324E3F),
        iconTheme: const IconThemeData(color: Color(0xffA6BD94)),
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFF324E3F),
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
                      onTap: () => Get.to(InitialViewRoute),
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
                onTap: () {
                  ServiceAuth().sair(context);
                },
              ),
            ),
          ],
        ),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(auth.currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading data please wait');
          }

          if (snapshot.hasError) {
            return const Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Error loading data'),
                ],
              ),
            );
          }

          if (snapshot.hasData && snapshot.data?.exists == true) {
            var userData = snapshot.data!.data();
            int points = snapshot.data?.data()?['points'] as int;
            int streak = snapshot.data?.data()?['streak'] as int;

            if (userData != null && userData.containsKey('nick')) {
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(top: 10),
                      alignment: Alignment.bottomCenter,
                      child: Image.asset(
                        "./assets/images/big-creeper-face.png",
                        width: 150,
                        height: 150,
                      ),
                    ),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            userData['nick'] as String,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 30),
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Pontos: $points",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Streak: $streak",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20),
                                  textAlign: TextAlign.right,
                                ),
                              ]),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          }
          return const Text('Data not available');
        },
      ),
    );
  }
}
