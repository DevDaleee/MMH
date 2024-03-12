import 'package:mmh/src/models/entities.dart';

class Game {
  int id;
  Entities eotd;
  int trys;
  int points;

  Game({
    required this.id,
    required this.eotd,
    required this.trys,
    required this.points,
  });

  factory Game.toMap(map) {
    return Game(
      id: map['id'] ?? 0,
      eotd: map['entitie_of_the_day'] ?? "Não Informado",
      trys: map['trys'] ?? 0,
      points: map['points'] ?? 0,
    );
  }
}
