import 'package:flutter/material.dart';
import 'package:mail/config/theme.dart';

class ComposeEmailScreen extends StatefulWidget {
  const ComposeEmailScreen({super.key});

  @override
  State<ComposeEmailScreen> createState() => _ComposeEmailScreenState();
}

class _ComposeEmailScreenState extends State<ComposeEmailScreen> {
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _ccController = TextEditingController();
  final _bccController = TextEditingController();
  final _subjectController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _showCcBcc = false;

  // Mock list of sender and recipient email addresses (replace with actual data source)
  final List<String> _fromEmails = [
    'johndoe@gmail.com',
    'john.doe@work.com',
    'jdoe@personal.com',
  ];
  final List<String> _recipientEmails = [
    'alice@gmail.com',
    'bob@work.com',
    'charlie@personal.com',
    'david@gmail.com',
  ];

  @override
  void initState() {
    super.initState();
    // Set default "From" email
    _fromController.text = _fromEmails.first;
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _ccController.dispose();
    _bccController.dispose();
    _subjectController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _sendEmail() {
    if (_toController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please enter a recipient"),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    if (_fromController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please enter a sender email"),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Email sent from ${_fromController.text}!"),
        backgroundColor: AppColors.success,
      ),
    );
    Navigator.pop(context);
  }

  void _discardEmail() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Discard Email"),
        content: const Text("Are you sure you want to discard this email?"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: AppColors.secondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text("Discard", style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _toggleCcBcc() {
    setState(() {
      _showCcBcc = !_showCcBcc;
    });
  }

  Widget _buildEmailField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required List<String> suggestions,
    bool isFromField = false,
    bool showToggle = false,
  }) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;

    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        return suggestions.where((String option) {
          return option.toLowerCase().contains(
            textEditingValue.text.toLowerCase(),
          );
        });
      },
      onSelected: (String selection) {
        controller.text = selection;
      },
      fieldViewBuilder:
          (
            BuildContext context,
            TextEditingController fieldController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted,
          ) {
            return TextFormField(
              controller: fieldController,
              focusNode: focusNode,
              decoration: InputDecoration(
                labelText: label,
                hintText: hint,
                labelStyle: TextStyle(color: AppColors.secondary),
                hintStyle: TextStyle(
                  color: AppColors.secondary.withOpacity(0.6),
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primary, width: 1.5),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: isSmallScreen ? 14 : 16,
                ),
                suffixIcon: showToggle
                    ? TextButton(
                        onPressed: _toggleCcBcc,
                        child: Text(
                          _showCcBcc ? 'Hide CC/BCC' : 'CC/BCC',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: isSmallScreen ? 12 : 14,
                          ),
                        ),
                      )
                    : null,
              ),
              style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
              onFieldSubmitted: (value) => onFieldSubmitted(),
            );
          },
      optionsViewBuilder:
          (
            BuildContext context,
            AutocompleteOnSelected<String> onSelected,
            Iterable<String> options,
          ) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: size.width - 32, // Match field width
                  constraints: BoxConstraints(maxHeight: 200),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final String option = options.elementAt(index);
                      return GestureDetector(
                        onTap: () => onSelected(option),
                        child: ListTile(
                          title: Text(
                            option,
                            style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Compose Email",
          style: TextStyle(
            fontSize: isSmallScreen ? 18 : 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: AppColors.secondary),
          onPressed: _discardEmail,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.attachment_rounded, color: AppColors.secondary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Attachment feature coming soon!"),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.send_rounded, color: AppColors.primary),
            onPressed: _sendEmail,
          ),
          SizedBox(width: isSmallScreen ? 8 : 12),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
          child: Column(
            children: [
              // From Field
              _buildEmailField(
                controller: _fromController,
                label: "From",
                hint: "Enter sender's email",
                suggestions: _fromEmails,
                isFromField: true,
              ),
              SizedBox(height: isSmallScreen ? 12 : 16),
              // To Field
              _buildEmailField(
                controller: _toController,
                label: "To",
                hint: "Enter recipient's email",
                suggestions: _recipientEmails,
                showToggle: true,
              ),
              // CC Field (shown when toggled)
              if (_showCcBcc) ...[
                SizedBox(height: isSmallScreen ? 12 : 16),
                _buildEmailField(
                  controller: _ccController,
                  label: "CC",
                  hint: "Enter CC recipients",
                  suggestions: _recipientEmails,
                ),
              ],
              // BCC Field (shown when toggled)
              if (_showCcBcc) ...[
                SizedBox(height: isSmallScreen ? 12 : 16),
                _buildEmailField(
                  controller: _bccController,
                  label: "BCC",
                  hint: "Enter BCC recipients",
                  suggestions: _recipientEmails,
                ),
              ],
              SizedBox(height: isSmallScreen ? 12 : 16),
              // Subject Field
              TextField(
                controller: _subjectController,
                decoration: InputDecoration(
                  labelText: "Subject",
                  hintText: "Enter email subject",
                  labelStyle: TextStyle(color: AppColors.secondary),
                  hintStyle: TextStyle(
                    color: AppColors.secondary.withOpacity(0.6),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: isSmallScreen ? 14 : 16,
                  ),
                ),
                style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
              ),
              SizedBox(height: isSmallScreen ? 12 : 16),
              // Body Field
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _bodyController,
                  maxLines: null,
                  minLines: isSmallScreen ? 10 : 12,
                  decoration: InputDecoration(
                    hintText: "Write your email...",
                    hintStyle: TextStyle(
                      color: AppColors.secondary.withOpacity(0.6),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                  ),
                  style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendEmail,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.send_rounded, color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
