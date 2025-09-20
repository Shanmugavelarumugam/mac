class SegregatedWallet {
  final String id;
  final String name;
  final String description;
  final double targetAmount;
  double currentAmount;
  final List<Transaction> transactions;

  bool get isTargetReached => currentAmount >= targetAmount;
  bool get canEditOrDelete => transactions.isEmpty || isTargetReached;

  SegregatedWallet({
    required this.id,
    required this.name,
    this.description = '',
    required this.targetAmount,
    this.currentAmount = 0,
    List<Transaction>? transactions,
  }) : transactions = transactions ?? [];

  SegregatedWallet copyWith({
    String? id,
    String? name,
    String? description,
    double? targetAmount,
    double? currentAmount,
    List<Transaction>? transactions,
  }) {
    return SegregatedWallet(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      transactions: transactions ?? this.transactions,
    );
  }
}

class Transaction {
  final String id;
  final double amount;
  final DateTime date;
  final String type; // 'add' or 'claim'
  final String? note;

  Transaction({
    required this.id,
    required this.amount,
    required this.date,
    required this.type,
    this.note,
  });
}
