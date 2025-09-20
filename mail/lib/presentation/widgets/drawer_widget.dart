import 'package:flutter/material.dart';
import 'package:mail/config/theme.dart'; // Assuming AppColors is defined here
import 'package:iconsax/iconsax.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.78,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header Section
          Container(
            height: isSmallScreen ? 110 : 150,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary,
                  AppColors.primary.withOpacity(0.85),
                ],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: isSmallScreen ? 14 : 22,
              ),
              child: Row(
                children: [
                  Container(
                    width: isSmallScreen ? 48 : 60,
                    height: isSmallScreen ? 48 : 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        isSmallScreen ? 24 : 30,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.person,
                      color: AppColors.primary,
                      size: isSmallScreen ? 26 : 34,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "John Doe",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isSmallScreen ? 18 : 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "johndoe@gmail.com",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: isSmallScreen ? 12 : 14,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Navigation Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(
                vertical: isSmallScreen ? 8 : 12,
                horizontal: 8,
              ),
              children: [
                // Primary Mail Categories
                _buildSectionTitle("MAIL", context, isSmallScreen),
                _buildDrawerItem(
                  context,
                  icon: Icons.inbox_rounded,
                  title: "Inbox",
                  count: "5",
                  isSelected: true,
                  isSmallScreen: isSmallScreen,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.star_rounded,
                  title: "Starred",
                  count: "12",
                  isSmallScreen: isSmallScreen,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.schedule_rounded,
                  title: "Snoozed",
                  count: "3",
                  isSmallScreen: isSmallScreen,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.send_rounded,
                  title: "Sent",
                  isSmallScreen: isSmallScreen,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.drafts_rounded,
                  title: "Drafts",
                  count: "2",
                  isSmallScreen: isSmallScreen,
                ),

                Divider(
                  color: Colors.grey.shade300,
                  thickness: 1,
                  indent: 16,
                  endIndent: 16,
                ),

                // Secondary Categories
                _buildSectionTitle("CATEGORIES", context, isSmallScreen),
                _buildDrawerItem(
                  context,
                  icon: Icons.mail_rounded,
                  title: "All mail",
                  isSmallScreen: isSmallScreen,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.warning_rounded,
                  title: "Spam",
                  count: "24",
                  isSmallScreen: isSmallScreen,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.delete_rounded,
                  title: "Trash",
                  isSmallScreen: isSmallScreen,
                ),

                Divider(
                  color: Colors.grey.shade300,
                  thickness: 1,
                  indent: 16,
                  endIndent: 16,
                ),

                // Labels Section
                _buildSectionTitle("LABELS", context, isSmallScreen),
                _buildDrawerItem(
                  context,
                  icon: Icons.label_rounded,
                  title: "Work",
                  color: Colors.blue.shade600,
                  isSmallScreen: isSmallScreen,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.label_rounded,
                  title: "Personal",
                  color: Colors.green.shade600,
                  isSmallScreen: isSmallScreen,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.label_rounded,
                  title: "Travel",
                  color: Colors.orange.shade600,
                  isSmallScreen: isSmallScreen,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.label_rounded,
                  title: "Finance",
                  color: Colors.purple.shade600,
                  isSmallScreen: isSmallScreen,
                ),

                // Settings Section
                _buildSectionTitle("SETTINGS", context, isSmallScreen),
                _buildDrawerItem(
                  context,
                  icon: Icons.settings_rounded,
                  title: "Settings",
                  isSmallScreen: isSmallScreen,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.help_rounded,
                  title: "Help & feedback",
                  isSmallScreen: isSmallScreen,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.exit_to_app_rounded,
                  title: "Sign out",
                  isSmallScreen: isSmallScreen,
                  color: Colors.red.shade600,
                ),
              ],
            ),
          ),

          // Footer with App Version
          Container(
            padding: const EdgeInsets.all(12),
            child: Text(
              "MailBox v1.0.0",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(
    String title,
    BuildContext context,
    bool isSmallScreen,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.secondary,
          fontSize: isSmallScreen ? 10 : 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? count,
    bool isSelected = false,
    Color? color,
    required bool isSmallScreen,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withOpacity(0.12)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color:
              color ?? (isSelected ? AppColors.primary : AppColors.secondary),
          size: isSmallScreen ? 20 : 22,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? AppColors.primary : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: isSmallScreen ? 13 : 14,
          ),
        ),
        trailing: count != null
            ? Text(
                count,
                style: TextStyle(
                  color: isSelected ? AppColors.primary : Colors.black54,
                  fontSize: isSmallScreen ? 11 : 12,
                  fontWeight: FontWeight.w600,
                ),
              )
            : null,
        onTap: () => Navigator.pop(context), // You can customize this
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        dense: true,
        visualDensity: const VisualDensity(vertical: -1),
      ),
    );
  }
}
