import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:3000';

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

  static Future<List<dynamic>> getRecommendedSportsForUser(int userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user_sport'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load recommended sports');
    }
  }

  static Future<Map<String, dynamic>> getSportDetail(int sportId) async {
  final response = await http.get(Uri.parse('$baseUrl/sport_detail/$sportId'));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load sport detail');
  }
}


  // static Future<bool> saveQuizResult(int userId, String type, String style, int sportId) async {
  //   final response = await http.post(
  //     Uri.parse('$baseUrl/quiz_result'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({
  //       'user_id': userId,
  //       'selected_type': type,
  //       'selected_style': style,
  //       'sport_id': sportId
  //     }),
  //   );
  //   return response.statusCode == 200;
  // }
}
