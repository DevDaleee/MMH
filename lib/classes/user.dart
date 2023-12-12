import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mmh/providers/game_stats.dart';
import 'package:mmh/shared/base_model.dart';

class User extends BaseModel {
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

    email = data?['email'] ?? "Não Informado";
    nick = data?['nick'] ?? "Não Informado";
    gamesPlayed = statistics.totalGamesPlayed;
    gamesWon = statistics.totalGamesWon;
    maxStreak = statistics.maxStreak;
    points = data?['points'] ?? 0;
    streak = statistics.currentStreak;
    winPercentage = statistics.winPercentage.toDouble();
  }

  @override
  toMap() {
    var map = <String, dynamic>{};
    map['email'] = email;
    map['nick'] = nick;
    // Use the UserStatistics values for gamesPlayed, gamesWon, maxStreak, streak, and winPercentage
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
