import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatRepository {
  static const baseUrl = "http://45.129.87.38:6065";

  Future<List<dynamic>> getUserChats(String userId, String token) async {
    final url = Uri.parse("$baseUrl/chats/user-chats/$userId");

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["chats"] ?? [];
    } else {
      throw Exception("Failed to load chats: ${response.body}");
    }
  }

  Future<List<dynamic>> getMessages(String chatId, String token) async {
    final url = Uri.parse("$baseUrl/messages/get-messagesformobile/$chatId");

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["messages"] ?? [];
    } else {
      throw Exception("Failed to load messages: ${response.body}");
    }
  }

  Future<Map<String, dynamic>> sendMessage({
    required String chatId,
    required String senderId,
    required String content,
    String messageType = "text",
    String fileUrl = "",
    required String token,
  }) async {
    final url = Uri.parse("$baseUrl/messages/sendMessage");

    final body = {
      "chatId": chatId,
      "senderId": senderId,
      "content": content,
      "messageType": messageType,
      "fileUrl": fileUrl,
    };

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to send message: ${response.body}");
    }
  }
}
