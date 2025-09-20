import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mail/config/theme.dart';
import 'package:mail/logic/bloc/mail/mail_bloc.dart';
import 'package:mail/logic/bloc/mail/mail_event.dart';
import 'package:mail/logic/bloc/mail/mail_state.dart';
import 'package:mail/presentation/screens/all_mail_screen.dart';
import 'package:mail/presentation/screens/inbox_screen.dart';
import 'package:mail/presentation/screens/label_categories_screen.dart';
import 'package:mail/presentation/screens/profile_screen.dart';

class MailHome extends StatelessWidget {
  const MailHome({super.key});

  static final List<Widget> _screens = [
    const InboxScreen(),
    const AllMailScreen(),
    const LabelCategoriesScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MailBloc, MailState>(
      builder: (context, state) {
        return Scaffold(
          body: _screens[state.currentIndex],
          bottomNavigationBar: _buildBottomNavigationBar(
            context,
            state.currentIndex,
          ),
        );
      },
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context, int currentIndex) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) =>
            context.read<MailBloc>().add(ChangeTab(index)),
        height: 70,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        backgroundColor: Colors.white,
        indicatorColor: AppColors.primary.withOpacity(0.2),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.inbox_outlined, color: AppColors.secondary),
            selectedIcon: Icon(Icons.inbox, color: AppColors.primary),
            label: "Inbox",
          ),
          NavigationDestination(
            icon: Icon(Icons.mail_outlined, color: AppColors.secondary),
            selectedIcon: Icon(Icons.mail, color: AppColors.primary),
            label: "All Mail",
          ),
          NavigationDestination(
            icon: Icon(Icons.label_outlined, color: AppColors.secondary),
            selectedIcon: Icon(Icons.label, color: AppColors.primary),
            label: "Labels",
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outlined, color: AppColors.secondary),
            selectedIcon: Icon(Icons.person, color: AppColors.primary),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
