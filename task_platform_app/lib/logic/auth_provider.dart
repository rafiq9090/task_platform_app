import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/user_model.dart';
import '../data/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;
  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  AuthProvider(this._repository) {
    _loadUser();
  }

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('name');
    final email = prefs.getString('email');
    final role = prefs.getString('role');
    final token = prefs.getString('access_token');

    if (token != null && name != null && email != null && role != null) {
      _user = UserModel(name: name, email: email, role: role, token: token);
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _repository.login(email, password);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', _user!.token!);
      await prefs.setString('name', _user!.name);
      await prefs.setString('email', _user!.email);
      await prefs.setString('role', _user!.role);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      if (e.toString().contains('SocketException') || e.toString().contains('Connection refused')) {
        _error = 'Cannot connect to server. Check IP and Backend status.';
      } else {
        _error = 'Login failed. Please check your credentials.';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.register(name: name, email: email, password: password, role: role);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Registration failed.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _user = null;
    notifyListeners();
  }
}
