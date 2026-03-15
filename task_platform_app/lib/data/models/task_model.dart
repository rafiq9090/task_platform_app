class TaskModel {
  final int id;
  final String title;
  final String description;
  final int developerId;
  final int projectId;
  final double hourlyRate;
  final String status;
  final double? hoursSpent;
  final String? solutionPath;
  final String? developerName;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.developerId,
    required this.projectId,
    required this.hourlyRate,
    required this.status,
    this.hoursSpent,
    this.solutionPath,
    this.developerName,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      developerId: json['developer_id'],
      projectId: json['project_id'],
      hourlyRate: (json['hourly_rate'] as num).toDouble(),
      status: json['status'],
      hoursSpent: json['hours_spent'] != null ? (json['hours_spent'] as num).toDouble() : null,
      solutionPath: json['solution_path'],
      developerName: json['developer_name'],
    );
  }

  double get totalAmount => (hoursSpent ?? 0) * hourlyRate;
}
