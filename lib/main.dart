import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mmh/classes/rest_client.dart';
import 'package:mmh/classes/user.dart';
import 'package:mmh/core/dio_client.dart';
import 'package:mmh/screens/login_page.dart';
import 'package:mmh/screens/main_page.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    GetIt.I.registerLazySingleton<RestClient>(() => DioClient());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minecraft Mistery Hunt',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        scaffoldBackgroundColor: const Color(0xFF38453E),
        useMaterial3: true,
      ),
      home: const RoteadorTela(),
    );
  }
}

class RoteadorTela extends StatelessWidget {
  const RoteadorTela({super.key});

  @override
  Widget build(BuildContext context) {
    //var usuarioAutenticado = const LoginPage();
    //if (usuarioAutenticado != null) {
      // return TelaInicial(
      //   user: usuarioAutenticado as User,
      // );
    //} else {
      return const LoginPage();
    //}
  }
}
