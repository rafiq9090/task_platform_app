import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/task_model.dart';
import '../../logic/task_provider.dart';
import 'package:intl/intl.dart';

class TaskDetailsScreen extends StatelessWidget {
  final TaskModel task;
  const TaskDetailsScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    return Scaffold(
      appBar: AppBar(title: const Text('Task Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(context, currencyFormat),
            const SizedBox(height: 32),
            const Text('Action', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            if (task.status == 'submitted')
              _buildPaymentSection(context, taskProvider, currencyFormat)
            else if (task.status == 'paid')
              _buildDownloadSection(context, taskProvider)
            else
              const Text('Waiting for developer to submit work...', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, NumberFormat currencyFormat) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(task.description, style: const TextStyle(color: Colors.grey)),
            const Divider(height: 32),
            _buildRow('Status', task.status.toUpperCase(), isStatus: true),
            _buildRow('Hourly Rate', currencyFormat.format(task.hourlyRate)),
            if (task.hoursSpent != null) _buildRow('Hours Logged', '${task.hoursSpent} hrs'),
            if (task.hoursSpent != null) 
              _buildRow('Total Amount', currencyFormat.format(task.totalAmount), isBold: true),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isStatus = false, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold || isStatus ? FontWeight.bold : FontWeight.normal,
              color: isStatus ? _getStatusColor(task.status) : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSection(BuildContext context, TaskProvider provider, NumberFormat format) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.amber.shade50, borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.amber),
              const SizedBox(width: 12),
              Expanded(child: Text('Payment of ${format.format(task.totalAmount)} is required to unlock the solution.')),
            ],
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: provider.isLoading
              ? null
              : () async {
                  final success = await provider.payForTask(task.id, task.projectId);
                  if (success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment Successful! Solution Unlocked.')));
                    Navigator.pop(context);
                  }
                },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          child: provider.isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Pay Now'),
        ),
      ],
    );
  }

  Widget _buildDownloadSection(BuildContext context, TaskProvider provider) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(12)),
          child: const Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.green),
              SizedBox(width: 12),
              Expanded(child: Text('Work is paid and unlocked.')),
            ],
          ),
        ),
        const SizedBox(height: 24),
        OutlinedButton.icon(
          onPressed: () async {
             final path = await provider.downloadSolution(task.id, task.title);
             if (path != null && context.mounted) {
               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Downloaded to: $path')));
             }
          },
          icon: const Icon(Icons.download),
          label: const Text('Download ZIP Solution'),
          style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 56)),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'todo': return Colors.blue;
      case 'in_progress': return Colors.orange;
      case 'submitted': return Colors.purple;
      case 'paid': return Colors.green;
      default: return Colors.grey;
    }
  }
}
