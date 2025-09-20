import 'package:btc/screens/Home/Bills%20&%20Payments/Insurance/bike_insurance_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/Insurance/car_insurance_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/Insurance/check_motor_policy_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/Insurance/cyber_insurance_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/Insurance/dengue_malaria_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/Insurance/health_insurance_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/Insurance/lic_premium_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/Insurance/pension_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/Insurance/personal_accident_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/Insurance/shop_insurance_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/Insurance/team_life_insurance_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/Insurance/ulip_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/Travel/travel_insurance_screen.dart';
import 'package:flutter/material.dart';

class InsuranceScreen extends StatelessWidget {
  InsuranceScreen({super.key});

  static const customColor = Color(0xFF009688); // Teal
  static const darkTextColor = Color(0xFF004D40); // Dark text
  static const customGreen = Color.fromARGB(255, 159, 190, 187);

  final Map<String, List<Map<String, dynamic>>> insuranceSections = const {
    'Insurance': [
      {
        'label': 'Bike',
        'screen': BikeInsuranceScreen(),
        'icon': Icons.motorcycle,
      },
      {
        'label': 'Car',
        'screen': CarInsuranceScreen(),
        'icon': Icons.directions_car,
      },
      {
        'label': 'Health',
        'screen': HealthInsuranceScreen(),
        'icon': Icons.health_and_safety,
      },
      {
        'label': 'Term Life',
        'screen': TeamLifeInsuranceScreen(),
        'icon': Icons.heart_broken,
      },
      {
        'label': 'Personal Accident',
        'screen': PersonalAccidentScreen(),
        'icon': Icons.personal_injury,
      },
      {
        'label': 'Travel',
        'screen': TravelInsuranceScreen(),
        'icon': Icons.flight,
      },
    ],
    'Investments & Savings': [
      {'label': 'ULIP', 'screen': ULIPScreen(), 'icon': Icons.trending_up},
      {'label': 'Pension', 'screen': PensionScreen(), 'icon': Icons.savings},
    ],
    'Explore Other Insurances': [
      {
        'label': 'Dengue & Malaria',
        'screen': DengueMalariaScreen(),
        'icon': Icons.bug_report,
      },
      {
        'label': 'Cyber Insurance',
        'screen': CyberInsuranceScreen(),
        'icon': Icons.security,
      },
      {'label': 'Shop', 'screen': ShopInsuranceScreen(), 'icon': Icons.store},
    ],
    'Services': [
      {
        'label': 'LIC / Premium Payment',
        'screen': LicPremiumScreen(),
        'icon': Icons.payment,
      },
      {
        'label': 'Motor Policy Expiry',
        'screen': CheckMotorPolicyScreen(),
        'icon': Icons.event_busy,
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
                        'Insurance',
                        style: TextStyle(
fontFamily: 'Poppins', // Set font to Poppins
                          letterSpacing: 0.1,                          fontSize: 20,
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
              ...insuranceSections.entries
                  .map(
                    (entry) =>
                        _buildInsuranceCard(context, entry.key, entry.value),
                  )
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInsuranceCard(
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
                  letterSpacing: 0.1,                  fontSize: 21,
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
fontFamily: 'Poppins', // Set font to Poppins
                                letterSpacing: 0.1,                                fontWeight: FontWeight.w600,
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
