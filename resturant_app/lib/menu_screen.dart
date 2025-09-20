import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shimmer/shimmer.dart';
import 'package:resturant_app/services/hive_service.dart'; // ✅ added

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final String baseUrl = 'http://192.168.1.4:3001';
  List<dynamic> menu = [];
  List<dynamic> filteredMenu = [];
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();
  String sortBy = 'None';
  String selectedType = ''; // Veg / Non-Veg / '' (All)

  @override
  void initState() {
    super.initState();
    fetchMenu();
    searchController.addListener(filterMenu);
  }

  Future<void> fetchMenu() async {
    setState(() => isLoading = true);
    try {
      final restaurantId = HiveService.id; // ✅ use logged-in ID
      final response = await Dio().get(
        '$baseUrl/api/restaurants/getMenu/$restaurantId',
      );
      menu = response.data['menu'];
      filteredMenu = [...menu];
      filterMenu();
    } catch (e) {
      print('Menu fetch error: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void filterMenu() {
    final query = searchController.text.toLowerCase();
    List<dynamic> result =
        menu.where((item) {
          final name = (item['name'] ?? '').toLowerCase();
          final category = (item['category'] ?? '').toLowerCase();
          return name.contains(query) || category.contains(query);
        }).toList();

    if (selectedType.isNotEmpty) {
      result =
          result.where((item) => item['veg_nonveg'] == selectedType).toList();
    }

    if (sortBy == 'Price') {
      result.sort(
        (a, b) => double.parse(a['price']).compareTo(double.parse(b['price'])),
      );
    } else if (sortBy == 'Rating') {
      result.sort((a, b) => (b['rating'] ?? 0).compareTo(a['rating'] ?? 0));
    }

    setState(() => filteredMenu = result);
  }

  void confirmDeleteFood(int id) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text("Confirm Delete"),
            content: Text("Are you sure you want to delete this food item?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () async {
                  Navigator.pop(context);
                  await deleteFood(id);
                },
                child: Text("Delete"),
              ),
            ],
          ),
    );
  }

  Future<void> deleteFood(int id) async {
    try {
      await Dio().delete('$baseUrl/api/foods/$id');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Food Deleted')));
      fetchMenu();
    } catch (e) {
      print('Delete error: $e');
    }
  }

  void showFoodDialog({Map? food}) {
    final nameController = TextEditingController(text: food?['name'] ?? '');
    final priceController = TextEditingController(
      text: food?['price']?.toString() ?? '',
    );
    final descriptionController = TextEditingController(
      text: food?['description'] ?? '',
    );
    final categoryController = TextEditingController(
      text: food?['category'] ?? '',
    );
    final spicyLevelController = TextEditingController(
      text: food?['spicy_level'] ?? '',
    );
    final caloriesController = TextEditingController(
      text: food?['calories']?.toString() ?? '',
    );
    final imageUrlController = TextEditingController(
      text: food?['image_url'] ?? '',
    );
    final stockController = TextEditingController(
      text: food?['stock_quantity']?.toString() ?? '',
    );
    final taglineController = TextEditingController(
      text: (food?['tagline'] as List?)?.join(', ') ?? '',
    );
    final cuisineController = TextEditingController(
      text: food?['cuisine'] ?? '',
    );
    final timeToDeliveryController = TextEditingController(
      text: food?['time_to_delivery']?.toString() ?? '',
    );

    String vegNonVeg = food?['veg_nonveg'] ?? 'Veg';

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            scrollable: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(food == null ? 'Add Food' : 'Edit Food'),
            content: StatefulBuilder(
              builder:
                  (context, setModalState) => Column(
                    children: [
                      buildTextField("Food Name", nameController),
                      buildTextField("Price", priceController, isNumber: true),
                      buildTextField("Description", descriptionController),
                      buildTextField("Category", categoryController),
                      buildTextField("Spicy Level", spicyLevelController),
                      buildTextField(
                        "Calories",
                        caloriesController,
                        isNumber: true,
                      ),
                      buildTextField("Image URL", imageUrlController),
                      buildTextField(
                        "Stock Quantity",
                        stockController,
                        isNumber: true,
                      ),
                      buildTextField("Cuisine", cuisineController),
                      buildTextField(
                        "Tagline (comma-separated)",
                        taglineController,
                      ),
                      buildTextField(
                        "Time to Delivery (min)",
                        timeToDeliveryController,
                        isNumber: true,
                      ),

                      DropdownButtonFormField<String>(
                        value: vegNonVeg,
                        items:
                            ['Veg', 'Non-Veg']
                                .map(
                                  (type) => DropdownMenuItem(
                                    value: type,
                                    child: Text(type),
                                  ),
                                )
                                .toList(),
                        onChanged:
                            (val) =>
                                setModalState(() => vegNonVeg = val ?? 'Veg'),
                        decoration: InputDecoration(labelText: 'Veg/Non-Veg'),
                      ),
                    ],
                  ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final restaurantId = HiveService.id; // ✅ here
                final data = {
                    'name': nameController.text,
                    'price': priceController.text,
                    'description': descriptionController.text,
                    'restaurantId': restaurantId,
                    'category': categoryController.text,
                    'spicy_level': spicyLevelController.text,
                    'calories': int.tryParse(caloriesController.text) ?? 0,
                    'image_url': imageUrlController.text,
                    'stock_quantity': int.tryParse(stockController.text) ?? 0,
                    'veg_nonveg': vegNonVeg,
                    'tagline':
                        taglineController.text
                            .split(',')
                            .map((tag) => tag.trim())
                            .where((tag) => tag.isNotEmpty)
                            .toList(),
                    'cuisine': cuisineController.text,
                    'time_to_delivery':
                        int.tryParse(timeToDeliveryController.text) ?? 0,
                  };

                  try {
                    if (food == null) {
                      await Dio().post('$baseUrl/api/foods', data: data);
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Food Added')));
                    } else {
                      await Dio().put(
                        '$baseUrl/api/foods/${food['id']}',
                        data: data,
                      );
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Food Updated')));
                    }
                    Navigator.pop(context);
                    fetchMenu();
                  } catch (e) {
                    print('Save error: $e');
                  }
                },
                child: Text(food == null ? 'Add' : 'Update'),
              ),
            ],
          ),
    );
  }

  TextField buildTextField(
    String label,
    TextEditingController controller, {
    bool isNumber = false,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
    );
  }

  Widget buildFoodCard(Map food) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                food['image_url']?.isNotEmpty == true
                    ? food['image_url']
                    : 'https://via.placeholder.com/60',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) => Icon(Icons.broken_image, size: 40),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food['name'] ?? '',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text("₹ ${food['price']} | ${food['calories']} cal"),
                  Text(
                    food['description'] ?? '',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Wrap(
                    spacing: 6,
                    children: [
                      Chip(label: Text(food['category'] ?? '')),
                      Chip(
                        label: Text(food['veg_nonveg'] ?? ''),
                        backgroundColor:
                            food['veg_nonveg'] == 'Veg'
                                ? Colors.green.shade100
                                : Colors.red.shade100,
                      ),
                      Chip(
                        label: Text("Spice: ${food['spicy_level'] ?? 'Mild'}"),
                      ),
                      Chip(
                        label: Text("Stock: ${food['stock_quantity'] ?? 0}"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => showFoodDialog(food: food),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed:
                      () => confirmDeleteFood(int.parse(food['id'].toString())),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildShimmer() {
    return ListView.builder(
      itemCount: 6,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder:
          (_, __) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("🍽 Menu Management"),
        backgroundColor: Colors.deepOrange,
        actions: [
          DropdownButton<String>(
            value: sortBy,
            onChanged: (value) {
              setState(() {
                sortBy = value!;
                filterMenu();
              });
            },
            items:
                ['None', 'Price', 'Rating']
                    .map(
                      (value) => DropdownMenuItem(
                        value: value,
                        child: Text("Sort by $value"),
                      ),
                    )
                    .toList(),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search food by name or category',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: Text('All'),
                      selected: selectedType == '',
                      onSelected:
                          (_) => setState(() {
                            selectedType = '';
                            filterMenu();
                          }),
                    ),
                    ChoiceChip(
                      label: Text('Veg'),
                      selected: selectedType == 'Veg',
                      onSelected:
                          (_) => setState(() {
                            selectedType = 'Veg';
                            filterMenu();
                          }),
                    ),
                    ChoiceChip(
                      label: Text('Non-Veg'),
                      selected: selectedType == 'Non-Veg',
                      onSelected:
                          (_) => setState(() {
                            selectedType = 'Non-Veg';
                            filterMenu();
                          }),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child:
                isLoading
                    ? buildShimmer()
                    : filteredMenu.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.hourglass_empty,
                            size: 60,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "No food items found",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                    : RefreshIndicator(
                      onRefresh: fetchMenu,
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children:
                            filteredMenu
                                .map((food) => buildFoodCard(food))
                                .toList(),
                      ),
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showFoodDialog(),
        backgroundColor: Colors.deepOrange,
        child: Icon(Icons.add),
        tooltip: "Add Food Item",
      ),
    );
  }
}
