import 'package:flutter/material.dart';
import 'mutual_fund_portfolio_screen.dart';
import 'mutual_funds_screen.dart';
import 'trading_screen.dart';
import 'organise_future_screen.dart';
import 'news_screen.dart';
import 'ads_screen.dart';

class PublicScreen extends StatelessWidget {
  final List<Map<String, dynamic>> features = [
    {
      'title': 'Track Mutual Fund Portfolio',
      'icon': Icons.pie_chart,
      'screen': MutualFundPortfolioScreen(),
    },
    {
      'title': 'Mutual Funds',
      'icon': Icons.show_chart,
      'screen': MutualFundsScreen(),
    },
    {'title': 'Trading', 'icon': Icons.swap_horiz, 'screen': TradingScreen()},
    {
      'title': 'Organise Future',
      'icon': Icons.timeline,
      'screen': OrganiseFutureScreen(),
    },
    {'title': 'News', 'icon': Icons.newspaper, 'screen': NewsScreen()},
    {'title': 'Ads', 'icon': Icons.campaign, 'screen': AdsScreen()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Public"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 2,
        foregroundColor: Colors.black87,
        shadowColor: Colors.grey.withOpacity(0.1),
      ),
      backgroundColor: const Color(0xFFF4F6FA),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: features.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 4 / 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            final feature = features[index];
            return GestureDetector(
              onTap: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => feature['screen']));
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Theme.of(
                        context,
                      ).primaryColor.withOpacity(0.1),
                      child: Icon(
                        feature['icon'],
                        size: 30,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        feature['title'],
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
