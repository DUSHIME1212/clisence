import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';

enum _SelectedTab { home, chat, profile, settings }

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabChanged;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
  });

  void _handleIndexChanged(int index) {
    onTabChanged(index);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: CrystalNavigationBar(
      currentIndex: currentIndex,
      indicatorColor: Colors.white,
        // enableFloatingNavBar: false,
      unselectedItemColor: Colors.white70,
      backgroundColor: Colors.green.withOpacity(0.9),
      outlineBorderColor: Colors.green.withOpacity(0.1),
      borderWidth: 2,
      onTap: _handleIndexChanged,
      items: [
        CrystalNavigationBarItem(
          icon: Icons.home,
          unselectedIcon: Icons.home,
          selectedColor: Colors.white,
          unselectedColor: Colors.grey[400],
        ),
        CrystalNavigationBarItem(
          icon: Icons.chat,
          unselectedIcon: Icons.chat,
          selectedColor: Colors.white,
          unselectedColor: Colors.grey[400],
        ),
        CrystalNavigationBarItem(
          icon: Icons.person,
          unselectedIcon: Icons.person,
          selectedColor: Colors.white,
          unselectedColor: Colors.grey[400],
        ),
        CrystalNavigationBarItem(
          icon: Icons.settings,
          unselectedIcon: Icons.settings,
          selectedColor: Colors.white,
          unselectedColor: Colors.grey[400],
        ),
      ],
    )
    );
  }
}
