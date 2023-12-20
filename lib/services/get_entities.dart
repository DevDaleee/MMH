// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mmh/classes/entities.dart';
import 'package:mmh/components/snackbar.dart';

class EntityService {
  final CollectionReference entitiesCollection =
      FirebaseFirestore.instance.collection('entities');

  final CollectionReference entitiesOfTheDayCollection =
      FirebaseFirestore.instance.collection('entitieOfTheDay');

  Future<Object> getEntityOfTheDay(BuildContext context) async {
    Object entityOfTheDay = await getEntity(context);
    return entityOfTheDay;
  }

  Future<Entities?> getEntityByName(String name) async {
    QuerySnapshot<Object?> querySnapshot =
        await entitiesCollection.where('name', isEqualTo: name).limit(1).get();

    if (querySnapshot.docs.isNotEmpty) {
      return Entities.fromFirestore(
          querySnapshot.docs[0].data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  static Future<dynamic> getPropertyByName(
      String propertyName, String entityName) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('entities')
          .doc(entityName)
          .get();

      Map<String, dynamic>? data = snapshot.data();
      if (data != null && data.containsKey(propertyName)) {
        return data[propertyName];
      } else {
        throw ArgumentError(
            'A propriedade "$propertyName" não existe na entidade "$entityName".');
      }
    } catch (e) {
      throw ArgumentError('Erro ao obter propriedade: $e');
    }
  }

  Future<Object> getEntity(BuildContext context) async {
    QuerySnapshot<Object?> querySnapshot =
        await entitiesOfTheDayCollection.get();

    List<QueryDocumentSnapshot<Object?>> entities = querySnapshot.docs;

    if (entities.isEmpty || entities.length > 1) {
      return showSnackBar(context: context, texto: "Erro no Servidor");
    }

    Object entityOfTheDay = entities[0].data()!;

    return entityOfTheDay;
  }
}
