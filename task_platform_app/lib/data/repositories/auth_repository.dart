import '../../core/api/api_client.dart';
import '../../core/api/endpoints.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _apiClient.post(Endpoints.login, data: {
        'email': email,
        'password': password,
      });
      final user = UserModel.fromJson(response.data);
      // Manually set email since API response doesn't include it but request does
      return user.copyWith(email: email);
    } catch (e) {
      print('AuthRepository Error: $e'); // Debug logging
      rethrow;
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      await _apiClient.post(Endpoints.register, data: {
        'name': name,
        'email': email,
        'password': password,
        'role': role,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    try {
      final response = await _apiClient.get(Endpoints.allUsers);
      print('AuthRepository: GET all-users response status: ${response.statusCode}');
      print('AuthRepository: Raw data: ${response.data}');
      return (response.data as List).map((u) => UserModel.fromJson(u)).toList();
    } catch (e) {
      print('AuthRepository: GET all-users failed: $e');
      rethrow;
    }
  }
}
