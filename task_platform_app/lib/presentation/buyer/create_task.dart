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
              const CircularProgressIndicator()
            else
              DropdownButtonFormField<UserModel>(
                value: _selectedDeveloper,
                items: adminProvider.developers.map((dev) {
                  return DropdownMenuItem(value: dev, child: Text(dev.name));
                }).toList(),
                onChanged: (val) => setState(() => _selectedDeveloper = val),
                decoration: const InputDecoration(hintText: 'Select a developer'),
              ),
            const SizedBox(height: 48),
            ElevatedButton(
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
              child: const Text('Assign Task'),
            ),
          ],
        ),
      ),
    );
  }
}
