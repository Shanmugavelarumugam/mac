import 'package:flutter/material.dart';
import 'package:mail/config/theme.dart';
import 'package:mail/presentation/widgets/drawer_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;
    final isVerySmallScreen = size.height < 600;

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text("Profile"),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.primary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isVerySmallScreen ? 12.0 : 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Header Card
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(
                  horizontal: isVerySmallScreen ? 8.0 : 0.0,
                ),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Colors.white,
                  shadowColor: Colors.black.withOpacity(0.1),
                  child: Padding(
                    padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
                    child: Column(
                      children: [
                        // Avatar with decorative border
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.2),
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.1),
                                blurRadius: 8,
                                spreadRadius: 2,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: isVerySmallScreen
                                ? 32.0
                                : isSmallScreen
                                ? 35.0
                                : 40.0,
                            backgroundImage: const NetworkImage(
                              "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1160&q=80",
                            ),
                          ),
                        ),
                        SizedBox(height: isVerySmallScreen ? 12 : 16),
                        // Name
                        Text(
                          "John Doe",
                          style: TextStyle(
                            fontSize: isVerySmallScreen
                                ? 18
                                : isSmallScreen
                                ? 20
                                : 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Email
                        Text(
                          "johndoe@gmail.com",
                          style: TextStyle(
                            fontSize: isVerySmallScreen
                                ? 13
                                : isSmallScreen
                                ? 14
                                : 16,
                            color: AppColors.secondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Edit Profile Button
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: Icon(
                            Icons.edit_rounded,
                            size: isVerySmallScreen ? 16 : 18,
                            color: AppColors.primary,
                          ),
                          label: Text(
                            "Edit Profile",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: isVerySmallScreen ? 13 : 14,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: AppColors.primary.withOpacity(
                              0.05,
                            ),
                            side: BorderSide(
                              color: AppColors.primary.withOpacity(0.2),
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: isVerySmallScreen ? 12 : 16,
                              vertical: isVerySmallScreen ? 6 : 8,
                            ),
                          ),
                        ),
                        SizedBox(height: isVerySmallScreen ? 16 : 24),
                        // Stats Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildProfileStat(
                              Icons.email_rounded,
                              "2.1K",
                              "Emails",
                              isSmallScreen,
                              isVerySmallScreen,
                            ),
                            _buildVerticalDivider(),
                            _buildProfileStat(
                              Icons.label_rounded,
                              "12",
                              "Labels",
                              isSmallScreen,
                              isVerySmallScreen,
                            ),
                            _buildVerticalDivider(),
                            _buildProfileStat(
                              Icons.star_rounded,
                              "24",
                              "Starred",
                              isSmallScreen,
                              isVerySmallScreen,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: isVerySmallScreen ? 16 : 24),
              // Settings Card
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(
                  horizontal: isVerySmallScreen ? 8.0 : 0.0,
                ),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Colors.white,
                  shadowColor: Colors.black.withOpacity(0.1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          isVerySmallScreen ? 16.0 : 20.0,
                          isVerySmallScreen ? 16.0 : 20.0,
                          isVerySmallScreen ? 16.0 : 20.0,
                          8.0,
                        ),
                        child: Text(
                          "Account Settings",
                          style: TextStyle(
                            fontSize: isVerySmallScreen ? 16 : 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      _buildProfileButton(
                        context,
                        icon: Icons.person_rounded,
                        text: "Manage Account",
                        isSmallScreen: isSmallScreen,
                        isVerySmallScreen: isVerySmallScreen,
                      ),
                      _buildDivider(),
                      _buildProfileButton(
                        context,
                        icon: Icons.security_rounded,
                        text: "Security",
                        isSmallScreen: isSmallScreen,
                        isVerySmallScreen: isVerySmallScreen,
                      ),
                      _buildDivider(),
                      _buildProfileButton(
                        context,
                        icon: Icons.notifications_rounded,
                        text: "Notifications",
                        isSmallScreen: isSmallScreen,
                        isVerySmallScreen: isVerySmallScreen,
                      ),
                      _buildDivider(),
                      _buildProfileButton(
                        context,
                        icon: Icons.storage_rounded,
                        text: "Storage",
                        isSmallScreen: isSmallScreen,
                        isVerySmallScreen: isVerySmallScreen,
                      ),
                      _buildDivider(),
                      _buildProfileButton(
                        context,
                        icon: Icons.help_rounded,
                        text: "Help & Feedback",
                        isSmallScreen: isSmallScreen,
                        isVerySmallScreen: isVerySmallScreen,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: isVerySmallScreen ? 16 : 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(height: 30, width: 1, color: Colors.grey.withOpacity(0.3));
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: Colors.grey.shade200,
      indent: 16,
      endIndent: 16,
    );
  }

  Widget _buildProfileStat(
    IconData icon,
    String value,
    String label,
    bool isSmallScreen,
    bool isVerySmallScreen,
  ) {
    return Flexible(
      child: Column(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: isVerySmallScreen
                ? 18
                : isSmallScreen
                ? 20
                : 24,
          ),
          SizedBox(height: isVerySmallScreen ? 4 : 6),
          Text(
            value,
            style: TextStyle(
              fontSize: isVerySmallScreen
                  ? 15
                  : isSmallScreen
                  ? 16
                  : 18,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: isVerySmallScreen ? 2 : 4),
          Text(
            label,
            style: TextStyle(
              color: AppColors.secondary,
              fontSize: isVerySmallScreen ? 11 : 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileButton(
    BuildContext context, {
    required IconData icon,
    required String text,
    required bool isSmallScreen,
    required bool isVerySmallScreen,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.primary,
        size: isVerySmallScreen
            ? 18
            : isSmallScreen
            ? 20
            : 22,
      ),
      title: Text(
        text,
        style: TextStyle(
          color: Colors.black87,
          fontSize: isVerySmallScreen
              ? 13
              : isSmallScreen
              ? 14
              : 16,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: AppColors.secondary,
        size: isVerySmallScreen
            ? 18
            : isSmallScreen
            ? 20
            : 24,
      ),
      onTap: () {},
      contentPadding: EdgeInsets.symmetric(
        horizontal: isVerySmallScreen ? 12 : 16,
        vertical: isVerySmallScreen ? 0 : 4,
      ),
      visualDensity: VisualDensity.compact,
      minLeadingWidth: isVerySmallScreen ? 24 : 32,
    );
  }
}
