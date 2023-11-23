import 'package:flutter/material.dart';
import 'package:mmh/classes/user.dart';
import 'package:mmh/named_routes.dart';
import 'package:mmh/screens/login_page.dart';
import 'package:mmh/screens/main_page.dart';
import 'package:mmh/screens/profile_page.dart';
import 'package:mmh/screens/ranking_page.dart';

Map<String, Widget Function(BuildContext)> routes = {
  LoginViewRoute: (p0) => const LoginPage(),
  InitialViemRoute: (context) {
    final arg = ModalRoute.of(context)?.settings.arguments;
    return TelaInicial(
      user: arg as User,
    );
  },
  ProfileViewRoute: (context) {
    final arg = ModalRoute.of(context)?.settings.arguments;
    return ProfilePage(
      user: arg as User,
    );
  },
  RankingViewRoute: (context) {
    final arg = ModalRoute.of(context)?.settings.arguments;
    return RankingPage(
      user: arg as User,
    );
  },
};
