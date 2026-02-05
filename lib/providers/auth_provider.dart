import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  String? get token => _user?.token;
  bool get isLoading => _isLoading;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await _apiService.login(email, password);

      if (data != null && data['token'] != null) {
        _user = User.fromJson(data);
        await _storage.write(key: 'jwt_token', value: _user!.token);
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Auth Provider Login Error: $e');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    _user = null;
    await _storage.delete(key: 'jwt_token');
    notifyListeners();
  }

  Future<void> tryAutoLogin() async {
    final storedToken = await _storage.read(key: 'jwt_token');
    if (storedToken != null) {
      _user = User(email: '', token: storedToken);
      notifyListeners();
    }
  }
}
