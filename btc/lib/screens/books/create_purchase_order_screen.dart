import 'package:btc/models/item_model.dart';
import 'package:btc/services/inventory_service.dart';
import 'package:flutter/material.dart';

class CreatePurchaseOrderScreen extends StatefulWidget {
  final int userId; // pass logged-in user ID here

  const CreatePurchaseOrderScreen({Key? key, required this.userId})
    : super(key: key);

  @override
  State<CreatePurchaseOrderScreen> createState() =>
      _CreatePurchaseOrderScreenState();
}

class _CreatePurchaseOrderScreenState extends State<CreatePurchaseOrderScreen> {
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
      items = await api.getItemsByUserId(
        widget.userId,
      ); // fetch only user's items
      setState(() => loading = false);
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load items: $e')));
    }
  }

  Future<void> submitPurchaseOrder() async {
    if (selectedItem == null || quantityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an item and enter quantity'),
        ),
      );
      return;
    }

    try {
      await api.stockInOut(
        selectedItem!.id,
        {
          'quantity': int.parse(quantityController.text),
          'user': 'Admin', // optionally, pass real username
          'note': 'Purchase Order',
        },
        true, // Stock In
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Purchase Order Successful')),
      );
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
        title: const Text('Create Purchase Order'),
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
                        onPressed: submitPurchaseOrder,
                        icon: const Icon(
                          Icons.shopping_cart_checkout,
                          color: Colors.white,
                        ),
                        label: const Text('Submit Purchase Order'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
