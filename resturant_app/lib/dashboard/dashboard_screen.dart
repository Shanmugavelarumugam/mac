import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:resturant_app/customer_screen.dart';
import 'package:resturant_app/menu_screen.dart';
import 'package:resturant_app/order_screen.dart';
import 'package:resturant_app/profile_screen.dart';
import 'package:resturant_app/review_screen.dart';
import 'package:resturant_app/services/hive_service.dart'; // <-- import HiveService
import 'package:shimmer/shimmer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isLoading = true;

  int ordersToday = 0;
  double revenueToday = 0.0;
  int totalCustomers = 0;
  List<dynamic> topFoods = [];

  final String baseUrl = 'http://192.168.1.4:3001';

  @override
  void initState() {
    super.initState();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      setState(() => isLoading = true);

      final ordersRes = await Dio().get('$baseUrl/api/insights/1/orders-today');
      final revenueRes = await Dio().get(
        '$baseUrl/api/insights/4/revenue-today',
      );
      final customersRes = await Dio().get(
        '$baseUrl/api/insights/4/total-customers',
      );
      final topFoodsRes = await Dio().get(
        '$baseUrl/api/insights/1/top-selling-foods',
      );

      if (!mounted) return;

      setState(() {
        ordersToday = ordersRes.data['orders'] ?? 0;
        revenueToday = revenueRes.data['revenue']?.toDouble() ?? 0.0;
        totalCustomers = customersRes.data['customers'] ?? 0;
        topFoods = topFoodsRes.data ?? [];
      });
    } catch (e) {
      print("Dashboard fetch error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 8),
                Text("Error loading dashboard data"),
              ],
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Widget buildBarChart() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "📊 Today's Insights",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 220,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: ordersToday.toDouble(),
                          color: Colors.blue,
                          width: 20,
                        ),
                      ],
                      showingTooltipIndicators: [0],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          toY: revenueToday,
                          color: Colors.green,
                          width: 20,
                        ),
                      ],
                      showingTooltipIndicators: [0],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [
                        BarChartRodData(
                          toY: totalCustomers.toDouble(),
                          color: Colors.deepPurple,
                          width: 20,
                        ),
                      ],
                      showingTooltipIndicators: [0],
                    ),
                  ],
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) {
                          switch (value.toInt()) {
                            case 0:
                              return const Text(
                                "Orders",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              );
                            case 1:
                              return const Text(
                                "Revenue",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              );
                            case 2:
                              return const Text(
                                "Customers",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              );
                            default:
                              return const Text("");
                          }
                        },
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTopFoods() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.orange.withOpacity(0.2), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "🍽 Top Selling Foods",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.deepOrange,
            ),
          ),
          const Divider(),
          ...topFoods.map((food) {
            return ListTile(
              leading: const Icon(
                Icons.fastfood,
                color: Colors.deepOrangeAccent,
              ),
              title: Text(food['name'] ?? 'N/A'),
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.deepOrangeAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Sold: ${food['sold'] ?? 0}",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget buildDrawerHeader() {
    return DrawerHeader(
      decoration: const BoxDecoration(color: Colors.deepOrange),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.restaurant_menu,
              size: 32,
              color: Colors.deepOrange,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            HiveService.name,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          Text(
            HiveService.email,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "📊 Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepOrange,
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
      ),
      drawer: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: Radius.circular(30)),
        ),
        child: ListView(
          children: [
            buildDrawerHeader(),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text("Dashboard"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.restaurant),
              title: const Text("Menu Management"),
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MenuScreen()),
                  ),
            ),
            ListTile(
              leading: const Icon(Icons.restaurant),
              title: const Text("Order"),
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => OrdersScreen()),
                  ),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text("Customers"),
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CustomerScreen()),
                  ),
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text("Reviews"),
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ReviewScreen()),
                  ),
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text("Profile"),
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ProfileScreen()),
                  ),
            ),
          ],
        ),
      ),
      body:
          isLoading
              ? Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    buildShimmerCard(height: 220),
                    const SizedBox(height: 20),
                    buildShimmerCard(height: 250),
                  ],
                ),
              )
              : RefreshIndicator(
                onRefresh: fetchDashboardData,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      buildBarChart(),
                      const SizedBox(height: 20),
                      buildTopFoods(),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget buildShimmerCard({required double height}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
