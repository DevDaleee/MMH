import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mmh/classes/entities.dart';

class FetchUser {
  Future<List<Entities>> getEntities({String? query}) async {
    List<Entities> results = [];

    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('entities').get();

      List<Map<String, dynamic>> data =
          querySnapshot.docs.map((doc) => doc.data()).toList();

      results =
          data.map<Entities>((map) => Entities.fromFirestore(map)).toList();

      if (query != null) {
        results = results
            .where((element) =>
                element.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    } on Exception catch (e) {
      print('ERROR: $e');
    }

    return results;
  }
}
