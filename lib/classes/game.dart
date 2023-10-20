import 'package:mmh/classes/entities.dart';

class Game {
  int id;
  Entities entitie_of_the_day;
  int trys;
  int points;

  Game({
    required this.id,
    required this.entitie_of_the_day,
    required this.trys,
    required this.points,
  });

  factory Game.toMap(map) {
    return Game(
      id: map['id'] ?? 0,
      entitie_of_the_day: map['entitie_of_the_day'] ?? "Não Informado",
      trys: map['trys'] ?? 0,
      points: map['points'] ?? 0,
    );
  }
}
