// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mmh/classes/entities.dart';
import 'package:mmh/components/app_color.dart';
import 'package:mmh/components/snackbar.dart';
import 'package:mmh/components/validations_mixin.dart';
import 'package:mmh/providers/count_down.dart';
<<<<<<< HEAD
=======
import 'package:mmh/providers/game_stats.dart';
import 'package:mmh/services/get_entities.dart';
>>>>>>> Criando_Logica_Jogo

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial>
    with ValidationsMixin, AutomaticKeepAliveClientMixin {
  final _formKey = GlobalKey<FormState>();
  final _try = TextEditingController();
  int tentativas = 6;
  int tFeitas = 0;
  final _entityService = EntityService();
  late Object entityOfTheDay;
  List<Entities> userGuesses = [];
  final UserStatistics userStats = UserStatistics();
  final user = FirebaseAuth.instance.currentUser;
  final CountdownTimer _countdownTimer = CountdownTimer();
  bool gameOver = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    fetchEntity();
  }

  @override
  void dispose() {
    _countdownTimer.dispose();
    super.dispose();
  }

  Future<void> fetchEntity() async {
    try {
      Object fetchedEntity = await _entityService.getEntityOfTheDay(context);
      setState(() {
        entityOfTheDay = fetchedEntity;
      });
    } catch (err) {
      showSnackBar(context: context, texto: "$err");
    }
  }

  Future<void> checkGuess() async {
    if (_formKey.currentState?.validate() ?? false) {
      String userGuess = _try.text;
      Entities? entityData = await _entityService.getEntityByName(userGuess);

      Entities? guessedEntity;

      if (entityData != null) {
        setState(() {
          guessedEntity = entityData;
        });
      }

      if (guessedEntity != null) {
        if (entityOfTheDay is Map<String, dynamic>) {
          String correctAnswer =
              (entityOfTheDay as Map<String, dynamic>)['name']
                      ?.toString()
                      .toLowerCase() ??
                  '';

          if (userGuess.toLowerCase() == correctAnswer) {
            setState(() {
              tFeitas++;
              tentativas--;
              gameOver = true;
            });
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
            setState(() {
              tFeitas++;
              tentativas--;
            });
            if (tentativas <= 0) {
              setState(() {
                tFeitas++;
                tentativas--;
                gameOver = true;
              });
              showSnackBar(
                  context: context, texto: "Suas tentativas acabaram!");
              DocumentReference userDocument =
                  FirebaseFirestore.instance.collection('users').doc(user?.uid);
              UserStatistics userStatistics = UserStatistics();
              userStatistics.updateStatistics(true, userDocument);
            }
          }

          setState(() {
            if (guessedEntity != null) {
              userGuesses.add(guessedEntity!);
            }
          });
        } else {
          showSnackBar(
              context: context,
              texto: "Erro: Tipo de entidade do dia inválido");
        }

        _try.clear();
      } else {
        showSnackBar(
            context: context,
            texto: "Entidade não encontrada. Tente novamente!");
      }
    }
  }

  Widget buildCharacteristicsIndicators(
      Map<String, dynamic> characteristics, Entities userGuess) {
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
    return ListView.builder(
      shrinkWrap: true,
      itemCount: userGuesses.length,
      itemBuilder: (context, index) {
        Entities guessEntity = userGuesses[index];

        Key cardKey = Key("card_$index");

        return Card(
          key: cardKey,
          child: Column(
            children: [
              ListTile(
                title: Text("Palpite: ${guessEntity.name}"),
              ),
              FutureBuilder<Map<String, dynamic>?>(
                future: Entities.getDocumentByName(guessEntity.name),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final guessedEntity =
                        Entities.fromFirestore(snapshot.data!);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildCharacteristicsIndicators(
                          guessedEntity.toJson(),
                          guessEntity,
                        ),
                      ],
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    width: 100,
                    child: Image.asset("./assets/images/MMH_Logo.png"),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const Text(
                    "ACERTE O MOB DO DIA",
                    style: TextStyle(color: Color(0xffA6BD94), fontSize: 30),
                  ),
                  Container(
                    height: 40,
                  ),
                  Visibility(
                    visible: gameOver,
                    child: StreamBuilder<Duration>(
                      stream: _countdownTimer.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final timeRemaining = snapshot.data!;
                          return Text(
                            'Tempo Restante: ${timeRemaining.inHours}:${(timeRemaining.inMinutes % 60).toString().padLeft(2, '0')}:${(timeRemaining.inSeconds % 60).toString().padLeft(2, '0')}',
                            style: const TextStyle(
                              fontSize: 20,
                              color: Color(0xffA6BD94),
                            ),
                          );
                        } else {
                          return const Text('Carregando...');
                        }
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _try,
                          style: const TextStyle(color: Color(0xffA6BD94)),
                          keyboardType: TextInputType.emailAddress,
                          enabled: !gameOver,
                          decoration: const InputDecoration(
                            hintStyle: TextStyle(color: Color(0xffA6BD94)),
                            labelStyle: TextStyle(color: Color(0xffA6BD94)),
                            labelText: 'Digite aqui um mob',
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xffA6BD94))),
                          ),
                          validator: (email) => combine(
                            [
                              () => isNotEmpty(email),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      TextButton(
                        onPressed: () async {
                          await checkGuess();
                          await fetchEntity();
                        },
                        style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all(
                            const Size.square(65),
                          ),
                          foregroundColor: MaterialStateProperty.all(
                            const Color(0xffA6BD94),
                          ),
                        ),
                        child: const Icon(
                          Icons.send,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Suas Tentativas: $tFeitas",
                        style: const TextStyle(color: Color(0xffA6BD94)),
                      ),
                      Text(
                        "Tentativas Restantes: $tentativas",
                        style: const TextStyle(color: Color(0xffA6BD94)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 300,
                    child: SingleChildScrollView(
                      child: buildGuessCards(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
