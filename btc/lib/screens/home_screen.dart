import 'dart:math';

import 'package:btc/screens/Home/QrScannerScreen.dart';
import 'package:btc/screens/Home/banner_carousel.dart';
import 'package:btc/screens/Home/bills.dart';
import 'package:btc/screens/Home/manage_payments_section.dart';
import 'package:btc/widgets/QrScannerScreen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> moneyTransferOptions = [
    {'icon': Icons.qr_code_scanner, 'label': 'Scan & Pay'},
    {'icon': Icons.phone_android, 'label': 'To Mobile'},
    {'icon': Icons.account_balance, 'label': 'To Bank \nA/c'},
    {'icon': Icons.person, 'label': 'To Self A/c'},
    {'icon': Icons.send, 'label': 'Pay UPI'},
    {'icon': Icons.card_giftcard, 'label': 'Refer & Earn'},
    {'icon': Icons.mobile_friendly, 'label': 'Mobile Recharge'},
    {'icon': Icons.account_balance_wallet, 'label': 'Balance Check'},
  ];

  List<Map<String, dynamic>> get filteredOptions {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return moneyTransferOptions;
    return moneyTransferOptions
        .where((option) => option['label'].toLowerCase().contains(query))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    const customGreen = Color(0xFF009688);
    const darkTextColor = Color(0xFF004D40);
    double responsiveFontSize(BuildContext context, {double min = 13}) {
      return max(MediaQuery.of(context).size.width * 0.035, min);
    }


    return Scaffold(
      backgroundColor: customGreen.withOpacity(0.08),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: AppBar(
          backgroundColor: customGreen.withOpacity(0.08),
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(12),
            child: CircleAvatar(
              backgroundColor: customGreen,
              child:  Text(
                'S',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: responsiveFontSize(context, min: 18),
                ),
              ),
            ),
          ),
          title: Container(
            height: 40,
            decoration: BoxDecoration(
              color: customGreen.withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Center(
              child: TextField(
                controller: _searchController,
                style: const TextStyle(fontSize: 14, color: darkTextColor),
                decoration: const InputDecoration(
                  hintText: "Search services...",
                  hintStyle: TextStyle(fontSize: 15),
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: customGreen),
                  contentPadding: EdgeInsets.only(bottom: 7),
                ),
              ),
            ),
          ),
          actions: [
           IconButton(
              icon: const Icon(Icons.qr_code_scanner, color: customGreen),
              onPressed: ()  {
             
              },
            ),

            IconButton(
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: customGreen,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              BannerCarousel(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: customGreen.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text(
                        'Money Transfer',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: responsiveFontSize(context, min: 18),
                          fontWeight: FontWeight.w700,
                          color: darkTextColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                     LayoutBuilder(
                        builder: (context, constraints) {
                          final double totalSpacing =
                              12 * 3; // 3 gaps between 4 items
                          final double itemWidth =
                              (constraints.maxWidth - totalSpacing) / 4;

                          double responsiveFontSize(BuildContext context) {
                            return max(
                              MediaQuery.of(context).size.width * 0.035,
                              13,
                            );
                          }

                          return Wrap(
                            spacing: 12,
                            runSpacing: 16,
                            children:
                                filteredOptions.map((item) {
                                  return SizedBox(
                                    width: itemWidth,
                                    child: InkWell(
                                      onTap: () {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "${item['label']} tapped",
                                            ),
                                          ),
                                        );
                                      },
                                      borderRadius: BorderRadius.circular(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: customGreen.withOpacity(
                                                0.1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Icon(
                                              item['icon'],
                                              size: 26,
                                              color: customGreen,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            item['label'],
                                            textAlign: TextAlign.center,
                                            maxLines: null,
                                            overflow: TextOverflow.visible,
                                            softWrap: true,
                                            style: TextStyle(
                                              fontSize: responsiveFontSize(
                                                context,
                                              ),
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w600,
                                              color: darkTextColor,
                                            ),
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
              BillsSection(),
              const SizedBox(height: 10),
              BannerCarousel(),
              const SizedBox(height: 10),
              ManagePaymentsSection(),
            ],
          ),
        ),
      ),
    );
  }
}
