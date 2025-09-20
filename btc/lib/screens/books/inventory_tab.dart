import 'package:flutter/material.dart';
import 'package:btc/models/item_model.dart';
import 'package:btc/services/inventory_service.dart';
import 'add_edit_item_screen.dart';

class InventoryTab extends StatefulWidget {
  final int userId;

  const InventoryTab({Key? key, required this.userId}) : super(key: key);

  @override
  State<InventoryTab> createState() => _InventoryTabState();
}

class _InventoryTabState extends State<InventoryTab> {
  final ApiService api = ApiService();
  List<Item> items = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchItems();
  }
Future<void> fetchItems() async {
    setState(() => loading = true); // show loader while fetching
    try {
      // Fetch only items for the current user using userId
      items = await api.getItemsByUserId(widget.userId);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load items: $e')));
    } finally {
      setState(() => loading = false); // hide loader after fetch
    }
  }


  void showStockDialog(Item item, bool isIn) {
    final qtyController = TextEditingController();
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(isIn ? 'Stock In' : 'Stock Out'),
            content: TextField(
              controller: qtyController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isIn ? Colors.green : Colors.red,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  if (qtyController.text.isEmpty) return;
                  await api.stockInOut(item.id, {
                    'quantity': int.parse(qtyController.text),
                    'user': 'Admin',
                    'note': isIn ? 'Stock In' : 'Stock Out',
                  }, isIn);
                  Navigator.pop(context);
                  fetchItems();
                },
                child: const Text(
                  'Confirm',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  void showDeleteDialog(Item item) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Delete Item'),
            content: Text('Are you sure you want to delete "${item.name}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  await api.deleteItem(item.id);
                  Navigator.pop(context);
                  fetchItems();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${item.name} deleted successfully'),
                    ),
                  );
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  void navigateToAddEdit([Item? item]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => AddEditItemScreen(
              item: item,
              userId: widget.userId, // pass userId here
            ),
      ),
    );
    if (result == true) fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body:
          loading
              ? const Center(child: CircularProgressIndicator())
              : items.isEmpty
              ? const Center(
                child: Text('No items found', style: TextStyle(fontSize: 16)),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: items.length,
                itemBuilder: (_, index) {
                  final item = items[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    shadowColor: Colors.grey.withOpacity(0.3),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.indigo.shade50,
                        child: Text(
                          item.name.isNotEmpty
                              ? item.name[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                      ),
                      title: Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'SKU: ${item.sku}\nStock: ${item.quantity}',
                          style: const TextStyle(height: 1.5),
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.add_circle,
                              color: Colors.green,
                            ),
                            tooltip: 'Stock In',
                            onPressed: () => showStockDialog(item, true),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.remove_circle,
                              color: Colors.red,
                            ),
                            tooltip: 'Stock Out',
                            onPressed: () => showStockDialog(item, false),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.blueAccent,
                            ),
                            tooltip: 'Edit Item',
                            onPressed: () => navigateToAddEdit(item),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.grey),
                            tooltip: 'Delete Item',
                            onPressed: () => showDeleteDialog(item),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => navigateToAddEdit(),
        label: const Text('Add Item'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blue.shade600,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
