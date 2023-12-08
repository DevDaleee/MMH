import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mmh/classes/entities.dart';

class EntityService {
  final CollectionReference entitiesCollection =
      FirebaseFirestore.instance.collection('entitieOfTheDay');

  Future<Entities> getEntity() async {
    Object etod = await getRandomEntity();
    return etod as Entities;
  }

  Future<Object> getRandomEntity() async {
    QuerySnapshot<Object?> querySnapshot = await entitiesCollection.get();
    List<QueryDocumentSnapshot<Object?>> entities = querySnapshot.docs;

    if (entities.isEmpty) {
      return {};
    }

    int randomIndex = Random().nextInt(entities.length);
    Object randomEntity = entities[randomIndex].data()!;

    return randomEntity;
  }
}
