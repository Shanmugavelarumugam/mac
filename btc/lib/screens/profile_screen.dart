import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color customGreen = Color(0xFF03FCC6);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top curved header with avatar
          Stack(
            children: [
              Container(
                height: 200,
                decoration: const BoxDecoration(
                  color: customGreen,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
              ),
              Positioned(
                top: 50,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.arrow_back, color: Colors.white),
                    const Text(
                      'Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(Icons.notifications, color: Colors.white),
                  ],
                ),
              ),
              Positioned(
                top: 120,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [customGreen, Colors.teal],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: customGreen.withOpacity(0.5),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.white,
                      // backgroundImage: AssetImage(
                      //   'assets/profile.png',
                      // ), // Replace with actual asset
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 60),

          // Name and ID
          const Text(
            'Shanmugavel',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          const Text('ID No: BTC123456', style: TextStyle(color: Colors.grey)),

          const SizedBox(height: 30),

          // Options list
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildOption(Icons.edit, 'Edit Profile', customGreen),
                _buildOption(Icons.security, 'Security', customGreen),
                _buildOption(Icons.settings, 'Settings', customGreen),
                _buildOption(Icons.help_outline, 'Help & Support', customGreen),
                _buildOption(Icons.logout, 'Logout', Colors.redAccent),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(IconData icon, String title, Color iconColor) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.1),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: () {
          // Add navigation or action here
        },
      ),
    );
  }
}
