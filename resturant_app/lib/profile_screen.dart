import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:resturant_app/services/hive_service.dart'; // ✅ HiveService for login info

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String baseUrl = 'http://192.168.1.4:3001';

  TextEditingController phoneController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController walletController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      final restaurantId = HiveService.id;
      final res = await Dio().get('$baseUrl/api/restaurants/$restaurantId');
      phoneController.text = res.data['phone'] ?? '';
      statusController.text = res.data['status'] ?? '';
      walletController.text = res.data['wallet_balance'].toString();
    } catch (e) {
      print('Profile fetch error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Failed to fetch profile")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> updateProfile() async {
    try {
      final restaurantId = HiveService.id;
      final data = {
        "phone": phoneController.text,
        "status": statusController.text,
        "wallet_balance": double.tryParse(walletController.text) ?? 0.0,
      };
      await Dio().put('$baseUrl/api/restaurants/$restaurantId', data: data);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("✅ Profile updated")));
    } catch (e) {
      print('Update error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Failed to update profile")),
      );
    }
  }

  void showChangePasswordDialog() {
    TextEditingController oldPassword = TextEditingController();
    TextEditingController newPassword = TextEditingController();

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("🔐 Change Password"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: oldPassword,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Old Password",
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: newPassword,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "New Password",
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                ),
                onPressed: () async {
                  // TODO: Implement actual password change API
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("🔐 Password changed (Mocked)"),
                    ),
                  );
                },
                child: const Text("Update"),
              ),
            ],
          ),
    );
  }

  void logout() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("🚪 Logout"),
            content: const Text("Are you sure you want to logout?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                ),
                onPressed: () async {
                  Navigator.pop(context); // Close dialog
                  await HiveService.logout(); // Clear Hive session

                  if (!mounted) return;
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil('/login', (route) => false);
                },
                child: const Text("Logout"),
              ),
            ],
          ),
    );
  }

  Widget buildProfileForm() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(top: 20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.deepOrange,
              child: Icon(Icons.store, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 12),
            const Text(
              "Restaurant Profile",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 30),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: "Phone Number",
                prefixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: statusController,
              decoration: InputDecoration(
                labelText: "Status (Active / Inactive)",
                prefixIcon: const Icon(Icons.toggle_on),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: walletController,
              decoration: InputDecoration(
                labelText: "Wallet Balance",
                prefixIcon: const Icon(Icons.account_balance_wallet),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: updateProfile,
                icon: const Icon(Icons.save),
                label: const Text(
                  "Update Profile",
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: showChangePasswordDialog,
                  icon: const Icon(Icons.lock, color: Colors.deepOrange),
                  label: const Text("Change Password"),
                ),
                TextButton.icon(
                  onPressed: logout,
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text("🏪 Profile"),
        backgroundColor: Colors.deepOrange,
        elevation: 0,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: buildProfileForm(),
              ),
    );
  }
}
