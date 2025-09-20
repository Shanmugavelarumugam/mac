import 'package:flutter/material.dart';
import 'package:mail/config/theme.dart';
import 'package:mail/presentation/widgets/drawer_widget.dart';


class LabelCategoriesScreen extends StatelessWidget {
  const LabelCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(title: const Text("Labels")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildLabelCard(
              context,
              "Work",
              Icons.work_rounded,
              AppColors.primary,
            ),
            _buildLabelCard(
              context,
              "Personal",
              Icons.person_rounded,
              Colors.green,
            ),
            _buildLabelCard(
              context,
              "Travel",
              Icons.flight_rounded,
              Colors.orange,
            ),
            _buildLabelCard(
              context,
              "Finance",
              Icons.attach_money_rounded,
              Colors.teal,
            ),
            _buildLabelCard(
              context,
              "Shopping",
              Icons.shopping_cart_rounded,
              Colors.purple,
            ),
            _buildLabelCard(
              context,
              "Social",
              Icons.people_rounded,
              Colors.pink,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabelCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 0,
      color: color.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w600, color: color),
              ),
              const SizedBox(height: 8),
              Text(
                "12 emails",
                style: TextStyle(color: AppColors.secondary, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
