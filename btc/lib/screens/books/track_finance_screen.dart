import 'package:btc/services/track_finance_service.dart';
import 'package:flutter/material.dart';

class TrackFinanceScreen extends StatefulWidget {
  final int userId; // Logged-in userId

  const TrackFinanceScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _TrackFinanceScreenState createState() => _TrackFinanceScreenState();
}

class _TrackFinanceScreenState extends State<TrackFinanceScreen> {
  final TrackFinanceService _service = TrackFinanceService();
  final List<Map<String, dynamic>> _goals = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchGoals();
  }

  Future<void> _fetchGoals() async {
    setState(() => _loading = true);
    try {
      final goals = await _service.getGoalsByUser(widget.userId);
      setState(() {
        _goals.clear();
        _goals.addAll(goals);
      });
    } catch (e) {
      debugPrint('Error fetching goals: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  void _showAddAmountDialog(Map<String, dynamic> goal) {
    final amountController = TextEditingController();
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Add Amount to ${goal['title']}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                  final int amount = int.tryParse(amountController.text) ?? 0;
                  if (amount > 0) {
                    await _service.addAmount(
                      goalId: goal['id'],
                      amount: amount,
                      date: DateTime.now().toIso8601String().split('T')[0],
                      note: noteController.text,
                    );
                    Navigator.pop(context);
                    _fetchGoals();
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }

  void _showCreateGoalDialog() {
    final titleController = TextEditingController();
    final targetController = TextEditingController();
    final dueDateController = TextEditingController();
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Create New Goal'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Goal Title'),
                  ),
                  TextField(
                    controller: targetController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Target Amount',
                    ),
                  ),
                  TextField(
                    controller: dueDateController,
                    decoration: const InputDecoration(
                      labelText: 'Due Date (YYYY-MM-DD)',
                    ),
                  ),
                  TextField(
                    controller: noteController,
                    decoration: const InputDecoration(
                      labelText: 'Note (optional)',
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final String title = titleController.text.trim();
                  final int target = int.tryParse(targetController.text) ?? 0;
                  final String dueDate = dueDateController.text.trim();
                  final String note = noteController.text.trim();

                  if (title.isNotEmpty && target > 0 && dueDate.isNotEmpty) {
                    await _service.createGoal(
                      title: title,
                      targetAmount: target,
                      dueDate: dueDate,
                      userId: widget.userId,
                      note: note.isEmpty ? null : note,
                    );
                    Navigator.pop(context);
                    _fetchGoals();
                  }
                },
                child: const Text('Create'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Finance'),
        backgroundColor: Colors.indigo,
      ),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : _goals.isEmpty
              ? const Center(child: Text('No goals yet! Add a new goal.'))
              : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _goals.length,
                itemBuilder: (context, index) {
                  final goal = _goals[index];
                  final progress = (goal['currentAmount'] /
                          goal['targetAmount'])
                      .clamp(0.0, 1.0);

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  goal['title'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.indigo,
                                ),
                                onPressed: () => _showAddAmountDialog(goal),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          LinearProgressIndicator(
                            value: progress,
                            minHeight: 8,
                            backgroundColor: Colors.grey[300],
                            valueColor: const AlwaysStoppedAnimation(
                              Colors.indigo,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${goal['currentAmount']} / ${goal['targetAmount']}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateGoalDialog,
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add),
      ),
    );
  }
}
