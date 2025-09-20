import 'dart:math';
import 'package:btc_store/bloc/dashboard/dashboard_bloc.dart';
import 'package:btc_store/bloc/dashboard/dashboard_state.dart';
import 'package:btc_store/bloc/product/product_bloc.dart';
import 'package:btc_store/bloc/profile/profile_bloc.dart';
import 'package:btc_store/bloc/profile/profile_event.dart';
import 'package:btc_store/bloc/profile/profile_state.dart';
import 'package:btc_store/data/models/dashboard_model.dart';
import 'package:btc_store/data/models/seller_dashboard_model.dart';
import 'package:btc_store/data/repositories/product_repository.dart';
import 'package:btc_store/data/repositories/profile_repository.dart';
import 'package:btc_store/presentation/screens/earnings/earnings.dart';
import 'package:btc_store/presentation/screens/home/complainant/ComplainantScreen.dart';
import 'package:btc_store/presentation/screens/order/orders.dart';
import 'package:btc_store/presentation/screens/products/add_product.dart';
import 'package:btc_store/presentation/screens/products/create_brand.dart';
import 'package:btc_store/presentation/screens/products/products.dart';
import 'package:btc_store/presentation/screens/products/products_screen.dart';
import 'package:btc_store/presentation/screens/profile/profile.dart';
import 'package:btc_store/presentation/widgets/best_selling_product.dart';

import 'package:btc_store/presentation/widgets/bottom_nav_bar.dart';
import 'package:btc_store/presentation/widgets/low_stock/low_stock_item.dart';
import 'package:btc_store/presentation/widgets/low_stock/low_stock_list.dart';
import 'package:btc_store/presentation/widgets/revenue_card.dart';
import 'package:btc_store/presentation/widgets/sales_chart.dart';
import 'package:btc_store/presentation/widgets/stat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SellerDashboard extends StatefulWidget {
  const SellerDashboard({super.key});

  @override
  State<SellerDashboard> createState() => _SellerDashboardState();
}

class _SellerDashboardState extends State<SellerDashboard> {
  int _selectedIndex = 0;
  String? _token;
  bool _isLoading = true;
  List<Widget> _pages = [];
  String _sellerName = "Store Manager";

  @override
  void initState() {
    super.initState();
    _loadTokenAndPages();
  }

  Future<void> _loadTokenAndPages() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final sellerName = prefs.getString('seller_name');
    final sellerId = prefs.getInt('user_id') ?? 0; // Get actual seller ID

    setState(() {
      _token = token;
      _sellerName = sellerName ?? "Store Manager";

      _pages = [
        _buildDashboard(),
        if (token != null && sellerId > 0)
          ProductsScreen(token: token, sellerId: sellerId)
        else
          const Center(child: Text('Unable to load products')),
        const OrdersScreen(),
        const EarningsScreen(),
        if (token != null)
          BlocProvider(
            create: (_) =>
                SellerBloc(repository: SellerRepository(token: token))
                  ..add(FetchSellerProfile()),
            child: const ProfileScreen(),
          )
        else
          const ProfileScreen(),
      ];

      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = min(screenWidth / 390, 1.2);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _selectedIndex == 0
          ? AppBar(
              title: Text(
                _getTitle(),
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 20 * scaleFactor,
                  color: const Color(0xFF1E293B),
                ),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              shadowColor: Colors.black.withOpacity(0.05),
              centerTitle: true,
              actions: _selectedIndex == 0
                  ? [
                      Container(
                        margin: EdgeInsets.only(right: 16 * scaleFactor),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Iconsax.notification,
                            size: 22 * scaleFactor,
                            color: const Color(0xFF6A5AE0),
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ]
                  : null,
            )
          : null,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        scaleFactor: scaleFactor,
      ),
    );
  }

  String _getTitle() {
    switch (_selectedIndex) {
      case 0:
        return "Seller Dashboard";
      case 4:
        return "Profile"; // add title
      default:
        return "";
    }
  }

