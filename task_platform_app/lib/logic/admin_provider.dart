import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../core/api/api_client.dart';
import '../core/api/endpoints.dart';
import '../data/models/stats_model.dart';
import '../data/models/user_model.dart';
import '../data/repositories/auth_repository.dart';

class AdminProvider extends ChangeNotifier {
  final ApiClient _apiClient;
  final AuthRepository _authRepository;
  StatsModel? _stats;
  List<UserModel> _users = [];
  bool _isLoading = false;
  String? _error;

  AdminProvider(this._apiClient, this._authRepository);

  StatsModel? get stats => _stats;
  List<UserModel> get users => _users;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchStats() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiClient.get(Endpoints.adminStats);
      _stats = StatsModel.fromJson(response.data);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load dashboard stats.';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUsers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _users = await _authRepository.getAllUsers();
      print('AdminProvider: Fetched ${_users.length} users total');
      print('AdminProvider: Found ${developers.length} developers');
      _isLoading = false;
      notifyListeners();
    } on DioException catch (e) {
      print('AdminProvider fetchUsers DioError: ${e.response?.statusCode} - ${e.message}');
      if (e.response?.statusCode == 403) {
        _error = 'Access Denied: You do not have permission to view users (Role: Buyer).';
      } else {
        _error = 'Failed to load users: ${e.message} (${e.response?.statusCode})';
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('AdminProvider fetchUsers error: $e');
      _error = 'Unexpected Error: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  List<UserModel> get developers => _users.where((u) => u.role.toLowerCase() == 'developer').toList();
}
