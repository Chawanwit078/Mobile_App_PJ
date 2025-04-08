import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SportDetailPage extends StatefulWidget {
  final int sportId;
  final String sportName;
  final int duration;
  final int calories;
  final String pic; // ✅ เพิ่มรูป

  const SportDetailPage({
    super.key,
    required this.sportId,
    required this.sportName,
    required this.duration,
    required this.calories,
    required this.pic,
  });

  @override
  State<SportDetailPage> createState() => _SportDetailPageState();
}

class _SportDetailPageState extends State<SportDetailPage> {
  bool isLoading = true;
  String description = '';
  List<String> postures = [];
  List<String> benefits = [];

  @override
  void initState() {
    super.initState();
    fetchSportDetail();
  }

  Future<void> fetchSportDetail() async {
    try {
      final detail = await ApiService.getSportDetail(widget.sportId);
      setState(() {
        description = detail['description'];
        postures = List<String>.from(detail['postures']);
        benefits = List<String>.from(detail['benefits']);
        isLoading = false;
      });
    } catch (e) {
      print("Error loading detail: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1E6D3),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // ✅ รูปภาพด้านบน
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(36),
                        bottomRight: Radius.circular(36),
                      ),
                      child: Image.asset(
                        'assets/images/${widget.pic}',
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 40,
                      left: 16,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),

                // ✅ เนื้อหาด้านล่าง
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.sportName,
                          style: TextStyle(
                            fontFamily: "KoPub",
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF354024),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${widget.duration} Min   |   ${widget.calories} kcal',
                          style: TextStyle(
                            color: Color(0xFF6B744D),
                            fontFamily: "Inter",
                            fontSize: 12,                 
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(description, 
                          style: TextStyle(
                              color: Color(0xFF354024),
                              fontFamily: "Inter",
                              fontSize: 16,
                            )
                          ),
                        SizedBox(height: 24),
                        Text(
                          'Common ${widget.sportName} Exercises:',
                          style: TextStyle(
                            fontFamily: "Inter",
                            fontSize: 20, 
                            fontWeight: FontWeight.bold, 
                            color: Color(0xFF354024)
                          ),
                        ),
                        ...postures.map((p) => ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(Icons.circle, size: 8, color: Color(0xFF354024)),
                              title: Text(p, 
                              style: TextStyle(
                                color: Color(0xFF354024),
                                fontFamily: "Inter",
                                fontSize: 16,
                              )),
                            )),
                        SizedBox(height: 24),
                        Text(
                          'Benefits',
                          style: TextStyle(
                            fontFamily: "Inter",
                            fontSize: 20, 
                            fontWeight: FontWeight.bold, 
                            color: Color(0xFF354024)
                          ),
                        ),
                        ...benefits.map((b) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                children: [
                                  Icon(Icons.check_box, size: 18, color: Color(0xFF37421B)),
                                  SizedBox(width: 8),
                                  Expanded(child: Text(b, 
                                  style: TextStyle(
                                    color: Color(0xFF354024),
                                    fontFamily: "Inter",
                                    fontSize: 16,
                                  ))),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
