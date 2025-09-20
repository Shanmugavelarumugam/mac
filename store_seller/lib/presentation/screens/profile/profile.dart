import 'package:btc_store/bloc/profile/profile_bloc.dart';
import 'package:btc_store/data/models/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:btc_store/bloc/profile/profile_event.dart';
import 'package:btc_store/bloc/profile/profile_state.dart';
import 'package:btc_store/data/repositories/profile_repository.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;
  bool _lowStockAlerts = true;
  bool _payoutUpdates = true;
  bool _darkMode = false;

  int _currentSection = 0; // 0: Profile, 1: Settings

  @override
  void initState() {
    super.initState();
    // Fetch profile data when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SellerBloc>().add(FetchSellerProfile());
    });
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 360;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentSection == 0 ? "Business Profile" : "Settings",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: isSmallScreen ? 18 : 20,
          ),
        ),
        centerTitle: true,
        elevation: 0.5,
        actions: [
          if (_currentSection == 0)
            IconButton(
              onPressed: () {
                _showEditProfileDialog(context);
              },
              icon: const Icon(Iconsax.edit),
            ),
        ],
      ),
      body: BlocConsumer<SellerBloc, SellerState>(
        listener: (context, state) {
          if (state is SellerError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error)));
          } else if (state is SellerUpdated) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is SellerLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final profile = state is SellerLoaded ? state.profile : null;

          return Column(
            children: [
              // Section selector
              Container(
                height: 50,
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _currentSection = 0;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: _currentSection == 0
                                ? const Color(0xFF6A5AE0)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            "Profile",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              color: _currentSection == 0
                                  ? Colors.white
                                  : const Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _currentSection = 1;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: _currentSection == 1
                                ? const Color(0xFF6A5AE0)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            "Settings",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              color: _currentSection == 1
                                  ? Colors.white
                                  : const Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: _currentSection == 0
                    ? _buildProfileSection(isSmallScreen, profile)
                    : _buildSettingsSection(isSmallScreen),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileSection(bool isSmallScreen, SellerProfile? profile) {
    if (profile == null) {
      return Center(
        child: Text("No profile data available", style: GoogleFonts.poppins()),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Business Info Card
          _buildSectionCard(
            title: "Business Information",
            icon: Iconsax.building,
            children: [
              _buildInfoRow("Business Name", profile.businessName),
              _buildInfoRow("Owner Name", profile.name),
              _buildInfoRow("Email", profile.email),
              _buildInfoRow("Phone", profile.phone),
              _buildInfoRow("Business Type", profile.businessType),
              _buildInfoRow("Address", profile.address ?? "Not provided"),
              _buildInfoRow("City", profile.city ?? "Not provided"),
              _buildInfoRow("State", profile.state ?? "Not provided"),
              _buildInfoRow("Country", profile.country ?? "Not provided"),
              _buildInfoRow("Pincode", profile.pincode ?? "Not provided"),
            ],
          ),

          const SizedBox(height: 16),

          // Legal/Tax Info Card
          _buildSectionCard(
            title: "Legal & Tax Information",
            icon: Iconsax.document,
            children: [
              _buildInfoRow("GST Number", profile.gstNumber ?? "Not provided"),
              _buildInfoRow("PAN Number", profile.panNumber ?? "Not provided"),
              _buildStatusRow("KYC Status", profile.kycStatus),
            ],
          ),

          const SizedBox(height: 16),

          // Bank Details Card
          _buildSectionCard(
            title: "Bank Account Details",
            icon: Iconsax.bank,
            children: [
              _buildInfoRow("Bank Name", profile.bankName ?? "Not provided"),
              _buildInfoRow(
                "Account Number",
                profile.bankAccountNumber ?? "Not provided",
              ),
              _buildInfoRow("IFSC Code", profile.ifscCode ?? "Not provided"),
              _buildInfoRow("UPI ID", profile.upiId ?? "Not provided"),
            ],
          ),

          const SizedBox(height: 16),

          // Stats Card
          _buildSectionCard(
            title: "Business Stats",
            icon: Iconsax.chart,
            children: [
              _buildInfoRow("Rating", profile.rating.toString()),
              _buildInfoRow("Total Sales", profile.totalSales.toString()),
              _buildStatusRow("Payment Status", profile.paymentStatus),
              _buildInfoRow(
                "Verification Status",
                profile.isVerified ? "Verified" : "Not Verified",
              ),
              _buildInfoRow(
                "Account Status",
                profile.isBlocked ? "Blocked" : "Active",
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    _showEditProfileDialog(context);
                  },
                  icon: const Icon(Iconsax.edit, size: 18),
                  label: Text(
                    "Edit Profile",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Color(0xFF6A5AE0)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Upload KYC docs
                  },
                  icon: const Icon(Iconsax.document_upload, size: 18),
                  label: Text(
                    "Upload KYC",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A5AE0),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(bool isSmallScreen) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Notifications Card
          _buildSectionCard(
            title: "Notifications",
            icon: Iconsax.notification,
            children: [
              _buildSwitchRow("Enable Notifications", _notificationsEnabled, (
                value,
              ) {
                setState(() {
                  _notificationsEnabled = value;
                });
              }),
              if (_notificationsEnabled) ...[
                const SizedBox(height: 8),
                _buildSwitchRow("Low Stock Alerts", _lowStockAlerts, (value) {
                  setState(() {
                    _lowStockAlerts = value;
                  });
                }, indent: true),
                const SizedBox(height: 8),
                _buildSwitchRow("Payout Updates", _payoutUpdates, (value) {
                  setState(() {
                    _payoutUpdates = value;
                  });
                }, indent: true),
              ],
            ],
          ),

          const SizedBox(height: 16),

          // Account Settings Card
          _buildSectionCard(
            title: "Account Settings",
            icon: Iconsax.security_user,
            children: [
              _buildSettingsButton("Change Password", Iconsax.lock, () {
                _showChangePasswordDialog();
              }),
              _buildSettingsButton(
                "Language Preference",
                Iconsax.language_circle,
                () {
                  // Language selection
                },
              ),
              _buildSwitchRow("Dark Mode", _darkMode, (value) {
                setState(() {
                  _darkMode = value;
                });
              }),
            ],
          ),

          const SizedBox(height: 16),

          // Support Card
          _buildSectionCard(
            title: "Support",
            icon: Iconsax.support,
            children: [
              _buildSettingsButton(
                "Help & Support",
                Iconsax.message_question,
                () {
                  // Help & support
                },
              ),
              _buildSettingsButton("About App", Iconsax.info_circle, () {
                // About app
              }),
            ],
          ),

          const SizedBox(height: 16),

          // Danger Zone Card
          _buildSectionCard(
            title: "Account Actions",
            icon: Iconsax.warning_2,
            children: [
              _buildSettingsButton(
                "Delete Account",
                Iconsax.profile_delete,
                () {
                  _showDeleteAccountDialog();
                },
                color: const Color(0xFFFF4757),
              ),
              _buildSettingsButton("Logout", Iconsax.logout, () {
                _showLogoutConfirmation();
              }, color: const Color(0xFFFF4757)),
            ],
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: const Color(0xFF6A5AE0)),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Column(children: children),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: const Color(0xFF64748B),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: const Color(0xFF1E293B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String status) {
    Color statusColor;
    IconData statusIcon;

    switch (status.toLowerCase()) {
      case "approved":
        statusColor = const Color(0xFF00B894);
        statusIcon = Iconsax.tick_circle;
        break;
      case "pending":
        statusColor = const Color(0xFFFFA726);
        statusIcon = Iconsax.clock;
        break;
      case "rejected":
        statusColor = const Color(0xFFFF4757);
        statusIcon = Iconsax.close_circle;
        break;
      default:
        statusColor = const Color(0xFF64748B);
        statusIcon = Iconsax.info_circle;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: const Color(0xFF64748B),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(statusIcon, size: 14, color: statusColor),
                  const SizedBox(width: 6),
                  Text(
                    status,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchRow(
    String title,
    bool value,
    Function(bool) onChanged, {
    bool indent = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: indent ? 16 : 0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: const Color(0xFF1E293B),
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF6A5AE0),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsButton(
    String title,
    IconData icon,
    Function() onTap, {
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color ?? const Color(0xFF64748B)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: color ?? const Color(0xFF1E293B),
                ),
              ),
            ),
            const Icon(
              Iconsax.arrow_right_3,
              size: 18,
              color: Color(0xFF94A3B8),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Edit Profile",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          content: Text(
            "This feature will allow you to update your business, tax, and bank details.",
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: GoogleFonts.poppins()),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6A5AE0),
              ),
              child: Text("Continue", style: GoogleFonts.poppins()),
            ),
          ],
        );
      },
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Change Password",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: "Current Password",
                  labelStyle: GoogleFonts.poppins(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  labelText: "New Password",
                  labelStyle: GoogleFonts.poppins(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  labelText: "Confirm New Password",
                  labelStyle: GoogleFonts.poppins(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: GoogleFonts.poppins()),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6A5AE0),
              ),
              child: Text("Update Password", style: GoogleFonts.poppins()),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Delete Account",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          content: Text(
            "Are you sure you want to request account deletion? This action will require admin approval and cannot be undone.",
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: GoogleFonts.poppins()),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF4757),
              ),
              child: Text("Request Deletion", style: GoogleFonts.poppins()),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Logout",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          content: Text(
            "Are you sure you want to logout from your account?",
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: GoogleFonts.poppins()),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF4757),
              ),
              child: Text("Logout", style: GoogleFonts.poppins()),
            ),
          ],
        );
      },
    );
  }
}
