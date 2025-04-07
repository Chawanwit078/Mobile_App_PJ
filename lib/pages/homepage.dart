import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final darkGreen = const Color(0xFF37421B);
  final yellow = const Color(0xFFF7C948);
  final background = const Color(0xFFF1E6D3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Home",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF37421B),
                  ),
                ),
                const SizedBox(height: 16),
                _buildStreakCard(),
                const SizedBox(height: 16),
                _buildWorkoutChart(),
                const SizedBox(height: 16),
                _buildStepChart(),
                const SizedBox(height: 16),
                _buildWaterCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStreakCard() {
    List<String> days = ['M', 'T', 'W', 'Th', 'F', 'S', 'Su'];
    List<bool> isActive = [true, true, true, true, false, false, false];

    return Container(
      decoration: BoxDecoration(
        color: darkGreen,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            "4 Day Streak!",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const Text(
            "Keep it up!, Kainuii",
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (index) {
              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: isActive[index] ? yellow : Colors.green[300],
                      shape: BoxShape.circle,
                    ),
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    days[index],
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutChart() {
    List<int> data = [60, 70, 55, 60];
    List<String> days = ['17', '18', '19', '20'];

    return _buildChartCard("Workout Duration (min)", data, days, yMax: 80);
  }

  Widget _buildStepChart() {
    List<int> steps = [9000, 5000, 10000, 7000];
    List<String> days = ['17', '18', '19', '20'];

    return _buildChartCard("Step", steps, days, yMax: 10000);
  }

  Widget _buildChartCard(String title, List<int> values, List<String> days,
      {required int yMax}) {
    return Container(
      decoration: BoxDecoration(
        color: darkGreen,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(values.length, (index) {
              double height = (values[index] / yMax) * 80;
              return Column(
                children: [
                  Container(
                    width: 12,
                    height: height,
                    decoration: BoxDecoration(
                      color: yellow,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    days[index],
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildWaterCard() {
    return Container(
      decoration: BoxDecoration(
        color: darkGreen,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(24),
      child: const Center(
        child: Text(
          "Water",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}