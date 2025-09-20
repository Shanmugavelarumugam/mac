import 'package:flutter/material.dart';
import 'inventory_tab.dart';
import 'getting_started_tab.dart';
import 'help_tab.dart';

class InventoryScreen extends StatefulWidget {
  final int userId;

  const InventoryScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: const Text(
          'Inventory',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, size: 24),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.indigo,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.indigo,
          tabs: const [
            Tab(text: 'Dashboard'),
            Tab(text: 'Getting Started'),
            Tab(text: 'Help'),
          ],
        ),
      ),
     body: TabBarView(
        controller: _tabController,
        children: [
          InventoryTab(userId: widget.userId), // OK, userId passed
          GettingStartedTab(userId: widget.userId), // <-- pass userId here too
          const HelpTab(),
        ],
      ),

    );
  }
}
