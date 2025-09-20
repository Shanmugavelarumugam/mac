import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

// Order model
class Order {
  final String id;
  final String customerName;
  final DateTime date;
  final double amount;
  final String status;
  final String paymentMethod;
  final String paymentStatus;
  final String address;
  final String phone;
  final String email;
  final List<OrderItem> items;
  String? trackingId;
  String? courier;

  Order({
    required this.id,
    required this.customerName,
    required this.date,
    required this.amount,
    required this.status,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.address,
    required this.phone,
    required this.email,
    required this.items,
    this.trackingId,
    this.courier,
  });
}

// Order item model
class OrderItem {
  final String productName;
  final int quantity;
  final double price;
  final String imageUrl;

  OrderItem({
    required this.productName,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });

  double get subtotal => quantity * price;
}

// Main Orders Screen
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Order> _allOrders = [];
  final List<Order> _filteredOrders = [];
  final TextEditingController _searchController = TextEditingController();
  String _currentFilter = "All";
  String _paymentFilter = "All";
  DateTimeRange? _dateRange;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _loadOrders();
  }

  void _loadOrders() {
    // Sample data with one product per order and images
    setState(() {
      _allOrders.addAll([
        Order(
          id: '#12345',
          customerName: 'John Doe',
          date: DateTime.now().subtract(const Duration(hours: 2)),
          amount: 99.99,
          status: 'Pending',
          paymentMethod: 'Credit Card',
          paymentStatus: 'Paid',
          address: '123 Main St, New York, NY 10001',
          phone: '+1 (555) 123-4567',
          email: 'john.doe@example.com',
          items: [
            OrderItem(
              productName: 'Wireless Headphones',
              quantity: 1,
              price: 99.99,
              imageUrl:
                  'https://via.placeholder.com/150/0000FF/FFFFFF?text=Headphones',
            ),
          ],
        ),
        Order(
          id: '#12346',
          customerName: 'Jane Smith',
          date: DateTime.now().subtract(const Duration(days: 1)),
          amount: 89.99,
          status: 'Packed',
          paymentMethod: 'PayPal',
          paymentStatus: 'Paid',
          address: '456 Oak Ave, Los Angeles, CA 90001',
          phone: '+1 (555) 987-6543',
          email: 'jane.smith@example.com',
          items: [
            OrderItem(
              productName: 'Smart Watch',
              quantity: 1,
              price: 89.99,
              imageUrl:
                  'https://via.placeholder.com/150/FF0000/FFFFFF?text=Watch',
            ),
          ],
        ),
        Order(
          id: '#12347',
          customerName: 'Robert Johnson',
          date: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
          amount: 79.99,
          status: 'Shipped',
          paymentMethod: 'Credit Card',
          paymentStatus: 'Paid',
          address: '789 Pine Rd, Chicago, IL 60007',
          phone: '+1 (555) 456-7890',
          email: 'robert.j@example.com',
          items: [
            OrderItem(
              productName: 'Bluetooth Speaker',
              quantity: 1,
              price: 79.99,
              imageUrl:
                  'https://via.placeholder.com/150/00FF00/FFFFFF?text=Speaker',
            ),
          ],
        ),
        Order(
          id: '#12348',
          customerName: 'Emily Davis',
          date: DateTime.now().subtract(const Duration(days: 2)),
          amount: 19.99,
          status: 'Delivered',
          paymentMethod: 'COD',
          paymentStatus: 'Pending',
          address: '321 Elm St, Houston, TX 77001',
          phone: '+1 (555) 234-5678',
          email: 'emily.d@example.com',
          items: [
            OrderItem(
              productName: 'USB-C Cable',
              quantity: 1,
              price: 19.99,
              imageUrl:
                  'https://via.placeholder.com/150/FFFF00/000000?text=Cable',
            ),
          ],
        ),
        Order(
          id: '#12349',
          customerName: 'Michael Wilson',
          date: DateTime.now().subtract(const Duration(days: 3)),
          amount: 99.99,
          status: 'Returned',
          paymentMethod: 'Credit Card',
          paymentStatus: 'Refunded',
          address: '654 Maple Dr, Phoenix, AZ 85001',
          phone: '+1 (555) 876-5432',
          email: 'michael.w@example.com',
          items: [
            OrderItem(
              productName: 'Wireless Charger',
              quantity: 1,
              price: 99.99,
              imageUrl:
                  'https://via.placeholder.com/150/FF00FF/FFFFFF?text=Charger',
            ),
          ],
        ),
      ]);
      _filteredOrders.addAll(_allOrders);
    });
  }

  void _filterOrders(String status) {
    setState(() {
      _currentFilter = status;
    });
    _searchOrders(_searchController.text);
  }

  void _searchOrders(String query) {
    setState(() {
      _filteredOrders.clear();
      Iterable<Order> temp = _allOrders;
      if (_currentFilter != "All") {
        temp = temp.where((order) => order.status == _currentFilter);
      }
      if (_paymentFilter != "All") {
        temp = temp.where((order) => order.paymentMethod == _paymentFilter);
      }
      if (_dateRange != null) {
        temp = temp.where(
          (order) =>
              order.date.isAfter(_dateRange!.start) &&
              order.date.isBefore(_dateRange!.end.add(const Duration(days: 1))),
        );
      }
      if (query.isNotEmpty) {
        temp = temp.where(
          (order) =>
              order.id.toLowerCase().contains(query.toLowerCase()) ||
              order.customerName.toLowerCase().contains(query.toLowerCase()),
        );
      }
      _filteredOrders.addAll(temp.toList());
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Packed':
        return Colors.blue;
      case 'Shipped':
        return Colors.purple;
      case 'Delivered':
        return Colors.green;
      case 'Returned':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = screenWidth / 390;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Orders Management",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: max(20 * scaleFactor, 18),
            color: const Color(0xFF1E293B),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: const Color(0xFF6A5AE0),
          labelColor: const Color(0xFF6A5AE0),
          unselectedLabelColor: const Color(0xFF64748B),
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
          tabs: const [
            Tab(text: "Pending"),
            Tab(text: "Packed"),
            Tab(text: "Shipped"),
            Tab(text: "Delivered"),
            Tab(text: "Returned"),
          ],
          onTap: (index) {
            final statuses = [
              'Pending',
              'Packed',
              'Shipped',
              'Delivered',
              'Returned',
            ];
            _filterOrders(statuses[index]);
          },
        ),
      ),
      body: Column(
        children: [
          // Search and Filter Row
          Padding(
            padding: EdgeInsets.all(16 * scaleFactor),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48 * scaleFactor,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12 * scaleFactor),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _searchOrders,
                      decoration: InputDecoration(
                        hintText: "Search by Order ID or Customer",
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 14 * scaleFactor,
                        ),
                        prefixIcon: Icon(
                          Iconsax.search_normal,
                          size: 20 * scaleFactor,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 14 * scaleFactor,
                          horizontal: 16 * scaleFactor,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12 * scaleFactor),
                Container(
                  height: 48 * scaleFactor,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6A5AE0),
                    borderRadius: BorderRadius.circular(12 * scaleFactor),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Iconsax.filter,
                      color: Colors.white,
                      size: 22 * scaleFactor,
                    ),
                    onPressed: () {
                      _showFilterDialog(context, scaleFactor);
                    },
                  ),
                ),
              ],
            ),
          ),

          // Orders List
          Expanded(
            child: _filteredOrders.isEmpty
                ? Center(
                    child: Text(
                      'No orders found',
                      style: GoogleFonts.poppins(
                        fontSize: 16 * scaleFactor,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = _filteredOrders[index];
                      return _buildOrderCard(order, scaleFactor, context);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(
    Order order,
    double scaleFactor,
    BuildContext context,
  ) {
    return Card(
      margin: EdgeInsets.fromLTRB(
        16 * scaleFactor,
        8 * scaleFactor,
        16 * scaleFactor,
        8 * scaleFactor,
      ),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16 * scaleFactor),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16 * scaleFactor),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8 * scaleFactor),
          child: Image.network(
            order.items.first.imageUrl,
            width: 50 * scaleFactor,
            height: 50 * scaleFactor,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 50 * scaleFactor,
              height: 50 * scaleFactor,
              color: Colors.grey[300],
              child: const Icon(Icons.image_not_supported, color: Colors.grey),
            ),
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailsScreen(order: order),
            ),
          );
        },
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              order.id,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16 * scaleFactor,
                color: const Color(0xFF1E293B),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 12 * scaleFactor,
                vertical: 6 * scaleFactor,
              ),
              decoration: BoxDecoration(
                color: _getStatusColor(order.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20 * scaleFactor),
              ),
              child: Text(
                order.status,
                style: GoogleFonts.poppins(
                  fontSize: 12 * scaleFactor,
                  fontWeight: FontWeight.w500,
                  color: _getStatusColor(order.status),
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8 * scaleFactor),
            Text(
              order.customerName,
              style: GoogleFonts.poppins(
                fontSize: 14 * scaleFactor,
                color: const Color(0xFF64748B),
              ),
            ),
            SizedBox(height: 4 * scaleFactor),
            Text(
              '${order.date.day}/${order.date.month}/${order.date.year}',
              style: GoogleFonts.poppins(
                fontSize: 13 * scaleFactor,
                color: const Color(0xFF94A3B8),
              ),
            ),
            SizedBox(height: 8 * scaleFactor),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${order.amount.toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16 * scaleFactor,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                Icon(
                  Iconsax.arrow_right_3,
                  size: 18 * scaleFactor,
                  color: const Color(0xFF94A3B8),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog(BuildContext context, double scaleFactor) {
    String selectedFilter = _paymentFilter;
    DateTimeRange? dateRange = _dateRange;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16 * scaleFactor),
              ),
              title: Text(
                "Filter Orders",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 18 * scaleFactor,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date Range Picker
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        Iconsax.calendar,
                        size: 20 * scaleFactor,
                        color: const Color(0xFF6A5AE0),
                      ),
                      title: Text(
                        "Date Range",
                        style: GoogleFonts.poppins(
                          fontSize: 14 * scaleFactor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        dateRange != null
                            ? "${dateRange.start.day}/${dateRange.start.month}/${dateRange.start.year} - ${dateRange.end.day}/${dateRange.end.month}/${dateRange.end.year}"
                            : "Select date range",
                        style: GoogleFonts.poppins(
                          fontSize: 12 * scaleFactor,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      onTap: () async {
                        final DateTimeRange? picked = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(2023),
                          lastDate: DateTime.now(),
                          builder: (context, child) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: Color(0xFF6A5AE0),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          setDialogState(() => dateRange = picked);
                        }
                      },
                    ),

                    SizedBox(height: 24 * scaleFactor),

                    // Payment Type Filter
                    Text(
                      "Payment Method",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 14 * scaleFactor,
                      ),
                    ),
                    SizedBox(height: 12 * scaleFactor),
                    Wrap(
                      spacing: 8 * scaleFactor,
                      runSpacing: 8 * scaleFactor,
                      children: [
                        FilterChip(
                          label: Text(
                            "All",
                            style: GoogleFonts.poppins(
                              fontSize: 12 * scaleFactor,
                            ),
                          ),
                          selected: selectedFilter == "All",
                          onSelected: (bool selected) {
                            setDialogState(() => selectedFilter = "All");
                          },
                          backgroundColor: Colors.grey[100],
                          selectedColor: const Color(
                            0xFF6A5AE0,
                          ).withOpacity(0.2),
                          checkmarkColor: const Color(0xFF6A5AE0),
                          labelStyle: TextStyle(
                            color: selectedFilter == "All"
                                ? const Color(0xFF6A5AE0)
                                : const Color(0xFF1E293B),
                          ),
                        ),
                        FilterChip(
                          label: Text(
                            "COD",
                            style: GoogleFonts.poppins(
                              fontSize: 12 * scaleFactor,
                            ),
                          ),
                          selected: selectedFilter == "COD",
                          onSelected: (bool selected) {
                            setDialogState(() => selectedFilter = "COD");
                          },
                          backgroundColor: Colors.grey[100],
                          selectedColor: const Color(
                            0xFF6A5AE0,
                          ).withOpacity(0.2),
                          checkmarkColor: const Color(0xFF6A5AE0),
                          labelStyle: TextStyle(
                            color: selectedFilter == "COD"
                                ? const Color(0xFF6A5AE0)
                                : const Color(0xFF1E293B),
                          ),
                        ),
                        FilterChip(
                          label: Text(
                            "Credit Card",
                            style: GoogleFonts.poppins(
                              fontSize: 12 * scaleFactor,
                            ),
                          ),
                          selected: selectedFilter == "Credit Card",
                          onSelected: (bool selected) {
                            setDialogState(
                              () => selectedFilter = "Credit Card",
                            );
                          },
                          backgroundColor: Colors.grey[100],
                          selectedColor: const Color(
                            0xFF6A5AE0,
                          ).withOpacity(0.2),
                          checkmarkColor: const Color(0xFF6A5AE0),
                          labelStyle: TextStyle(
                            color: selectedFilter == "Credit Card"
                                ? const Color(0xFF6A5AE0)
                                : const Color(0xFF1E293B),
                          ),
                        ),
                        FilterChip(
                          label: Text(
                            "PayPal",
                            style: GoogleFonts.poppins(
                              fontSize: 12 * scaleFactor,
                            ),
                          ),
                          selected: selectedFilter == "PayPal",
                          onSelected: (bool selected) {
                            setDialogState(() => selectedFilter = "PayPal");
                          },
                          backgroundColor: Colors.grey[100],
                          selectedColor: const Color(
                            0xFF6A5AE0,
                          ).withOpacity(0.2),
                          checkmarkColor: const Color(0xFF6A5AE0),
                          labelStyle: TextStyle(
                            color: selectedFilter == "PayPal"
                                ? const Color(0xFF6A5AE0)
                                : const Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.poppins(color: const Color(0xFF64748B)),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).pop({'payment': selectedFilter, 'dateRange': dateRange});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A5AE0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12 * scaleFactor),
                    ),
                  ),
                  child: Text(
                    "Apply Filters",
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    ).then((result) {
      if (result != null) {
        setState(() {
          _paymentFilter = result['payment'];
          _dateRange = result['dateRange'];
        });
        _searchOrders(_searchController.text);
      }
    });
  }
}

