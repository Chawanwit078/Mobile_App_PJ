import 'package:flutter/material.dart';
import 'pages/homepage.dart';
import 'pages/workout.dart';
import 'pages/calendar.dart';
import 'pages/add.dart';
import 'pages/profile.dart';
import 'nav.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0; // ตำแหน่งปัจจุบันของหน้า

  final List<Widget> _pages = [
    HomePage(),
    CalendarPage(),
    AddPage(),
    WorkOut(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // เปลี่ยนหน้าเมื่อกดปุ่ม
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
        bottomNavigationBar: BottomBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
