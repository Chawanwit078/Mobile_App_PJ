import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import 'quiz.dart';
import 'detail.dart';

class WorkOut extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5D7C4),
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: const Color(0xFFE5D7C4),
        title: const Padding(
          padding: EdgeInsets.only(top: 35, left: 15),
          child: Text(
            'Workout',
            style: TextStyle(
              fontFamily: "KoPub",
              fontWeight: FontWeight.bold,
              fontSize: 35,
              color: Color(0xFF354024),
            ),
          ),
        ),
      ),
      body: const SportListPage(),
    );
  }
}

class SportListPage extends StatefulWidget {
  const SportListPage({super.key});

  @override
  State<SportListPage> createState() => _SportListPageState();
}

class _SportListPageState extends State<SportListPage> {
  List<dynamic> visibleSports = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  Future<void> getInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId != null) {
      try {
        final sports = await ApiService.getRecommendedSportsForUser(userId);
        setState(() {
          visibleSports = sports.take(5).toList(); // ✅ จำกัดแค่ 3 กีฬา
          isLoading = false;
        });
      } catch (e) {
        print("เกิดข้อผิดพลาด: $e");
        setState(() => isLoading = false);
      }
    } else {
      print("ไม่พบ user_id");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());

    if (visibleSports.isEmpty) {
      return const Center(child: Text('ยังไม่มีกีฬาแนะนำ'));
    }

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 20),
      itemCount: visibleSports.length + 2, // Quiz + Header + กีฬา 3 อัน
      separatorBuilder: (_, __) => const Divider(height: 0),
      itemBuilder: (context, index) {
        if (index == 0) return const Quiz();
        if (index == 1) return _headerWidget();

        final i = index - 2;
        final sport = visibleSports[i];

        return ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/images/${sport['pic']}',
              width: 70,
              height: 45,
              fit: BoxFit.cover,
              cacheWidth: 120, // ✅ โหลดภาพขนาดเล็กลง
            ),
          ),
          title: Text(
            sport['name'],
            style: const TextStyle(
              fontFamily: "Inter",
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Color(0xFF354024),
            ),
          ),
          subtitle: Text(
            "${sport['duration']} min | ${sport['calories']} cal",
            style: const TextStyle(
              fontFamily: "Inter",
              fontSize: 12,
              color: Color(0xFF354024),
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SportDetailPage(
                  sportId: sport['id'],
                  sportName: sport['name'],
                  duration: sport['duration'],
                  calories: sport['calories'],
                  pic: sport['pic'],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _headerWidget() {
    return const Padding(
      padding: EdgeInsets.only(left: 30, top: 10, bottom: 20),
      child: Text(
        "Recommended For You",
        style: TextStyle(
          fontFamily: "Inter",
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Color(0xFF354024),
        ),
      ),
    );
  }
}

class Quiz extends StatelessWidget {
  const Quiz({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => QuizPage()))
          .then((result) {
            if (result == 'success') {
              // ✅ เรียก fetch ใหม่หลังจากกลับมา
              final state = context.findAncestorStateOfType<_SportListPageState>();
              state?.getInfo();

              // ✅ แสดง snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Saved successfully!')),
              );
            }
          });
      },
      child: Container(
        width: double.infinity,
        height: 120,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 30),
        decoration: BoxDecoration(
          color: const Color(0xFFA7AD8A),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded( // ✅ ให้ Column ยืดหยุ่นตามพื้นที่
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Not sure which sport suits you?",
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xFF354024),
                    ),
                  ),
                  Text(
                    'Take the quiz!',
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(0xFF354024),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(width: 10), // ✅ เพิ่มช่องว่างเล็กน้อย
            const Icon(
              IconlyBold.document,
              size: 36, // ✅ ขนาดที่ไม่ใหญ่เกินไป
              color: Color(0xFF354024),
            ),
          ],
        ),

      ),
    );
  }
}
