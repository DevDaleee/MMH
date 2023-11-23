import 'package:flutter/material.dart';
import 'package:mmh/classes/user.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key, required User user});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Ranking"));
  }
}
