import 'package:flutter/material.dart';
import 'package:mmh/classes/user.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key, required User user});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Tela"),
    );
  }
}
