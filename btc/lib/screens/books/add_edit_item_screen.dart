import 'package:flutter/material.dart';
import 'package:btc/models/item_model.dart';
import 'package:btc/services/inventory_service.dart';

class AddEditItemScreen extends StatefulWidget {
  final Item? item;
  final int userId; // <-- userId from logged-in user

  const AddEditItemScreen({Key? key, this.item, required this.userId})
    : super(key: key);

  @override
  State<AddEditItemScreen> createState() => _AddEditItemScreenState();
}

class _AddEditItemScreenState extends State<AddEditItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService api = ApiService();

  final TextEditingController name = TextEditingController();
  final TextEditingController sku = TextEditingController();
  final TextEditingController category = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController quantity = TextEditingController();
  final TextEditingController unitCost = TextEditingController();
  final TextEditingController reorder = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      name.text = widget.item?.name ?? '';
      sku.text = widget.item?.sku ?? '';
      category.text = widget.item?.category ?? '';
      description.text = widget.item?.description ?? '';
      quantity.text = widget.item?.quantity?.toString() ?? '';
      unitCost.text = widget.item?.unitCost?.toString() ?? '';
      reorder.text = widget.item?.reorderLevel?.toString() ?? '';
    }
  }

  Future<void> saveItem() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'name': name.text,
        'quantity': int.tryParse(quantity.text) ?? 0,
        'sku': sku.text.isEmpty ? null : sku.text,
        'category': category.text.isEmpty ? null : category.text,
        'description': description.text.isEmpty ? null : description.text,
        'unitCost':
            unitCost.text.isEmpty ? null : double.tryParse(unitCost.text),
        'reorderLevel':
            reorder.text.isEmpty ? null : int.tryParse(reorder.text),
      };

      if (widget.item == null) {
        data['userId'] = widget.userId; // use actual logged-in userId here
      }

      try {
        if (widget.item == null) {
          await api.createItem(data);
        } else {
          await api.updateItem(widget.item!.id, data);
        }
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Widget buildField(
    String label,
    TextEditingController controller, {
    TextInputType type = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator:
            (value) => value == null || value.isEmpty ? 'Required' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.item != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Item' : 'Add Item'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildField('Name', name),
              buildField('SKU', sku),
              buildField('Category', category),
              buildField('Description', description),
              buildField('Quantity', quantity, type: TextInputType.number),
              buildField('Unit Cost', unitCost, type: TextInputType.number),
              buildField('Reorder Level', reorder, type: TextInputType.number),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: saveItem,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    isEdit ? 'Update Item' : 'Add Item',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
