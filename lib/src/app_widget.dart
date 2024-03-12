import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mmh/routes.dart';
import 'package:mmh/src/screens/login_page.dart';
import 'package:mmh/src/screens/root.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Minecraft Mistery Hunt',
      theme: ThemeData(
        fontFamily: 'Jua',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        scaffoldBackgroundColor: const Color(0xFF324E3F),
        useMaterial3: true,
      ),
      routes: routes,
      home: const RoteadorTela(),
    );
  }
}

class RoteadorTela extends StatelessWidget {
  const RoteadorTela({Key? key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const Root();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
