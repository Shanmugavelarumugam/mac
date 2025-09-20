import 'package:btc/models/trip.dart';
import 'package:btc/services/trip_service.dart';
import 'package:btc/widgets/date_picker.dart';
import 'package:flutter/material.dart';


class EditTripScreen extends StatefulWidget {
  final Trip trip;

  const EditTripScreen({Key? key, required this.trip}) : super(key: key);

  @override
  _EditTripScreenState createState() => _EditTripScreenState();
}

class _EditTripScreenState extends State<EditTripScreen> {
  late TextEditingController placeController;
  late TextEditingController dateController;
  final List<TextEditingController> memberControllers = [];
  final TripService service = TripService();
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    placeController = TextEditingController(text: widget.trip.place);
    dateController = TextEditingController(text: widget.trip.date);
    for (final member in widget.trip.members) {
      memberControllers.add(TextEditingController(text: member));
    }
    if (memberControllers.isEmpty) {
      // Ensure at least one member field is there
      memberControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    placeController.dispose();
    dateController.dispose();
    for (var c in memberControllers) {
      c.dispose();
    }
    super.dispose();
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

  Future<void> _updateTrip() async {
    final place = placeController.text.trim();
    final date = dateController.text.trim();
    final members =
        memberControllers
            .map((c) => c.text.trim())
            .where((m) => m.isNotEmpty)
            .toList();

    if (place.isEmpty || date.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in Place and Date')),
      );
      return;
    }
    if (members.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one member')),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      await service.updateTrip(widget.trip.id, place, members);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Trip updated successfully')),
      );
      Navigator.pop(context, true); // true to indicate success
    } catch (e) {
      setState(() => isSaving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update trip: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Trip',
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
                  'Edit Trip',
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

                // Date Picker (reuse your CustomDatePicker widget)
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

                // Save Button
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
                    onPressed: isSaving ? null : _updateTrip,
                    child:
                        isSaving
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text(
                              'Save Changes',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
