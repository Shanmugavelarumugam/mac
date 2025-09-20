import 'package:btc/screens/Home/Bills%20&%20Payments/Recharge%20&%20Bills/Recharge/fastag_recharge_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/Recharge%20&%20Bills/Recharge/metro_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/Travel/airport_cabs_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/Travel/bus_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/Travel/flights_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/Travel/train_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/Travel/travel_activities_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/Travel/travel_insurance_screen.dart';
import 'package:btc/screens/Home/Bills%20&%20Payments/Travel/visa_services_screen.dart';
import 'package:flutter/material.dart';

class TravelScreen extends StatelessWidget {
  TravelScreen({super.key});

  static const customColor = Color(0xFF009688); // Teal
  static const darkTextColor = Color(0xFF004D40); // Dark text
  static const customGreen = Color.fromARGB(255, 159, 190, 187);

  final Map<String, List<Map<String, dynamic>>> travelSections = {
    'Travel & Transit': [
      {
        'label': 'Flights',
        'screen': FlightsScreen(),
        'icon': Icons.flight_takeoff,
      },
      {'label': 'Bus', 'screen': BusScreen(), 'icon': Icons.directions_bus},
      {'label': 'Train', 'screen': TrainScreen(), 'icon': Icons.train},
      {'label': 'Metro', 'screen': MetroScreen(), 'icon': Icons.subway},
    ],
    'More Services': [
      {
        'label': 'FASTag Recharge',
        'screen': FastagRechargeScreen(),
        'icon': Icons.car_crash,
      },
      {
        'label': 'Visa Services',
        'screen': VisaServicesScreen(),
        'icon': Icons.assignment,
      },
      {
        'label': 'Airport Cabs',
        'screen': AirportCabsScreen(),
        'icon': Icons.local_taxi,
      },
      {
        'label': 'Travel Insurance',
        'screen': TravelInsuranceScreen(),
        'icon': Icons.shield,
      },
      {
        'label': 'Travel Activities',
        'screen': TravelActivitiesScreen(),
        'icon': Icons.explore,
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
                        'Travel',
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
              ...travelSections.entries
                  .map(
                    (entry) =>
                        _buildTravelCard(context, entry.key, entry.value),
                  )
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTravelCard(
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
                                fontFamily: 'Poppins', // Set font to Poppins
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
