import 'package:flutter/material.dart';
import 'package:mmh/classes/user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required User user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Perfil"));
  }
}