  Widget _buildDashboard() {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = min(screenWidth / 390, 1.2);

    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DashboardLoaded) {
          final dashboard = state.dashboard;
          return SingleChildScrollView(
            padding: EdgeInsets.all(16 * scaleFactor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeHeader(scaleFactor),
                SizedBox(height: 12 * scaleFactor),
                _buildDashboardButtons(scaleFactor), // <- Buttons added
                SizedBox(height: 20 * scaleFactor),
                _buildStatsGrid(scaleFactor, screenWidth, dashboard),
                SizedBox(height: 24 * scaleFactor),
                _buildSectionHeader("Sales Overview", scaleFactor),
                SizedBox(height: 12 * scaleFactor),
                SalesChart(dashboard: dashboard, scaleFactor: scaleFactor),
                SizedBox(height: 24 * scaleFactor),
                _buildMobileLayout(scaleFactor, dashboard),
                SizedBox(height: 24 * scaleFactor),
              ],
            ),
          );
        } else if (state is DashboardError) {
          return Center(child: Text("Error: ${state.error}"));
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildWelcomeHeader(double scaleFactor) {
    return Container(
      padding: EdgeInsets.all(16 * scaleFactor),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF6A5AE0).withOpacity(0.1),
            const Color(0xFF00B894).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16 * scaleFactor),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24 * scaleFactor,
            backgroundColor: const Color(0xFF6A5AE0).withOpacity(0.2),
            child: Icon(
              Iconsax.profile_circle,
              color: const Color(0xFF6A5AE0),
              size: 28 * scaleFactor,
            ),
          ),
          SizedBox(width: 12 * scaleFactor),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome back!",
                  style: GoogleFonts.poppins(
                    fontSize: 14 * scaleFactor,
                    color: const Color(0xFF64748B),
                  ),
                ),
                SizedBox(height: 4 * scaleFactor),
                Text(
                  _sellerName,
                  style: GoogleFonts.poppins(
                    fontSize: 18 * scaleFactor,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- New Buttons Row ---
  Widget _buildDashboardButtons(double scaleFactor) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A5AE0),
                  padding: EdgeInsets.symmetric(vertical: 14 * scaleFactor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Iconsax.tag, color: Colors.white),
                label: Text(
                  "Create Brand",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CreateBrandScreen(),
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: 12 * scaleFactor),
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00B894),
                  padding: EdgeInsets.symmetric(vertical: 14 * scaleFactor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Iconsax.add_square, color: Colors.white),
                label: Text(
                  "Add Product",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  final token = prefs.getString('auth_token');

                  if (token == null || token.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "User token not found, please login again.",
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  final repository = ProductRepository(token: token);
                  final productBloc = ProductBloc(repository);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider.value(
                        value: productBloc,
                        child: AddProductScreen(productBloc: productBloc),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 12 * scaleFactor),
        // ✅ Complainant button below Add Product
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B6B),
              padding: EdgeInsets.symmetric(vertical: 14 * scaleFactor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(
              Icons.warning,
              color: Colors.white,
            ), // ✅ Use a valid icon
            label: Text(
              "Complainant",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ComplainantScreen()),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(
    double scaleFactor,
    double screenWidth,
    SellerDashboardModel dashboard,
  ) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12 * scaleFactor,
      mainAxisSpacing: 12 * scaleFactor,
      childAspectRatio: screenWidth > 400 ? 1.6 : 1.5,
      children: [
        StatCard(
          title: "Total Orders",
          value: dashboard.totalSales.toString(),
          icon: Iconsax.shopping_bag,
          color: const Color(0xFF6A5AE0),
          scaleFactor: scaleFactor,
        ),
        StatCard(
          title: "Today Orders",
          value: dashboard.todayTotalOrder.toString(),
          icon: Iconsax.calendar,
          color: const Color(0xFF0984E3),
          scaleFactor: scaleFactor,
        ),
        StatCard(
          title: "Total Customers",
          value: dashboard.countOfCustomer.toString(),
          icon: Iconsax.user,
          color: const Color(0xFF6C5CE7),
          scaleFactor: scaleFactor,
        ),

        // ✅ Active Products clickable
        GestureDetector(
          onTap: () async {
            final prefs = await SharedPreferences.getInstance();
            final token = prefs.getString('auth_token');
            final sellerId = prefs.getInt('user_id'); // ✅ fixed key

            if (token == null || token.isEmpty || sellerId == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("User not logged in correctly."),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }

            final repository = ProductRepository(token: token);

            try {
              final products = await repository.getProductsBySeller(sellerId);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductScreen(
                    products: products,
                    sellerId: sellerId, // 👈 added sellerId
                  ),
                ),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Failed to fetch products: $e"),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: StatCard(
            title: "Active Products",
            value: dashboard.totalProducts.toString(),
            icon: Iconsax.box,
            color: const Color(0xFF00B894),
            scaleFactor: scaleFactor,
          ),
        ),

        RevenueCard(scaleFactor: scaleFactor, revenue: dashboard.totalRevenue),
        StatCard(
          title: "Pending Orders",
          value: dashboard.orderStatusCount
              .firstWhere(
                (e) => e.status.toLowerCase() == "pending",
                orElse: () => OrderStatusCount(status: "Pending", count: 0),
              )
              .count
              .toString(),
          icon: Iconsax.clock,
          color: const Color(0xFFFFA726),
          scaleFactor: scaleFactor,
        ),
      ],
    );
  }

  Widget _buildMobileLayout(
    double scaleFactor,
    SellerDashboardModel dashboard,
  ) {
    return Column(
      children: [
        _buildSectionHeader(
          "Low Stock Alert",
          scaleFactor,
          onViewAll: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    LowStockScreen(products: dashboard.lowStockProducts),
              ),
            );
          },
        ),
        SizedBox(height: 12 * scaleFactor),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16 * scaleFactor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: EdgeInsets.all(8 * scaleFactor),
          child: LowStockList(
            products: dashboard.lowStockProducts,
            scaleFactor: scaleFactor,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(
    String title,
    double scaleFactor, {
    VoidCallback? onViewAll,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18 * scaleFactor,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1E293B),
          ),
        ),
        if (onViewAll != null)
          GestureDetector(
            onTap: onViewAll,
            child: Text(
              "View All",
              style: GoogleFonts.poppins(
                fontSize: 14 * scaleFactor,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF6A5AE0),
              ),
            ),
          ),
      ],
    );
  }
}
