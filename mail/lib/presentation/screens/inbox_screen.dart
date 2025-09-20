import 'package:flutter/material.dart';
import 'package:mail/config/theme.dart';
import 'package:mail/data/models/email.dart';
import 'package:mail/presentation/screens/compose_email_screen.dart';
import 'package:mail/presentation/widgets/drawer_widget.dart';
import 'package:mail/presentation/widgets/email_list_item.dart';

import '../widgets/search_bar_widget.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Email> _filteredEmails = inboxEmails;

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredEmails = inboxEmails;
      } else {
        _filteredEmails = inboxEmails.where((email) {
          return email.sender.toLowerCase().contains(query.toLowerCase()) ||
              email.subject.toLowerCase().contains(query.toLowerCase()) ||
              email.preview.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            backgroundColor: Colors.white,
            title: Text(
              "Mailbox",
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.star_border_rounded, color: AppColors.primary),
                onPressed: () {},
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: SearchBarWidget(
              onSearch: _onSearch,
              controller: _searchController,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final email = _filteredEmails[index];
                return EmailListItem(email: email);
              }, childCount: _filteredEmails.length),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ComposeEmailScreen()),
          );
        },
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.edit_rounded, color: Colors.white, size: 24),
      ),
    );
  }
}
