import 'package:go_router/go_router.dart';
import '../../logic/auth_provider.dart';
import '../admin/admin_dashboard.dart';
import '../auth/login_screen.dart';
import '../auth/register_screen.dart';
import '../buyer/project_list.dart';
import '../buyer/task_details.dart';
import '../buyer/create_task.dart';
import '../developer/assigned_tasks.dart';
import '../developer/submit_task_form.dart';
import '../../data/models/task_model.dart';

class AppRouter {
  static GoRouter createRouter(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: '/login',
      refreshListenable: authProvider,
      redirect: (context, state) {
        final loggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/register';

        if (!authProvider.isAuthenticated) {
          return loggingIn ? null : '/login';
        }

        if (loggingIn) {
          switch (authProvider.user?.role) {
            case 'admin':
              return '/admin';
            case 'buyer':
              return '/buyer';
            case 'developer':
              return '/developer';
            default:
              return '/login';
          }
        }

        return null;
      },
      routes: [
        GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
        GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
        
        // Admin
        GoRoute(path: '/admin', builder: (context, state) => const AdminDashboard()),
        
        // Buyer
        GoRoute(
          path: '/buyer',
          builder: (context, state) => const ProjectList(),
          routes: [
            GoRoute(
              path: 'create-task',
              builder: (context, state) => CreateTaskScreen(project: state.extra),
            ),
            GoRoute(
              path: 'task-details',
              builder: (context, state) => TaskDetailsScreen(task: state.extra as TaskModel),
            ),
          ],
        ),
        
        // Developer
        GoRoute(
          path: '/developer',
          builder: (context, state) => const AssignedTasksScreen(),
          routes: [
            GoRoute(
              path: 'submit-task',
              builder: (context, state) => SubmitTaskForm(task: state.extra as TaskModel),
            ),
          ],
        ),
      ],
    );
  }
}
