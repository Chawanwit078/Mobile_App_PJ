import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db/database_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Color darkGreen = const Color(0xFF37421B);
  final Color background = const Color(0xFFF1E6D3);
  final Color olive = const Color(0xFF9BA88D);
  final Color yellow = const Color(0xFFF7C948);

  int userId = 0;
  int currentStreak = 0;
  List<BarChartGroupData> durationBars = [];
  List<BarChartGroupData> stepBars = [];
  List<BarChartGroupData> waterBars = [];

  @override
  void initState() {
    super.initState();
    _loadUserIdAndStats();
  }

  Future<void> _loadUserIdAndStats() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId') ?? 0;
    await _loadChartData();
    await _calculateStreak();
  }

  Future<void> _calculateStreak() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.rawQuery(
      'SELECT DISTINCT date FROM activities WHERE user_id = ? ORDER BY date DESC',
      [userId],
    );

    List<DateTime> dates = result.map((e) => DateTime.parse(e['date'] as String)).toList();
    int streak = 0;
    DateTime today = DateTime.now();

    for (var date in dates) {
      if (date.difference(today.subtract(Duration(days: streak))).inDays == 0) {
        streak++;
      } else {
        break;
      }
    }

    setState(() {
      currentStreak = streak;
    });
  }

  Future<void> _loadChartData() async {
    final now = DateTime.now();
    final last7Days = List.generate(7, (i) => now.subtract(Duration(days: 6 - i)));

    List<BarChartGroupData> durationData = [];
    List<BarChartGroupData> stepData = [];
    List<BarChartGroupData> waterData = [];

    for (int i = 0; i < last7Days.length; i++) {
      final date = DateFormat('yyyy-MM-dd').format(last7Days[i]);
      final activityList = await DatabaseHelper.instance.getActivitiesByDate(userId, date);
      final summary = await DatabaseHelper.instance.getDailySummaryByDate(userId, date);

      // รวมเวลาในหน่วยนาที
      int totalMinutes = 0;
      for (var a in activityList) {
        final parts = a['duration'].toString().split(RegExp(r'h|min'));
        final h = int.tryParse(parts[0].trim()) ?? 0;
        final m = parts.length > 1 ? int.tryParse(parts[1].trim()) ?? 0 : 0;
        totalMinutes += h * 60 + m;
      }

      durationData.add(BarChartGroupData(x: i, barRods: [
        BarChartRodData(toY: totalMinutes.toDouble(), color: yellow, width: 14),
      ]));

      stepData.add(BarChartGroupData(x: i, barRods: [
        BarChartRodData(toY: (summary['steps'] ?? 0).toDouble(), color: yellow, width: 14),
      ]));

      waterData.add(BarChartGroupData(x: i, barRods: [
        BarChartRodData(toY: (summary['water'] ?? 0).toDouble(), color: yellow, width: 14),
      ]));
    }

    setState(() {
      durationBars = durationData;
      stepBars = stepData;
      waterBars = waterData;
    });
  }

  Widget _buildStreakBadge() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: yellow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.local_fire_department, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            "$currentStreak-day Streak",
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart(String title, List<BarChartGroupData> data, String unit, double maxY) {
    final now = DateTime.now();
    final labels = List.generate(7, (i) {
      final d = now.subtract(Duration(days: 6 - i));
      return DateFormat('d').format(d);
    });

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: darkGreen,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 150,
            child: BarChart(
              BarChartData(
                maxY: maxY,
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) {
                        final i = value.toInt();
                        return Text(
                          i >= 0 && i < labels.length ? labels[i] : '',
                          style: const TextStyle(color: Colors.white, fontSize: 10),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, _) =>
                          Text('${value.toInt()}', style: const TextStyle(color: Colors.white, fontSize: 10)),
                    ),
                  ),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                barGroups: data,
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: maxY / 4,
                  getDrawingHorizontalLine: (value) => FlLine(color: Colors.white12, strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Home", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF37421B))),
              const SizedBox(height: 12),
              _buildStreakBadge(),
              _buildBarChart("Workout Duration (min)", durationBars, "min", 100),
              _buildBarChart("Step", stepBars, "steps", 10000),
              _buildBarChart("Water", waterBars, "cups", 10),
            ],
          ),
        ),
      ),
    );
  }
}
