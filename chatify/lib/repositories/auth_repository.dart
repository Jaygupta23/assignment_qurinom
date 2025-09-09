import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthResult {
  final String userId;
  final String token;
  AuthResult(this.userId, this.token);
}

class AuthRepository {
  static const baseUrl = "http://45.129.87.38:6065";

  Future<AuthResult> login(String email, String password, String role) async {
    final url = Uri.parse("$baseUrl/user/login");

    final body = {
      "email": email,
      "password": password,
      "role": role,
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final data = responseBody['data'];
      final userId = data["user"]["_id"];
      final token = data["token"];
      if (userId != null && token != null) {
        return AuthResult(userId, token);
      } else {
        throw Exception("Invalid response structure");
      }
    } else {
      throw Exception(responseBody["msg"] ?? "Something went wrong");
    }
  }
}
