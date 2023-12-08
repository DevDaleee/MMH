import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mmh/named_routes.dart';

class ServiceAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String?> cadastrarUsuario({
    required String email,
    required String senha,
  }) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );
      await userCredential.user!.updateDisplayName(email);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        return "O Usuário já está cadastrado";
      }
      return "Erro desconhecido";
    }
  }

  Future<String?> fazerLogin({
    required String email,
    required String senha,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: senha);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> sair(BuildContext context) async {
    await _firebaseAuth.signOut().then(
          Navigator.pushReplacementNamed(context, LoginViewRoute) as FutureOr
              Function(void value),
        );
  }

  String? currentUserUid() {
    User? user = _firebaseAuth.currentUser;
    return user?.uid;
  }
}
