import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  Map<String, String> selectedOptions = {};

  void selectOption(String question, String option) {
    setState(() {
      selectedOptions[question] = option;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF354024),
      appBar: AppBar(
        backgroundColor: Color(0xFF354024),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Quiz",
          style: TextStyle(
            fontFamily: "Inter",
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildQuestion(
              "What type of activity do you prefer?",
              ["Team sports", "Solo sports", "Water sports", "Extreme sports"],
            ),
            buildQuestion(
              "What is your fitness level?",
              ["Beginner", "Intermediate", "Advanced"],
            ),
            buildQuestion(
              "Do you prefer indoor or outdoor activities?",
              ["Indoor", "Outdoor", "No preference"],
            ),
            buildQuestion(
              "Do you like high-intensity workouts?",
              ["Yes", "No", "Sometimes"],
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  print("Selected options: $selectedOptions");
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF7A8253),
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  "SAVE",
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget buildQuestion(String question, List<String> options) {
    return Padding(
      padding: EdgeInsets.only(top: 15,bottom: 10,left: 17,right: 17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(
              fontFamily: "Inter",
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 15),
          Wrap(
            spacing: 10,
            children: options.map((option) {
              bool isSelected = selectedOptions[question] == option;
              return ChoiceChip(
                label: Text(
                  option,
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    fontFamily: "Inter",
                  ),
                ),
                selected: isSelected,
                selectedColor: Color(0xFFECBB3F),
                backgroundColor: Color(0xFF889063),
                onSelected: (selected) {
                  selectOption(question, option);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
