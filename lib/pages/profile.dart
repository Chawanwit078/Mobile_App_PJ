import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Color background = const Color(0xFFF1E6D3);

  final Color darkGreen = const Color(0xFF37421B);

  final Color cardGreen = const Color(0xFF9BA88D);

  bool isLoading = true;
  String name = "";
  String dob = "";
  int height = 0;
  int weight = 0;

  @override
  void initState() {
    super.initState();
    fetchUserDetail();
  }

  Future<void> fetchUserDetail() async {
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getInt('user_id');

  if (userId != null) {
    try {
      final user = await ApiService.getUserDetail(userId);

      setState(() {
        name = user['username'] ?? '';
        dob = (user['dob'] ?? '').toString().split('T').first; // ตัดเวลาออก (ถ้ามี)

        // ✅ แปลงจาก dynamic เป็น int ป้องกัน NaN
        height = (user['height'] ?? 0).toDouble().round();
        weight = (user['weight'] ?? 0).toDouble().round();

        isLoading = false;
      });
    } catch (e) {
      print("Error fetching user: $e");
      setState(() => isLoading = false);
    }
  }
}


  double calculateBMI(int weight, int height) {
    double heightInM = height / 100;
    return weight / (heightInM * heightInM);
  }

  String getBMICategory(double bmi) {
    if (bmi < 18.5) return "Underweight";
    if (bmi < 25) return "Normal";
    if (bmi < 30) return "Overweight";
    return "Obese";
  }

  @override
  Widget build(BuildContext context) {
    double bmi = calculateBMI(weight, height);
    String bmiCategory = getBMICategory(bmi);

    return Scaffold(
      backgroundColor: background,
      body: Stack(
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: darkGreen,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(36),
                bottomRight: Radius.circular(36),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Profile",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.remove('user_id');

                          // 🚨 ล้าง stack และเริ่มใหม่ที่ MyApp()
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => MyApp()),
                            (route) => false,
                          );
                        },
                        child: const Text(
                          "Log Out",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 30),
                  _buildProfileCard(),
                  const SizedBox(height: 20),
                  _buildBMICard(bmi, bmiCategory),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF1E6D3),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        width: double.infinity,
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: cardGreen,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Icon(Icons.edit, size: 20, color: darkGreen),
                )
              ],
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: TextStyle(
                color: darkGreen,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cake, color: darkGreen),
                const SizedBox(width: 8),
                Text(dob, style: TextStyle(color: darkGreen)),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.straighten, color: darkGreen),
                const SizedBox(width: 8),
                Text("Height $height", style: TextStyle(color: darkGreen)),
                const SizedBox(width: 16),
                Text("|", style: TextStyle(color: darkGreen)),
                const SizedBox(width: 16),
                Text("Weight $weight", style: TextStyle(color: darkGreen)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBMICard(double bmi, String category) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.monitor_weight, color: darkGreen),
          const SizedBox(width: 12),
          Text(
            "BMI : ${bmi.toStringAsFixed(2)} ($category)",
            style: TextStyle(color: darkGreen, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
