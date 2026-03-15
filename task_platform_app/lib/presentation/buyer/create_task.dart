import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/admin_provider.dart';
import '../../logic/task_provider.dart';
import '../../data/models/user_model.dart';

class CreateTaskScreen extends StatefulWidget {
  final dynamic project; // Can be ProjectModel or int (projectId)
  const CreateTaskScreen({super.key, required this.project});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _rateController = TextEditingController();
  UserModel? _selectedDeveloper;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<AdminProvider>().fetchUsers());
  }

  @override
  Widget build(BuildContext context) {
    final adminProvider = context.watch<AdminProvider>();
    final taskProvider = context.watch<TaskProvider>();
    final projectId = widget.project is int ? widget.project : (widget.project as dynamic).id;
    
    print('CreateTaskScreen: Building with ${adminProvider.developers.length} developers');
    for (var d in adminProvider.developers) {
      print('  - Developer: "${d.name}" (ID: ${d.id}, Role: ${d.role})');
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Create New Task')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Task Title'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _rateController,
              decoration: const InputDecoration(labelText: 'Hourly Rate (\$)', prefixIcon: Icon(Icons.attach_money)),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            const Text('Assign to Developer:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            if (adminProvider.isLoading)
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 8),
                    Text('Fetching developers...'),
                  ],
                ),
              )
            else if (adminProvider.error != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Error: ${adminProvider.error!}', style: const TextStyle(color: Colors.red)),
                  TextButton(
                    onPressed: () => adminProvider.fetchUsers(),
                    child: const Text('Retry'),
                  ),
                ],
              )
            else if (adminProvider.developers.isEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'No developers found in the system.',
                    style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'To show up here, a user must be registered with the role "developer".',
                    style: TextStyle(fontSize: 12),
                  ),
                  TextButton(
                    onPressed: () => adminProvider.fetchUsers(),
                    child: const Text('Refresh List'),
                  ),
                ],
              )
            else
              DropdownButtonFormField<UserModel>(
                value: _selectedDeveloper,
                isExpanded: true,
                items: adminProvider.developers.map((dev) {
                  return DropdownMenuItem(
                    value: dev,
                    child: Text('${dev.name} (${dev.email})'),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedDeveloper = val),
                decoration: const InputDecoration(
                  hintText: 'Select a developer',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: taskProvider.isLoading || _selectedDeveloper == null
                    ? null
                    : () async {
                        final success = await taskProvider.createTask(
                          title: _titleController.text,
                          description: _descController.text,
                          developerId: _selectedDeveloper!.id!,
                          hourlyRate: double.parse(_rateController.text),
                          projectId: projectId,
                        );
                        if (success && mounted) Navigator.pop(context);
                      },
                child: taskProvider.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Assign Task'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
