import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/navigation/navigation_bloc.dart';
import '../blocs/navigation/navigation_event.dart';
import '../blocs/navigation/navigation_state.dart';

import '../presentation/screens/home_screen.dart';
import '../presentation/screens/finance_screen.dart';
import '../presentation/screens/ai_screen.dart';
import '../presentation/screens/public_screen.dart';
import '../presentation/screens/profile_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final List<Widget> pages = [
    const HomeScreen(),
    const FinanceScreen(),
    const AIScreen(),
    const PublicScreen(),
    const ProfileScreen(),
  ];

  static final List<BottomNavigationBarItem> bottomNavItems = [
    const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
    const BottomNavigationBarItem(
      icon: Icon(Icons.account_balance_wallet),
      label: "Finance",
    ),
    const BottomNavigationBarItem(icon: Icon(Icons.smart_toy), label: "AI"),
    const BottomNavigationBarItem(icon: Icon(Icons.public), label: "Public"),
    const BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NavigationBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BLoC Bottom Navigation App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: BlocBuilder<NavigationBloc, NavigationState>(
          builder: (context, state) {
            return Scaffold(
              body: pages[state.selectedIndex],
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: state.selectedIndex,
                items: bottomNavItems,
                selectedItemColor: Colors.blue,
                unselectedItemColor: Colors.grey,
                type: BottomNavigationBarType.fixed,
                onTap: (index) {
                  context.read<NavigationBloc>().add(NavigateTo(index));
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
