import 'package:flutter/material.dart';
import 'login.dart';

class ProfilePage extends StatelessWidget {
  final Color background = const Color(0xFFF1E6D3);
  final Color darkGreen = const Color(0xFF37421B);
  final Color cardGreen = const Color(0xFF9BA88D);

  final String name = "NOKKIWI";
  final String dob = "6 June 2005";
  final int height = 171;
  final int weight = 60;

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
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => LoginPage()),
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
