import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/homepage.dart';
import 'pages/workout.dart';
import 'pages/calendar.dart';
import 'pages/add.dart';
import 'pages/profile.dart';
import 'pages/login.dart';
import 'pages/sign_up.dart';
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
  bool _isLoggedIn = false;
  int? _userId;

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
  void initState() {
    super.initState();
    _checkLoginStatus(); // ✅ เช็คว่าเคย login มั้ย
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUserId = prefs.getInt('user_id');
    if (savedUserId != null) {
      setState(() {
        _isLoggedIn = true;
        _userId = savedUserId;
      });
    }
  }

  void _handleLoginSuccess(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', userId); // ✅ เก็บ user_id ไว้
    setState(() {
      _isLoggedIn = true;
      _userId = userId;
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
  debugShowCheckedModeBanner: false,
  routes: {
    '/signup': (context) => SignUpPage(),
  },
  home: _isLoggedIn
      ? Scaffold(
          body: IndexedStack(
            index: _selectedIndex,
            children: _pages,
          ),
          bottomNavigationBar: BottomBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        )
      : LoginPage(onLoginSuccess: _handleLoginSuccess),
);

  }
}
