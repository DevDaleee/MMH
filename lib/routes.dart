import 'package:flutter/material.dart';
import 'package:mmh/named_routes.dart';
import 'package:mmh/screens/login_page.dart';
import 'package:mmh/screens/main_page.dart';
import 'package:mmh/screens/profile_page.dart';
import 'package:mmh/screens/ranking_page.dart';
import 'package:mmh/screens/root.dart';

Map<String, Widget Function(BuildContext)> routes = {
  InitialViewRoute: (p0) => const TelaInicial(),
  RootViewRoute: (p0) => const Root(),
  LoginViewRoute: (p0) => const LoginPage(),
  ProfileViewRoute: (p0) => const ProfilePage(),
  RankingViewRoute: (p0) => const RankingPage(),
};
