import 'package:flutter/material.dart';
import 'package:mmh/components/validations_mixin.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> with ValidationsMixin {
  final _formKey = GlobalKey<FormState>();
  final _try = TextEditingController();
  final tentativas = 10;
  final tFeitas = 0;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
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
                const SizedBox(
                  child: Text(
                    "ACERTE O MOB DO DIA",
                    style: TextStyle(color: Color(0xffA6BD94), fontSize: 30),
                  ),
                ),
                Container(
                  height: 35,
                ),
                TextFormField(
                  controller: _try,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
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
                      () => validacaoEmail(email!),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
