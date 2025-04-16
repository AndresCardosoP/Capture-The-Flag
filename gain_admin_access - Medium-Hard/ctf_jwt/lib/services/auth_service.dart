import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class AuthService with ChangeNotifier {
  String _token = '';
  String _username = '';
  String _adminResponse = '';

  final String baseUrl = 'http://localhost:5000'; // Change if hosted elsewhere

  String get token => _token;
  String get username => _username;
  String get adminResponse => _adminResponse;

  bool get isAuthenticated => _token.isNotEmpty;

  Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username}),
        // Note: The server appears to only check username, not password
        // In a real app, you'd send password too: {'username': username, 'password': password}
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        _username = username;
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<String> checkAdmin() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/admin'),
        headers: {'Authorization': 'Bearer $_token'},
      );

      _adminResponse = response.body;
      notifyListeners();
      return _adminResponse;
    } catch (e) {
      _adminResponse = 'Error accessing admin: $e';
      notifyListeners();
      return _adminResponse;
    }
  }

  void logout() {
    _token = '';
    _username = '';
    _adminResponse = '';
    notifyListeners();
  }
}
