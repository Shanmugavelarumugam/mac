import 'package:btc/widgets/date_picker.dart';
import 'package:flutter/material.dart';
import 'package:btc/services/trip_service.dart';
import 'package:flutter/services.dart';

class AddTransactionScreen extends StatefulWidget {
  final int tripId;
  final int userId; // <-- add userId here

  const AddTransactionScreen({
    Key? key,
    required this.tripId,
    required this.userId, // require userId in constructor
  }) : super(key: key);

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController purposeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TripService service = TripService();

  final List<String> purposeOptions = [
    'Food',
    'Travel',
    'Shopping',
    'Hotel',
    'Fuel',
    'Parking',
    'Entertainment',
    'Gifts',
    'Miscellaneous',
  ];

  String? selectedPurpose;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Transaction',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF74ebd5), Color(0xFFACB6E5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  'New Transaction',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),

                _buildInputField(
                  controller: nameController,
                  label: 'Name',
                  icon: Icons.person,
                ),
                const SizedBox(height: 16),

                _buildInputField(
                  controller: amountController,
                  label: 'Amount',
                  icon: Icons.attach_money,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 16),

                _buildDropdownPurpose(),
                const SizedBox(height: 16),

                CustomDatePicker(controller: dateController, labelText: 'Date'),
                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      backgroundColor: const Color(0xFF4facfe),
                    ),
                    child: const Text(
                      'Add Transaction',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                     onPressed: () async {
                      if (nameController.text.isEmpty ||
                          amountController.text.isEmpty ||
                          purposeController.text.isEmpty ||
                          dateController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill all fields'),
                          ),
                        );
                        return;
                      }

                      try {
                        final transaction = await service.addTransaction(
                          widget.tripId,
                          nameController.text,
                          double.parse(amountController.text),
                          purposeController.text,
                          dateController.text,
                          // no userId here as backend does not expect it
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Transaction Added')),
                        );
                        Navigator.pop(context, transaction);
                      } catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('Error: $e')));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(16),
      color: Colors.white.withOpacity(0.95),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters:
              label == 'Amount'
                  ? [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*\.?\d{0,2}'),
                    ),
                  ]
                  : [],
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: label,
            prefixIcon: Icon(icon, color: const Color(0xFF4facfe)),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownPurpose() {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(16),
      color: Colors.white.withOpacity(0.95),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: DropdownButtonFormField<String>(
          value: selectedPurpose,
          decoration: const InputDecoration(
            border: InputBorder.none,
            labelText: 'Purpose',
            prefixIcon: Icon(Icons.note_alt, color: Color(0xFF4facfe)),
          ),
          items:
              purposeOptions
                  .map(
                    (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ),
                  )
                  .toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedPurpose = newValue;
              purposeController.text = newValue ?? '';
            });
          },
        ),
      ),
    );
  }
}
