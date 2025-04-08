import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class LoginPage extends StatefulWidget {
  final Function(int userId) onLoginSuccess;

  const LoginPage({super.key, required this.onLoginSuccess});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;
  final TextEditingController usernameController = TextEditingController(); // 👈 เปลี่ยนชื่อ controller
  final TextEditingController passwordController = TextEditingController();

  Future<void> _login() async {
    final username = usernameController.text.trim(); // 👈 ใช้ username
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Please enter Username and Password"),
        ),
      );
      return;
    }

    final userId = await ApiService.login(username, password);

    if (userId != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('user_id', userId);
      widget.onLoginSuccess(userId);
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Login Failed"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E3A1B),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Hi, Ready to work out?',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text('Username', style: TextStyle(color: Colors.white)), // 👈 เปลี่ยน label
                const SizedBox(height: 8),
                TextField(
                  controller: usernameController, // 👈 ใช้ usernameController
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFF3E4C2C),
                    hintText: 'Username', // 👈 เปลี่ยน hint
                    hintStyle: TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text('Password', style: TextStyle(color: Colors.white)),
                const SizedBox(height: 8),
                TextField(
                  controller: passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFF3E4C2C),
                    hintText: 'Enter Your Password',
                    hintStyle: TextStyle(color: Colors.white70),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.white70,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF7C948),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _login,
                    child: Text(
                      'Login',
                      style: TextStyle(color: Color(0xFF3E3E3E)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don’t have an account ? ",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Color(0xFFF7C948),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
