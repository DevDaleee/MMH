import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mmh/named_routes.dart';
import 'package:mmh/services/auth.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "RANKING GERAL",
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
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
                      onTap: () {
                        Navigator.pushNamed(context, InitialViewRoute);
                      },
                    ),
                    ListTile(
                      leading:
                          const Icon(Icons.person, color: Color(0xffA6BD94)),
                      title: const Text("Perfil"),
                      textColor: Colors.white,
                      onTap: () {
                        Navigator.pushNamed(context, ProfileViewRoute);
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
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
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

          if (snapshot.hasData) {
            List<DocumentSnapshot<Map<String, dynamic>>> userDocs =
                snapshot.data!.docs;

            userDocs.sort((a, b) => (b.data()?['points'] as int)
                .compareTo(a.data()?['points'] as int));

            return ListView.builder(
              itemCount: userDocs.length,
              itemBuilder: (context, index) {
                var userData = userDocs[index].data();
                int points = userData?['points'] as int;

                int position = index + 1;

                return Card(
                  child: ListTile(
                    title: Text(
                      userData?['nick'] as String,
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    subtitle: Text(
                      "Points: $points - Position: $position",
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xffA6BD94),
                      child: Text(
                        position.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const Text('Data not available');
        },
      ),
    );
  }
}
