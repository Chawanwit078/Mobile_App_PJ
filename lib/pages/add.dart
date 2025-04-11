import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:pedometer/pedometer.dart';
import 'package:sqflite/sqflite.dart';

import 'add_activity.dart';
import 'edit_activity.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  int stepCount = 0;
  int? initialSteps;
  int stepGoal = 10000;
  Stream<StepCount>? _stepCountStream;

  int waterCups = 0;
  int waterGoal = 8;

  List<Map<String, dynamic>> todayActivities = [];

  final Color darkGreen = const Color(0xFF37421B);
  final Color yellow = const Color(0xFFF7C948);
  final Color background = const Color(0xFFF1E6D3);
  final Color olive = const Color(0xFF9BA88D);

  final Map<String, IconData> sportIcons = {
    'Running': Icons.directions_run,
    'Cycling': Icons.directions_bike,
    'Yoga': Icons.self_improvement,
    'Swimming': Icons.pool,
    'Weight Training': Icons.fitness_center,
    'Basketball': Icons.sports_basketball,
    'Football': Icons.sports_football,
  };

  @override
  void initState() {
    super.initState();
    _initPedometer();
    fetchTodayActivities();
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
      debugPrint("Pedometer Error: $error");
    });
  }

  Future<void> fetchTodayActivities() async {
    final dbPath = await getDatabasesPath();
    final db = await openDatabase(p.join(dbPath, 'activities.db'));
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    todayActivities = await db.query(
      'activities',
      where: 'date = ?',
      whereArgs: [today],
      orderBy: 'id DESC',
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Today", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF37421B))),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityCard() {
    return Container(
      decoration: BoxDecoration(color: darkGreen, borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Today’s Activities", style: TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 4),
          Text("${todayActivities.length} Activities", style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 12),
          ...todayActivities.map((activity) {
            return GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EditActivityPage(activity: activity)),
                );
                fetchTodayActivities();
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(color: olive, borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.all(12),
                      child: Icon(
                        sportIcons[activity['name']] ?? Icons.fitness_center,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(activity['name'], style: const TextStyle(color: Colors.white)),
                        Text("${activity['date']}  |  ${activity['duration']}", style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          const SizedBox(height: 8),
          InkWell(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddActivityPage()),
              );
              fetchTodayActivities();
            },
            child: Container(
              height: 40,
              width: double.infinity,
              decoration: BoxDecoration(color: olive, borderRadius: BorderRadius.circular(10)),
              child: const Center(
                child: Text("Add activities manually", style: TextStyle(color: Colors.white)),
              ),
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
        decoration: BoxDecoration(color: darkGreen, borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: percent.clamp(0, 1)),
              duration: const Duration(milliseconds: 300),
              builder: (context, value, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: CircularProgressIndicator(
                        value: value,
                        strokeWidth: 8,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation(yellow),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(IconlyLight.activity, size: 24, color: Colors.white),
                        Text("$stepCount", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                        Text("/$stepGoal", style: const TextStyle(fontSize: 12, color: Colors.white)),
                      ],
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 8),
            Text("Step", style: TextStyle(color: Colors.white)),
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
        decoration: BoxDecoration(color: darkGreen, borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: percent.clamp(0, 1)),
              duration: const Duration(milliseconds: 300),
              builder: (context, value, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: CircularProgressIndicator(
                        value: value,
                        strokeWidth: 8,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation(yellow),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.local_drink_outlined, size: 24, color: Colors.white),
                        Text("$waterCups", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                        const Text("/ 8 cups", style: TextStyle(fontSize: 12, color: Colors.white)),
                      ],
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 8),
            Text("Water", style: TextStyle(color: Colors.white)),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, color: Colors.white),
                  onPressed: () => setState(() => waterCups = (waterCups > 0) ? waterCups - 1 : 0),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () => setState(() => waterCups = (waterCups < waterGoal) ? waterCups + 1 : waterCups),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
