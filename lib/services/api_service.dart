import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';

class ApiService {
  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      print('API Response Status: ${response.statusCode}');
      print('API Response Headers: ${response.headers}');
      print('API Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = jsonDecode(response.body);
        String? token = body['token'] ?? body['access_token'];
        Map<String, dynamic>? userData = body['data']?['user'];

        if (token == null && body['data'] != null && body['data'] is Map) {
          token = body['data']['token'] ?? body['data']['access_token'];
        }

        if (token == null) {
          token = response.headers['authorization'] ??
              response.headers['Authorization'];
        }

        if (token != null && token.startsWith('Bearer ')) {
          token = token.substring(7);
        }

        if (token != null) {
          return {'token': token, ...userData ?? {}, ...body};
        }

        return null;
      } else {
        print('Login request failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('An error occurred during login: $e');
      return null;
    }
  }

  Future<List<dynamic>?> getConversations(String token) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.conversations),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Conversations Status: ${response.statusCode}');
      print('Conversations Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) return data;
        return data['results'] ?? [];
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<dynamic>?> getMessages(
      String token, String conversationId) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.messages(conversationId)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) return data;
        return data['results'] ?? [];
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
