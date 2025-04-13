import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/database_helper.dart';

class AddActivityPage extends StatefulWidget {
  final int userId; // ✅ รับ userId จากหน้าที่เรียกใช้

  const AddActivityPage({super.key, required this.userId});

  @override
  State<AddActivityPage> createState() => _AddActivityPageState();
}

class _AddActivityPageState extends State<AddActivityPage> {
  final Color darkGreen = const Color(0xFF2E3A1B);
  final Color olive = const Color(0xFF9BA88D);

  final List<String> sports = [
    'Running', 'Cycling', 'Yoga', 'Swimming', 'Weight Training', 'Basketball', 'Football'
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
  int selectedMinute = 1;
  DateTime today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkGreen,
      appBar: AppBar(
        backgroundColor: darkGreen,
        elevation: 0,
        title: const Text("Add Activities", style: TextStyle(color: Colors.white)),
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
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: olive,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedSport,
                        dropdownColor: olive,
                        hint: const Text("Select", style: TextStyle(color: Colors.white)),
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
                        onChanged: (value) {
                          setState(() {
                            selectedSport = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Duration", style: TextStyle(color: Colors.white)),
                Row(
                  children: [
                    _buildTimeSelector("h", selectedHour, (val) {
                      setState(() => selectedHour = val);
                    }),
                    const SizedBox(width: 12),
                    _buildTimeSelector("min", selectedMinute, (val) {
                      setState(() => selectedMinute = val);
                    }),
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: olive,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () async {
                  if (selectedSport != null) {
                    final duration = '${selectedHour}h ${selectedMinute}min';
                    final date = DateFormat('yyyy-MM-dd').format(today);
                    await DatabaseHelper.instance.insertActivity(
                      widget.userId, // ✅ ส่ง userId เข้าไป
                      selectedSport!,
                      duration,
                      date,
                    );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please select an activity")),
                    );
                  }
                },
                child: const Text("ADD", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
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
              onChanged: (val) {
                if (val != null) onChanged(val);
              },
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}
