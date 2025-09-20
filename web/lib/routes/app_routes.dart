import 'package:flutter/material.dart';
import 'package:web_app/presentation/screens/Home/search_home_page.dart';
import 'package:web_app/presentation/screens/search_home_page.dart';
import 'package:web_app/presentation/screens/saved_screen.dart';
import 'package:web_app/presentation/screens/downloads_screen.dart';
import 'package:web_app/presentation/screens/profile_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String saved = '/saved';
  static const String downloads = '/downloads';
  static const String profile = '/profile';

  static Map<String, WidgetBuilder> routes = {
    home: (context) => const SearchHomePage(),
    saved: (context) => const SavedScreen(),
    downloads: (context) => const DownloadsScreen(),
    profile: (context) => const ProfileScreen(),
  };
}
