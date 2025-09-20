import 'package:btc/screens/books/finance_contact_screen.dart';
import 'package:btc/screens/books/track_finance_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:btc/screens/auth/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/ai_screen.dart';
import 'screens/profile_screen.dart';
import 'package:btc/screens/books/books_screen.dart';
import 'package:btc/screens/public/public_screen.dart';

void main() {
  runApp(FinanceApp());
}

class FinanceApp extends StatefulWidget {
  @override
  _FinanceAppState createState() => _FinanceAppState();
}

class _FinanceAppState extends State<FinanceApp> {
  final _storage = const FlutterSecureStorage();
  late String _token; // non-nullable
  late int _userId; // non-nullable
  bool _loading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    print('Loading token...');
    String? storedToken = await _storage.read(key: 'auth_token');
    String? storedUserIdStr = await _storage.read(key: 'user_id');

    if (storedToken != null && storedUserIdStr != null) {
      _token = storedToken;
      _userId = int.parse(storedUserIdStr);
      _isLoggedIn = true;
      print('Stored token: $_token');
      print('Stored userId: $_userId');
    }

    setState(() {
      _loading = false;
    });
  }

  void _onLoginSuccess(String token, int userId) async {
    await _storage.write(key: 'auth_token', value: token);
    await _storage.write(key: 'user_id', value: userId.toString());

    setState(() {
      _token = token;
      _userId = userId;
      _isLoggedIn = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Finance',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home:
          _isLoggedIn
              ? MainScreen(token: _token, userId: _userId)
              : LoginScreen(onLoginSuccess: _onLoginSuccess),
    );
  }
}

class MainScreen extends StatefulWidget {
  final String token;
  final int userId;

  const MainScreen({Key? key, required this.token, required this.userId})
    : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(),
      BooksScreen(userId: widget.userId), // userId available here
      AiScreen(),
      PublicScreen(),
      ProfileScreen(),
    ];
  }

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Books'),
          BottomNavigationBarItem(icon: Icon(Icons.smart_toy), label: 'AI'),
          BottomNavigationBarItem(icon: Icon(Icons.public), label: 'Public'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
