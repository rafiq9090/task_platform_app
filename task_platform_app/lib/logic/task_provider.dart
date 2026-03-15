import 'dart:io';
import 'package:flutter/material.dart';
import '../data/models/task_model.dart';
import '../data/repositories/task_repository.dart';

class TaskProvider extends ChangeNotifier {
  final TaskRepository _repository;
  List<TaskModel> _projectTasks = [];
  List<TaskModel> _myTasks = [];
  bool _isLoading = false;
  String? _error;

  TaskProvider(this._repository);

  List<TaskModel> get projectTasks => _projectTasks;
  List<TaskModel> get myTasks => _myTasks;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchProjectTasks(int projectId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _projectTasks = await _repository.getProjectTasks(projectId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load tasks.';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMyTasks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _myTasks = await _repository.getMyTasks();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load assigned tasks.';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createTask({
    required String title,
    required String description,
    required int developerId,
    required double hourlyRate,
    required int projectId,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.createTask(
        title: title,
        description: description,
        developerId: developerId,
        hourlyRate: hourlyRate,
        projectId: projectId,
      );
      await fetchProjectTasks(projectId);
      return true;
    } catch (e) {
      _error = 'Failed to create task.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> submitTask({
    required int taskId,
    required double hours,
    required File file,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.submitTask(taskId: taskId, hours: hours, file: file);
      await fetchMyTasks();
      return true;
    } catch (e) {
      _error = 'Failed to submit task.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> payForTask(int taskId, int projectId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.payForTask(taskId);
      await fetchProjectTasks(projectId);
      return true;
    } catch (e) {
      _error = 'Payment failed.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateTaskStatus(int taskId, String status, int? projectId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.updateStatus(taskId, status);
      if (projectId != null) {
        await fetchProjectTasks(projectId);
      } else {
        await fetchMyTasks();
      }
      return true;
    } catch (e) {
      _error = 'Failed to update task status.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<String?> downloadSolution(int taskId, String fileName) async {
    try {
      return await _repository.downloadSolution(taskId, fileName);
    } catch (e) {
      _error = 'Download failed.';
      notifyListeners();
      return null;
    }
  }
}
