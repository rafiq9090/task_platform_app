class StatsModel {
  final SummaryStats summary;
  final UserStats users;
  final FinancialStats financials;

  StatsModel({
    required this.summary,
    required this.users,
    required this.financials,
  });

  factory StatsModel.fromJson(Map<String, dynamic> json) {
    return StatsModel(
      summary: SummaryStats.fromJson(json['summary']),
      users: UserStats.fromJson(json['users']),
      financials: FinancialStats.fromJson(json['financials']),
    );
  }
}

class SummaryStats {
  final int totalProjects;
  final int totalTasks;
  final int completedTasks;
  final int pendingPayments;

  SummaryStats({
    required this.totalProjects,
    required this.totalTasks,
    required this.completedTasks,
    required this.pendingPayments,
  });

  factory SummaryStats.fromJson(Map<String, dynamic> json) {
    return SummaryStats(
      totalProjects: json['total_projects'],
      totalTasks: json['total_tasks'],
      completedTasks: json['completed_tasks'],
      pendingPayments: json['pending_payments'],
    );
  }
}

class UserStats {
  final int totalBuyers;
  final int totalDevelopers;

  UserStats({
    required this.totalBuyers,
    required this.totalDevelopers,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      totalBuyers: json['total_buyers'],
      totalDevelopers: json['total_developers'],
    );
  }
}

class FinancialStats {
  final double totalPaymentsReceived;
  final double totalRevenue;
  final double totalLoggedHours;
  final double potentialTotalRevenue;

  FinancialStats({
    required this.totalPaymentsReceived,
    required this.totalRevenue,
    required this.totalLoggedHours,
    required this.potentialTotalRevenue,
  });

  factory FinancialStats.fromJson(Map<String, dynamic> json) {
    return FinancialStats(
      totalPaymentsReceived: (json['total_payments_received'] as num).toDouble(),
      totalRevenue: (json['total_revenue'] as num).toDouble(),
      totalLoggedHours: (json['total_logged_hours'] as num).toDouble(),
      potentialTotalRevenue: (json['potential_total_revenue'] as num).toDouble(),
    );
  }
}
