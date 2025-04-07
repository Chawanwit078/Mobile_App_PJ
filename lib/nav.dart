import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class BottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  BottomBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16), // Add padding
      decoration: BoxDecoration(
        color: Color(0xFFA7AD8A), // Background color
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ), // Optional: Rounded corners
      ),
      child: BottomNavigationBar(
        elevation: 0,
        currentIndex: currentIndex,
        onTap: onTap,
        selectedItemColor: Colors.black,
        unselectedItemColor: Color(0xFF354024),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFFA7AD8A), // Remove default background
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

  BottomNavigationBarItem _buildNavItem(IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      label: label,
      icon: ZoomTapAnimation(
        onTap: () => onTap(index), // เมื่อกดให้เปลี่ยนหน้า
        child: Icon(
          icon,
          size: 28, // ปรับขนาดไอคอน
        ),
      ),
    );
  }
}
