import 'package:btc/screens/Home/Bills%20&%20Payments/insurance_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/loan_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/recharge_bills_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/travel_screen.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class BillsSection extends StatelessWidget {
  BillsSection({super.key});

  final List<Map<String, dynamic>> billOptions = [
    {'icon': Icons.attach_money, 'label': 'Loan'},
    {'icon': Icons.receipt_long, 'label': 'Recharge & Bills'},
    {'icon': Icons.airplanemode_active, 'label': 'Travel'},
    {'icon': Icons.health_and_safety, 'label': 'Insurance'},
  ];

  static const customColor = Color(0xFF009688);
  static const darkTextColor = Color(0xFF004D40);

  double _responsiveFontSize(
    BuildContext context, {
    double scale = 0.035,
    double min = 13,
  }) {
    return max(MediaQuery.of(context).size.width * scale, min);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        shadowColor: Colors.grey.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              Text(
                'Bills & Payments',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  letterSpacing: 0.1,
                  fontSize: _responsiveFontSize(context, scale: 0.052, min: 20),
                  fontWeight: FontWeight.w700,
                  color: darkTextColor,
                ),
              ),

              const SizedBox(height: 20),

              /// Grid Section
              LayoutBuilder(
                builder: (context, constraints) {
                  final double totalSpacing = 12 * 3; // 3 gaps between 4 items
                  final double itemWidth =
                      (constraints.maxWidth - totalSpacing) / 4;

                  return Wrap(
                    spacing: 12,
                    runSpacing: 16,
                    children:
                        billOptions.map((item) {
                          return SizedBox(
                            width: itemWidth,
                            child: InkWell(
                              onTap: () {
                                Widget screen;
                                switch (item['label']) {
                                  case 'Loan':
                                    screen = LoanScreen();
                                    break;
                                  case 'Recharge & Bills':
                                    screen = RechargeBillsScreen();
                                    break;
                                  case 'Travel':
                                    screen = TravelScreen();
                                    break;
                                  case 'Insurance':
                                    screen = InsuranceScreen();
                                    break;
                                  default:
                                    return;
                                }

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => screen),
                                );
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: customColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      item['icon'],
                                      size: 26,
                                      color: customColor,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    item['label'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: _responsiveFontSize(context),
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      color: darkTextColor,
                                    ),
                                    maxLines: null,
                                    overflow: TextOverflow.visible,
                                    softWrap: true,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
