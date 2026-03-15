import 'package:flutter/material.dart';
import '../data/models/project_model.dart';
import '../data/repositories/project_repository.dart';

class ProjectProvider extends ChangeNotifier {
  final ProjectRepository _repository;
  List<ProjectModel> _projects = [];
  bool _isLoading = false;
  String? _error;

  ProjectProvider(this._repository);

  List<ProjectModel> get projects => _projects;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchProjects() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _projects = await _repository.getMyProjects();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load projects.';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createProject(String title) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.createProject(title);
      await fetchProjects();
      return true;
    } catch (e) {
      _error = 'Failed to create project.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
