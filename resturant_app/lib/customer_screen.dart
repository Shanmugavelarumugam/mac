import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shimmer/shimmer.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({Key? key}) : super(key: key);

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final String baseUrl = 'http://192.168.1.4:3001';
  List<dynamic> customers = [];
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    fetchCustomers();
  }

  Future<void> fetchCustomers() async {
    setState(() {
      isLoading = true;
      isError = false;
    });

    try {
      final response = await Dio().get('$baseUrl/api/customers/restaurant/1');
      customers = response.data;
    } catch (e) {
      isError = true;
      print('Customer fetch error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 8),
                Text("Failed to load customers"),
              ],
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Widget buildCustomerCard(Map customer) {
    String name = customer['name'] ?? 'Unknown';
    String initials = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: Colors.deepOrange.shade100,
          child: Text(
            initials,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange,
            ),
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          customer['email'] ?? 'No email',
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.deepOrange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "#${customer['id'] ?? ''}",
            style: const TextStyle(
              color: Colors.deepOrange,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildShimmerCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          leading: const CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white,
          ),
          title: Container(height: 14, width: 80, color: Colors.white),
          subtitle: Container(height: 12, width: 120, color: Colors.white),
          trailing: Container(height: 20, width: 40, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text("👥 Customers"),
        backgroundColor: Colors.deepOrange,
        elevation: 0,
      ),
      body:
          isLoading
              ? ListView.builder(
                itemCount: 6,
                itemBuilder: (_, __) => buildShimmerCard(),
              )
              : isError
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.redAccent,
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Something went wrong",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    TextButton.icon(
                      onPressed: fetchCustomers,
                      icon: const Icon(Icons.refresh),
                      label: const Text("Retry"),
                    ),
                  ],
                ),
              )
              : customers.isEmpty
              ? const Center(
                child: Text(
                  "No customers found",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
              : RefreshIndicator(
                onRefresh: fetchCustomers,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(top: 10, bottom: 20),
                  itemCount: customers.length,
                  itemBuilder:
                      (context, index) => buildCustomerCard(customers[index]),
                ),
              ),
    );
  }
}
