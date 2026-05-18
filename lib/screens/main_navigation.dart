import 'package:flutter/material.dart';
import 'package:responsive_navigation_bar/responsive_navigation_bar.dart';

import 'home_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  // Liste des pages
  final List<Widget> pages = const [
    HomeScreen(),
  ];

  // Changement d'onglet
  void changeTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],

      bottomNavigationBar: ResponsiveNavigationBar(
        selectedIndex: _selectedIndex,
        onTabChange: changeTab,

        textStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),

        navigationBarButtons: const [
          NavigationBarButton(
            text: 'Home',
            icon: Icons.home,
            backgroundGradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
            ),
          ),
          NavigationBarButton(
            text: 'Contact',
            icon: Icons.mail,
            backgroundGradient: LinearGradient(
              colors: [Colors.orange, Colors.red],
            ),
          ),
        ],
      ),
    );
  }
}