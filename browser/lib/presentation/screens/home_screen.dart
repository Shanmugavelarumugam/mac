import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _urlController = TextEditingController();
  int _currentTab = 0;
  List<String> _tabs = ['New Tab'];

  void _handleMenuItem(String value) {
    switch (value) {
      case 'New Tab':
        setState(() {
          _tabs.add('New Tab ${_tabs.length + 1}');
          _currentTab = _tabs.length - 1;
        });
        break;
      case 'New Incognito Tab':
        // TODO: implement incognito
        break;
      case 'History':
        // TODO: implement history
        break;
      case 'Downloads':
        // TODO
        break;
      case 'Bookmarks':
        // TODO
        break;
      case 'Recent Tabs':
        // TODO
        break;
      case 'Settings':
        // TODO
        break;
      case 'Help & Feedback':
        // TODO
        break;
      case 'Notifications':
        // TODO
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;
    final isLargeScreen = size.width > 600;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isSmallScreen ? 120 : 140),
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Top Row: Home, Account, Menu
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 8 : 16,
                    vertical: isSmallScreen ? 8 : 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.home,
                          color: Colors.grey[800],
                          size: isSmallScreen ? 24 : 28,
                        ),
                        onPressed: () {},
                      ),
                      Row(
                        children: [
                          // Tabs count
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isSmallScreen ? 6 : 8,
                              vertical: isSmallScreen ? 2 : 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              _tabs.length.toString(),
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontWeight: FontWeight.bold,
                                fontSize: isSmallScreen ? 12 : 14,
                              ),
                            ),
                          ),
                          SizedBox(width: isSmallScreen ? 4 : 8),
                          IconButton(
                            icon: Icon(
                              Icons.account_circle,
                              color: Colors.grey[800],
                              size: isSmallScreen ? 24 : 28,
                            ),
                            onPressed: () {},
                          ),
                          PopupMenuButton<String>(
                            onSelected: _handleMenuItem,
                            icon: Icon(
                              Icons.more_vert,
                              color: Colors.grey[800],
                              size: isSmallScreen ? 24 : 28,
                            ),
                            color: Colors.white,
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'New Tab',
                                child: Text('New Tab'),
                              ),
                              const PopupMenuItem(
                                value: 'New Incognito Tab',
                                child: Text('New Incognito Tab'),
                              ),
                              const PopupMenuItem(
                                value: 'History',
                                child: Text('History'),
                              ),
                              const PopupMenuItem(
                                value: 'Downloads',
                                child: Text('Downloads'),
                              ),
                              const PopupMenuItem(
                                value: 'Bookmarks',
                                child: Text('Bookmarks'),
                              ),
                              const PopupMenuItem(
                                value: 'Recent Tabs',
                                child: Text('Recent Tabs'),
                              ),
                              const PopupMenuItem(
                                value: 'Settings',
                                child: Text('Settings'),
                              ),
                              const PopupMenuItem(
                                value: 'Help & Feedback',
                                child: Text('Help & Feedback'),
                              ),
                              const PopupMenuItem(
                                value: 'Notifications',
                                child: Text('Notifications'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isSmallScreen ? 8 : 12),
                // Search bar with mic and lens
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 8 : 16,
                  ),
                  child: Container(
                    height: isSmallScreen ? 40 : 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _urlController,
                      style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
                      decoration: InputDecoration(
                        hintText: 'Search or enter URL',
                        hintStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: isSmallScreen ? 14 : 16,
                        ),
                        filled: true,
                        fillColor: Colors.transparent,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey[600],
                          size: isSmallScreen ? 20 : 24,
                        ),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.mic,
                                color: Colors.grey[600],
                                size: isSmallScreen ? 20 : 24,
                              ),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.camera_alt,
                                color: Colors.grey[600],
                                size: isSmallScreen ? 20 : 24,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 12 : 16),
            child: Text(
              'BTC',
              style: TextStyle(
                fontSize: isSmallScreen ? 24 : 28,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
                letterSpacing: 1.2,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.language,
                    size: isLargeScreen
                        ? 120
                        : isSmallScreen
                        ? 80
                        : 100,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 20),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      _tabs.isEmpty
                          ? 'No Tabs Open'
                          : 'Web page will display for "${_tabs[_currentTab]}"',
                      key: ValueKey(_currentTab),
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
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

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }
}
