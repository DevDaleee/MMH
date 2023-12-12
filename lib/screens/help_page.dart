import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mmh/components/search_entitites.dart';
import 'package:mmh/named_routes.dart';
import 'package:mmh/services/auth.dart'; // Importe a classe SearchEntities aqui

class HelpPage extends StatefulWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "TODAS AS ENTIDADES",
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        backgroundColor: const Color(0xFF324E3F),
        iconTheme: const IconThemeData(color: Color(0xffA6BD94)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Abrir a tela de pesquisa
              showSearch(context: context, delegate: SearchEntities());
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('entities').snapshots(),
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

            return ListView.builder(
              itemCount: userDocs.length,
              itemBuilder: (context, index) {
                var userData = userDocs[index].data();
                String category = userData?['category'] as String;
                String name = userData?['name'] as String;
                String spawn = userData?['spawn'] as String;
                String type = userData?['type'] as String;
                int health = userData?['health'] as int;

                int position = index + 1;

                return Card(
                  child: ListTile(
                    title: Text(
                      name,
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Category: $category",
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        Text(
                          "Spawn: $spawn",
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        Text(
                          "Type: $type",
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        Text(
                          "Health: $health",
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
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
                    ListTile(
                      leading: const Icon(Icons.help_center,
                          color: Color(0xffA6BD94)),
                      title: const Text("Entidades"),
                      textColor: Colors.white,
                      onTap: () {
                        Navigator.of(context)
                            .pushReplacementNamed(EntitiesTipsViewRoute);
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
