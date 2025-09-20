import 'package:flutter/material.dart';
import 'package:btc/models/item_model.dart';
import 'package:btc/services/inventory_service.dart';

class CreateSalesOrderScreen extends StatefulWidget {
  final int userId; // logged-in user's ID passed here

  const CreateSalesOrderScreen({Key? key, required this.userId})
    : super(key: key);

  @override
  State<CreateSalesOrderScreen> createState() => _CreateSalesOrderScreenState();
}

class _CreateSalesOrderScreenState extends State<CreateSalesOrderScreen> {
  final ApiService api = ApiService();
  List<Item> items = [];
  Item? selectedItem;
  final TextEditingController quantityController = TextEditingController();
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchUserItems();
  }

  Future<void> fetchUserItems() async {
    try {
      items = await api.getItemsByUserId(widget.userId);
      setState(() => loading = false);
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load items: $e')));
    }
  }

  Future<void> submitSalesOrder() async {
    if (selectedItem == null || quantityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an item and enter quantity'),
        ),
      );
      return;
    }

    final qty = int.tryParse(quantityController.text);
    if (qty == null || qty <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid quantity')),
      );
      return;
    }

    try {
      await api.stockInOut(
        selectedItem!.id,
        {
          'quantity': qty,
          'user': 'UserID: ${widget.userId}', // dynamically pass user info
          'note': 'Sales Order',
        },
        false, // Stock Out
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Sales Order Successful')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Sales Order'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body:
          loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Item',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<Item>(
                      value: selectedItem,
                      items:
                          items
                              .map(
                                (item) => DropdownMenuItem<Item>(
                                  value: item,
                                  child: Text(
                                    '${item.name} (SKU: ${item.sku ?? "N/A"})',
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged:
                          (value) => setState(() => selectedItem = value),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Enter Quantity',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: quantityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: submitSalesOrder,
                        icon: const Icon(Icons.sell, color: Colors.white),
                        label: const Text('Submit Sales Order'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
