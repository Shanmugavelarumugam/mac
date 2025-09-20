import 'package:flutter/material.dart';
import 'package:btc_store/data/models/product_model.dart';
import 'package:btc_store/data/repositories/product_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late ProductRepository repository;
  late Product product;
  bool isLoading = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      Navigator.pop(context);
      return;
    }

    repository = ProductRepository(token: token);

    // Get the product passed as argument
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args is Product) {
      product = args;
      _populateForm();
    } else {
      Navigator.pop(context);
    }
  }

  void _populateForm() {
    _nameController.text = product.name;
    _priceController.text = product.price.toString();
    _stockController.text = product.stock.toString();
    _descriptionController.text = product.description ?? '';
    _categoryController.text = product.category;
    _discountController.text = product.discount?.toString() ?? '0';
  }

  Future<void> _updateProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final updates = {
        'name': _nameController.text,
        'price': double.parse(_priceController.text),
        'stock': int.parse(_stockController.text),
        'description': _descriptionController.text,
        'category': _categoryController.text,
        'discount': double.parse(_discountController.text),
        'is_available': product.isAvailable,
      };

      await repository.updateProduct(product.id!, updates);

      if (mounted) {
        Navigator.pop(context, true); // Return true to indicate success
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update product: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _updateProduct),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Product Name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a product name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(labelText: 'Price'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _stockController,
                      decoration: const InputDecoration(labelText: 'Stock'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter stock quantity';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _categoryController,
                      decoration: const InputDecoration(labelText: 'Category'),
                    ),
                    TextFormField(
                      controller: _discountController,
                      decoration: const InputDecoration(
                        labelText: 'Discount (%)',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _updateProduct,
                      child: const Text('Update Product'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _discountController.dispose();
    super.dispose();
  }
}
