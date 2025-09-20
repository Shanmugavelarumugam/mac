import 'package:btc/services/trip_service.dart';
import 'package:btc/widgets/date_picker.dart';
import 'package:flutter/material.dart';

class AddTripScreen extends StatefulWidget {
  final int userId; // Add userId here

  const AddTripScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _AddTripScreenState createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen> {
  final TextEditingController placeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final List<TextEditingController> memberControllers = [];
  final TripService service = TripService();

  @override
  void initState() {
    super.initState();
    _addMemberField(); // Start with one member input
  }

  void _addMemberField() {
    setState(() {
      memberControllers.add(TextEditingController());
    });
  }

  void _removeMemberField(int index) {
    setState(() {
      memberControllers.removeAt(index);
    });
  }

  Future<void> _createTrip() async {
    print("=== Creating Trip ===");
    print("Place: ${placeController.text}");
    print("Date: ${dateController.text}");

    if (placeController.text.isEmpty || dateController.text.isEmpty) {
      print("Validation failed: Place or Date is empty");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill place and date')),
      );
      return;
    }

    final members =
        memberControllers
            .map((c) => c.text.trim())
            .where((name) => name.isNotEmpty)
            .toList();

    print("Members: $members");

    if (members.isEmpty) {
      print("Validation failed: No members added");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one member')),
      );
      return;
    }

    try {
      print("Sending request to create trip...");
      final trip = await service.createTrip(
        placeController.text,
        dateController.text,
        members,
        widget.userId, // Pass userId here
      );
      print("Trip created successfully: ${trip.toJson()}");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Trip Created')));
      Navigator.pop(context);
    } catch (e) {
      print("Error creating trip: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Trip',
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
                const SizedBox(height: 60),
                const Text(
                  'New Trip',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),

                // Place Input
                _buildTextField(placeController, 'Place', Icons.location_on),
                const SizedBox(height: 20),

                // Date Picker
                CustomDatePicker(controller: dateController),

                const SizedBox(height: 20),

                // Members Section
                Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Members',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.add, color: Colors.white),
                          onPressed: _addMemberField,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ...memberControllers.asMap().entries.map((entry) {
                      final index = entry.key;
                      final controller = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller,
                                'Member Name',
                                Icons.person,
                              ),
                            ),
                            if (memberControllers.length > 1)
                              IconButton(
                                icon: const Icon(
                                  Icons.remove_circle,
                                  color: Colors.redAccent,
                                ),
                                onPressed: () => _removeMemberField(index),
                              ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),

                const SizedBox(height: 40),

                // Submit Button
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
                      'Create Trip',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: _createTrip,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
          prefixIcon: Icon(icon, color: const Color(0xFF4facfe)),
        ),
      ),
    );
  }
}
