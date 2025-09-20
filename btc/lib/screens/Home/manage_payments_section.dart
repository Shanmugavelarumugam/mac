import 'package:btc/screens/Home/ManagePaymentsSection/qr_upi.dart';
import 'package:btc/screens/Home/ManagePaymentsSection/rupay_on_upi_screen.dart';
import 'package:btc/screens/Home/ManagePaymentsSection/upi_circle_screen.dart';
import 'package:btc/screens/Home/ManagePaymentsSection/upi_lite_screen.dart';
import 'package:btc/screens/Home/ManagePaymentsSection/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'dart:math';

// ... your imports remain unchanged

class ManagePaymentsSection extends StatelessWidget {
  ManagePaymentsSection({super.key});

  final List<Map<String, dynamic>> manageOptions = [
    {
      'icon': Icons.account_balance_wallet,
      'label': 'Wallet',
      'screen': WalletScreen(),
    },
    {'icon': Icons.flash_on, 'label': 'UPI Lite', 'screen': UPILiteScreen()},
    {'icon': Icons.group, 'label': 'UPI Circle', 'screen': UPICircleScreen()},
    {
      'icon': Icons.credit_card,
      'label': 'RuPay on UPI',
      'screen': RupayOnUPIScreen(),
    },
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
              /// Title row with View All
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text(
                    'Manage Payments',
                    style: TextStyle(
                      fontFamily: 'Poppins', // Set font to Poppins
                      letterSpacing: 0.1,
                      fontSize: _responsiveFontSize(
                        context,
                        scale: 0.052,
                        min: 20,
                      ),
                      fontWeight: FontWeight.w700,
                      color: darkTextColor,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('View All tapped')),
                      );
                    },
                    child:  Text(
                      'View All',
                      style: TextStyle(
                        fontFamily: 'Poppins', // Set font to Poppins
                        letterSpacing: 0.1,
                        fontSize: _responsiveFontSize(
                          context,
                          scale: 0.036,
                          min: 14,
                        ),
                        fontWeight: FontWeight.w600,
                        color: customColor,
                      ),
                    ),
                  ),
                ],
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
                        manageOptions.map((item) {
                          return SizedBox(
                            width: itemWidth,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => item['screen'],
                                  ),
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
                                      color: customColor,
                                      size: 26,
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

              /// UPI Info Line

              /// Divider line
              Divider(color: Colors.grey.shade300, thickness: 1),

              const SizedBox(height: 12),

              /// UPI Info Line (PhonePe style)
              // Row(
              //   children: [
              //     Container(
              //       child: const Icon(
              //         Icons.qr_code,
              //         color: customColor,
              //         size: 20,
              //       ),
              //     ),
              //     const SizedBox(width: 10),
              //     const Text(
              //       'My QR',
              //       style: TextStyle(
              //         fontSize: 14,
              //         fontFamily: 'Poppins',
              //         fontWeight: FontWeight.w500,
              //         color: darkTextColor,
              //       ),
              //     ),

              //     // Vertical divider
              //     Container(
              //       margin: const EdgeInsets.symmetric(horizontal: 12),
              //       height: 16,
              //       width: 1,
              //       color: Colors.grey.shade400,
              //     ),

              //     // UPI ID text
              //     const Expanded(
              //       child: Text(
              //         'UPI ID: 9876543210@abc',
              //         style: TextStyle(
              //           fontSize: 14,
              //           fontFamily: 'Poppins',
              //           fontWeight: FontWeight.w500,
              //           color: darkTextColor,
              //         ),
              //         overflow: TextOverflow.ellipsis,
              //       ),
              //     ),

              //     // Arrow icon
              //     const Icon(
              //       Icons.chevron_right,
              //       size: 20,
              //       color: darkTextColor,
              //     ),
              //   ],
              // ),
              //
              Row(
                children: [
                  // My QR
                  Container(
                    child: const Icon(
                      Icons.qr_code,
                      color: customColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                   Text(
                    'My QR',
                    style: TextStyle(
                      fontSize: _responsiveFontSize(
                        context,
                        scale: 0.036,
                        min: 14,
                      ),
                      fontFamily: 'Poppins', // Set font to Poppins
                      letterSpacing: 0.1,
                      fontWeight: FontWeight.w500,
                      color: darkTextColor,
                    ),
                  ),

                  // Vertical divider
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    height: 16,
                    width: 1,
                    color: Colors.grey,
                  ),

                  // UPI ID
                   Expanded(
                    child: Text(
                      'UPI ID: 9876543210@abc',
                      style: TextStyle(
                        fontSize: _responsiveFontSize(
                          context,
                          scale: 0.036,
                          min: 14,
                        ),
                        fontFamily: 'Poppins', // Set font to Poppins
                        letterSpacing: 0.1,
                        fontWeight: FontWeight.w500,
                        color: darkTextColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Navigable Chevron icon
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const QRAndUPIScreen(),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.chevron_right,
                        size: 20,
                        color: darkTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
