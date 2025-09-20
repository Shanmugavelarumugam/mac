import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class ComplainantScreen extends StatefulWidget {
  const ComplainantScreen({super.key});

  @override
  State<ComplainantScreen> createState() => _ComplainantScreenState();
}

class _ComplainantScreenState extends State<ComplainantScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _complaintController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _complaintController.dispose();
    super.dispose();
  }

  void _submitComplaint() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final complaint = _complaintController.text.trim();

      // TODO: Add your API or database call here
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Complaint submitted by $name")));

      _nameController.clear();
      _complaintController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Complainant"),
        backgroundColor: const Color(0xFFFF6B6B),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Submit a Complaint",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Iconsax.profile_circle),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your name";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _complaintController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: "Complaint",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Iconsax.message),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your complaint";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B6B),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _submitComplaint,
                  child: Text(
                    "Submit",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
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
