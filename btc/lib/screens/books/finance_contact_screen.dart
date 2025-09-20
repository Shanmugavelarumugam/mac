import 'package:flutter/material.dart';
import 'package:btc/services/finance_contact_service.dart';

class FinanceContactScreen extends StatefulWidget {
  final int userId;
  const FinanceContactScreen({Key? key, required this.userId})
    : super(key: key);

  @override
  _FinanceContactScreenState createState() => _FinanceContactScreenState();
}

class _FinanceContactScreenState extends State<FinanceContactScreen> {
  late FinanceContactService _service;
  List<Map<String, dynamic>> _contacts = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    print('Initializing FinanceContactScreen for userId: ${widget.userId}');
    _service = FinanceContactService(userId: widget.userId);
    _fetchContacts();
  }

  Future<void> _fetchContacts() async {
    setState(() => _loading = true);
    print('Fetching contacts...');
    try {
      _contacts = await _service.getContacts();
      print('Fetched ${_contacts.length} contacts');
      for (var c in _contacts) {
        c['transactions'] = await _service.getTransactions(c['id']);
        print(
          'Fetched ${c['transactions'].length} transactions for contact ${c['name']}',
        );
      }
    } catch (e) {
      debugPrint('Error fetching contacts: $e');
    } finally {
      setState(() => _loading = false);
      print('Finished fetching contacts');
    }
  }

  void _showCreateContactDialog() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Create Contact'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Phone'),
                ),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email (optional)',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final name = nameController.text.trim();
                  final phone = phoneController.text.trim();
                  final email = emailController.text.trim();
                  if (name.isNotEmpty && phone.isNotEmpty) {
                    print(
                      'Creating contact: name=$name, phone=$phone, email=$email',
                    );
                    await _service.createContact(
                      name: name,
                      phone: phone,
                      email: email.isEmpty ? null : email,
                    );
                    Navigator.pop(context);
                    _fetchContacts();
                  }
                },
                child: const Text('Create'),
              ),
            ],
          ),
    );
  }

  void _showAddTransactionDialog(Map<String, dynamic> contact) {
    final amountController = TextEditingController();
    final noteController = TextEditingController();
    String type = 'pay';

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Add Transaction for ${contact['name']}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: type,
                  items: const [
                    DropdownMenuItem(value: 'pay', child: Text('Pay')),
                    DropdownMenuItem(value: 'get', child: Text('Get')),
                  ],
                  onChanged: (val) {
                    if (val != null) type = val;
                    print('Transaction type selected: $type');
                  },
                  decoration: const InputDecoration(labelText: 'Type'),
                ),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Amount'),
                ),
                TextField(
                  controller: noteController,
                  decoration: const InputDecoration(labelText: 'Note'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final amount = int.tryParse(amountController.text) ?? 0;
                  final note = noteController.text.trim();
                  if (amount > 0) {
                    print(
                      'Adding transaction: contactId=${contact['id']}, type=$type, amount=$amount, note=$note',
                    );
                    await _service.addTransaction(
                      contactId: contact['id'],
                      type: type,
                      amount: amount,
                      date: DateTime.now().toIso8601String().split('T')[0],
                      note: note,
                    );
                    Navigator.pop(context);
                    _fetchContacts();
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> tx) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text('${tx['date']} - ${tx['note']}')),
          Text(
            '${tx['type'] == 'pay' ? '-' : '+'} ₹${tx['amount']}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: tx['type'] == 'pay' ? Colors.red : Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Building FinanceContactScreen UI...');
    return Scaffold(
      appBar: AppBar(title: const Text('Finance Contacts')),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : _contacts.isEmpty
              ? const Center(child: Text('No contacts yet! Add a new contact.'))
              : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _contacts.length,
                itemBuilder: (context, index) {
                  final contact = _contacts[index];
                  final transactions = contact['transactions'] ?? [];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ExpansionTile(
                      title: Text(
                        contact['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        '${contact['phone']}\n${contact['email'] ?? ''}',
                      ),
                      children: [
                        if (transactions.isEmpty)
                          const Text('No transactions yet.')
                        else
                          Column(
                            children:
                                transactions
                                    .map<Widget>(
                                      (tx) => _buildTransactionItem(tx),
                                    )
                                    .toList(),
                          ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                            onPressed: () => _showAddTransactionDialog(contact),
                            icon: const Icon(Icons.add),
                            label: const Text('Add Transaction'),
                          ),
                        ),
                      ],

                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateContactDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
