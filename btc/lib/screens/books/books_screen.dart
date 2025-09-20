import 'package:flutter/material.dart';
import 'people_screen.dart';
import 'track_finance_screen.dart';
import 'calculator_screen.dart';
import 'inventory_screen.dart';
import 'finance_contact_screen.dart';
import 'financial_planner_screen.dart';
import 'trip_screen.dart';

class BooksScreen extends StatelessWidget {
  final int userId; // accept userId here

  const BooksScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> features = [
    {
        'title': 'People',
        'icon': Icons.group,
        'screen': PeopleScreen(userId: userId),
      },
      {
        'title': 'Segrigation',
        'icon': Icons.track_changes,
        'screen': TrackFinanceScreen(userId: userId),
      },
      {
        'title': 'Stock',
        'icon': Icons.inventory,
        'screen': InventoryScreen(userId: userId),
      },
      {
        'title': 'Contact',
        'icon': Icons.contacts,
        'screen': FinanceContactScreen(userId: userId),
      },
      {
        'title': 'Plan',
        'icon': Icons.event_note,
        'screen': FinancialPlannerScreen(),
      },
      {
        'title': 'Group Expenses',
        'icon': Icons.card_travel,
        'screen': TripScreen(userId: userId),
      },
      {
        'title': 'Auditor',
        'icon': Icons.account_balance,
        'screen': Scaffold(
          appBar: AppBar(title: Text('Auditor')),
          body: Center(child: Text('Auditor screen coming soon')),
        ),
      },

    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Books"), elevation: 2),
      backgroundColor: const Color(0xFFF4F6FA),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: features.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 4 / 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            final feature = features[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => feature['screen']),
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.indigo.withOpacity(0.08),
                      blurRadius: 12,
                      spreadRadius: 2,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.indigo.shade50,
                      child: Icon(
                        feature['icon'],
                        size: 30,
                        color: Colors.indigo,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        feature['title'],
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
