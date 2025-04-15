import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:project_demo/db/database_helper.dart';
import 'add_activity.dart';
import 'edit_activity.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  int stepCount = 0;
  int stepGoal = 10000;
  Stream<StepCount>? _stepCountStream;

  int waterCups = 0;
  int waterGoal = 8;

  List<Map<String, dynamic>> todayActivities = [];
  int userId = 0;

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
    _initialize();
  }

  Future<void> _initialize() async {
    await _requestPermission();
    await _loadUserId();
  }

  Future<void> _requestPermission() async {
    await Permission.activityRecognition.request();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId') ?? 0;

    prefs.remove('initial_steps');
    prefs.remove('initial_steps_user_$userId');

    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final summary = await DatabaseHelper.instance.getDailySummaryByDate(userId, today);

    // ✅ แค่ครั้งแรกของวันนั้นเท่านั้นที่เซฟค่า sensor steps
    if (summary['initial_sensor_steps'] == null) {
      final sensorEvent = await Pedometer.stepCountStream.first;
      await DatabaseHelper.instance.saveInitialSensorSteps(userId, sensorEvent.steps);
    }

    _initPedometer();
    _loadSummary();
    _loadActivities();
  }


  void _initPedometer() async {
    try {
      _stepCountStream = Pedometer.stepCountStream;

      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final summary = await DatabaseHelper.instance.getDailySummaryByDate(userId, today);

      int? initialSensorSteps = summary['initial_sensor_steps'];

      _stepCountStream!.listen((event) async {
        if (initialSensorSteps == null) {
          initialSensorSteps = event.steps;
          await DatabaseHelper.instance.saveInitialSensorSteps(userId, initialSensorSteps!);
        }

        final calculatedSteps = event.steps - initialSensorSteps!;
        final cleanSteps = calculatedSteps < 0 ? 0 : calculatedSteps;

        setState(() {
          stepCount = cleanSteps;
        });

        await DatabaseHelper.instance.saveDailySummary(userId, stepCount, waterCups);
      }).onError((error) {
        debugPrint("Pedometer Error: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("This device does not support step counting."),
            backgroundColor: Colors.redAccent,
          ),
        );
      });
    } catch (e) {
      debugPrint("Pedometer Exception: $e");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Step counter sensor not available on this device."),
            backgroundColor: Colors.redAccent,
          ),
        );
      });
    }
  }

  Future<void> _loadSummary() async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final summary = await DatabaseHelper.instance.getDailySummaryByDate(userId, today);
    setState(() {
      waterCups = summary['water'] ?? 0;
    });
  }

  Future<void> _loadActivities() async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    todayActivities = await DatabaseHelper.instance.getActivitiesByDate(userId, today);
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
                  MaterialPageRoute(
                    builder: (_) => EditActivityPage(activity: activity, userId: userId),
                  ),
                );
                _loadActivities();
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(color: olive, borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.all(12),
                      child: Icon(sportIcons[activity['name']] ?? Icons.fitness_center, color: Colors.white),
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
                MaterialPageRoute(builder: (_) => AddActivityPage(userId: userId)),
              );
              _loadActivities();
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
    return _buildCircularCard("Step", stepCount, stepGoal, yellow, Icons.directions_walk);
  }

  Widget _buildWaterCard() {
    return _buildCircularCard("Water", waterCups, waterGoal, yellow, Icons.local_drink_outlined, isWater: true);
  }

  Widget _buildCircularCard(String label, int value, int goal, Color color, IconData icon, {bool isWater = false}) {
    double percent = (value / goal).clamp(0, 1);
    return AspectRatio(
      aspectRatio: 3 / 4,
      child: Container(
        decoration: BoxDecoration(color: darkGreen, borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: percent),
              duration: const Duration(milliseconds: 300),
              builder: (context, valueAnim, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: CircularProgressIndicator(
                        value: valueAnim,
                        strokeWidth: 8,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation(color),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, size: 24, color: Colors.white),
                        Text("$value", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                        Text("/ $goal", style: const TextStyle(fontSize: 12, color: Colors.white)),
                      ],
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(color: Colors.white)),
            if (isWater)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        if (waterCups > 0) waterCups--;
                      });
                      DatabaseHelper.instance.saveDailySummary(userId, stepCount, waterCups);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        if (waterCups < waterGoal) waterCups++;
                      });
                      DatabaseHelper.instance.saveDailySummary(userId, stepCount, waterCups);
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}