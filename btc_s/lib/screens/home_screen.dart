import 'package:btc_s/screens/profile_screen.dart';
import 'package:btc_s/screens/search.dart';
import 'package:btc_s/utils/shared_preferences.dart';
import 'package:btc_s/widgets/custom_app_bar.dart';
import 'package:btc_s/widgets/custom_bottom_nav_bar.dart';
import 'package:btc_s/widgets/drawer.dart';
import 'package:btc_s/widgets/home_tabs.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String userName = '';
  String userEmail = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final name = await UserPreferences.getUserName();
    final email = await UserPreferences.getUserEmail();
    setState(() {
      userName = name ?? '';
      userEmail = email ?? '';
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const HomeTabs(),
      const SearchScreen(),
      Center(child: Text('Shop', style: GoogleFonts.montserrat(fontSize: 18))),
      const ProfileScreen(),
    ];

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar:
          _selectedIndex == 3
              ? null
              : CustomAppBar(
                onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
              ),
      drawer:
          _selectedIndex == 3
              ? null
              : AppDrawer(userName: userName, userEmail: userEmail),
      body: screens[_selectedIndex],
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
