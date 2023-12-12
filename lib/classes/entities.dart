import 'package:cloud_firestore/cloud_firestore.dart';

class Entities {
  String category;
  int health;
  String name;
  String spawn;
  String type;

  Entities({
    required this.category,
    required this.health,
    required this.name,
    required this.spawn,
    required this.type,
  });

  Entities.fromFirestore(Map<String, dynamic> data)
      : category = data['category'],
        health = data['health'],
        name = data['name'],
        spawn = data['spawn'],
        type = data['type'];

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'health': health,
      'name': name,
      'spawn': spawn,
      'type': type,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'category': category,
      'health': health,
      'name': name,
      'spawn': spawn,
      'type': type,
    };
  }

  static Future<Map<String, dynamic>?> getDocumentByName(String name) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('entities')
              .where('name', isEqualTo: name)
              .limit(1)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs[0].data();
      } else {
        return null;
      }
    } catch (e) {
      throw ArgumentError('Erro ao obter documento: $e');
    }
  }

  dynamic getProperty(String propertyName) {
    switch (propertyName) {
      case 'category':
        return category;
      case 'health':
        return health;
      case 'name':
        return name;
      case 'spawn':
        return spawn;
      case 'type':
        return type;
      default:
        throw ArgumentError('Propriedade desconhecida: $propertyName');
    }
  }
}
