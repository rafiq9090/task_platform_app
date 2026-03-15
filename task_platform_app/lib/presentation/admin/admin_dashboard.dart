import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/admin_provider.dart';
import '../../logic/auth_provider.dart';
import 'package:intl/intl.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<AdminProvider>().fetchStats());
  }

  @override
  Widget build(BuildContext context) {
    final adminProvider = context.watch<AdminProvider>();
    final authProvider = context.read<AuthProvider>();
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: () => authProvider.logout()),
        ],
      ),
      body: adminProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => adminProvider.fetchStats(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('Key Statistics'),
                    const SizedBox(height: 16),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.5,
                      children: [
                        _buildStatCard('Total Projects', adminProvider.stats?.summary.totalProjects.toString() ?? '0', Icons.folder, Colors.blue),
                        _buildStatCard('Total Tasks', adminProvider.stats?.summary.totalTasks.toString() ?? '0', Icons.task, Colors.orange),
                        _buildStatCard('Completed', adminProvider.stats?.summary.completedTasks.toString() ?? '0', Icons.done_all, Colors.green),
                        _buildStatCard('Pending Pay', adminProvider.stats?.summary.pendingPayments.toString() ?? '0', Icons.payment, Colors.red),
                      ],
                    ),
                    const SizedBox(height: 32),
                    _buildSectionHeader('Financial Overview'),
                    const SizedBox(height: 16),
                    _buildFinancialCard(adminProvider, currencyFormat),
                    const SizedBox(height: 32),
                    _buildSectionHeader('User Metrics'),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildSimpleCard('Buyers', adminProvider.stats?.users.totalBuyers.toString() ?? '0')),
                        const SizedBox(width: 16),
                        Expanded(child: _buildSimpleCard('Developers', adminProvider.stats?.users.totalDevelopers.toString() ?? '0')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const Spacer(),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialCard(AdminProvider provider, NumberFormat format) {
    final stats = provider.stats?.financials;
    return Card(
      color: Colors.indigo.shade900,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildFinancialRow('Total Received', format.format(stats?.totalPaymentsReceived ?? 0), Colors.green),
            const Divider(color: Colors.white24, height: 32),
            _buildFinancialRow('Platform Revenue', format.format(stats?.totalRevenue ?? 0), Colors.white),
            const SizedBox(height: 12),
            _buildFinancialRow('Projected Rev', format.format(stats?.potentialTotalRevenue ?? 0), Colors.white70),
            const SizedBox(height: 12),
            _buildFinancialRow('Total Hours', '${stats?.totalLoggedHours ?? 0} hrs', Colors.white70),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 16)),
        Text(value, style: TextStyle(color: valueColor, fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSimpleCard(String label, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
