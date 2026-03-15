import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../logic/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'developer';

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline)),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email Address', prefixIcon: Icon(Icons.email_outlined)),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock_outline)),
            ),
            const SizedBox(height: 24),
            const Text('I am a:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                _roleChip('developer', 'Developer'),
                const SizedBox(width: 12),
                _roleChip('buyer', 'Buyer'),
                const SizedBox(width: 12),
                _roleChip('admin', 'Admin'),
              ],
            ),
            const SizedBox(height: 40),
            if (authProvider.error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(authProvider.error!, style: const TextStyle(color: Colors.red)),
              ),
            ElevatedButton(
              onPressed: authProvider.isLoading
                  ? null
                  : () async {
                      final success = await authProvider.register(
                        name: _nameController.text,
                        email: _emailController.text,
                        password: _passwordController.text,
                        role: _selectedRole,
                      );
                      if (success && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Account created! Please login.')),
                        );
                        context.pop();
                      }
                    },
              child: authProvider.isLoading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roleChip(String role, String label) {
    final isSelected = _selectedRole == role;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (val) {
        if (val) setState(() => _selectedRole = role);
      },
    );
  }
}