// Order Details Screen
class OrderDetailsScreen extends StatefulWidget {
  final Order order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = screenWidth / 390;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Order Details",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: max(20 * scaleFactor, 18),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF1E293B),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Iconsax.printer, size: 22 * scaleFactor),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Invoice download started")),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16 * scaleFactor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Status Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16 * scaleFactor),
              ),
              child: Padding(
                padding: EdgeInsets.all(16 * scaleFactor),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.order.id,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 18 * scaleFactor,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12 * scaleFactor,
                            vertical: 6 * scaleFactor,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(
                              widget.order.status,
                            ).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(
                              20 * scaleFactor,
                            ),
                          ),
                          child: Text(
                            widget.order.status,
                            style: GoogleFonts.poppins(
                              fontSize: 14 * scaleFactor,
                              fontWeight: FontWeight.w500,
                              color: _getStatusColor(widget.order.status),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16 * scaleFactor),
                    LinearProgressIndicator(
                      value: _getProgressValue(widget.order.status),
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        const Color(0xFF6A5AE0),
                      ),
                      minHeight: 6 * scaleFactor,
                      borderRadius: BorderRadius.circular(10 * scaleFactor),
                    ),
                    SizedBox(height: 12 * scaleFactor),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatusLabel("Placed", true, scaleFactor),
                        _buildStatusLabel(
                          "Packed",
                          widget.order.status != "Pending",
                          scaleFactor,
                        ),
                        _buildStatusLabel(
                          "Shipped",
                          widget.order.status == "Shipped" ||
                              widget.order.status == "Delivered" ||
                              widget.order.status == "Returned",
                          scaleFactor,
                        ),
                        _buildStatusLabel(
                          "Delivered",
                          widget.order.status == "Delivered" ||
                              widget.order.status == "Returned",
                          scaleFactor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24 * scaleFactor),

            // Customer Information
            Text(
              "Customer Information",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 18 * scaleFactor,
                color: const Color(0xFF1E293B),
              ),
            ),
            SizedBox(height: 12 * scaleFactor),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16 * scaleFactor),
              ),
              child: Padding(
                padding: EdgeInsets.all(16 * scaleFactor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(
                      "Name",
                      widget.order.customerName,
                      scaleFactor,
                    ),
                    SizedBox(height: 12 * scaleFactor),
                    _buildInfoRow("Phone", widget.order.phone, scaleFactor),
                    SizedBox(height: 12 * scaleFactor),
                    _buildInfoRow("Email", widget.order.email, scaleFactor),
                    SizedBox(height: 12 * scaleFactor),
                    _buildInfoRow("Address", widget.order.address, scaleFactor),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24 * scaleFactor),

            // Order Items
            Text(
              "Order Items",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 18 * scaleFactor,
                color: const Color(0xFF1E293B),
              ),
            ),
            SizedBox(height: 12 * scaleFactor),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16 * scaleFactor),
              ),
              child: Padding(
                padding: EdgeInsets.all(16 * scaleFactor),
                child: Column(
                  children:
                      widget.order.items.map((item) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    8 * scaleFactor,
                                  ),
                                  child: Image.network(
                                    item.imageUrl,
                                    width: 60 * scaleFactor,
                                    height: 60 * scaleFactor,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                              width: 60 * scaleFactor,
                                              height: 60 * scaleFactor,
                                              color: Colors.grey[300],
                                              child: const Icon(
                                                Icons.image_not_supported,
                                                color: Colors.grey,
                                              ),
                                            ),
                                  ),
                                ),
                                SizedBox(width: 16 * scaleFactor),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.productName,
                                        style: GoogleFonts.poppins(
                                          fontSize: 16 * scaleFactor,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFF1E293B),
                                        ),
                                      ),
                                      SizedBox(height: 4 * scaleFactor),
                                      Text(
                                        'Quantity: ${item.quantity}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14 * scaleFactor,
                                          color: const Color(0xFF64748B),
                                        ),
                                      ),
                                      SizedBox(height: 4 * scaleFactor),
                                      Text(
                                        '\$${item.price.toStringAsFixed(2)} each',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14 * scaleFactor,
                                          color: const Color(0xFF64748B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '\$${item.subtotal.toStringAsFixed(2)}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16 * scaleFactor,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1E293B),
                                  ),
                                ),
                              ],
                            ),
                            if (widget.order.items.last != item)
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 12 * scaleFactor,
                                ),
                                child: Divider(color: Colors.grey[200]),
                              ),
                          ],
                        );
                      }).toList()..addAll([
                     ,
                ),
              ),
            ),

            SizedBox(height: 24 * scaleFactor),

            // Payment Information
            Text(
              "Payment Information",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 18 * scaleFactor,
                color: const Color(0xFF1E293B),
              ),
            ),
            SizedBox(height: 12 * scaleFactor),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16 * scaleFactor),
              ),
              child: Padding(
                padding: EdgeInsets.all(16 * scaleFactor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(
                      "Payment Method",
                      widget.order.paymentMethod,
                      scaleFactor,
                    ),
                    SizedBox(height: 12 * scaleFactor),
                    _buildInfoRow(
                      "Payment Status",
                      widget.order.paymentStatus,
                      scaleFactor,
                    ),
                  ],
                ),
              ),
            ),

            if (widget.order.status == "Shipped" ||
                widget.order.status == "Delivered" ||
                widget.order.status == "Returned") ...[
              SizedBox(height: 24 * scaleFactor),
              Text(
                "Shipping Information",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 18 * scaleFactor,
                  color: const Color(0xFF1E293B),
                ),
              ),
              SizedBox(height: 12 * scaleFactor),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16 * scaleFactor),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16 * scaleFactor),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(
                        "Courier",
                        widget.order.courier ?? "N/A",
                        scaleFactor,
                      ),
                      SizedBox(height: 12 * scaleFactor),
                      _buildInfoRow(
                        "Tracking ID",
                        widget.order.trackingId ?? "N/A",
                        scaleFactor,
                      ),
                    ],
                  ),
                ),
              ),
            ],

            SizedBox(height: 32 * scaleFactor),

            // Order Actions
            if (widget.order.status == "Pending")
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Accept order
                        _updateOrderStatus("Packed");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00B894),
                        padding: EdgeInsets.symmetric(
                          vertical: 16 * scaleFactor,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12 * scaleFactor),
                        ),
                      ),
                      child: Text(
                        "Accept Order",
                        style: GoogleFonts.poppins(
                          fontSize: 16 * scaleFactor,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12 * scaleFactor),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // Reject order
                        _updateOrderStatus("Returned");
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: 16 * scaleFactor,
                        ),
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12 * scaleFactor),
                        ),
                      ),
                      child: Text(
                        "Reject Order",
                        style: GoogleFonts.poppins(
                          fontSize: 16 * scaleFactor,
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            if (widget.order.status == "Packed")
              ElevatedButton(
                onPressed: () {
                  // Update tracking info
                  _showTrackingDialog(scaleFactor);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A5AE0),
                  padding: EdgeInsets.symmetric(vertical: 16 * scaleFactor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12 * scaleFactor),
                  ),
                  minimumSize: Size(double.infinity, 50 * scaleFactor),
                ),
                child: Text(
                  "Update Tracking Info",
                  style: GoogleFonts.poppins(
                    fontSize: 16 * scaleFactor,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),

            if (widget.order.status == "Shipped")
              ElevatedButton(
                onPressed: () {
                  // Mark as delivered
                  _updateOrderStatus("Delivered");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A5AE0),
                  padding: EdgeInsets.symmetric(vertical: 16 * scaleFactor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12 * scaleFactor),
                  ),
                  minimumSize: Size(double.infinity, 50 * scaleFactor),
                ),
                child: Text(
                  "Mark as Delivered",
                  style: GoogleFonts.poppins(
                    fontSize: 16 * scaleFactor,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),

            SizedBox(height: 16 * scaleFactor),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusLabel(String label, bool active, double scaleFactor) {
    return Text(
      label,
      style: GoogleFonts.poppins(
        fontSize: 12 * scaleFactor,
        color: active ? const Color(0xFF6A5AE0) : const Color(0xFF94A3B8),
        fontWeight: active ? FontWeight.w500 : FontWeight.normal,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, double scaleFactor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120 * scaleFactor,
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14 * scaleFactor,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF64748B),
            ),
          ),
        ),
        SizedBox(width: 16 * scaleFactor),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14 * scaleFactor,
              color: const Color(0xFF1E293B),
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Packed':
        return Colors.blue;
      case 'Shipped':
        return Colors.purple;
      case 'Delivered':
        return Colors.green;
      case 'Returned':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  double _getProgressValue(String status) {
    switch (status) {
      case 'Pending':
        return 0.25;
      case 'Packed':
        return 0.5;
      case 'Shipped':
        return 0.75;
      case 'Delivered':
        return 1.0;
      case 'Returned':
        return 1.0;
      default:
        return 0.0;
    }
  }

  void _updateOrderStatus(String newStatus) {
    // In a real app, update in database
    setState(() {
      widget.order.status = newStatus;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Order status updated to $newStatus"),
        backgroundColor: Colors.green,
      ),
    );

    // Navigate back after a short delay
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context);
    });
  }

  void _showTrackingDialog(double scaleFactor) {
    final trackingController = TextEditingController(
      text: widget.order.trackingId,
    );
    final courierController = TextEditingController(text: widget.order.courier);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16 * scaleFactor),
          ),
          title: Text(
            "Update Tracking Information",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 18 * scaleFactor,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: trackingController,
                decoration: InputDecoration(
                  labelText: "Tracking ID",
                  labelStyle: GoogleFonts.poppins(fontSize: 14 * scaleFactor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12 * scaleFactor),
                  ),
                ),
              ),
              SizedBox(height: 16 * scaleFactor),
              TextField(
                controller: courierController,
                decoration: InputDecoration(
                  labelText: "Courier Partner",
                  labelStyle: GoogleFonts.poppins(fontSize: 14 * scaleFactor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12 * scaleFactor),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancel",
                style: GoogleFonts.poppins(color: const Color(0xFF64748B)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  widget.order.trackingId = trackingController.text;
                  widget.order.courier = courierController.text;
                });
                _updateOrderStatus("Shipped");
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6A5AE0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12 * scaleFactor),
                ),
              ),
              child: Text(
                "Update",
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
