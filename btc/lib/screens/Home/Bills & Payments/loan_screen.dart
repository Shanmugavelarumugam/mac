import 'package:btc/screens/Home/Bills%20&%20Payments/Recharge%20&%20Bills/Utilities/loan_repayment_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/loans/bike_loan.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/loans/car_loan.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/loans/gold_loan.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/loans/home_loan.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/loans/mutual_funds_loan.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/loans/personal_loan.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/loans/property_loan.dart';
import 'package:flutter/material.dart';

class LoanScreen extends StatelessWidget {
  LoanScreen({super.key});

  static const customColor = Color(0xFF009688); // Teal
  static const darkTextColor = Color(0xFF004D40); // Dark text
  static const customGreen = Color.fromARGB(255, 159, 190, 187);

  final Map<String, List<Map<String, dynamic>>> loanSections = const {
    'Loans': [
      {
        'label': 'Personal Loan',
        'screen': PersonalLoanScreen(),
        'icon': Icons.person,
      },
      {
        'label': 'Gold Loan',
        'screen': GoldLoanScreen(),
        'icon': Icons.currency_rupee,
      },
      {
        'label': 'Mutual Funds Loan',
        'screen': MutualFundsLoanScreen(),
        'icon': Icons.trending_up,
      },
      {
        'label': 'Loan Repayment',
        'screen': LoanRepaymentScreen(),
        'icon': Icons.request_quote,
      },
    ],
    'Other Loans': [
      {'label': 'Home Loan', 'screen': HomeLoanScreen(), 'icon': Icons.house},
      {
        'label': 'Property Loan',
        'screen': PropertyLoanScreen(),
        'icon': Icons.location_city,
      },
      {
        'label': 'Car Loan',
        'screen': CarLoanScreen(),
        'icon': Icons.directions_car,
      },
      {
        'label': 'Bike Loan',
        'screen': BikeLoanScreen(),
        'icon': Icons.motorcycle,
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customGreen,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Top Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          size: 20,
                          color: darkTextColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Loans',
                        style: TextStyle(
                          fontFamily: 'Poppins', // Set font to Poppins
                          letterSpacing: 0.1,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: darkTextColor,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.help_outline, color: darkTextColor),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Help tapped')),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              /// Cards
              ...loanSections.entries
                  .map(
                    (entry) => _buildLoanCard(context, entry.key, entry.value),
                  )
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoanCard(
    BuildContext context,
    String title,
    List<Map<String, dynamic>> items,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        shadowColor: Colors.grey.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Poppins', // Set font to Poppins
                  letterSpacing: 0.1,
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  color: darkTextColor,
                ),
              ),
              const SizedBox(height: 20),
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 8,
                childAspectRatio: 0.8,
                children:
                    items.map((item) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => item['screen']),
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: customColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                item['icon'],
                                color: customColor,
                                size: 26,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              item['label'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 13,
                                fontFamily: 'Poppins', 
                                letterSpacing: 0.1,
                                fontWeight: FontWeight.w600,
                                color: darkTextColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
