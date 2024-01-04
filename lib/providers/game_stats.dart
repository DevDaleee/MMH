import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserStatistics extends ChangeNotifier {
  int totalGamesPlayed = 0;
  int totalGamesWon = 0;
  int winPercentage = 0;
  int currentStreak = 0;
  int maxStreak = 0;

  UserStatistics() {
    // Load stats from SharedPreferences when the provider is initialized
    readStatsFromSharedPreferences();
  }

  Future<void> loadStatsFromFirestore(DocumentReference userDocument) async {
    DocumentSnapshot userSnapshot = await userDocument.get();
    Map<String, dynamic>? userData =
        userSnapshot.data() as Map<String, dynamic>?;

    if (userData != null) {
      totalGamesPlayed = userData['gamesPlayed'] ?? 0;
      totalGamesWon = userData['gamesWon'] ?? 0;

      if (totalGamesPlayed != 0) {
        winPercentage = ((totalGamesWon / totalGamesPlayed) * 100).toInt();
      } else {
        winPercentage = 0;
      }

      currentStreak = userData['streak'] ?? 0;
      maxStreak = userData['maxStreak'] ?? 0;

      saveStatsToSharedPreferences();
      notifyListeners();
    } else {
      print('User data is null');
    }
  }

  void readStatsFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final stats = prefs.getStringList('stats');

    if (stats != null && stats.length == 5) {
      totalGamesPlayed = int.parse(stats[0]);
      totalGamesWon = int.parse(stats[1]);
      winPercentage = int.parse(stats[2]);
      currentStreak = int.parse(stats[3]);
      maxStreak = int.parse(stats[4]);
    }
  }

  void saveStatsToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
      'stats',
      [
        totalGamesPlayed.toString(),
        totalGamesWon.toString(),
        winPercentage.toString(),
        currentStreak.toString(),
        maxStreak.toString(),
      ],
    );
    notifyListeners();
  }

  void updateStatistics(bool gameWon, DocumentReference userDocument) async {
    await loadStatsFromFirestore(userDocument);

    totalGamesPlayed++;
    if (gameWon) {
      totalGamesWon++;
      currentStreak++;
    } else {
      currentStreak = 0;
    }
    if (currentStreak > maxStreak) {
      maxStreak = currentStreak;
    }
    winPercentage = ((totalGamesWon / totalGamesPlayed) * 100).toInt();
    int points = calculatePoints(currentStreak);
    saveStatsToSharedPreferences();

    userDocument.update(
      {
        'gamesPlayed': FieldValue.increment(1),
        'gamesWon': gameWon ? FieldValue.increment(1) : totalGamesWon,
        'maxStreak': maxStreak,
        'streak': currentStreak,
        'winPercentage': winPercentage.toDouble(),
        'points': FieldValue.increment(points),
      },
    );
    notifyListeners();
  }

  int calculatePoints(int attempts) {
    if (attempts >= 1 && attempts <= 6) {
      return 7 - attempts;
    } else {
      return 0;
    }
  }

  void displayStatistics(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF324E3F),
          title: const Text(
            'Estatísticas do usuário',
            style: TextStyle(fontSize: 18, color: Color(0xffA6BD94)),
          ),
          content: SizedBox(
            height: 170,
            width: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Jogos: $totalGamesPlayed',
                  style:
                      const TextStyle(fontSize: 20, color: Color(0xffA6BD94)),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'Wins: $winPercentage%',
                  style:
                      const TextStyle(fontSize: 20, color: Color(0xffA6BD94)),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'Streak: $currentStreak',
                  style:
                      const TextStyle(fontSize: 20, color: Color(0xffA6BD94)),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'Maior Streak: $maxStreak',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Color(0xffA6BD94),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xffA6BD94),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }
}
