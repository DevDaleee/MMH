import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mmh/components/validations_mixin.dart';
import 'package:mmh/providers/count_down.dart';
import 'package:mmh/providers/game_stats.dart';
import 'package:mmh/providers/home_provider.dart';
import 'package:provider/provider.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> with ValidationsMixin {
  final _formKey = GlobalKey<FormState>();
  final _try = TextEditingController();
  final UserStatistics userStats = UserStatistics();
  final user = FirebaseAuth.instance.currentUser;
  final CountdownTimer _countdownTimer = CountdownTimer();

  @override
  void dispose() {
    _countdownTimer.dispose();
    super.dispose();
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
          child: Consumer<GameProvider>(
            builder: (context, gameProvider, _) {
              return Form(
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
                        style:
                            TextStyle(color: Color(0xffA6BD94), fontSize: 30),
                      ),
                      Container(
                        height: 20,
                      ),
                      Visibility(
                        visible: gameProvider.gameOver,
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
                              keyboardType: TextInputType.text,
                              enabled: !gameProvider.gameOver,
                              decoration: const InputDecoration(
                                hintStyle: TextStyle(color: Color(0xffA6BD94)),
                                labelStyle: TextStyle(color: Color(0xffA6BD94)),
                                labelText: 'Digite aqui um mob',
                                border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xffA6BD94)),
                                ),
                              ),
                              validator: (mob) => combine(
                                [
                                  () => isNotEmpty(mob),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          TextButton(
                            onPressed: () async {
                              await gameProvider.fetchEntity();
                              await gameProvider.checkGuess(_formKey, _try);
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
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Suas Tentativas: ${gameProvider.tFeitas}",
                            style: const TextStyle(color: Color(0xffA6BD94)),
                          ),
                          Text(
                            "Tentativas Restantes: ${gameProvider.tentativas}",
                            style: const TextStyle(color: Color(0xffA6BD94)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 250,
                        child: SingleChildScrollView(
                          child: gameProvider.buildGuessCards(),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
