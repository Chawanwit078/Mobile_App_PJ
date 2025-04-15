import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.1.100:3000'; // ใช้กับ Android Emulator
  // ถ้าเป็นอุปกรณ์จริง: ใช้ IP เครื่องคอมแทน เช่น 192.168.1.5

  // 🔐 Login
  static Future<int?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['user_id'];
    } else {
      return null;
    }
  }

  // 🧠 Quiz Result
  static Future<List<dynamic>> getRecommendedSportsForUser(int userId) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/user_sport'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'user_id': userId}),
          )
          .timeout(const Duration(seconds: 5)); // ✅ เพิ่ม timeout

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("⚠️ getRecommendedSportsForUser: Bad status ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("❌ getRecommendedSportsForUser Error: $e");
      return []; // ป้องกันแอพ crash
    }
  }

  // 🏅 Sport Detail
  static Future<Map<String, dynamic>> getSportDetail(int sportId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/sport_detail/$sportId'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load sport detail');
    }
  }

  // 📝 Sign Up
  static Future<bool> signUp(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['success'] == true;
    } else {
      return false;
    }
  }

  static Future<Map<String, dynamic>> getUserDetail(int userId) async {
    final response = await http
        .get(Uri.parse('$baseUrl/user_detail/$userId'))
        .timeout(const Duration(seconds: 5)); // ✅ timeout กันค้าง

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load user detail');
    }
  }

  static Future<void> saveUserQuizAnswers(int userId, String type, String style) async {
    final response = await http.post(
      Uri.parse('$baseUrl/save_quiz'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'selected_type': type,
        'selected_style': style,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to save quiz answers');
    }
  }

}
