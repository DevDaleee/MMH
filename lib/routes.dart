import 'package:flutter/material.dart';
import 'package:mmh/named_routes.dart';
import 'package:mmh/screens/help_page.dart';
import 'package:mmh/screens/login_page.dart';
import 'package:mmh/screens/profile_page.dart';
import 'package:mmh/screens/ranking_page.dart';
import 'package:mmh/screens/root.dart';

Map<String, Widget Function(BuildContext)> routes = {
  InitialViewRoute: (p0) => const Root(),
  LoginViewRoute: (p0) => const LoginPage(),
  RankingViewRoute: (p0) => const RankingPage(),
  ProfileViewRoute: (p0) => const ProfilePage(),
  EntitiesTipsViewRoute: (p0) => const HelpPage(),
};
