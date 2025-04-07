import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'quiz.dart';

class WorkOut extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xFFE5D7C4),
      appBar: AppBar(
        toolbarHeight: 100,
        title: Padding(
          padding: EdgeInsets.only(top: 35, left: 15),
          child: Text(
            'Workout',
            style: TextStyle(
              fontFamily: "KoPub", 
              fontWeight: FontWeight.bold,
              fontSize: 35,
              color: Color(0xFF354024)
            ),
          ),
        ),
        backgroundColor: Color(0xFFE5D7C4),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Quiz(),
          Padding(
            padding: EdgeInsets.only(left: 30, top: 10,bottom: 30),
            child: Text(
              "Recommended For You",
              style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFF354024)
                ),
            ),
          ),
          Expanded(
            child: SportList()
          )
        ],
      ),
    );
  }
}

class Quiz extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector( // เพิ่ม GestureDetector ครอบ Container
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => QuizPage()),
         ); // ไปที่ QuizPage
      },
      child: Container(
        width: double.infinity,
        height: 120,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 30),
        decoration: BoxDecoration(
          color: Color(0xFFA7AD8A),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
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
            Icon(
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


class SportList extends StatelessWidget{
  List<String> sportPic = ["11.jpg","12.jpg","13.jpg"];
  List<String> sportName = ["SP1","SP2","SP3"];
  List<String> sportMin = ["10 min","20 min","30 min"];
  List<String> sportCal = ["100 cal","200 cal","300 cal"];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: ListView.builder(
          itemCount: sportName.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10), // ทำให้รูปภาพมีมุมโค้ง
                child: Image.asset(
                  'assets/images/${sportPic[index]}', // โหลดรูปจาก assets
                  width: 80,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                sportName[index],
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Color(0xFF354024)
                ),
              ),
              subtitle: Text(
                "${sportMin[index]} | ${sportCal[index]}",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                  color: Color(0xFF354024)
                ),
                ),
              onTap: () {
                // ทำอะไรบางอย่างเมื่อกดไอเทม
                print("เลือก ${sportName[index]}");
              },
            );
          },
        ),
    );
  }

}