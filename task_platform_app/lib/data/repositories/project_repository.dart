import '../../core/api/api_client.dart';
import '../../core/api/endpoints.dart';
import '../models/project_model.dart';

class ProjectRepository {
  final ApiClient _apiClient;

  ProjectRepository(this._apiClient);

  Future<List<ProjectModel>> getMyProjects() async {
    try {
      final response = await _apiClient.get(Endpoints.projects);
      return (response.data as List).map((p) => ProjectModel.fromJson(p)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createProject(String title) async {
    try {
      await _apiClient.post(Endpoints.projects, data: {'title': title});
    } catch (e) {
      rethrow;
    }
  }
}
