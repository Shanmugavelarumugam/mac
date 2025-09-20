import 'package:btc/services/people_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PeopleScreen extends StatefulWidget {
  final int userId; // pass userId from login

  const PeopleScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _PeopleScreenState createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  final PeopleService _service = PeopleService();
  List<Map<String, dynamic>> _people = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    fetchPeople();
  }

  Future<void> fetchPeople() async {
    try {
      final data = await _service.getPeopleByUser(widget.userId);
      setState(() {
        _people = data;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      print("Error fetching people: $e");
    }
  }

  Future<void> _createPersonDialog() async {
    String name = '';
    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Text(
              'Create Person',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: TextField(
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => name = value,
            ),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                child: Text('Create'),
                onPressed: () async {
                  if (name.trim().isNotEmpty) {
                    await _service.createPerson(name.trim(), widget.userId);
                    fetchPeople();
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
    );
  }

  Future<void> _addTransactionDialog(int peopleId) async {
    String purpose = '';
    String amountStr = '';
    DateTime selectedDate = DateTime.now();

    await showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  title: Text(
                    'Add Transaction',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Purpose',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => purpose = value,
                      ),
                      SizedBox(height: 10),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Amount',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) => amountStr = value,
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}',
                          ),
                          Spacer(),
                          TextButton(
                            child: Text('Select Date'),
                            onPressed: () async {
                              DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null)
                                setState(() => selectedDate = picked);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      child: Text('Cancel'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    ElevatedButton(
                      child: Text('Add'),
                      onPressed: () async {
                        if (purpose.trim().isNotEmpty &&
                            amountStr.trim().isNotEmpty) {
                          await _service.addTransaction(
                            peopleId: peopleId,
                            userId: widget.userId, // pass userId here
                            amount: double.tryParse(amountStr) ?? 0,
                            purpose: purpose.trim(),
                            date: DateFormat('yyyy-MM-dd').format(selectedDate),
                          );
                          fetchPeople();
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                ),
          ),
    );
  }

  Color _getExpenseColor(double amount) {
    if (amount == 0) return Colors.grey;
    if (amount < 500) return Colors.green;
    if (amount < 2000) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('People Expenses'),
        centerTitle: true,
        elevation: 4,
      ),
      body:
          _loading
              ? Center(child: CircularProgressIndicator())
              : _people.isEmpty
              ? Center(
                child: Text('No people found', style: TextStyle(fontSize: 16)),
              )
              : ListView.builder(
                padding: EdgeInsets.all(12),
                itemCount: _people.length,
                itemBuilder: (context, index) {
                  final person = _people[index];
                  return Card(
                    elevation: 5,
                    shadowColor: Colors.grey.shade200,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: _getExpenseColor(
                                  person['expenses'].toDouble(),
                                ),
                                child: Text(
                                  person['name'][0].toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                person['name'],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                              ElevatedButton.icon(
                                icon: Icon(Icons.add),
                                label: Text('Transaction'),
                                onPressed:
                                    () => _addTransactionDialog(person['id']),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Text(
                                'Total Expenses: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getExpenseColor(
                                    person['expenses'].toDouble(),
                                  ).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '₹${person['expenses']}',
                                  style: TextStyle(
                                    color: _getExpenseColor(
                                      person['expenses'].toDouble(),
                                    ),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          person['PeopleTransactions'] != null &&
                                  person['PeopleTransactions'].isNotEmpty
                              ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(
                                  person['PeopleTransactions'].length,
                                  (i) {
                                    final t = person['PeopleTransactions'][i];
                                    return Card(
                                      margin: EdgeInsets.symmetric(vertical: 4),
                                      color: Colors.grey.shade50,
                                      child: ListTile(
                                        dense: true,
                                        leading: Icon(
                                          Icons.monetization_on,
                                          color: Colors.blue,
                                        ),
                                        title: Text('${t['purpose']}'),
                                        trailing: Text('₹${t['amount']}'),
                                        subtitle: Text('${t['date']}'),
                                      ),
                                    );
                                  },
                                ),
                              )
                              : Text(
                                'No transactions',
                                style: TextStyle(color: Colors.grey),
                              ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createPersonDialog,
        child: Icon(Icons.person_add),
      ),
    );
  }
}
