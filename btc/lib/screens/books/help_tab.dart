import 'package:flutter/material.dart';

class HelpTab extends StatelessWidget {
  const HelpTab({Key? key}) : super(key: key);

  Widget buildHelpCard({
    required String title,
    required String description,
    IconData icon = Icons.help_outline,
    Color color = Colors.indigo,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(0.2),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade800,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'We’re here to help!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),

            buildHelpCard(
              title: 'What is Inventory?',
              description:
                  'Inventory represents the stock of goods your business holds for sale or production. Managing it helps avoid stockouts or excess storage.',
              icon: Icons.warehouse_outlined,
              color: Colors.blueAccent,
            ),

            buildHelpCard(
              title: 'How to Add an Item?',
              description:
                  'Tap "Create an Item" in the Getting Started tab. Fill in details like Name, SKU, and Quantity to start tracking your stock.',
              icon: Icons.add_box_outlined,
              color: Colors.teal,
            ),

            buildHelpCard(
              title: 'How to Update Stock?',
              description:
                  'In the Dashboard, use the green (+) button for Stock In or red (-) button for Stock Out. Quantities update instantly.',
              icon: Icons.update_outlined,
              color: Colors.deepPurple,
            ),

            buildHelpCard(
              title: 'How to Edit or Delete?',
              description:
                  'Tap ✏️ to edit item details or 🗑️ to permanently remove items. Be careful—deleted items cannot be recovered.',
              icon: Icons.edit_note_outlined,
              color: Colors.orange,
            ),

            buildHelpCard(
              title: 'Contact Support',
              description:
                  '📧 help@yourcompany.com\n📞 +91 98765 43210\nWe’re here Monday to Friday, 9AM to 6PM.',
              icon: Icons.support_agent,
              color: Colors.redAccent,
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
