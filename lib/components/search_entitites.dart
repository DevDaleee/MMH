import 'package:flutter/material.dart';
import 'package:mmh/classes/entities.dart';
import 'package:mmh/providers/api.dart';

class SearchEntities extends SearchDelegate {
  final FetchUser _entities = FetchUser();
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Entities>>(
      future: _entities.getEntities(query: query),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        List<Entities>? data = snapshot.data;
        return ListView.builder(
          itemCount: data?.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Row(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xffA6BD94),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        '${data?[index].name}',
                        style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Categoria: ${data?[index].category}",
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      Text(
                        "Spawn: ${data?[index].spawn}",
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      Text(
                        "Tipo: ${data?[index].type}",
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      Text(
                        "Vida: ${data?[index].health}",
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(
      child: Text('Search Entites'),
    );
  }
}
