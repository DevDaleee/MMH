import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mmh/classes/entities.dart';
import 'package:mmh/components/app_color.dart';
import 'package:mmh/components/snackbar.dart';
import 'package:mmh/providers/game_stats.dart';
import 'package:mmh/services/get_entities.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameProvider extends ChangeNotifier {
  int tentativas = 6;
  int tFeitas = 0;
  late Object entityOfTheDay;
  List<Entities> userGuesses = [];
  bool gameOver = false;
  late BuildContext context;
  final _entityService = EntityService();
  final user = FirebaseAuth.instance.currentUser;
  late SharedPreferences _preferences;

  GameProvider(this.context) {
    _initPreferences().then((_) {
      _loadGameState();
    });
  }

  Future<void> _initPreferences() async {
    _preferences = await SharedPreferences.getInstance();
  }

  void _loadGameState() {
    tentativas = _preferences.getInt('tentativas') ?? 6;
    tFeitas = _preferences.getInt('tFeitas') ?? 0;
    notifyListeners();
  }

  void dispose() {
    _saveGameState();
    super.dispose();
  }

  void restartGame() {
    tentativas = 6;
    tFeitas = 0;
    entityOfTheDay;
    userGuesses = [];
    gameOver = false;
    _initPreferences();
  }

  void _saveGameState() {
    _preferences.setInt('tentativas', tentativas);
    _preferences.setInt('tFeitas', tFeitas);
  }

  void finalizarJogo() {
    gameOver = true;
    _saveGameState();
    notifyListeners();
  }

  Future<void> fetchEntity() async {
    try {
      Object fetchedEntity = await _entityService.getEntityOfTheDay(context);
      entityOfTheDay = fetchedEntity;
      notifyListeners();
    } catch (err) {
      showSnackBar(
        context: context,
        texto: "Estamos com problemas no servidor, volte mais tarde!",
        isError: true,
      );
    }
  }

  Future<void> checkGuess(
      GlobalKey<FormState> _formKey, TextEditingController _try) async {
    if (_formKey.currentState?.validate() ?? false) {
      String userGuess = _try.text;
      Entities? entityData = await _entityService.getEntityByName(userGuess);
      Entities? guessedEntity;

      if (entityData != null) {
        guessedEntity = entityData;
      }
      if (userGuesses.contains(userGuess)) {
        showSnackBar(
          context: context,
          texto: "Você já tentou essa entidade. Tente outra!",
          isError: true,
        );

        FocusScope.of(context).unfocus();
        _try.clear();
        return;
      }

      if (guessedEntity != null) {
        if (entityOfTheDay is Map<String, dynamic>) {
          String correctAnswer =
              (entityOfTheDay as Map<String, dynamic>)['name']
                      ?.toString()
                      .toLowerCase() ??
                  '';

          if (userGuess.toLowerCase() == correctAnswer) {
            tFeitas++;
            tentativas--;
            gameOver = true;
            FocusScope.of(context).unfocus();
            showSnackBar(
              context: context,
              texto: "Parabéns, você acertou!",
              isError: false,
            );
            DocumentReference userDocument =
                FirebaseFirestore.instance.collection('users').doc(user?.uid);
            UserStatistics userStatistics = UserStatistics();
            userStatistics.updateStatistics(true, userDocument);
          } else {
            tFeitas++;
            tentativas--;
            FocusScope.of(context).unfocus();
            if (tentativas <= 0) {
              tFeitas++;
              tentativas--;
              gameOver = true;
              FocusScope.of(context).unfocus();
              showSnackBar(
                  context: context, texto: "Suas tentativas acabaram!");
              DocumentReference userDocument =
                  FirebaseFirestore.instance.collection('users').doc(user?.uid);
              UserStatistics userStatistics = UserStatistics();
              userStatistics.updateStatistics(true, userDocument);
            }
          }

          if (!userGuesses.contains(guessedEntity)) {
            userGuesses.add(guessedEntity);
            _saveGameState();
            notifyListeners();
          }

          FocusScope.of(context).unfocus();
        } else {
          showSnackBar(
              context: context,
              texto: "Erro: Tipo de entidade do dia inválido");
        }
        FocusScope.of(context).unfocus();
        _try.clear();
      } else {
        showSnackBar(
            context: context,
            texto: "Entidade não encontrada. Tente novamente!");
        FocusScope.of(context).unfocus();
      }
    }
  }

  Widget buildCharacteristicsIndicators(
    Map<String, dynamic> characteristics,
    Entities userGuess,
  ) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CharacteristicsIndicator(
            userGuess: userGuess,
            correctAnswer: Entities.fromFirestore(
              (entityOfTheDay as Map<String, dynamic>),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGuessCards() {
    return Builder(
      builder: (context) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: userGuesses.length,
          reverse: true,
          itemBuilder: (context, index) {
            Entities guessEntity = userGuesses[index];
            Key cardKey = Key("card_$index");
        
            return FutureBuilder<Map<String, dynamic>?>(
              future: Entities.getDocumentByName(guessEntity.name),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final guessedEntity = Entities.fromFirestore(snapshot.data!);
                  bool isCorrectGuess = guessedEntity == entityOfTheDay;
                  Color cardColor = isCorrectGuess ? Colors.green : Colors.red;
        
                  return Card(
                    key: cardKey,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0),
                      ),
                      side: BorderSide(width: 5, color: cardColor),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text("Palpite: ${guessEntity.name}"),
                        ),
                        buildCharacteristicsIndicators(
                          guessedEntity.toJson(),
                          guessEntity,
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              },
            );
          },
        );
      }
    );
  }
}
