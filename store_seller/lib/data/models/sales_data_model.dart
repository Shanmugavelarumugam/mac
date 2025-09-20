// lib/data/models/sales_data_model.dart
class SalesData {
  final DateTime date;
  final double amount;

  /// Order/entry status for the pie chart (e.g., "Delivered", "Pending", "Shipping").
  /// Kept optional with a default so existing code that doesn't pass it still compiles.
  final String status;

  SalesData({
    required this.date,
    required this.amount,
    this.status = 'Delivered', // default so old constructors still work
  });

  factory SalesData.fromJson(Map<String, dynamic> json) => SalesData(
    date: DateTime.parse(json['date'] as String),
    amount: (json['amount'] as num).toDouble(),
    status: (json['status'] ?? 'Delivered') as String,
  );

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'amount': amount,
    'status': status,
  };
}
