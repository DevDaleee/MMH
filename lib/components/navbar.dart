import 'package:flutter/material.dart';


BottomNavigationBar navbar() {
  return BottomNavigationBar(
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
