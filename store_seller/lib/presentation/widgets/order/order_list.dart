import 'package:btc_store/data/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class OrderListScreen extends StatefulWidget {
  final List<Order> orders;

  const OrderListScreen({super.key, required this.orders});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Order> _filterOrders(String status) {
    List<Order> filtered = status == "All"
        ? widget.orders
        : widget.orders.where((o) => o.status == status).toList();

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((o) {
        final idMatch = o.id.toLowerCase().contains(_searchQuery.toLowerCase());
        final nameMatch = o.customerName.toLowerCase().contains(
          _searchQuery.toLowerCase(),
        );
        return idMatch || nameMatch;
      }).toList();
    }
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Order Management",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: isSmallScreen ? 18 : 20,
            color: const Color(0xFF1E293B),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Align(
            alignment: Alignment.centerLeft,
            child: TabBar(
              controller: _tabController,
              labelStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: isSmallScreen ? 12 : 13,
              ),
              unselectedLabelStyle: GoogleFonts.poppins(
                fontSize: isSmallScreen ? 12 : 13,
              ),
              labelColor: const Color(0xFF6A5AE0),
              unselectedLabelColor: const Color(0xFF64748B),
              indicatorColor: const Color(0xFF6A5AE0),
              isScrollable: true,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 3,
              indicatorPadding: const EdgeInsets.symmetric(horizontal: 10),
              tabs: const [
                Tab(text: "All Orders"),
                Tab(text: "Pending"),
                Tab(text: "Shipped"),
                Tab(text: "Delivered"),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            color: Colors.white,
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                onChanged: (val) {
                  setState(() => _searchQuery = val);
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Iconsax.search_normal, size: 20),
                  hintText: "Search by ID or customer name",
                  hintStyle: GoogleFonts.poppins(
                    fontSize: isSmallScreen ? 13 : 14,
                    color: const Color(0xFF94A3B8),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),

          // Tab content
          Expanded(
            child: Container(
              color: const Color(0xFFF8FAFC),
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOrderList(_filterOrders("All")),
                  _buildOrderList(_filterOrders("Pending")),
                  _buildOrderList(_filterOrders("Shipped")),
                  _buildOrderList(_filterOrders("Delivered")),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList(List<Order> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.box_remove, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              "No orders found",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Try adjusting your search or filter",
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final order = orders[index];
        Color statusColor;
        IconData statusIcon;
        String statusText = order.status;

        switch (order.status) {
          case 'Pending':
            statusColor = const Color(0xFFFFA726);
            statusIcon = Iconsax.clock;
            break;
          case 'Shipped':
            statusColor = const Color(0xFF6A5AE0);
            statusIcon = Iconsax.truck_fast;
            break;
          case 'Delivered':
            statusColor = const Color(0xFF00B894);
            statusIcon = Iconsax.tick_circle;
            break;
          default:
            statusColor = const Color(0xFF64748B);
            statusIcon = Iconsax.info_circle;
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(statusIcon, color: statusColor, size: 24),
            ),
            title: Text(
              order.id,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: const Color(0xFF1E293B),
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  order.customerName,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    statusText,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: statusColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "\$${order.amount.toStringAsFixed(2)}",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "2 items", // You might want to add this field to your Order model
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
