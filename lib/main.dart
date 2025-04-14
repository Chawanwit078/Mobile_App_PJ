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
  int _selectedIndex = 0;
  bool _isLoggedIn = false;
  int? _userId;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
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
    await prefs.setInt('user_id', userId);
    setState(() {
      _isLoggedIn = true;
      _userId = userId;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const HomePage();
      case 1:
        return const CalendarPage();
      case 2:
        return const AddPage();
      case 3:
        return WorkOut();
      case 4:
        return ProfilePage();
      default:
        return const HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/signup': (context) => const SignUpPage(),
      },
      home: _isLoggedIn
          ? Scaffold(
              body: _getPage(_selectedIndex),
              bottomNavigationBar: BottomBar(
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
              ),
            )
          : LoginPage(onLoginSuccess: _handleLoginSuccess),
    );
  }
}
