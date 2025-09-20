import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class StockUpdateScreen extends StatefulWidget {
  const StockUpdateScreen({Key? key}) : super(key: key);

  @override
  State<StockUpdateScreen> createState() => _StockUpdateScreenState();
}

class _StockUpdateScreenState extends State<StockUpdateScreen> {
  final String baseUrl = 'http://192.168.1.4:3001';
  List<dynamic> foods = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFoods();
  }

  Future<void> fetchFoods() async {
    setState(() => isLoading = true);
    try {
      final response = await Dio().get('$baseUrl/api/restaurants/getMenu/1');
      foods = response.data['menu'];
    } catch (e) {
      print('Error fetching foods: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> updateStock(int foodId, int quantity) async {
    try {
      await Dio().put(
        '$baseUrl/api/foods/$foodId/stock',
        data: {"stock_quantity": quantity},
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ Stock updated for Food ID $foodId")),
      );
    } catch (e) {
      print('Stock update error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ Failed to update stock")));
    }
  }

  Widget buildFoodRow(Map food) {
    final TextEditingController stockController = TextEditingController(
      text: food['stock_quantity'].toString(),
    );

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.deepOrange,
          child: Icon(Icons.fastfood, color: Colors.white),
        ),
        title: Text(
          food['name'],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("Current Stock: ${food['stock_quantity']}"),
        trailing: SizedBox(
          width: 150,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: TextField(
                  controller: stockController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "Qty",
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 10,
                    ),
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              IconButton(
                icon: const Icon(Icons.save, color: Colors.green),
                tooltip: "Update Stock",
                onPressed: () {
                  final qty = int.tryParse(stockController.text);
                  if (qty != null) {
                    updateStock(food['id'], qty);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("📦 Update Food Stock"),
        backgroundColor: Colors.deepOrange,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: fetchFoods,
                child: ListView(
                  padding: const EdgeInsets.only(top: 16),
                  children: foods.map((food) => buildFoodRow(food)).toList(),
                ),
              ),
    );
  }
}
