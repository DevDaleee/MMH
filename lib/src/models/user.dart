// ignore_for_file: dead_null_aware_expression

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mmh/src/providers/game_stats.dart';
import 'package:mmh/src/shared/base_model.dart';

class User extends BaseModel {
  late String uid;
  late String _documentId;
  late String email;
  late String nick;
  late int gamesPlayed;
  late int gamesWon;
  late int maxStreak;
  late int points;
  late int streak;
  late double winPercentage;

  User.fromMap(DocumentSnapshot document, UserStatistics statistics) {
    _documentId = document.id;
    Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
    uid = data?['uid'] ?? "Não informado";
    email = data?['email'] ?? "Não Informado";
    nick = data?['nick'] ?? "Não Informado";
    gamesPlayed = statistics.totalGamesPlayed ?? 0;
    gamesWon = statistics.totalGamesWon ?? 0;
    maxStreak = statistics.maxStreak ?? 0;
    points = data?['points'] ?? 0;
    streak = statistics.currentStreak ?? 0;
    winPercentage = statistics.winPercentage.toDouble() ?? 0;
  }

  @override
  toMap() {
    var map = <String, dynamic>{};
    map['uid'] = uid;
    map['email'] = email;
    map['nick'] = nick;
    map['gamesPlayed'] = gamesPlayed;
    map['gamesWon'] = gamesWon;
    map['maxStreak'] = maxStreak;
    map['points'] = points;
    map['streak'] = streak;
    map['winPercentage'] = winPercentage;
    return map;
  }

  @override
  String documentId() => _documentId;
}
