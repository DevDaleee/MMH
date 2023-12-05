import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class EntityService {
  final CollectionReference entitiesCollection =
      FirebaseFirestore.instance.collection('entities');

  Future<void> getEntity() async {
    Object randomEntity = await getRandomEntity();
    print(randomEntity);
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
