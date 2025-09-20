import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
   return Drawer(
      child: SafeArea(
        child: SingleChildScrollView(
          // <--- Wrap with this
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF3C8CE7), Color(0xFF00EAFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                accountName: const Text("John Doe"),
                accountEmail: const Text("john@upi"),
                currentAccountPicture: const CircleAvatar(),
              ),
              _drawerSectionTitle("Quick Actions"),
              _drawerItem(Icons.home, "Home", () {}),
              _drawerItem(Icons.search, "Search", () {}),
              _drawerItem(Icons.payment, "Single Payment", () {}),
              _drawerItem(Icons.qr_code_scanner, "Scan QR", () {}),
              _drawerItem(Icons.history, "Transaction History", () {}),
              _drawerItem(Icons.account_balance_wallet, "Wallet", () {}),
              _drawerItem(Icons.flash_on, "Recharge / Pay Bill", () {}),
              const Divider(),
              _drawerSectionTitle("Finance Shortcuts"),
              _drawerItem(Icons.bar_chart, "Current Stock Market", () {}),
              _drawerItem(Icons.military_tech, "Gold Rate", () {}),
              _drawerItem(Icons.trending_up, "My Investments", () {}),
              _drawerItem(Icons.newspaper, "News & Updates", () {}),
              const Divider(),
              _drawerSectionTitle("Other Services"),
              _drawerItem(Icons.account_balance, "Banking Services", () {}),
              _drawerItem(Icons.article, "Gov Schemes", () {}),
              _drawerItem(Icons.share, "Refer & Earn", () {}),
              _drawerItem(Icons.support_agent, "Help & Support", () {}),
              const SizedBox(height: 16), // Spacer replaced with SizedBox
              _drawerItem(Icons.settings, "Settings", () {}),
              _drawerItem(Icons.lock, "Logout", () {}),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "App v1.0.0 • Powered by BTC",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }

  Widget _drawerItem(IconData icon, String text, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(text),
      onTap: onTap,
    );
  }

  Widget _drawerSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }
}
