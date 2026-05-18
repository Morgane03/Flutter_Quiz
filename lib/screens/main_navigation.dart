import 'package:flutter/material.dart';
import '../assets/const/color.dart';
import '../pages.dart';
import '../widgets/nav_item.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  void changeTab(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorbackground,

      body: appPages[_selectedIndex],

      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFEAEAEA))),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NavItem(
              icon: Icons.home_outlined,
              label: "Home",
              active: _selectedIndex == 0,
              onTap: () => changeTab(0),
            ),
            NavItem(
              icon: Icons.list,
              label: "Quiz",
              active: _selectedIndex == 1,
              onTap: () => changeTab(1),
            ),
            NavItem(
              icon: Icons.settings,
              label: "Config",
              active: _selectedIndex == 2,
              onTap: () => changeTab(2),
            ),
          ],
        ),
      ),
    );
  }
}
