import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  final String baseUrl = 'http://192.168.1.6:3001';
  List<dynamic> activeOrders = [];
  List<dynamic> completedOrders = [];
  String statusFilter = 'All';

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      final activeRes = await Dio().get('$baseUrl/api/order/orders/1');
      final completedRes = await Dio().get('$baseUrl/api/order/completed');

      setState(() {
        activeOrders = activeRes.data ?? [];
        completedOrders = completedRes.data ?? [];
      });
    } catch (e) {
      print('Fetch error: $e');
    }
  }

  Future<void> updateStatus(int orderId, String newStatus) async {
    try {
      await Dio().put(
        '$baseUrl/api/order/$orderId/status',
        data: {"status": newStatus},
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Updated to $newStatus")));
      fetchOrders();
    } catch (e) {
      print('Status update error: $e');
    }
  }

  Widget buildOrderCard(Map order, {bool isCompleted = false}) {
    final id = order['id'];
    final status = order['status'] ?? 'Pending';
    final name = order['customer_name'] ?? 'Customer';
    final items = order['items'] ?? [];
    final price = order['total_price'] ?? 0;
    final time = order['created_at'];
    final address = order['delivery_address'] ?? "No address";

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "🧾 Order #$id",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 6),
            Text("👤 $name"),
            SizedBox(height: 6),
            Text(
              "📅 ${DateFormat.yMMMd().add_jm().format(DateTime.parse(time))}",
            ),
            Text("📦 ₹$price"),
            Text("📍 $address", style: TextStyle(color: Colors.grey[700])),
            Divider(height: 20),
            ...items.map<Widget>(
              (item) => Text("• ${item['food_name']} x${item['quantity']}"),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text("Status: ", style: TextStyle(fontWeight: FontWeight.w500)),
                if (isCompleted)
                  Text(status)
                else
                  DropdownButton<String>(
                    value: status,
                    items:
                        ['Pending', 'Preparing', 'Delivered'].map((s) {
                          return DropdownMenuItem(value: s, child: Text(s));
                        }).toList(),
                    onChanged: (newStatus) {
                      if (newStatus != null && newStatus != status) {
                        updateStatus(id, newStatus);
                      }
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Map> getFilteredOrders(List orders) {
    if (statusFilter == 'All') return orders.cast<Map>();
    return orders
        .where((o) => o['status'] == statusFilter)
        .cast<Map>()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredActive = getFilteredOrders(activeOrders);

    return Scaffold(
      appBar: AppBar(
        title: Text("📦 Orders"),
        backgroundColor: Colors.deepOrange,
        bottom: TabBar(
          controller: _tabController,
          tabs: [Tab(text: "Active"), Tab(text: "Completed")],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: DropdownButton<String>(
              value: statusFilter,
              onChanged: (value) {
                if (value != null) setState(() => statusFilter = value);
              },
              items:
                  ['All', 'Pending', 'Preparing', 'Delivered']
                      .map(
                        (status) => DropdownMenuItem(
                          value: status,
                          child: Text("Filter: $status"),
                        ),
                      )
                      .toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                RefreshIndicator(
                  onRefresh: fetchOrders,
                  child:
                      filteredActive.isEmpty
                          ? Center(child: Text("No active orders"))
                          : ListView.builder(
                            itemCount: filteredActive.length,
                            itemBuilder:
                                (_, i) => buildOrderCard(filteredActive[i]),
                          ),
                ),
                RefreshIndicator(
                  onRefresh: fetchOrders,
                  child:
                      completedOrders.isEmpty
                          ? Center(child: Text("No completed orders"))
                          : ListView.builder(
                            itemCount: completedOrders.length,
                            itemBuilder:
                                (_, i) => buildOrderCard(
                                  completedOrders[i],
                                  isCompleted: true,
                                ),
                          ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
