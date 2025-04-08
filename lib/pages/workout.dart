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
  List<String> sportPic = [];
  List<String> sportName = [];
  List<int> sportMin = [];
  List<int> sportCal = [];
  List<int> sportId = [];
  List<dynamic> allSports = [];
  bool isLoading = true;
  int _loadedCount = 10;

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
        allSports = sports;

        final initial = sports.take(_loadedCount).toList();
        updateVisibleData(initial);
      } catch (e) {
        print("Error fetching sports: $e");
        setState(() => isLoading = false);
      }
    }
  }

  void loadMore() {
    final nextCount = _loadedCount + 10;

    // จำกัดสูงสุดไม่เกิน 20
    final maxCount = nextCount > 20 ? 20 : nextCount;
    final nextBatch = allSports.take(maxCount).toList();

    setState(() {
      _loadedCount = maxCount;
      sportId = nextBatch.map<int>((sport) => sport['id'] as int).toList();
      sportPic = nextBatch.map<String>((sport) => sport['pic'].toString()).toList();
      sportName = nextBatch.map<String>((sport) => sport['name'].toString()).toList();
      sportMin = nextBatch.map<int>((sport) => sport['duration'] as int).toList();
      sportCal = nextBatch.map<int>((sport) => sport['calories'] as int).toList();
    });
  }


  void updateVisibleData(List<dynamic> data) {
    setState(() {
      sportId = data.map<int>((sport) => sport['id'] as int).toList();
      sportPic = data.map<String>((sport) => sport['pic'].toString()).toList();
      sportName = data.map<String>((sport) => sport['name'].toString()).toList();
      sportMin = data.map<int>((sport) => sport['duration'] as int).toList();
      sportCal = data.map<int>((sport) => sport['calories'] as int).toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());

    if (sportName.isEmpty) {
      return const Center(child: Text('ยังไม่มีกีฬาแนะนำ'));
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 20),
      itemCount: sportName.length + 3,
      itemBuilder: (context, index) {
        if (index == 0) return Quiz();
        if (index == 1) return _headerWidget();
        if (index == sportName.length + 2) {
          // ✅ ปุ่มแสดงเฉพาะเมื่อยังไม่เกิน 20 อัน
          if (_loadedCount >= 20 || _loadedCount >= allSports.length) return const SizedBox();
          return Center(
            child: TextButton(
              onPressed: loadMore,
              child: Text("more", style: TextStyle(color: Colors.green[900])),
            ),
          );
        }
        final i = index - 2;
        return _sportItem(i);
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

  Widget _sportItem(int i) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          'assets/images/${sportPic[i]}',
          width: 80,
          height: 50,
          fit: BoxFit.cover,
          cacheWidth: 160,
        ),
      ),
      title: Text(
        sportName[i],
        style: const TextStyle(
          fontFamily: "Inter",
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: Color(0xFF354024),
        ),
      ),
      subtitle: Text(
        "${sportMin[i]} min | ${sportCal[i]} cal",
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
              sportId: sportId[i],
              sportName: sportName[i],
              duration: sportMin[i],
              calories: sportCal[i],
              pic: sportPic[i],
            ),
          ),
        );
      },
    );
  }
}

// ✅ Quiz Widget
class Quiz extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => QuizPage()));
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
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
            const Icon(
              IconlyBold.document,
              size: 50,
              color: Color(0xFF354024),
            ),
          ],
        ),
      ),
    );
  }
}
