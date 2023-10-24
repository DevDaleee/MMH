import 'package:flutter/material.dart';

BottomNavigationBar navbar() {
  return BottomNavigationBar(
    backgroundColor: const Color(0x0038453E),
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.people),
        label: "Contatos",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: "Home",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.list),
        label: "Pacientes",
      )
    ],
  );
}
