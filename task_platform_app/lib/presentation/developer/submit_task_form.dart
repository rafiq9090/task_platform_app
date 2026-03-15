import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../../data/models/task_model.dart';
import '../../logic/task_provider.dart';

class SubmitTaskForm extends StatefulWidget {
  final TaskModel task;
  const SubmitTaskForm({super.key, required this.task});

  @override
  State<SubmitTaskForm> createState() => _SubmitTaskFormState();
}

class _SubmitTaskFormState extends State<SubmitTaskForm> {
  final _hoursController = TextEditingController();
  File? _selectedFile;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );

    if (result != null) {
      setState(() => _selectedFile = File(result.files.single.path!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Submit Solution')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Submitting for: ${widget.task.title}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),
            TextField(
              controller: _hoursController,
              decoration: const InputDecoration(
                labelText: 'Total Hours Worked',
                prefixIcon: Icon(Icons.timer_outlined),
                hintText: 'e.g. 6.5',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 32),
            const Text('Solution File (ZIP only)', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            InkWell(
              onTap: _pickFile,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade50,
                ),
                child: Column(
                  children: [
                    Icon(Icons.cloud_upload_outlined, size: 48, color: Colors.indigo.shade300),
                    const SizedBox(height: 12),
                    Text(_selectedFile == null ? 'Click to select ZIP file' : _selectedFile!.path.split('/').last),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: taskProvider.isLoading || _selectedFile == null || _hoursController.text.isEmpty
                  ? null
                  : () async {
                      final success = await taskProvider.submitTask(
                        taskId: widget.task.id,
                        hours: double.parse(_hoursController.text),
                        file: _selectedFile!,
                      );
                      if (success && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Task submitted successfully!')));
                        Navigator.pop(context);
                      }
                    },
              child: taskProvider.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Submit Work'),
            ),
          ],
        ),
      ),
    );
  }
}
