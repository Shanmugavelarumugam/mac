import 'package:flutter/material.dart';
import '../widgets/profile_section.dart';
import '../widgets/profile_option.dart';
import '../widgets/account_menu.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF1F1F1F)
          : const Color(0xFFFAFAFA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            expandedHeight: 280,
            pinned: true,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [
                            const Color(0xFF1565C0),
                            const Color(0xFF283593),
                            const Color(0xFF512DA8),
                          ]
                        : [
                            const Color(0xFF2196F3),
                            const Color(0xFF3F51B5),
                            const Color(0xFF673AB7),
                          ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 46,
                                backgroundColor: const Color(0xFF4285F4),
                                child: Text(
                                  "HV",
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF34A853),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Hari Vel",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          "hari111a1@gmail.com",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _quickActionButton(
                            Icons.edit_outlined,
                            "Edit",
                            () {},
                          ),
                          const SizedBox(width: 24),
                          _quickActionButton(
                            Icons.share_outlined,
                            "Share",
                            () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -30),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2D2D30) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF3C3C3C)
                        : const Color(0xFFE8EAED),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (isDark ? Colors.black : Colors.grey).withOpacity(
                        0.1,
                      ),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    _modernStatCard(
                      "128",
                      "Saved Items",
                      Icons.bookmark_border,
                      const Color(0xFF4285F4),
                      isDark,
                    ),
                    Container(
                      width: 1,
                      height: 60,
                      color: isDark
                          ? const Color(0xFF3C3C3C)
                          : const Color(0xFFE8EAED),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                    _modernStatCard(
                      "24",
                      "Downloads",
                      Icons.download_outlined,
                      const Color(0xFF34A853),
                      isDark,
                    ),
                    Container(
                      width: 1,
                      height: 60,
                      color: isDark
                          ? const Color(0xFF3C3C3C)
                          : const Color(0xFFE8EAED),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                    _modernStatCard(
                      "12",
                      "Collections",
                      Icons.folder_outlined,
                      const Color(0xFFFF9800),
                      isDark,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                buildProfileSection(
                  "Account",
                  Icons.person_outline,
                  const Color(0xFF4285F4),
                  isDark,
                  [
                    buildProfileOption(
                      "Personal Information",
                      "Manage your personal details",
                      Icons.badge_outlined,
                      () {},
                      isDark,
                    ),
                    buildProfileOption(
                      "Security & Privacy",
                      "Password, 2FA and privacy settings",
                      Icons.security_outlined,
                      () {},
                      isDark,
                    ),
                    buildProfileOption(
                      "Payment Methods",
                      "Credit cards and payment options",
                      Icons.payment_outlined,
                      () {},
                      isDark,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                buildProfileSection(
                  "Preferences",
                  Icons.tune_outlined,
                  const Color(0xFF34A853),
                  isDark,
                  [
                    buildProfileOption(
                      "Theme & Appearance",
                      "Dark mode, colors and layout",
                      Icons.palette_outlined,
                      () {},
                      isDark,
                    ),
                    buildProfileOption(
                      "Language & Region",
                      "Language, currency and time zone",
                      Icons.language_outlined,
                      () {},
                      isDark,
                    ),
                    buildProfileOption(
                      "Notifications",
                      "Push notifications and email alerts",
                      Icons.notifications_outlined,
                      () {},
                      isDark,
                    ),
                    buildProfileOption(
                      "Data & Storage",
                      "Manage your data usage and storage",
                      Icons.storage_outlined,
                      () {},
                      isDark,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                buildProfileSection(
                  "Support",
                  Icons.support_agent_outlined,
                  const Color(0xFFFF9800),
                  isDark,
                  [
                    buildProfileOption(
                      "Help Center",
                      "FAQs and user guides",
                      Icons.help_outline,
                      () {},
                      isDark,
                    ),
                    buildProfileOption(
                      "Contact Support",
                      "Get help from our team",
                      Icons.headset_mic_outlined,
                      () {},
                      isDark,
                    ),
                    buildProfileOption(
                      "Feedback",
                      "Share your thoughts with us",
                      Icons.feedback_outlined,
                      () {},
                      isDark,
                    ),
                    buildProfileOption(
                      "About",
                      "App version and legal information",
                      Icons.info_outlined,
                      () {},
                      isDark,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFEA4335).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: TextButton.icon(
                    onPressed: () {
                      _showSignOutDialog(context, isDark);
                    },
                    icon: Icon(
                      Icons.logout_outlined,
                      color: const Color(0xFFEA4335),
                      size: 20,
                    ),
                    label: Text(
                      "Sign Out",
                      style: TextStyle(
                        color: const Color(0xFFEA4335),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Center(
                  child: Text(
                    "Version 2.1.4 • Built with Flutter",
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white38 : const Color(0xFF9AA0A6),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickActionButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _modernStatCard(
    String value,
    String label,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF202124),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.white70 : const Color(0xFF5F6368),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF2D2D30) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Sign Out",
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF202124),
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          "Are you sure you want to sign out of your account?",
          style: TextStyle(
            color: isDark ? Colors.white70 : const Color(0xFF5F6368),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              "Cancel",
              style: TextStyle(
                color: isDark ? Colors.white70 : const Color(0xFF5F6368),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              "Sign Out",
              style: TextStyle(color: Color(0xFFEA4335)),
            ),
          ),
        ],
      ),
    );
  }
}
