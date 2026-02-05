import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/socket_service.dart';
import 'dart:convert';

class ChatProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final SocketService _socketService = SocketService();
  
  List<dynamic> _conversations = [];
  List<dynamic> _messages = [];
  bool _isLoading = false;

  List<dynamic> get conversations => _conversations;
  List<dynamic> get messages => _messages;
  bool get isLoading => _isLoading;

  Future<void> fetchConversations(String token) async {
    _isLoading = true;
    notifyListeners();

    final result = await _apiService.getConversations(token);
    if (result != null) {
      _conversations = result;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> enterChat(String token, String conversationId) async {
    _isLoading = true;
    _messages = []; 
    notifyListeners();

    final history = await _apiService.getMessages(token, conversationId);
    if (history != null) {
      _messages = history.reversed.toList(); 
    }

    _socketService.connect(conversationId, token);
    
    _socketService.stream.listen((event) {
      try {
        final message = jsonDecode(event);
        _messages.add(message);
        notifyListeners();
      } catch (e) {
        print(e);
      }
    }, onError: (e) {
      print(e);
    });

    _isLoading = false;
    notifyListeners();
  }

  void leaveChat() {
    _socketService.disconnect();
    _messages = [];
  }

  void sendMessage(String text) {
    final payload = jsonEncode({"message": text});
    _socketService.sendMessage(payload);
  }
}
