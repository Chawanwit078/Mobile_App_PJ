import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class BottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: const BoxDecoration(
        color: Color(0xFFA7AD8A),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: BottomNavigationBar(
        elevation: 0,
        currentIndex: currentIndex,
        onTap: onTap, // ปิด onTap ของ BottomNavigationBar
        selectedItemColor: Colors.black,
        unselectedItemColor: Color(0xFF354024),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFA7AD8A),
        items: [
          _buildNavItem(IconlyLight.home, "Home", 0),
          _buildNavItem(IconlyLight.calendar, "Calendar", 1),
          _buildNavItem(IconlyLight.plus, "Add", 2),
          _buildNavItem(IconlyLight.ticket_star, "Sport", 3),
          _buildNavItem(IconlyLight.profile, "Profile", 4),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
    IconData icon,
    String label,
    int index,
  ) {
    return BottomNavigationBarItem(label: label, icon: Icon(icon, size: 28));
  }
}
