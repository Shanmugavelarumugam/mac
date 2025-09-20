import 'package:btc_f/logic/auth/auth_bloc.dart';
import 'package:btc_f/logic/auth/auth_event.dart';
import 'package:btc_f/presentation/screens/auth/login_screen.dart';
import 'package:btc_f/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _user;
  bool _isLoading = true;

  Future<void> _fetchUser() async {
    try {
final response = await Dio().get(getAllUsersApi);
      const currentEmail = "john@example.com"; // Simulate auth
      final user = (response.data as List).firstWhere(
        (user) => user['email'] == currentEmail,
      );

      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load user profile")),
      );
    }
  }

  void _signOut(BuildContext context) {
    context.read<AuthBloc>().add(SignOutRequested());
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        title: const Text("👤 Profile"),
        backgroundColor: Colors.deepOrange,
        elevation: 0,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _user == null
              ? const Center(child: Text("No user data found"))
              : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.deepOrange.shade100,
                      child: const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.deepOrange,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Text(
                      _user!['name'] ?? '',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _user!['email'] ?? '',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),

                    const SizedBox(height: 24),

                    // Card UI
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            ProfileTile(
                              icon: Icons.person,
                              title: "Gender",
                              value: _user!['gender'] ?? 'N/A',
                            ),
                            const Divider(),
                            ProfileTile(
                              icon: Icons.cake,
                              title: "Age",
                              value: _user!['age']?.toString() ?? 'N/A',
                            ),
                            const Divider(),
                            ProfileTile(
                              icon: Icons.location_on,
                              title: "Location",
                              value: _user!['location'] ?? 'N/A',
                            ),
                            const Divider(),
                            ProfileTile(
                              icon: Icons.pin,
                              title: "Pincode",
                              value: _user!['pincode'] ?? 'N/A',
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Sign out button
                    ElevatedButton.icon(
                      onPressed: () => _signOut(context),
                      icon: const Icon(Icons.logout),
                      label: const Text("Sign Out"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}

class ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const ProfileTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepOrange, size: 24),
        const SizedBox(width: 12),
        Text(
          "$title:",
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
