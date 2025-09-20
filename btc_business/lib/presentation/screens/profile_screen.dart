import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Dummy data for demonstration
  String userName = "Mr XYZ";
  String upiId = "GGFFV1455@okaxis";
  String phoneNumber = "+91 9876543210";
  String email = "xyz@example.com";
  String kycStatus = "Verified";
  int cibilScore = 750;

  bool twoFactorEnabled = true;
  bool biometricEnabled = false;
  bool notifSms = true;
  bool notifEmail = true;
  bool notifPush = true;
  bool isDarkTheme = false;

  final Color primaryColor = const Color(0xFF3C8CE7);
  final Color accentColor = const Color(0xFF00EAFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: primaryColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 32),
          _buildSectionTitle("Account Information"),
          _buildEditableField(
            "Phone Number",
            phoneNumber,
            onEdit:
                () => _showEditDialog("Phone Number", phoneNumber, (val) {
                  setState(() => phoneNumber = val);
                }),
          ),
          _buildEditableField(
            "Email Address",
            email,
            onEdit:
                () => _showEditDialog("Email", email, (val) {
                  setState(() => email = val);
                }),
          ),
          _buildLinkedBankAccounts(),
          _buildInfoRow(
            "KYC Status",
            kycStatus,
            icon: Icons.verified,
            iconColor: Colors.green,
          ),
          _buildCibilScore(),

          const SizedBox(height: 32),
          _buildSectionTitle("Security & Settings"),
          _buildSwitchTile(
            "Two-Factor Authentication",
            twoFactorEnabled,
            (v) => setState(() => twoFactorEnabled = v),
          ),
          _buildSwitchTile(
            "Biometric Login",
            biometricEnabled,
            (v) => setState(() => biometricEnabled = v),
          ),
          _buildSimpleListTile(
            title: "Change Password / PIN",
            icon: Icons.lock,
            onTap: () {
              /* navigate to change password screen */
            },
          ),
          _buildSimpleListTile(
            title: "Manage Devices",
            icon: Icons.devices,
            onTap: () {
              /* navigate to devices screen */
            },
          ),

          const SizedBox(height: 32),
          _buildSectionTitle("Payment & Transaction Settings"),
          _buildSimpleListTile(
            title: "Default Payment Method",
            subtitle: "Visa **** 1234",
            icon: Icons.payment,
            onTap: () {
              /* select default payment */
            },
          ),
          _buildSimpleListTile(
            title: "Transaction Limits",
            subtitle: "Daily: ₹50,000",
            icon: Icons.timelapse,
            onTap: () {
              /* view/set limits */
            },
          ),
          _buildNotificationPreferences(),

          const SizedBox(height: 32),
          _buildSectionTitle("App Preferences"),
          _buildSwitchTile(
            "Dark Theme",
            isDarkTheme,
            (v) => setState(() => isDarkTheme = v),
          ),
          _buildSimpleListTile(
            title: "Language Settings",
            icon: Icons.language,
            onTap: () {
              /* language selection */
            },
          ),
          _buildSimpleListTile(
            title: "Manage Addresses",
            icon: Icons.location_on,
            onTap: () {
              /* manage addresses */
            },
          ),

          const SizedBox(height: 32),
          _buildSectionTitle("Support & Legal"),
          _buildSimpleListTile(
            title: "Help & Support",
            icon: Icons.help_outline,
            onTap: () {
              /* open help */
            },
          ),
          _buildSimpleListTile(
            title: "Terms & Conditions",
            icon: Icons.description,
            onTap: () {
              /* open T&C */
            },
          ),
          _buildSimpleListTile(
            title: "Privacy Policy",
            icon: Icons.privacy_tip,
            onTap: () {
              /* open privacy policy */
            },
          ),

          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // logout logic
            },
            icon: const Icon(Icons.logout),
            label: const Text("Logout"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              padding: const EdgeInsets.symmetric(vertical: 14),
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),

          const SizedBox(height: 36),
          Center(
            child: Text(
              "App v1.0.3 • Powered by BTC",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Color(0xFF222222),
          letterSpacing: 0.4,
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 56,
              backgroundImage: const AssetImage("assets/images/profile.jpg"),
              backgroundColor: Colors.grey.shade200,
            ),
            Positioned(
              right: 4,
              bottom: 4,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: primaryColor,
                child: IconButton(
                  icon: const Icon(Icons.edit, size: 20, color: Colors.white),
                  onPressed: () {
                    // Edit profile picture
                  },
                  tooltip: "Edit Profile Picture",
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          userName,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          upiId,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 16,
            letterSpacing: 0.3,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            // Open edit profile dialog/page
          },
          child: const Text("Edit Profile"),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 14),
            backgroundColor: primaryColor,
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            elevation: 3,
            shadowColor: primaryColor.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildEditableField(
    String label,
    String value, {
    required VoidCallback onEdit,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1.8,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(value, style: const TextStyle(fontSize: 16)),
        trailing: IconButton(
          icon: Icon(Icons.edit, color: primaryColor),
          onPressed: onEdit,
          tooltip: "Edit $label",
        ),
      ),
    );
  }

  Widget _buildLinkedBankAccounts() {
    final banks = ["Axis Bank", "HDFC Bank", "ICICI Bank"];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1.8,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        title: const Text(
          "Linked Bank Accounts",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: Icon(Icons.account_balance, color: primaryColor),
        children: [
          for (var bank in banks)
            ListTile(
              title: Text(bank, style: const TextStyle(fontSize: 16)),
              trailing: IconButton(
                icon: const Icon(Icons.remove_circle, color: Colors.redAccent),
                onPressed: () {
                  // Remove bank action
                },
                tooltip: "Remove $bank",
              ),
            ),
          ListTile(
            leading: Icon(Icons.add_circle, color: Colors.green.shade700),
            title: const Text(
              "Add Bank Account",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            onTap: () {
              // Add bank account action
            },
            hoverColor: Colors.green.shade100,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    IconData? icon,
    Color? iconColor,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1.8,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        leading: icon != null ? Icon(icon, color: iconColor) : null,
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: Text(value, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget _buildCibilScore() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1.8,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        leading: const Icon(Icons.score, color: Colors.orange),
        title: const Text(
          "CIBIL Score",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          "$cibilScore - Good",
          style: const TextStyle(fontSize: 16),
        ),
        trailing: TextButton(
          onPressed: () {
            // Navigate to score details page
          },
          child: const Text(
            "View Details",
            style: TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return SwitchListTile.adaptive(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      value: value,
      activeColor: primaryColor,
      onChanged: onChanged,
      dense: true,
      controlAffinity: ListTileControlAffinity.trailing,
    );
  }

  Widget _buildNotificationPreferences() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1.8,
      child: ExpansionTile(
        leading: Icon(Icons.notifications, color: primaryColor),
        title: const Text(
          "Notifications Preferences",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 8),
        children: [
          SwitchListTile.adaptive(
            title: const Text("SMS"),
            value: notifSms,
            activeColor: primaryColor,
            onChanged: (v) => setState(() => notifSms = v),
            dense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          ),
          SwitchListTile.adaptive(
            title: const Text("Email"),
            value: notifEmail,
            activeColor: primaryColor,
            onChanged: (v) => setState(() => notifEmail = v),
            dense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          ),
          SwitchListTile.adaptive(
            title: const Text("Push Notifications"),
            value: notifPush,
            activeColor: primaryColor,
            onChanged: (v) => setState(() => notifPush = v),
            dense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleListTile({
    required String title,
    IconData? icon,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1.2,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: icon != null ? Icon(icon, color: primaryColor) : null,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
        hoverColor: primaryColor.withOpacity(0.1),
      ),
    );
  }

  void _showEditDialog(
    String title,
    String currentValue,
    ValueChanged<String> onSave,
  ) {
    final controller = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Edit $title"),
            content: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Enter $title",
                border: const OutlineInputBorder(),
              ),
              autofocus: true,
              keyboardType:
                  title.toLowerCase().contains("phone")
                      ? TextInputType.phone
                      : TextInputType.text,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  onSave(controller.text.trim());
                  Navigator.pop(context);
                },
                child: const Text("Save"),
              ),
            ],
          ),
    );
  }
}
