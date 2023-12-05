import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mmh/shared/base_model.dart';

class User extends BaseModel {
  late String _documentId;
  late String nick;
  late String email;
  late int? points;

  User.fromMap(DocumentSnapshot document) {
    _documentId = document.id;
    Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

    nick = data?['nick'] ?? "Não Informado";
    email = data?['email'] ?? "Não Informado";
    points = data?['points'];
  }

  @override
  toMap() {
    var map = <String, dynamic>{};
    map['nick'] = nick;
    map['email'] = email;
    map['points'] = points;
    return map;
  }

  @override
  String documentId() => _documentId;
}
