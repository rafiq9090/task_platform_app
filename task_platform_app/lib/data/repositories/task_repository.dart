import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import '../../core/api/api_client.dart';
import '../../core/api/endpoints.dart';
import '../models/task_model.dart';

class TaskRepository {
  final ApiClient _apiClient;

  TaskRepository(this._apiClient);

  Future<List<TaskModel>> getProjectTasks(int projectId) async {
    try {
      final response = await _apiClient.get(Endpoints.projectTasks(projectId));
      return (response.data as List).map((t) => TaskModel.fromJson(t)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<TaskModel>> getMyTasks() async {
    try {
      final response = await _apiClient.get(Endpoints.myTasks);
      return (response.data as List).map((t) => TaskModel.fromJson(t)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createTask({
    required String title,
    required String description,
    required int developerId,
    required double hourlyRate,
    required int projectId,
  }) async {
    try {
      await _apiClient.post(Endpoints.tasks, data: {
        'title': title,
        'description': description,
        'developer_id': developerId,
        'hourly_rate': hourlyRate,
        'project_id': projectId,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> submitTask({
    required int taskId,
    required double hours,
    required File file,
  }) async {
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "hours": hours,
        "file": await MultipartFile.fromFile(file.path, filename: fileName),
      });

      await _apiClient.post(Endpoints.submitTask(taskId), data: formData);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> payForTask(int taskId) async {
    try {
      await _apiClient.post(Endpoints.payTask(taskId));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateStatus(int taskId, String status) async {
    try {
      await _apiClient.post('${Endpoints.tasks}$taskId/update-status', data: {'status': status});
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> downloadSolution(int taskId, String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = "${directory.path}/$fileName.zip";
      await _apiClient.download(Endpoints.downloadTask(taskId), filePath);
      return filePath;
    } catch (e) {
      rethrow;
    }
  }
}
