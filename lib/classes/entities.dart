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

  factory Entities.fromFirestore(Map<String, dynamic> json) {
    return Entities(
      category: json['category'] ?? '',
      health: json['health'] ?? 0,
      name: json['name'] ?? '',
      spawn: json['spawn'] ?? '',
      type: json['type'] ?? '',
    );
  }

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
}
