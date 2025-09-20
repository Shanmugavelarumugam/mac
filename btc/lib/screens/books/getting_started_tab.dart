import 'package:flutter/material.dart';
import 'add_edit_item_screen.dart';
import 'create_purchase_order_screen.dart';
import 'package:btc/screens/books/create_sales_order_screen.dart';

class GettingStartedTab extends StatelessWidget {
  final int userId;

  const GettingStartedTab({Key? key, required this.userId}) : super(key: key);

  void navigateToCreateItem(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddEditItemScreen(userId: userId)),
    );
  }

  void navigateToPurchaseOrder(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) =>
                CreatePurchaseOrderScreen(userId: userId), // pass userId here
      ),
    );
  }

 void navigateToSalesOrder(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CreateSalesOrderScreen(userId: userId)),
    );
  }


  Widget buildMenuCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 5,
      shadowColor: Colors.grey.withOpacity(0.2),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 28),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.blue.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade100.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Text(
              'Hello, User!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 30),

          Text(
            'Quick Actions',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 12),

          buildMenuCard(
            context: context,
            icon: Icons.add_box_outlined,
            title: 'Create an Item',
            iconColor: Colors.teal,
            onTap: () => navigateToCreateItem(context),
          ),

          buildMenuCard(
            context: context,
            icon: Icons.shopping_cart_outlined,
            title: 'Create a Purchase Order',
            iconColor: Colors.indigo,
            onTap: () => navigateToPurchaseOrder(context),
          ),

          buildMenuCard(
            context: context,
            icon: Icons.sell_outlined,
            title: 'Create a Sales Order',
            iconColor: Colors.deepOrange,
            onTap: () => navigateToSalesOrder(context),
          ),
        ],
      ),
    );
  }
}
