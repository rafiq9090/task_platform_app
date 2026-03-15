import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/api/api_client.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/project_repository.dart';
import 'data/repositories/task_repository.dart';
import 'logic/auth_provider.dart';
import 'logic/admin_provider.dart';
import 'logic/project_provider.dart';
import 'logic/task_provider.dart';
import 'presentation/router/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  final apiClient = ApiClient();
  final authRepo = AuthRepository(apiClient);
  final projectRepo = ProjectRepository(apiClient);
  final taskRepo = TaskRepository(apiClient);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(authRepo)),
        ChangeNotifierProvider(create: (_) => ProjectProvider(projectRepo)),
        ChangeNotifierProvider(create: (_) => TaskProvider(taskRepo)),
        ChangeNotifierProvider(create: (_) => AdminProvider(apiClient, authRepo)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    
    return MaterialApp.router(
      title: 'Task Platform',
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.createRouter(authProvider),
      debugShowCheckedModeBanner: false,
    );
  }
}
