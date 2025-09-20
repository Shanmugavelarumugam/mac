import 'package:btc_s/screens/login.dart';
import 'package:btc_s/utils/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppDrawer extends StatelessWidget {
  final String userName;
  final String userEmail;

  const AppDrawer({Key? key, required this.userName, required this.userEmail})
    : super(key: key);

  Future<void> logout(BuildContext context) async {
    await UserPreferences.clearAll();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    String initialLetter =
        userName.isNotEmpty ? userName[0].toUpperCase() : '?';

    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.white),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.black,
                  child: Text(
                    initialLetter,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName.isNotEmpty ? userName : 'Guest',
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userEmail.isNotEmpty ? userEmail : 'No Email',
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          buildDrawerItem(Icons.home_outlined, 'Home'),
          buildDrawerItem(Icons.search_outlined, 'Discover'),
          buildDrawerItem(Icons.shopping_bag_outlined, 'My Order'),
          buildDrawerItem(Icons.person_outline, 'My Profile'),
          buildDrawerItem(Icons.settings_outlined, 'Settings'),
          buildDrawerItem(Icons.support_agent_outlined, 'Support'),
          buildDrawerItem(Icons.info_outline, 'About Us'),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.black),
            title: Text('Logout', style: GoogleFonts.montserrat()),
            onTap: () => logout(context),
          ),

          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.wb_sunny_outlined, color: Colors.black),
                const SizedBox(width: 8),
                Text(
                  'Light',
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                const Spacer(),
                Icon(Icons.nightlight_round, color: Colors.black),
                const SizedBox(width: 8),
                Text(
                  'Dark',
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget buildDrawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title, style: GoogleFonts.montserrat()),
      onTap: () {
      },
    );
  }
}
