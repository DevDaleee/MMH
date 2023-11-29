import 'package:flutter/material.dart';
import 'package:mmh/classes/user.dart';
import 'package:mmh/named_routes.dart';
import 'package:mmh/screens/login_page.dart';
import 'package:mmh/screens/main_page.dart';
import 'package:mmh/screens/profile_page.dart';
import 'package:mmh/screens/ranking_page.dart';

Map<String, Widget Function(BuildContext)> routes = {
  InitialViemRoute: (p0) => const TelaInicial(),
  LoginViewRoute: (p0) => const LoginPage(),
  RankingViewRoute: (p0) => const RankingPage(),
  ProfileViewRoute: (context) {
    final arg = ModalRoute.of(context)?.settings.arguments;
    return ProfilePage(
      user: arg as User,
    );
  },
};
