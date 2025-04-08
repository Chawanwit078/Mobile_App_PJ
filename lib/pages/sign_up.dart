import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import '../services/api_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  String gender = 'Male';
  DateTime? selectedDate;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController(); // เปลี่ยนตรงนี้
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dobController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _submitSignUp() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    final userData = {
      "firstName": firstNameController.text.trim(),
      "lastName": lastNameController.text.trim(),
      "username": usernameController.text.trim(), // 👈 ตรงนี้
      "password": passwordController.text.trim(),
      "dob": selectedDate?.toIso8601String().split("T")[0],
      "gender": gender,
      "weight": double.tryParse(weightController.text) ?? 0,
      "height": double.tryParse(heightController.text) ?? 0,
    };

    final success = await ApiService.signUp(userData);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration Successful")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration Failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E3A1B),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Create an account',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildTextField(label: 'First Name', controller: firstNameController),
            const SizedBox(height: 16),
            _buildTextField(label: 'Last Name', controller: lastNameController),
            const SizedBox(height: 16),
            _buildTextField(label: 'Username', controller: usernameController), // 👈
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Password',
              controller: passwordController,
              obscure: _obscurePassword,
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
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Confirm Password',
              controller: confirmPasswordController,
              obscure: _obscureConfirm,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white70,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirm = !_obscureConfirm;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            Text('Date of Birth', style: TextStyle(color: Colors.white)),
            const SizedBox(height: 8),
            TextField(
              controller: dobController,
              readOnly: true,
              onTap: () => _selectDate(context),
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF3E4C2C),
                hintText: 'DD/MM/YYYY',
                hintStyle: TextStyle(color: Colors.white70),
                suffixIcon: Icon(Icons.calendar_today, color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Gender', style: TextStyle(color: Colors.white)),
            Row(
              children: ['Male', 'Female'].map((value) {
                return Expanded(
                  child: RadioListTile(
                    title: Text(
                      value,
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    value: value,
                    groupValue: gender,
                    activeColor: Color(0xFFF7C948),
                    onChanged: (val) {
                      setState(() => gender = val!);
                    },
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildNumberField(
                    label: "Weight (Kg)",
                    controller: weightController,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildNumberField(
                    label: "Height (Cm)",
                    controller: heightController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
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
                onPressed: _submitSignUp,
                child: Text(
                  'Sign Up',
                  style: TextStyle(color: Color(0xFF3E3E3E)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?",
                      style: TextStyle(color: Colors.white)),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.remove('user_id');
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => MyApp()),
                        (route) => false,
                      );
                    },
                    child: Text("Login",
                        style: TextStyle(
                          color: Color(0xFFF7C948),
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool obscure = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        filled: true,
        fillColor: Color(0xFF3E4C2C),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildNumberField({
    required String label,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        filled: true,
        fillColor: Color(0xFF3E4C2C),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
