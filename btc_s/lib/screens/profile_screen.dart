import 'package:btc_s/screens/login.dart';
import 'package:btc_s/utils/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = '';
  String userEmail = '';

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final name = await UserPreferences.getUserName();
    final email = await UserPreferences.getUserEmail();

    setState(() {
      userName = name ?? 'Guest';
      userEmail = email ?? 'No Email';
    });
  }

  Future<void> logout(BuildContext context) async {
    await UserPreferences.clearAll();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) =>  LoginScreen()),
      (route) => false,
    );
  }

  Widget buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title, style: GoogleFonts.montserrat(fontSize: 15)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Profile',
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              // TODO: Implement Settings action
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.black,
              child: Text(
                userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                style: GoogleFonts.montserrat(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              userName,
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              userEmail,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 30),

            // Menu Items
            buildMenuItem(Icons.location_on_outlined, 'Address', () {
              // TODO: Navigate to Address Screen
            }),
            buildMenuItem(Icons.payment_outlined, 'Payment Method', () {
              // TODO: Navigate to Payment Screen
            }),
            buildMenuItem(Icons.card_giftcard_outlined, 'Vouchers', () {
              // TODO: Navigate to Vouchers Screen
            }),
            buildMenuItem(Icons.favorite_border, 'My Wishlist', () {
              // TODO: Navigate to Wishlist Screen
            }),
            buildMenuItem(Icons.star_border, 'Rate This App', () {
              // TODO: Implement Rating
            }),
            buildMenuItem(Icons.logout, 'Logout', () => logout(context)),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
