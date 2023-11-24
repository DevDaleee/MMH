import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mmh/classes/rest_client.dart';
import 'package:mmh/core/dio_client.dart';
import 'package:mmh/named_routes.dart';
import 'package:mmh/routes.dart';

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        scaffoldBackgroundColor: const Color(0xFF38453E),
        useMaterial3: true,
      ),
      routes: routes,
      initialRoute: LoginViewRoute,
    );
  }
}
