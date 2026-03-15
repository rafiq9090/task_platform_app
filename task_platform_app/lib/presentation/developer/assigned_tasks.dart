import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../logic/task_provider.dart';
import '../../logic/auth_provider.dart';

class AssignedTasksScreen extends StatefulWidget {
  const AssignedTasksScreen({super.key});

  @override
  State<AssignedTasksScreen> createState() => _AssignedTasksScreenState();
}

class _AssignedTasksScreenState extends State<AssignedTasksScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<TaskProvider>().fetchMyTasks());
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final authProvider = context.read<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Assigned Tasks'),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: () => authProvider.logout()),
        ],
      ),
      body: taskProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => taskProvider.fetchMyTasks(),
              child: taskProvider.myTasks.isEmpty
                  ? const Center(child: Text('No tasks assigned yet.'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: taskProvider.myTasks.length,
                      itemBuilder: (context, index) {
                        final task = taskProvider.myTasks[index];
                        return Card(
                          child: ListTile(
                            title: Text(task.title),
                            subtitle: Text('Status: ${task.status.toUpperCase()}'),
                            trailing: task.status == 'todo'
                                ? IconButton(
                                    icon: const Icon(Icons.play_arrow, color: Colors.green),
                                    onPressed: () => taskProvider.updateTaskStatus(task.id, 'in_progress', null),
                                  )
                                : task.status == 'in_progress'
                                    ? const Icon(Icons.upload_file, color: Colors.indigo)
                                    : const Icon(Icons.check_circle, color: Colors.green),
                            onTap: task.status == 'todo' || task.status == 'in_progress'
                                ? () => context.push('/developer/submit-task', extra: task)
                                : null,
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
