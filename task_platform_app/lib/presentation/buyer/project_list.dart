import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../logic/project_provider.dart';
import '../../logic/auth_provider.dart';
import '../../logic/task_provider.dart';

class ProjectList extends StatefulWidget {
  const ProjectList({super.key});

  @override
  State<ProjectList> createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ProjectProvider>().fetchProjects());
  }

  @override
  Widget build(BuildContext context) {
    final projectProvider = context.watch<ProjectProvider>();
    final authProvider = context.read<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Projects'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authProvider.logout(),
          ),
        ],
      ),
      body: projectProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => projectProvider.fetchProjects(),
              child: projectProvider.projects.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: projectProvider.projects.length,
                      itemBuilder: (context, index) {
                        final project = projectProvider.projects[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            title: Text(project.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            subtitle: const Text('Tap to view tasks'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => _showProjectTasks(project.id, project.title),
                          ),
                        );
                      },
                    ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateProjectDialog(context),
        label: const Text('New Project'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('No projects yet', style: TextStyle(fontSize: 18, color: Colors.grey)),
        ],
      ),
    );
  }

  void _showProjectTasks(int projectId, String title) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => _ProjectTasksSheet(projectId: projectId, projectTitle: title),
    );
  }

  void _showCreateProjectDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Project'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Project Title'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final success = await context.read<ProjectProvider>().createProject(controller.text);
              if (success && mounted) Navigator.pop(context);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

class _ProjectTasksSheet extends StatefulWidget {
  final int projectId;
  final String projectTitle;

  const _ProjectTasksSheet({required this.projectId, required this.projectTitle});

  @override
  State<_ProjectTasksSheet> createState() => _ProjectTasksSheetState();
}

class _ProjectTasksSheetState extends State<_ProjectTasksSheet> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<TaskProvider>().fetchProjectTasks(widget.projectId));
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.projectTitle),
        actions: [
          TextButton.icon(
            onPressed: () => context.push('/buyer/create-task', extra: widget.projectId), // Pass project ID
            icon: const Icon(Icons.add_task),
            label: const Text('Add Task'),
          ),
        ],
      ),
      body: taskProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: taskProvider.projectTasks.length,
              itemBuilder: (context, index) {
                final task = taskProvider.projectTasks[index];
                return Card(
                  child: ListTile(
                    title: Text(task.title),
                    subtitle: Text('Status: ${task.status.toUpperCase()}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/buyer/task-details', extra: task),
                  ),
                );
              },
            ),
    );
  }
}
