import 'package:btc/screens/Home/Bills%20&%20Payments/Recharge%20&%20Bills/Housing%20&%20Society/apartment_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/Recharge%20&%20Bills/Housing%20&%20Society/clubs_associations_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/Recharge%20&%20Bills/Housing%20&%20Society/municipal_tax_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/Recharge%20&%20Bills/Housing%20&%20Society/rentals_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/Recharge%20&%20Bills/Other/devotion_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/Recharge%20&%20Bills/Other/donations_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/Recharge%20&%20Bills/Other/hospitals_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/Recharge%20&%20Bills/Other/nps_contribution_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/Recharge%20&%20Bills/Other/recurring_deposit_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/Recharge%20&%20Bills/Other/subscription_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/Recharge%20&%20Bills/Recharge/apple_store_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/Recharge%20&%20Bills/Recharge/cable_tv_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/Recharge%20&%20Bills/Recharge/dth_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/Recharge%20&%20Bills/Recharge/fastag_recharge_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/Recharge%20&%20Bills/Recharge/google_play_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/Recharge%20&%20Bills/Recharge/metro_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/Recharge%20&%20Bills/Recharge/mobile_recharge.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/Recharge%20&%20Bills/Recharge/ncmc_recharge_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/Recharge%20&%20Bills/Utilities/book_cylinder_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/Recharge%20&%20Bills/Utilities/broadband_landline_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/Recharge%20&%20Bills/Utilities/credit_card_bill_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/Recharge%20&%20Bills/Utilities/education_fee_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/Recharge%20&%20Bills/Utilities/electricity_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/Recharge%20&%20Bills/Utilities/fees_via_credit_card_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/Recharge%20&%20Bills/Utilities/loan_repayment_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/Recharge%20&%20Bills/Utilities/mobile_postpaid_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/Recharge%20&%20Bills/Utilities/piped_gas_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/Recharge%20&%20Bills/Utilities/prepaid_meter_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/Recharge%20&%20Bills/Utilities/rent_via_credit_card_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/Recharge%20&%20Bills/Utilities/water_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/insurance_screen.dart';
import 'package:flutter/material.dart';

class RechargeBillsScreen extends StatelessWidget {
  RechargeBillsScreen({super.key});

  static const customColor = Color(0xFF009688);
  static const darkTextColor = Color(0xFF004D40);
  static const customGreen = Color.fromARGB(255, 159, 190, 187);

  final Map<String, List<Map<String, dynamic>>> sections = {
    'Recharge': [
      {
        'label': 'Mobile Recharge',
        'screen': MobileRechargeScreen(),
        'icon': Icons.smartphone,
      },
      {
        'label': 'FASTag Recharge',
        'screen': FastagRechargeScreen(),
        'icon': Icons.directions_car,
      },
      {'label': 'DTH', 'screen': DthScreen(), 'icon': Icons.tv},
      {
        'label': 'Google Play',
        'screen': GooglePlayScreen(),
        'icon': Icons.play_arrow,
      },
      {'label': 'Metro', 'screen': MetroScreen(), 'icon': Icons.train},
      {
        'label': 'NCMC Recharge',
        'screen': NcmcRechargeScreen(),
        'icon': Icons.credit_card,
      },
      {'label': 'Cable TV', 'screen': CableTvScreen(), 'icon': Icons.cable},
      {
        'label': 'Apple Store',
        'screen': AppleStoreScreen(),
        'icon': Icons.apple,
      },
    ],
    'Utilities': [
      {
        'label': 'Electricity',
        'screen': ElectricityScreen(),
        'icon': Icons.flash_on,
      },
      {
        'label': 'Credit card Bill',
        'screen': CreditCardBillScreen(),
        'icon': Icons.credit_card,
      },
      {
        'label': 'Book Cylinder',
        'screen': BookCylinderScreen(),
        'icon': Icons.local_gas_station,
      },
      {
        'label': 'Education Fee',
        'screen': EducationFeeScreen(),
        'icon': Icons.school,
      },
      {
        'label': 'Loan Repayment',
        'screen': LoanRepaymentScreen(),
        'icon': Icons.request_quote,
      },
      {
        'label': 'Rent via Credit card',
        'screen': RentViaCreditCardScreen(),
        'icon': Icons.home_work,
      },
      {
        'label': 'Mobile Postpaid',
        'screen': MobilePostpaidScreen(),
        'icon': Icons.phone_android,
      },
      {
        'label': 'Broadband/Landline',
        'screen': BroadbandLandlineScreen(),
        'icon': Icons.wifi,
      },
      {
        'label': 'Fees via credit card',
        'screen': FeesViaCreditCardScreen(),
        'icon': Icons.receipt,
      },
      {
        'label': 'Prepaid meter',
        'screen': PrepaidMeterScreen(),
        'icon': Icons.electric_meter,
      },
      {
        'label': 'Piped gas',
        'screen': PipedGasScreen(),
        'icon': Icons.fireplace,
      },
      {'label': 'Water', 'screen': WaterScreen(), 'icon': Icons.water_drop},
    ],
    'Housing & Society': [
      {
        'label': 'Municipal Tax',
        'screen': MunicipalTaxScreen(),
        'icon': Icons.account_balance,
      },
      {'label': 'Rentals', 'screen': RentalsScreen(), 'icon': Icons.apartment},
      {
        'label': 'Clubs & Associations',
        'screen': ClubsAssociationsScreen(),
        'icon': Icons.groups,
      },
      {'label': 'Apartment', 'screen': ApartmentScreen(), 'icon': Icons.home},
    ],
    'Other': [
      {
        'label': 'Donations',
        'screen': DonationsScreen(),
        'icon': Icons.volunteer_activism,
      },
      {
        'label': 'Devotion',
        'screen': DevotionScreen(),
        'icon': Icons.temple_hindu,
      },
      {
        'label': 'Hospitals',
        'screen': HospitalsScreen(),
        'icon': Icons.local_hospital,
      },
      {
        'label': 'Subscription',
        'screen': SubscriptionScreen(),
        'icon': Icons.subscriptions,
      },
      {
        'label': 'LIC/Insurance',
        'screen': InsuranceScreen(),
        'icon': Icons.shield,
      },
      {
        'label': 'Recurring Deposit',
        'screen': RecurringDepositScreen(),
        'icon': Icons.savings,
      },
      {
        'label': 'NPS Contribution',
        'screen': NpsContributionScreen(),
        'icon': Icons.trending_up,
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
              /// Header
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
                        'Recharge & Bills',
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

              /// Cards for all sections
              ...sections.entries
                  .map((entry) => _buildCard(context, entry.key, entry.value))
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
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
