class ProjectModel {
  final int id;
  final String title;
  final int buyerId;
  final DateTime? createdAt;

  ProjectModel({
    required this.id,
    required this.title,
    required this.buyerId,
    this.createdAt,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'],
      title: json['title'],
      buyerId: json['buyer_id'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    );
  }
}
