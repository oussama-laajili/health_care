import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  // Local hardcoded credentials for testing
  final Map<String, String> _localUsers = {
    'admin@test.com': 'admin123',
    'user@test.com': 'user123',
  };

  bool _isLoading = false;
  String? _errorMessage;
  bool _isLoggedIn = false;
  String? _currentUserEmail;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _isLoggedIn;
  String? get currentUserEmail => _currentUserEmail;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Validate credentials against local data
    if (_localUsers.containsKey(email) && _localUsers[email] == password) {
      _isLoggedIn = true;
      _currentUserEmail = email;
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _errorMessage = 'Invalid email or password';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _isLoggedIn = false;
    _currentUserEmail = null;
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
