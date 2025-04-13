import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import '../db/database_helper.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  List<Map<String, dynamic>> activities = [];
  int steps = 0;
  int water = 0;
  int userId = 0;

  final Color background = const Color(0xFFF1E6D3);
  final Color darkGreen = const Color(0xFF37421B);
  final Color olive = const Color(0xFF9BA88D);
  final Color yellow = const Color(0xFFF7C948);

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
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId') ?? 0;
    await _loadStatsForDate(_selectedDay);
  }

  Future<void> _loadStatsForDate(DateTime date) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    activities = await DatabaseHelper.instance.getActivitiesByDate(userId, formattedDate);
    final summary = await DatabaseHelper.instance.getDailySummaryByDate(userId, formattedDate);
    steps = summary['steps'];
    water = summary['water'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Calendar", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF37421B))),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: darkGreen,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(8),
                child: TableCalendar(
                  focusedDay: _focusedDay,
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2100, 12, 31),
                  selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                    _loadStatsForDate(selectedDay);
                  },
                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(color: olive, shape: BoxShape.circle),
                    todayDecoration: BoxDecoration(color: yellow, shape: BoxShape.circle),
                    weekendTextStyle: const TextStyle(color: Colors.white70),
                    defaultTextStyle: const TextStyle(color: Colors.white),
                    outsideDaysVisible: false,
                  ),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(color: Colors.white),
                    leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
                    rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
                  ),
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      return Center(child: Text('${day.day}', style: const TextStyle(color: Colors.white)));
                    },
                  ),
                  calendarFormat: CalendarFormat.month,
                  startingDayOfWeek: StartingDayOfWeek.sunday,
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle: TextStyle(color: Colors.white70),
                    weekendStyle: TextStyle(color: Colors.white70),
                  ),
                  availableGestures: AvailableGestures.all,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildActivityCard(),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(child: _buildProgressCard("Step", steps, 10000, yellow, Icons.directions_walk)),
                          const SizedBox(width: 12),
                          Expanded(child: _buildProgressCard("Water", water, 8, yellow, Icons.local_drink)),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityCard() {
    int totalMin = 0;

    for (var a in activities) {
      var duration = a['duration'];
      if (duration is String && duration.contains('h')) {
        final parts = duration.split(RegExp(r'h|min'));
        int hour = int.tryParse(parts[0].trim()) ?? 0;
        int min = parts.length > 1 ? int.tryParse(parts[1].trim()) ?? 0 : 0;
        totalMin += hour * 60 + min;
      }
    }

    String dateText = DateFormat('d MMM').format(_selectedDay);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: darkGreen, borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$dateText Activities", style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
          Text("$totalMin min", style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 12),
          ...activities.map((a) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(sportIcons[a['name']] ?? Icons.fitness_center, color: Colors.white),
                  const SizedBox(width: 8),
                  Text("${a['name']}", style: const TextStyle(color: Colors.white)),
                  const Spacer(),
                  Text("${a['duration']}", style: const TextStyle(color: Colors.white70)),
                ],
              ),
            );
          }).toList()
        ],
      ),
    );
  }

  Widget _buildProgressCard(String label, int value, int goal, Color color, IconData icon) {
    double percent = (value / goal).clamp(0, 1);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(
                  value: percent,
                  strokeWidth: 8,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: darkGreen),
                  Text("$value", style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text("/ $goal", style: const TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: darkGreen, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
