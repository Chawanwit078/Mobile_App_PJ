import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_demo/db/database_helper.dart';

class EditActivityPage extends StatefulWidget {
  final Map<String, dynamic> activity;
  final int userId;

  const EditActivityPage({super.key, required this.activity, required this.userId});

  @override
  State<EditActivityPage> createState() => _EditActivityPageState();
}

class _EditActivityPageState extends State<EditActivityPage> {
  final Color darkGreen = const Color(0xFF2E3A1B);
  final Color olive = const Color(0xFF9BA88D);

  final List<String> sports = [
    'Running', 'Cycling', 'Yoga', 'Swimming',
    'Weight Training', 'Basketball', 'Football',
  ];

  final Map<String, IconData> sportIcons = {
    'Running': Icons.directions_run,
    'Cycling': Icons.directions_bike,
    'Yoga': Icons.self_improvement,
    'Swimming': Icons.pool,
    'Weight Training': Icons.fitness_center,
    'Basketball': Icons.sports_basketball,
    'Football': Icons.sports_football,
  };

  String? selectedSport;
  int selectedHour = 0;
  int selectedMinute = 0;
  DateTime today = DateTime.now();

  @override
  void initState() {
    super.initState();
    selectedSport = widget.activity['name'];
    final durationParts = widget.activity['duration'].split(' ');
    selectedHour = int.tryParse(durationParts[0].replaceAll('h', '')) ?? 0;
    selectedMinute = int.tryParse(durationParts[1].replaceAll('min', '')) ?? 0;
    today = DateTime.tryParse(widget.activity['date']) ?? DateTime.now();
  }

  Future<void> updateActivity() async {
    final updatedData = {
      'name': selectedSport,
      'duration': '${selectedHour}h ${selectedMinute}min',
      'date': DateFormat('yyyy-MM-dd').format(today),
    };

    await DatabaseHelper.instance.updateActivity(
      widget.activity['id'],
      updatedData,
    );

    Navigator.pop(context);
  }

  Future<void> deleteActivity() async {
    await DatabaseHelper.instance.deleteActivity(widget.activity['id']);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkGreen,
      appBar: AppBar(
        backgroundColor: darkGreen,
        elevation: 0,
        title: const Text("Edit Activity", style: TextStyle(color: Colors.white)),
        leading: const BackButton(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                const Text("Activities", style: TextStyle(color: Colors.white)),
                const SizedBox(width: 16),
                Expanded(child: _buildSportDropdown()),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Duration", style: TextStyle(color: Colors.white)),
                Row(
                  children: [
                    _buildTimeSelector("h", selectedHour, (val) => setState(() => selectedHour = val)),
                    const SizedBox(width: 12),
                    _buildTimeSelector("min", selectedMinute, (val) => setState(() => selectedMinute = val)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Date", style: TextStyle(color: Colors.white)),
                Text(
                  DateFormat('MMMM d, yyyy').format(today),
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            const Spacer(),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: updateActivity,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: olive,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text("SAVE", style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: deleteActivity,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[400],
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text("DELETE", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSportDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: olive,
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedSport,
          dropdownColor: olive,
          hint: const Text("Select activity", style: TextStyle(color: Colors.white)),
          items: sports.map((sport) {
            return DropdownMenuItem(
              value: sport,
              child: Row(
                children: [
                  Icon(sportIcons[sport], color: Colors.white),
                  const SizedBox(width: 8),
                  Text(sport, style: const TextStyle(color: Colors.white)),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) => setState(() => selectedSport = value),
        ),
      ),
    );
  }

  Widget _buildTimeSelector(String label, int value, ValueChanged<int> onChanged) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: olive,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: value,
              dropdownColor: olive,
              items: List.generate(label == "h" ? 10 : 60, (index) => index).map((val) {
                return DropdownMenuItem(
                  value: val,
                  child: Text("$val", style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: (val) => val != null ? onChanged(val) : null,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}
