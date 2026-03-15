class Endpoints {
  static const String baseUrl = 'http://192.168.0.112:8000'; // Machine IP

  // Auth
  static const String register = '/register';
  static const String login = '/login';

  // Projects
  static const String projects = '/projects/';

  // Tasks
  static const String tasks = '/tasks/';
  static const String myTasks = '/tasks/my-tasks';
  static String projectTasks(int projectId) => '/tasks/project/$projectId';
  static String submitTask(int taskId) => '/tasks/$taskId/submit';
  static String downloadTask(int taskId) => '/tasks/$taskId/download';

  // Payments
  static const String payments = '/payments/';
  static String payTask(int taskId) => '/payments/$taskId';

  // Admin
  static const String adminStats = '/admin/stats';
  static const String allUsers = '/admin/all-users';
}
