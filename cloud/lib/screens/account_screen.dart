import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _profileAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _profileScaleAnimation;

  bool _notificationsEnabled = true;
  bool _autoBackup = true;
  bool _offlineSync = false;
  String _storageUsed = "4.2 GB";
  String _storageTotal = "15 GB";
  double _storageProgress = 0.28;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _profileAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _profileScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _profileAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _animationController.forward();
    _profileAnimationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _profileAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(theme, colorScheme),
            Expanded(
              child: SingleChildScrollView(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      _buildProfileSection(theme, colorScheme, size),
                      _buildStorageSection(theme, colorScheme, size),
                      _buildQuickActions(theme, colorScheme, isTablet),
                      _buildSettingsSection(theme, colorScheme),
                      _buildSupportSection(theme, colorScheme),
                      _buildAccountSection(theme, colorScheme),
                      SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colorScheme.primary, colorScheme.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.person, color: Colors.white, size: 28),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Account",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: colorScheme.onBackground,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                  ),
                ),
                Text(
                  "Manage your profile and settings",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _showAccountMenu(),
            icon: Icon(Icons.more_vert, size: 28),
            style: IconButton.styleFrom(
              backgroundColor: colorScheme.surfaceVariant.withOpacity(0.5),
              foregroundColor: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection(
    ThemeData theme,
    ColorScheme colorScheme,
    Size size,
  ) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withOpacity(0.08),
            colorScheme.secondary.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outline.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          ScaleTransition(
            scale: _profileScaleAnimation,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: size.width * 0.25,
                  height: size.width * 0.25,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [colorScheme.primary, colorScheme.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withOpacity(0.3),
                        blurRadius: 20,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.person,
                    size: size.width * 0.12,
                    color: Colors.white,
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _showProfileOptions(),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        size: 20,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Shanmugavel A",
            style: theme.textTheme.headlineSmall?.copyWith(
              color: colorScheme.onBackground,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: "shanmugavel@example.com"));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Email copied to clipboard"),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.email,
                    size: 18,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "shanmugavel@example.com",
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Inter',
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.copy,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildProfileStat("Files", "245", colorScheme),
              Container(
                width: 1,
                height: 30,
                color: colorScheme.outline.withOpacity(0.3),
              ),
              _buildProfileStat("Shared", "18", colorScheme),
              Container(
                width: 1,
                height: 30,
                color: colorScheme.outline.withOpacity(0.3),
              ),
              _buildProfileStat("Starred", "12", colorScheme),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileStat(
    String label,
    String value,
    ColorScheme colorScheme,
  ) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: colorScheme.primary,
            fontFamily: 'Poppins',
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }

  Widget _buildStorageSection(
    ThemeData theme,
    ColorScheme colorScheme,
    Size size,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outline.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.cloud_outlined,
                  color: colorScheme.primary,
                  size: 28,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Storage",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onBackground,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Text(
                      "$_storageUsed of $_storageTotal used",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => _showStorageDetails(),
                child: Text("Manage"),
                style: TextButton.styleFrom(
                  foregroundColor: colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _storageProgress,
              minHeight: 10,
              backgroundColor: colorScheme.surfaceVariant,
              valueColor: AlwaysStoppedAnimation(colorScheme.primary),
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStorageItem(
                "Photos",
                "2.1 GB",
                colorScheme.primary,
                colorScheme,
              ),
              _buildStorageItem(
                "Documents",
                "1.8 GB",
                colorScheme.secondary,
                colorScheme,
              ),
              _buildStorageItem("Others", "0.3 GB", Colors.orange, colorScheme),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStorageItem(
    String type,
    String size,
    Color color,
    ColorScheme colorScheme,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              type,
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurfaceVariant,
                fontFamily: 'Inter',
              ),
            ),
            Text(
              size,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: colorScheme.onBackground,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActions(
    ThemeData theme,
    ColorScheme colorScheme,
    bool isTablet,
  ) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Quick Actions",
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onBackground,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  "Backup",
                  Icons.backup,
                  "Auto backup: ${_autoBackup ? 'On' : 'Off'}",
                  colorScheme.primary,
                  () => setState(() => _autoBackup = !_autoBackup),
                  colorScheme,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildQuickActionCard(
                  "Sync",
                  Icons.sync,
                  "Offline sync: ${_offlineSync ? 'On' : 'Off'}",
                  colorScheme.secondary,
                  () => setState(() => _offlineSync = !_offlineSync),
                  colorScheme,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(
    String title,
    IconData icon,
    String description,
    Color color,
    VoidCallback onTap,
    ColorScheme colorScheme,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorScheme.outline.withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onBackground,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurfaceVariant,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Settings",
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 12),
          _buildSettingsTile(
            Icons.tune,
            "Preferences",
            "Theme, language, and display",
            colorScheme,
            () => _showPreferences(),
          ),
          SizedBox(height: 8),
          _buildSettingsTile(
            Icons.notifications_outlined,
            "Notifications",
            _notificationsEnabled ? "Enabled" : "Disabled",
            colorScheme,
            () =>
                setState(() => _notificationsEnabled = !_notificationsEnabled),
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged:
                  (value) => setState(() => _notificationsEnabled = value),
              activeColor: colorScheme.primary,
            ),
          ),
          SizedBox(height: 8),
          _buildSettingsTile(
            Icons.security,
            "Privacy & Security",
            "Manage your data and privacy",
            colorScheme,
            () => _showPrivacySettings(),
          ),
          SizedBox(height: 8),
          _buildSettingsTile(
            Icons.devices,
            "Connected Devices",
            "Manage linked devices",
            colorScheme,
            () => _showConnectedDevices(),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSection(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Support",
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 12),
          _buildSettingsTile(
            Icons.help_outline,
            "Help Center",
            "Get help and support",
            colorScheme,
            () => _showHelpCenter(),
          ),
          SizedBox(height: 8),
          _buildSettingsTile(
            Icons.feedback_outlined,
            "Send Feedback",
            "Share your thoughts",
            colorScheme,
            () => _showFeedback(),
          ),
          SizedBox(height: 8),
          _buildSettingsTile(
            Icons.info_outline,
            "About",
            "Version 2.1.0",
            colorScheme,
            () => _showAbout(),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Account",
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 12),
          _buildSettingsTile(
            Icons.edit,
            "Edit Profile",
            "Update your information",
            colorScheme,
            () => _showEditProfile(),
          ),
          SizedBox(height: 8),
          _buildSettingsTile(
            Icons.swap_horiz,
            "Switch Account",
            "Change to another account",
            colorScheme,
            () => _showSwitchAccount(),
          ),
          SizedBox(height: 8),
          _buildSettingsTile(
            Icons.logout,
            "Sign Out",
            "Sign out of your account",
            colorScheme,
            () => _showSignOutDialog(),
            iconColor: Colors.red,
            textColor: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
    IconData icon,
    String title,
    String subtitle,
    ColorScheme colorScheme,
    VoidCallback onTap, {
    Widget? trailing,
    Color? iconColor,
    Color? textColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorScheme.outline.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: (iconColor ?? colorScheme.primary).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? colorScheme.primary,
                  size: 24,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: textColor ?? colorScheme.onBackground,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: colorScheme.onSurfaceVariant,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              trailing ??
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: colorScheme.onSurfaceVariant,
                  ),
            ],
          ),
        ),
      ),
    );
  }

  // Dialog and bottom sheet methods
  void _showAccountMenu() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.qr_code, size: 28),
                title: Text(
                  "Show QR Code",
                  style: TextStyle(fontFamily: 'Inter'),
                ),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: Icon(Icons.share, size: 28),
                title: Text(
                  "Share Profile",
                  style: TextStyle(fontFamily: 'Inter'),
                ),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: Icon(Icons.download, size: 28),
                title: Text(
                  "Export Data",
                  style: TextStyle(fontFamily: 'Inter'),
                ),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showProfileOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt, size: 28),
                title: Text(
                  "Take Photo",
                  style: TextStyle(fontFamily: 'Inter'),
                ),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: Icon(Icons.photo_library, size: 28),
                title: Text(
                  "Choose from Gallery",
                  style: TextStyle(fontFamily: 'Inter'),
                ),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: Icon(Icons.delete, size: 28, color: Colors.red),
                title: Text(
                  "Remove Photo",
                  style: TextStyle(color: Colors.red, fontFamily: 'Inter'),
                ),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text("Sign Out", style: TextStyle(fontFamily: 'Poppins')),
          content: Text(
            "Are you sure you want to sign out of your account?",
            style: TextStyle(fontFamily: 'Inter'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(fontFamily: 'Inter')),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Signed out successfully",
                      style: TextStyle(fontFamily: 'Inter'),
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              child: Text("Sign Out", style: TextStyle(fontFamily: 'Inter')),
            ),
          ],
        );
      },
    );
  }

  // Placeholder methods for other actions
  void _showStorageDetails() => _showComingSoon("Storage Details");
  void _showPreferences() => _showComingSoon("Preferences");
  void _showPrivacySettings() => _showComingSoon("Privacy Settings");
  void _showConnectedDevices() => _showComingSoon("Connected Devices");
  void _showHelpCenter() => _showComingSoon("Help Center");
  void _showFeedback() => _showComingSoon("Feedback");
  void _showAbout() => _showComingSoon("About");
  void _showEditProfile() => _showComingSoon("Edit Profile");
  void _showSwitchAccount() => _showComingSoon("Switch Account");

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "$feature coming soon!",
          style: TextStyle(fontFamily: 'Inter'),
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
