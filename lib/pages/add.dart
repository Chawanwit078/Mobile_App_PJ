import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:pedometer/pedometer.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  int stepCount = 0;
  int stepGoal = 10000;
  int? initialSteps;

  Stream<StepCount>? _stepCountStream;

  int waterCups = 3;
  int waterGoal = 8;

  final Color darkGreen = const Color(0xFF37421B);
  final Color yellow = const Color(0xFFF7C948);
  final Color background = const Color(0xFFF1E6D3);
  final Color olive = const Color(0xFF9BA88D);

  @override
  void initState() {
    super.initState();
    _initPedometer();
  }

  void _initPedometer() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream!.listen((event) {
      if (initialSteps == null) {
        initialSteps = event.steps;
      }
      setState(() {
        stepCount = event.steps - (initialSteps ?? 0);
      });
    }).onError((error) {
      print('Pedometer Error: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Today",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF37421B),
                  ),
                ),
                const SizedBox(height: 16),
                _buildActivityCard(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildStepCard()),
                    const SizedBox(width: 12),
                    Expanded(child: _buildWaterCard()),
                  ],
                ),
                const SizedBox(height: 16),
                _buildIntakeCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivityCard() {
    return Container(
      decoration: BoxDecoration(
        color: darkGreen,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Today’s Activities", style: TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 4),
          Text("1 Hours", style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: olive,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12),
                child: Icon(Icons.fitness_center, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Weight Training", style: TextStyle(color: Colors.white)),
                  Text("Feb 20  |  1 Hour", style: TextStyle(color: Colors.white70)),
                ],
              )
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 40,
            width: double.infinity,
            decoration: BoxDecoration(
              color: olive,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text("Add activities manually", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard() {
    double percent = stepCount / stepGoal;

    return AspectRatio(
      aspectRatio: 3 / 4,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: CircularProgressIndicator(
                      value: percent.clamp(0, 1),
                      strokeWidth: 8,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation(yellow),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(IconlyLight.activity, size: 24),
                      Text("$stepCount", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("/$stepGoal", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text("Step", style: TextStyle(color: darkGreen)),
          ],
        ),
      ),
    );
  }

  Widget _buildWaterCard() {
    double percent = waterCups / waterGoal;

    return AspectRatio(
      aspectRatio: 3 / 4,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: CircularProgressIndicator(
                      value: percent.clamp(0, 1),
                      strokeWidth: 8,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation(darkGreen),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.local_drink_outlined, size: 24),
                      Text("$waterCups", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("/ $waterGoal cups", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text("Water", style: TextStyle(color: darkGreen)),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (waterCups > 0) waterCups--;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      if (waterCups < waterGoal) waterCups++;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntakeCard() {
    return Container(
      decoration: BoxDecoration(
        color: darkGreen,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Today’s intake", style: TextStyle(color: Colors.white)),
              Text("250 kcal in total", style: TextStyle(color: Colors.white70)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.restaurant_menu, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("ลาบหมูข้าวเหนียว", style: TextStyle(color: Colors.white)),
                    Text("Breakfast  |  250 kcal", style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
              Text("9 AM", style: TextStyle(color: Colors.white70)),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 36,
            decoration: BoxDecoration(
              color: olive,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text("+ Add", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
