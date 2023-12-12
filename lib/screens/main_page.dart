// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mmh/classes/entities.dart';
import 'package:mmh/components/app_color.dart';
import 'package:mmh/components/snackbar.dart';
import 'package:mmh/components/validations_mixin.dart';
import 'package:mmh/services/get_entities.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({Key? key}) : super(key: key);

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> with ValidationsMixin {
  final _formKey = GlobalKey<FormState>();
  final _try = TextEditingController();
  int tentativas = 6;
  int tFeitas = 0;
  final _entityService = EntityService();
  late Object entityOfTheDay;
  List<Entities> userGuesses = [];

  @override
  void initState() {
    super.initState();
    fetchEntity();
  }

  Future<void> fetchEntity() async {
    try {
      entityOfTheDay = await _entityService.getEntityOfTheDay(context);
      print(entityOfTheDay);
      setState(() {});
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
        guessedEntity = entityData;
      }

      if (guessedEntity != null) {
        if (entityOfTheDay is Map<String, dynamic>) {
          String correctAnswer =
              (entityOfTheDay as Map<String, dynamic>)['name']
                      ?.toString()
                      .toLowerCase() ??
                  '';

          if (userGuess.toLowerCase() == correctAnswer) {
            showSnackBar(
              context: context,
              texto: "Parabéns, você acertou!",
              isError: false,
            );
          } else {
            tFeitas++;
            tentativas--;

            if (tentativas <= 0) {
              showSnackBar(
                  context: context, texto: "Suas tentativas acabaram!");
            }
          }

          setState(() {
            if (guessedEntity != null) {
              userGuesses.add(guessedEntity);
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

  Widget buildCharacteristicsIndicators(Map<String, dynamic> characteristics) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          for (var entry in characteristics.entries)
            CharacteristicsIndicator(
              label: entry.key,
              userGuess: _try.text,
              correctAnswer: (entityOfTheDay as Map<String, dynamic>)[entry.key]
                      ?.toString() ??
                  '',
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
        Entities guess = userGuesses[index];

        // Gere uma chave única para cada card
        Key cardKey = Key("card_$index");

        return Card(
          key: cardKey, // Defina a chave para identificar este card
          child: Column(
            children: [
              ListTile(
                title: Text("Palpite: ${guess.name}"),
              ),
              FutureBuilder<Entities?>(
                future: _entityService.getEntityByName(guess.name),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("Erro: ${snapshot.error}");
                  } else if (snapshot.hasData) {
                    final guessedEntity = snapshot.data!.toFirestore();

                    return buildCharacteristicsIndicators(guessedEntity);
                  } else {
                    return showSnackBar(
                      context: context,
                      texto: "Entidade não encontrada",
                    );
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
                    height: 40, // Defina uma altura específica aqui
                  ),
                  TextFormField(
                    controller: _try,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.emailAddress,
                    //onTapOutside: (event) => FocusScope.of(context).unfocus(),
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(color: Colors.white),
                      labelStyle: TextStyle(color: Colors.white),
                      labelText: 'Digite aqui um mob',
                      hintText: 'Axolote',
                      border: OutlineInputBorder(),
                    ),
                    validator: (email) => combine(
                      [
                        () => isNotEmpty(email),
                        () => hasFiveChars(email),
                      ],
                    ),
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
                  ElevatedButton(
                    onPressed: () async {
                      await checkGuess();
                      await fetchEntity();
                    },
                    child: const Text("Enviar Palpite"),
                  ),
                  const SizedBox(height: 20),
                  SingleChildScrollView(
                    child: buildGuessCards(),
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
